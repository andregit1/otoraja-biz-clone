var packagingProductRelation = function() {
};
(function(packagingProductRelation) {
  'use strict';

  packagingProductRelation.afterProductInsert = function() {
    $('.packaging-product-relations-packaging-box select').select2();
  }

  onPageLoad('packaging_product_relations#index', function() {
    $('#packaging_product_relation_search select').select2();
  });

  onPageLoad([
    'packaging_product_relations#new',
    'packaging_product_relations#create',
    'packaging_product_relations#edit',
    'packaging_product_relations#update'
  ], function() {
    $('#shop_product_shop_id').select2();
    $('#shop_product_product_category_id').select2();
    $('.packaging-product-relations-packaging-box select').select2();
    $(document).on('cocoon:after-insert', packagingProductRelation.afterProductInsert);
  });
})(packagingProductRelation || (packagingProductRelation = {}));
