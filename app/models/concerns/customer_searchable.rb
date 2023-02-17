module CustomerSearchable
  extend ActiveSupport::Concern
  included do
    include Elasticsearch::Model
    #一旦、都度投入はせず、定期的にimportするようにする
    #include Elasticsearch::Model::Callbacks
    index_name 'customers'
    settings analysis: self.analyzer_settings do
      mappings dynamic: 'false' do
        indexes :id,                type: 'integer'
        indexes :name,              type: 'text', analyzer: 'custom_analyzer', search_analyzer: 'custom_analyzer'
        indexes :tel_international, type: 'text', analyzer: 'custom_analyzer', search_analyzer: 'custom_analyzer'
        indexes :tel_national,      type: 'text', analyzer: 'custom_analyzer', search_analyzer: 'custom_analyzer'
        indexes :number_plate,      type: 'text', analyzer: 'custom_analyzer', search_analyzer: 'custom_analyzer'
        indexes :available_shops,   type: 'text'
      end
    end

    def as_indexed_json(*)
      attributes
        .symbolize_keys
        .slice(:id, :name)
        .merge(
          number_plate: number_plate,
          available_shops: available_shops,
          tel_international: tel_international,
          tel_national: tel_national,
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

    def es_search(query, shop_ids)
      __elasticsearch__.search({
        query: {
          bool: {
            must: {
              query_string: {
                fields: %w(name tel_international tel_national number_plate),
                query: (query.split(' ').map do |v| "*#{v}*" end).join(' AND '),
              }
            },
            filter: {
              terms: {
                available_shops: shop_ids
              }
            }
          }
        }
      })
    end

    def es_search_byfield(name, tel, number_plate, shop_ids)
      name_query = name.blank? ? '' : "*#{name}*"
      tel_query = tel.blank? ? '' : "*#{tel}*"
      number_plate_query = number_plate.blank? ? '' : (number_plate.split(' ').map do |v| "*#{v}*" end).join(' AND ')
      __elasticsearch__.search({
        query: {
          bool: {
            minimum_should_match: 1,
            should: [
              {
                query_string: {
                  fields: %w(name),
                  query: name_query,
                }
              },
              {
                query_string: {
                  fields: %w(tel_international tel_national),
                  query: tel_query,
                }
              },
              {
                query_string: {
                  fields: %w(number_plate),
                  query: number_plate_query,
                }
              },
            ],
            filter: {
              terms: {
                available_shops: shop_ids
              }
            }
          }
        }
      })
    end

    def analyzer_settings
      {
        analyzer: {
          custom_analyzer: {
            type: 'custom',
            char_filter: ['whitespaces'],
            tokenizer: 'keyword',
            filter: ['lowercase', 'trim']
          },
        },
        char_filter: {
          whitespaces: {
            type: 'pattern_replace',
            pattern: '\\s{2,}',
            replacement: '\u0020'
          },
        },
      }
    end

    def es_import_by_id(customer_id)
      __elasticsearch__.import(query: -> {
        where(
          id: customer_id
        )
      })
    end
  end

  # 結合されたナンバープレート
  def number_plate
    owned_bikes.map do |bike|
      "#{bike.number_plate_area}-#{bike.number_plate_number}-#{bike.number_plate_pref}" if bike.has_number_plate
    end
  end

  def bikes_info
    owned_bikes.map do |owned_bike|
      bike = owned_bike.bike
      "#{bike.maker}#{' / ' unless bike.model.blank? || bike.maker.blank?}#{bike.model}" unless bike.nil?
    end
  end

  # 過去チェックインした店舗
  def available_shops
    checkins.pluck(:shop_id)
  end

  def tel_international
    Phonelib.parse(self.tel).international(false)
  end

  def tel_national
    Phonelib.parse(self.tel).national(false)
  end

  def tel_national_hyphen
    Phonelib.parse(self.tel).national
  end

  def last_maintenance_log
    maintenance_log = checkins.order(datetime:'DESC').first.maintenance_log
    unless maintenance_log.nil?
      maintenance_log.to_json
    end
  end

  def tel_country_code
    Phonelib.parse(self.tel).country_code
  end
end
