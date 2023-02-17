module ShopProductSearchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model

    product_es_settings = {
      index: {
        analysis: {
          filter: {
            autocomplete_filter: {
              type: "edge_ngram",
              min_gram: 1,
              max_gram: 20
            }
          },
          analyzer:{
            autocomplete: {
              type: "custom",
              tokenizer: "standard",
              filter: ["lowercase", "autocomplete_filter"]
            }
          }
        }
      }
    }

    index_name 'shop_products'
    settings product_es_settings do
      mappings dynamic: 'false' do
        indexes :id,                  type: 'integer'
        indexes :admin_product_name,  type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :shop_alias_name,     type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :item_detail,         type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :category_name,       type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :inclusion_products_name,  type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :product_no,          type: 'text', analyzer: 'autocomplete', search_analyzer: 'standard'
        indexes :is_use,              type: 'boolean'
        indexes :shop_id,             type: 'integer'
      end
    end

    def as_indexed_json(*)
      attributes
        .symbolize_keys
        .slice(
          :id,
          :shop_alias_name,
          :item_detail,
          :is_use,
          :shop_id,
        )
        .merge(
          admin_product_name: admin_product_name,
          category_name: category_name,
          inclusion_products_name: inclusion_products_name,
          product_no: display_product_no
        )
    end
  end

  class_methods do
    # INDEX作成
    def create_index!
      client = __elasticsearch__.client
      # INDEXを削除する
      client.indices.delete index: self.index_name rescue nil
      # INDEXを作成する
      client.indices.create(index: self.index_name,
                            body: {
                                settings: self.settings.to_hash,
                                mappings: self.mappings.to_hash
                            })
    end

    def es_search(query, shop_id, is_use = true)
      query = {
        query: {
          bool: {
            should: [
              query.split(' ').map do |v|
                {
                  query_string: {
                    fields: %w(category_name admin_product_name shop_alias_name item_detail inclusion_products_name),
                    query: "#{es_escape(v)}~",
                    boost: 0.5
                  }
                }
              end,
              query.split(' ').map do |v|
                {
                  query_string: {
                    fields: %w(category_name admin_product_name shop_alias_name item_detail inclusion_products_name),
                    query: "#{es_escape(v)}",
                    boost: 1
                  },
                }
              end,
              query.split(' ').map do |v|
                {
                  query_string: {
                    fields: %w(product_no),
                    query: "#{es_escape(v)}*",
                    boost: 1
                  },
                }
              end,
            ],
            minimum_should_match: 1,
            filter: [
              {
                term: { is_use: is_use }
              }, {
                term: { shop_id: shop_id }
              }
            ]
          }
        },
        highlight: {
          fields: {
            "*": {}
          }
        },
      }
      __elasticsearch__.search(query)
    end

    def es_import(shop_id)
      __elasticsearch__.import(query: -> {
        where(
          shop_id: shop_id
        )
      })
    end

    def es_import_by_id(shop_product_id)
      __elasticsearch__.import(query: -> {
        where(
          id: shop_product_id
        )
      })
    end

    def es_escape(value)
      value.gsub(/[\+\-\=\&\|\>\<\!\(\)\{\}\[\]\^\"\~\*\?\:\\\/]/){|s| "\\#{s}" }
    end
  end

  def admin_product_name
    admin_product.name unless admin_product.nil?
  end

  def category_name
    product_category.name unless product_category_id.nil?
  end

  def inclusion_products_name
    inclusion_products.select(:shop_alias_name, :item_detail).map{ |c| sprintf('%s %s', c.shop_alias_name, c.item_detail)&.strip }
  end

end
