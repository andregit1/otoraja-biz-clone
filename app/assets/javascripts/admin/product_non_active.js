var productNonActive = function() {
};
(function(productNonActive) {
  'use strict';
  productNonActive.selected_product = [];
  productNonActive.unselected_product = [];
  var isSelectAllProduct = false;
  var total_product = null;

  var page_number = null;

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/product_non_active/' + url
    $.ajax({
      url: url,
      type: method,
      dataType: 'json',
      data: data,
      async: async,
    }).fail(function (xhr, status, error) {
      console.error(error);
    }).done(function (data) {
      callback(data);
    });
  }

  function putAjax(url, data, callback, async) {
    coreAjax('PUT', url, data, callback, async);
  }

  productNonActive.loadData = function(empty, callback) {
    var $product_list = $('#product_list');
    var current_page = parseInt($('#shop_product_search_current_page').val());
    
    var params = {
      shop_id: $('#select_shop').val(),
      product_category_id: $('#select_category').val(),
      search: $('#shop-product-search').val(),
      page: current_page
    };

    page_number = current_page;

    $product_list.empty();
    productNonActive.resetMultipleSelected();

    $('#paginator').empty();
    $('#select-all-remaining-product').hide();
    $('#cancle-all-product-selected').hide(); 
    $('.loading').removeClass('hide');
    $('.products-box-admin').removeClass('hide');
    $('.no_search_result').addClass('hide');
    $('.products-box-admin').removeClass('hide');
    $('#shop-product-search').prop('disabled',true);
    $('#select_category').prop('disabled',true);
    $("#shop-product-search-clear-btn").hide();
    $('#shop-product-search-btn').hide();

    $.ajax({
      url: '/api/admin/product_non_active/list.json',
      dataType: 'json',
      data: params,
      method: 'GET'
    }).then(function(data) {

      $('#shop-product-search-btn').show();
      $('#shop-product-search').prop('disabled',false);
      $('#select_category').prop('disabled',false);

      if($('#shop-product-search').val()){
        $("#shop-product-search-clear-btn").show();
      }

      if(data.paginator){
        $('#paginator').html(data.paginator);
        $('#paginator nav').removeClass('h6').find('.pagination').removeClass('my-2');
      }
      
      if (data.product.length != 0) {
        data.product.forEach(function(item){
          productNonActive.addItem(item);
        });
        $('#shop_product_search_no_more_result').val('false');
        $('#list-search-body-section .no_search_result').addClass('hide');
        $('.products-box-admin').removeClass('hide');
      } else {
        $('#shop_product_search_no_more_result').val('true');
        $('#list-search-body-section .no_search_result').removeClass('hide');
        $('.products-box-admin').addClass('hide');
      }
      
      total_product = data.meta.total_count

      productNonActive.handleItemEditClickEvent();
      productNonActive.remainingProductHandler();
      productNonActive.recheckedProduct();
    }).always(function(){
      $('.loading').addClass('hide');
      $('#select-all-product').prop('disabled',false);
      $('.loading-restore-product').addClass('hide');  
      $('.confirmation-content').removeClass('hide');
    });
  }

  productNonActive.addItem = function(item){
    var $list = $('#product_list');
    var $clone = $("#add-product-item-clone").find(".list-item").clone();

    //set UI
    $clone.find(".item__name").text(item.shop_alias_name);

    item.item_detail ? $clone.find(".item__description").text(item.item_detail) : $clone.find(".item__description").hide();

    $clone.attr("data-id", item.id);

    //draw it
    $list.append($clone)
  }

  productNonActive.resetSearchCondition = function() {
    $('.products-box-admin').removeClass('hide');
    $('.no_search_result').addClass('hide');
    $("#shop-product-search-clear-btn").hide();
    $("#shop-product-search").val(null);
  }

  productNonActive.resetMultipleSelected = function() {
    $('#select-all-product').prop('checked',false);
    $('#select-all-product').prop('disabled',true);
    $('.select-product').prop('checked',false);
    $('#multiple-restore-button').addClass('color-inactive').removeClass('color-text-gray');
    $('#count-selected-restore').html(0);
  }

  productNonActive.checkboxAllProductHandler = function () {
    if(isSelectAllProduct){
      if(productNonActive.unselected_product.length == total_product){
        $('#multiple-restore-button').addClass('color-inactive').removeClass('color-text-gray');
        $('#select-all-product').prop('checked', false);
        $('#select-all-remaining-product').hide();
        productNonActive.unselected_product.length = 0;
        productNonActive.selected_product.length = 0;
        isSelectAllProduct = false;
      }
    }else{
      if( productNonActive.selected_product[page_number].length > 0){
        $('#multiple-restore-button').removeClass('color-inactive').addClass('color-text-gray');
 
       //check if all item was checked by user 
       if($('#product_list').find('.select-product:checked').length == $('#product_list').find('.select-product').length){
         $('#select-all-product').prop('checked',true);
       }else{
         $('#select-all-product').prop('checked',false);
       }
      }else{
        $('#multiple-restore-button').addClass('color-inactive').removeClass('color-text-gray');
        $('#select-all-product').prop('checked', false);
        productNonActive.remainingProductHandler();
      }
    }
  }

  productNonActive.recheckedProduct = function () {
    $('.select-product').prop('checked',false);
    if(isSelectAllProduct){
      $('.select-product').prop('checked',true);
      $('#select-all-product').prop('checked',true);
      $('#count-selected-restore').html(total_product-productNonActive.unselected_product.length);
      productNonActive.unselected_product.forEach(function(product_id){
        $(`.list-item[data-id='${product_id}']`).find('.select-product').prop('checked',false);
      });
    }else{
      if(!productNonActive.selected_product[page_number]){
        productNonActive.selected_product[page_number] = new Array();
      }else{
        productNonActive.selected_product[page_number].forEach(function(product_id){
          $(`.list-item[data-id='${product_id}']`).find('.select-product').prop('checked',true);
        });
      }
      productNonActive.checkboxAllProductHandler();
      $('#count-selected-restore').html(productNonActive.selected_product[page_number].length);
    }
  }

  productNonActive.remainingProductHandler = function () {
    let total_selected = null;
    let total_unselected = null;

    if(isSelectAllProduct){
      $('#select-all-remaining-product').hide(); 
      $('#multiple-restore-button').removeClass('color-inactive').addClass('color-text-gray');
      $('#count-selected-restore').html(total_product - productNonActive.unselected_product.length);
      $('#total-product-unselected').html(productNonActive.unselected_product.length);  
      productNonActive.unselected_product.length > 0 ? $('#select-all-remaining-product').show() : $('#select-all-remaining-product').hide();
    }else{
      productNonActive.selected_product.forEach(function(count_product_each_page){
        total_selected = total_selected + count_product_each_page.length;
      });

      total_unselected = total_product - total_selected;
      $('#total-product-unselected').html(total_unselected);  
      total_selected > 0 && total_unselected > 0 ? $('#select-all-remaining-product').show() : $('#select-all-remaining-product').hide();
    }
  }

  productNonActive.handleItemEditClickEvent = function(){
    $(".list-item").on("click", function(event){
      var $target = $(this);
      $('#label-id').val($target.data('id'));
      $('#mode').val('single');
    })

    $("#multiple-restore-button").on("click", function(event){
      $('#mode').val('multiple');
    })
  }
  
  onPageLoad("product_non_active#index", function() {
    $('#select-all-remaining-product').hide();
    $('#cancle-all-product-selected').hide();
    $('#select_category').select2();
    
    productNonActive.loadData();

    $('#shop-product-search-btn').on("click", function(){
      $('#shop_product_search_current_page').val(1);
      isSelectAllProduct = false;
      productNonActive.unselected_product.length = 0;
      productNonActive.selected_product.length = 0;
      productNonActive.loadData();
    });

    $("#shop-product-search-clear-btn").on("click", function(event){
      $('#shop_product_search_current_page').val(1);
      isSelectAllProduct = false;
      productNonActive.unselected_product.length = 0;
      productNonActive.selected_product.length = 0;
      productNonActive.resetSearchCondition();
      productNonActive.loadData();
    })

    $("#shop-product-search").on("keyup", function(event) {
      $('#shop_product_search_current_page').val(1);
      isSelectAllProduct = false;
      productNonActive.unselected_product.length = 0;
      productNonActive.selected_product.length = 0;
      if (event.key === 'Enter') {
        productNonActive.loadData();
      }
    })

    $("#select_category").on("change", function(){
      $('#shop_product_search_current_page').val(1);
      isSelectAllProduct = false;
      productNonActive.unselected_product.length = 0;
      productNonActive.selected_product.length = 0;
      productNonActive.loadData();
    });

    $(document).on('click','.single-restore-btn', function () {
      $('#confirmationModalRestoreProduct').modal({backdrop: 'static', keyboard: false});
      $('#confirmationModalRestoreProduct').modal('show');
      $('#confirmRestoreProduct').attr('data-mode', 'single');

      if(!productNonActive.selected_product[page_number]){
        productNonActive.selected_product[page_number] = new Array();
      }

      productNonActive.selected_product[page_number].push($(this).closest('li').data('id'));
    });

    $('#multiple-restore-button').on('click',function () {
      if($('#multiple-restore-button').hasClass('color-text-gray')){
        $('#confirmRestoreProduct').attr('data-mode', 'multiple');
        $('#confirmationModalRestoreProduct').modal({backdrop: 'static', keyboard: false});
        $("#confirmationModalRestoreProduct").modal("show");
      }
    });

    $('#select-all-product').on('click',function () {
      let product_id = null;
      
      if(!productNonActive.selected_product[page_number]){
        productNonActive.selected_product[page_number] = new Array();
      }

      productNonActive.selected_product[page_number].length = 0;
      if($('#select-all-product').is(':checked')){
         
        $('.select-product').prop('checked',true).each(function () {
          product_id = $(this).closest('.list-item').data('id');
          if(product_id){
            productNonActive.selected_product[page_number].push(product_id)
          };
        });
        
        if(productNonActive.selected_product[page_number].length > 0){
          $('#multiple-restore-button').removeClass('color-inactive').addClass('color-text-gray');
        }
        
        $('#count-selected-restore').html(productNonActive.selected_product[page_number].length);
      }else{
        if(isSelectAllProduct){
          isSelectAllProduct = false;
          productNonActive.selected_product.length = 0
          productNonActive.unselected_product.length = 0;
        }

        $('#multiple-restore-button').addClass('color-inactive').removeClass('color-text-gray');
        $('.select-product').prop('checked',false);
        $('#count-selected-restore').html(0);
        $('#select-all-remaining-product').hide();
      }

      productNonActive.remainingProductHandler();
    })

    $(document).on('click', '.select-product', function() {
      if(!productNonActive.selected_product[page_number]){
        productNonActive.selected_product[page_number] = new Array();
      }

      let product_selected = $('#product_list').find('.select-product:checked').length;
      let product_id = $(this).closest('.list-item').data('id');
      let index_product_id_selected = productNonActive.selected_product[page_number].indexOf(product_id);
      let index_product_id_unselected = productNonActive.unselected_product.indexOf(product_id);

      if(isSelectAllProduct){
        if($(this).is(':checked')){
          productNonActive.unselected_product.splice(index_product_id_unselected, 1);
        }else{
          productNonActive.unselected_product.push(product_id);
        }
      }else{
        if($(this).is(':checked')){
          productNonActive.selected_product[page_number].push(product_id);
        }else{
          productNonActive.selected_product[page_number].splice(index_product_id_selected, 1);
        }
        $('#count-selected-restore').html(product_selected);
      }
      productNonActive.remainingProductHandler();
      productNonActive.checkboxAllProductHandler();
    });

    $('#select-all-remaining-product').on('click',function () {
      if(isSelectAllProduct){
        productNonActive.unselected_product.length = 0;
      }else{
        productNonActive.selected_product.length = 0;
        isSelectAllProduct = true;
      };

      $('.select-product').prop('checked',true);
      $('#select-all-product').prop('checked',true);
      $('#count-selected-restore').html(total_product);
      $('#select-all-remaining-product').hide();
      $('#multiple-restore-button').removeClass('color-inactive').addClass('color-text-gray');
    });

    $(document).on('click','#confirmRestoreProduct', function () {
      let mode = $('#mode').val();
      let product_id = $("#label-id").val();
      let params = {
        product_category_id: $('#select_category').val(),
        search: $('#shop-product-search').val(),
      };
  
      if(mode == 'single'){
        productNonActive.selected_product.length = 0;
        productNonActive.unselected_product.length = 0;
        params.selected_product = product_id;
      }else{
        if(isSelectAllProduct){
          productNonActive.selected_product.length = 0;
          params.unselected_product = productNonActive.unselected_product;
        }else{
          productNonActive.unselected_product.length = 0;
          params.selected_product = productNonActive.selected_product[page_number];
        }
      }
      
      $('.loading-restore-product').removeClass('hide');  
      $('.confirmation-content').addClass('hide');  
      
      putAjax(
        'restore_deleted',
        params,
        function(data) {
          $('#shop_product_search_current_page').val(1);
          $('#confirmationModalRestoreProduct').modal('hide');

          productNonActive.selected_product.length = 0;
          productNonActive.unselected_product.length = 0;
          isSelectAllProduct = false;
          productNonActive.loadData();
        },
        true
      );
    });

    $(document).on('click', 'nav .pagination a', function(e) {
      e.preventDefault();
      let page = new RegExp('[\?&]' + 'page' + '=([^&#]*)').exec($(this).attr('href'));
      page ? $('#shop_product_search_current_page').val(page[1]) : $('#shop_product_search_current_page').val(1);
      productNonActive.loadData();
    });
  });

})(productNonActive || (productNonActive = {}));