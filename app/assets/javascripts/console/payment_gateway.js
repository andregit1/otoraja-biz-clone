var paymentGateway = function(){};
(function(paymentGateway) {
  'use strict';
  
  onPageLoad("payment_gateway", function(){

    paymentGateway.ajaxSelect2 = function (element) {
      $(element).select2({ 
        ajax: {
          url: "payment_gateway/search",
          dataType: 'json',
          delay: 250,
          multiple: true,
          data: function (params) {
            return {
              search_key: params.term
            };
          },
          processResults: function(data) {
            var results = [];
            $.each(data.shop_list, function (index, shop) {
              results.push({
                id: shop.bengkel_id,
                text: shop.bengkel_id +':'+ shop.name
              });
            });
            return {
              "results": results
            };                 
          },
          cache: true
        },
        width: 'resolve',
        minimumInputLength: 1,
        placeholder: 'Cari bengkel ID'
      });
    }

    $('.shop_list').each(function (index, item) {
      paymentGateway.ajaxSelect2(item)

      let new_option = ""; 
      let shop_ids = $(item).data("shop-list");
      let id_name_shops = $(item).data("id-name-shops");

      $.each(id_name_shops, function (index, shop) {
        new_option = new Option(shop, index, false, false);
        $(item).append(new_option).trigger('change');
      });        
      $(item).val(shop_ids).trigger("change");

    });

    $('.payment_gateway_status').each(function(index, item) {
      let is_active = $(item).data('is-active');
      if(is_active){
        $(this).prop("checked", true).trigger('change');
        $(this).closest('.payment_gateway').find('.payment_method').removeClass('hide');
      }else{
        $(this).prop("checked", false).trigger('change');
        $(this).closest('.payment_gateway').find('.payment_method').addClass('hide');
      }
    });

    $('.is_use_all_list').each(function (index, item) {
      let is_use_all = $(item).data('is_use_all');
      if(is_use_all){
        $(item).find('.radio-button-true').prop('checked', true);
        $(item).find('.shop_list').prop('disabled', true);
      }else{
        $(item).find('.radio-button-false').prop('checked', true);
      }
    });

    $('.payment_gateway_status').on('change', function() {
      if($(this).is(':checked')){
        $(this).prop("checked", true);
        $(this).closest('.payment_gateway').find('.payment_method').removeClass('hide');
      }else{
        $(this).prop("checked", false);
        $(this).closest('.payment_gateway').find('.payment_method').addClass('hide');
      }
    });

    $('.radio-button-false').on('click', function () {
      $(this).parents('.is_use_all_list').find('.shop_list').prop('disabled', false);
    });

    $('.radio-button-true').on('click', function () {
      $(this).parents('.is_use_all_list').find('.shop_list')
      $(this).parents('.is_use_all_list').find('.shop_list').prop('disabled', true);
    });

  });

})(paymentGateway || (paymentGateway = {}));