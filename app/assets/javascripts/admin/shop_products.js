var shopProduct = function() {
};
(function(shopProduct) {
  'use strict';

  shopProduct.cache_product_data = {};
  shopProduct.selected_product = [];
  shopProduct.unselected_product = [];
  shopProduct.polluteCache = false;
  shopProduct.processing = false;
  var isSelectAllProduct = false;
  var isSearchLoading = false;
  var shop_product_id = null;
  var page_number = null;
  var total_product = null;
  var product_deleted_expectation = null; 

  shopProduct.getCacheProductData = function(category) {
    if (category === undefined) {
      return this.cache_product_data;
    } else {
      var product_data = this.cache_product_data[category];
      if (product_data === undefined) {
        product_data = {};
      }
      return product_data;
    }
  }

  shopProduct.setCacheProductData = function(category, list, variants, tech_specs) {
    this.cache_product_data[category] = {
      admin_products: list,
      variants: variants,
      tech_specs: tech_specs
    };
  }

  shopProduct.loadData = function(empty, callback) {
    if(isSearchLoading){
      return;
    }
    $('#paginator').empty();
    if (empty == undefined) {
      empty = true;
    }
    var params = {
      shop_id: $('#select_shop').val(),
      product_category_id: $('#select_category').val(),
      search: $('#shop-product-search').val(),
      sort: $('#select_sort').val(),
      is_use: $('#select_use').val(),
    };
    var $product_list = $('#product_list');
    var current_page = parseInt($('#shop_product_search_current_page').val());
    $('.loading').removeClass('hide');
    if (empty) {
      current_page = 1;
      $('#list-search-body-section .products-box-admin').scrollTop(0);
    }
    params['page'] = current_page;
    page_number = current_page;
    isSearchLoading = true;
    $product_list.empty();
    $('#select-all-product').prop('checked',false);
    $('#select-all-product').prop('disabled',true);
    $('#multiple-delete-button').addClass('btn-circle-inactive').removeClass('btn-circle-default');
    $('#count-selected-delete').html(0);
    $('#select-all-remaining-product').hide();
    $('#cancle-all-product-selected').hide(); 
    $('.no_search_result').addClass('hide');
    $('.products-box-admin').removeClass('hide');

    let console = $('#shop_product_search_console');
    let URL_SEARCH = '/api/admin/shop_products/list.json'
    
    if (console.length > 0) {
      URL_SEARCH = '/console/shop_products/list.json'
    }

    $.ajax({
      url: URL_SEARCH,
      dataType: 'json',
      data: params,
      method: 'GET'
    }).then(function(data) {        
      if (empty) { 
        $('#shop_product_search_current_page').val('1');
      }
    
      if(data.paginator){
        $('#paginator').html(data.paginator);
        $('#paginator nav').removeClass('h6').find('.pagination').removeClass('my-2');
      }

      if (data.product.length != 0) {
        data.product.forEach(function(item, index){
          shopProduct.addItem(item);
        })
        $('#shop_product_search_no_more_result').val('false');
        $('#list-search-body-section .no_search_result').addClass('hide');
        if($('.products-box-admin').hasClass('hide')){
          $('.products-box-admin').removeClass('hide');
        }
      } else {
        $('#shop_product_search_no_more_result').val('true');
        $('#list-search-body-section .no_search_result').removeClass('hide');
        $('.products-box-admin').addClass('hide');
      }

      total_product = data.meta.total_count

      shopProduct.checkNewActivity();
      shopProduct.handleItemEditClickEvent();
      shopProduct.recheckedProduct();
      shopProduct.remainingProductHandler();
    }).always(function(){
      if (callback != undefined) {
        callback();
      }
      isSearchLoading = false;
      $('.loading').addClass('hide');
      $('#select-all-product').prop('disabled',false);
      $('.loading-delete-product').addClass('hide');  
      $('.confirmation-content').removeClass('hide');
    });
  }

  shopProduct.addItem = function(item){
    var $list = $('#product_list');
    var $clone = $("#add-product-item-clone").find(".list-item").clone();
    //set UI
    $clone.find(".item__name").text(item.shop_alias_name);

    if(item.item_detail){
      $clone.find(".item__description").text(item.item_detail);
    }else{
      $clone.find(".item__description").hide();
    }

    //null check
    $clone.find(".item__price").text((item.sales_unit_price ? item.sales_unit_price.toLocaleString("id-ID") : null));
    
    $clone.find(".item__current__quantity").text(item.stock_quantity || 0);
    $clone.find(".item__min__quantity").text(item.stock_minimum || 0);

    if(!item.is_stock_control){
      $clone.find(".not_count").removeClass('hide');
    }

    if(item.stock_minimum > 0){
      $clone.find(".stock_minimum_value").removeClass('hide');
    }

    if (item.stock_quantity  <= 0 ) {
      $clone.find(".item__current__quantity").addClass("stock_depleted");
      $clone.find(".item__quantity").append("<i class='fas fa-exclamation-triangle stock_depleted ml-1'></i><span class='text-danger'> Update stok</span>");
    } else if (item.stock_minimum >= item.stock_quantity) {
      $clone.find(".item__current__quantity").addClass("stock_low");
      $clone.find(".item__quantity").append("<i class='fas fa-exclamation-triangle stock_low ml-1'></i><span class='text-warning'> Stok minimal</span");
    } else {
      $clone.find(".item__quantity").addClass("stock_ok");
    }

    $clone.attr("data-id", item.id);
    $clone.attr("data-shop-id", item.shop_d);
    $clone.attr("data-admin-product-id", item.admin_product_id);
    $clone.attr("data-admin-product-no", item.admin_product_no);
    $clone.attr("data-product-category-id", item.product_category_id);
    $clone.attr("data-product-name", item.shop_alias_name);
    $clone.attr("data-shop-alias-name", item.shop_alias_name);
    $clone.attr("data-product-no", item.product_no);
    $clone.attr("data-sales-unit-price", item.sales_unit_price);
    $clone.attr("data-purchase-unit-price", item.formated_purchase_unit_price);
    $clone.attr("data-shop-alias-name", item.shop_alias_name);
    $clone.attr("data-item-detail", item.item_detail);
    $clone.attr("data-is-stock-control", item.is_stock_control);
    $clone.attr("data-is-use", item.is_use);
    $clone.attr("data-average-price", item.formated_average_price || 0);
    $clone.attr("data-stock-minimum", item.stock_minimum);
    $clone.attr("data-stock-quantity", item.stock_quantity || 0);
    $clone.attr("data-remind-interval-day", item.remind_interval_day || 0);
    //append gross profit
    $clone.attr("data-gross-profit", ((item.sales_unit_price || 0) - (item.average_price || 0)).toLocaleString("id-ID"));
    //draw it
    $list.append($clone)
  }

  shopProduct.checkNewActivity = function(){
    var newItemId = $("#new-activity-item-id").val();
    if(!newItemId)
      return;

    var $target = $(`.list-item[data-id='${newItemId}']`);
    if ($target.find('.new-badge').length == 0) {
      $target.find(".item__name").prepend("<span class='badge badge-pill badge-secondary pr-2 new-badge'>New</span>");
    }
  }

  shopProduct.addPurchaseHistory = function(item){
    var item_exist = item.difference || item.quantity
    var op = item_exist > 0 ? '+' : ''
    var notes = item.reason
    var stock = item.stock_at_close == 0 || item.difference == 0 ? item_exist : parseInt(item.stock_at_close + item_exist).toLocaleString("id-ID")
    var quantity = item.difference == 0 ? 0 : op + item_exist

    switch (item.reason) {
      case "1":
        notes = "Beli"
        break;
      case "2":
        notes = "Opname"
        break;
      case "3":
        notes = "Jual"
        break;
      case "4":
        notes = "Opname"
        break;
      default:
        notes = ""
    }


    $("#purchase_history").append(`
      <tr class="text-normal">
        <td>${item.formated_date}</td>
        <td class="text-right">${quantity}</td>
        <td class="text-right">${stock}</td>
        <td class="text-center">${notes}</td>
      </tr>`)
  }
  shopProduct.formatProductData = function(data, obj) {
    Object.keys(data).forEach(function(key){
      obj[key] = data[key].name;
    });
  }

  shopProduct.getFormattedProductData = function(category) {
    var product_data = shopProduct.getProductData(category);
    var formatted_product_data = {
      admin_products: {},
      variants: {},
      tech_specs: {}
    };
    shopProduct.formatProductData(product_data.admin_products, formatted_product_data.admin_products);
    shopProduct.formatProductData(product_data.variants, formatted_product_data.variants);
    shopProduct.formatProductData(product_data.tech_specs, formatted_product_data.tech_specs);

    return formatted_product_data;
  }

  shopProduct.getProductData = function(category) {
    if (
      Object.keys(shopProduct.getCacheProductData(category)).length === 0
    ) {
      var list = {};
      var variants = {};
      var tech_specs = {};
      var params = {};
      if (category != undefined || category != "") {
        params = {
          product_category_id: category
        };
      }
      getAjax(
        'admin_products.json',
        params,
        function(data) {
          data.forEach(function(val){
            list[val.id] = val;
          });
        },
        false
      );
      getAjax(
        'variants.json',
        params,
        function(data) {
          data.forEach(function(val){
            variants[val.id] = val;
          });
        },
        false
      );
      getAjax(
        'tech_specs.json',
        params,
        function(data) {
          data.forEach(function(val){
            tech_specs[val.id] = val;
          });
        },
        false
      );
      shopProduct.setCacheProductData(category, list, variants, tech_specs);
    }
    return shopProduct.getCacheProductData(category);
  }

  function getAjax(url, data, callback, async) {
    coreAjax('GET', url, data, callback, async);
  }

  function postAjax(url, data, callback, async) {
    coreAjax('POST', url, data, callback, async);
  }

  function putAjax(url, data, callback, async) {
    coreAjax('PUT', url, data, callback, async);
  }

  function deleteAjax(url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/shop_products/' + url
    $.ajax({
      url: url,
      type: 'DELETE',
      dataType: 'json',
      data: data,
      async: async,
      timeout: 30000 // 30 second
    }).fail(function (xhr, status, error) {
      $('#confirmationModalMoreTime').modal('show'); 
      console.error(error);
    }).done(function (data) {
      callback(data);
    });
  }

  function check_progress_deleted() {
    var url = '/api/admin/shop_products/check_progress_delete'
    $.ajax({
      url: url,
      type: 'GET',
      dataType:'json',
      timeout: 30000 // 30 second
    }).fail(function (xhr, status, error) {
      $('#confirmationModalMoreTime').modal('show');
    }).done(function (data) {
      if(data.deleted_product == product_deleted_expectation){
        location.reload();
      }else{
        $('#confirmationModalMoreTime').modal('show'); 
      }
    });
  }

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/shop_products/' + url
    $.ajax({
      url: url,
      type: method,
      dataType: 'json',
      data: data,
      async: async
    }).fail(function (xhr, status, error) {
      console.error(error);
    }).done(function (data) {
      callback(data);
    });
  }

  shopProduct.handleItemEditClickEvent = function(){
    $(".list-item").on("click", function(event){
      //target contains all data to populate edit form
      var $target = $(this);
      $("#label-id").val($target.data("id"));
      $("#label-admin_product_id").val($target.data("admin-product-id"));
      $("#label-shop_alias_name").val($target.data("shop-alias-name"));
      $("#label-item_detail").val($target.data("item-detail"));
      $("#label-stock_minimum").val($target.data("stock-minimum"));
      $("#label-stock").val($target.data("stock-quantity"));
      $("#label-sales_unit_price").val($target.data("sales-unit-price"));
      $("#label-remind_interval_day").val($target.data("remind-interval-day"));
      $("#label-is_stock_control").val($target.data("is-stock-control"));
      $("#label-is_use").val($target.data("is-use"));
      $("#label-admin_product-no").val($target.data("data-admin-product-no"));
      $("#label-shop_product-no").val($target.data("product-no"));
      $("#label-product-category-id").val($target.data("product-category-id"));
      $("#label-gross-profit").val($target.data("gross-profit"));
      $("#label-average-price").val($target.data("average-price"));
    })
  }

  shopProduct.createOptionDropdown = function(data) {
    var options = "<option value=''></option>"
    Object.keys(data).forEach(function(key){
      var node = `<option value=${key}>${data[key]}</option>`
      options = options + node;
    });

    return options;
  }

  shopProduct.getProductDataForDropdown = function($select, category_id){
    var product_data = shopProduct.getFormattedProductData(category_id);
    //set selectors
    switch($select.attr("name")) {
      case "admin_product_id":
        var options = shopProduct.createOptionDropdown(product_data.admin_products);
        break;
      case "variant_id":
        var options = shopProduct.createOptionDropdown(product_data.variants);
        break;
      case "tech_spec_id":
        var options = shopProduct.createOptionDropdown(product_data.tech_specs);
        break;
    };

    $select.empty().append(options)
  }

  shopProduct.getStockHistory = function(){
    if (!shop_product_id) return;
    //isSearchLoading = true;
    var params = {
      shop_product_id: shop_product_id, //from property
      start_date: $('#start_date').val(),
      end_date: $('#end_date').val(),
    };

    $('#loading_purchase_history').removeClass('hide')
    $('#empty_data_info').addClass('hide')
    $('#purchase_history').empty();
    
    getAjax(
      'stock_controls.json',
      params,
      function(data) {
        $('#loading_purchase_history').addClass('hide')
        if(data.length){
          data.forEach(function(item){
            shopProduct.addPurchaseHistory(item);
          })
        }else{
          $('#empty_data_info').removeClass('hide')
        }
      },
      true
    );
  }

  shopProduct.openAddProductModal = function(event, data) {
    if (data !== "#addProductModal") return;
    
    $('#is_use').prop('checked', true);
    $("#confirm-add-product-button").addClass("button-inactive").attr("disabled", true);
    $('input[name="availability"]').eq(0).click();
    $('#addProductModal input[name="admin_product_id"]').val(null);
    $("#product_category_id").val(null).trigger("change");
    $("#brand_id").val(null).trigger("change").attr("disabled", true);
    $("#variant_id").val(null).trigger("change").attr("disabled", true);
    $("#tech_spec_id").val(null).trigger("change").attr("disabled", true);
    $('#add-admin-product_id').val(null).trigger("change").attr("disabled", true);
    $('#shop_alias_name').val(null);
    $('#sales_unit_price').val(null);
    $('#remind_interval_day').val(null);
    $('#is_stock_control').prop("checked", false).trigger('change')
    $('#stock_minimum_product').val(null).prop("disabled", true).addClass('text-color-disabled');
    $('#stock_minimum_status').hide()

    shopProduct.stockConfigHandler(data);
  }

  shopProduct.openEditProductModal = function(event, data) {
    if (data !== "#editProductModal") return;
    
    shopProduct.findStockHistory();
    
    //set input fields
    var $form = $("#editProductModal");
    
    //set category
    var $select = $form.find("#edit_product_category_id");
    var category_id = $("#label-product-category-id").val();
    $select.val(category_id).trigger("change");
    shopProduct.getProductDataForDropdown($("#edit-admin-product_id"), category_id);
    $('#edit-admin-product_id').val($('#edit-admin-product_id').val());
    var value = $("#label-admin_product_id").val();

    if (value.length > 0) {
      var items = shopProduct.getCacheProductData();
      var selected = items[category_id].admin_products[parseInt(value)];
      $("#edit_brand_id").val(selected.brand_id || null).trigger("change");
      $("#edit_variant_id").val(selected.variant_id || null).trigger("change");
      $("#edit_tech_spec_id").val(selected.tech_spec_id || null).trigger("change");
    }

    shop_product_id = $("#label-id").val();
    shopProduct.paramState = $('#update-product-form').serialize();
    $form.find("[name='shop_product_id']").val(shop_product_id);
    $form.find("[name='admin_product_id']").val(parseInt(value)||null);
    $form.find("[name='shop_alias_name']").val($("#label-shop_alias_name").val());
    $form.find("[name='sales_unit_price']").val($("#label-sales_unit_price").val());
    $form.find("[name='remind_interval_day']").val($("#label-remind_interval_day").val());
    $form.find("[name='is_stock_control']").val($("#label-is_stock_control").val());
    $form.find("[name='admin_product-no']").val($("#label-admin_product-no").val());
    $form.find("[name='product_no']").val($("#label-shop_product-no").val());
    $form.find("[name='average-price']").val($("#label-average-price").val());
    $form.find("[name='item_detail']").val($("#label-item_detail").val());
    $form.find('#stock_minimum_product').val($("#label-stock_minimum").val());
    $("#gross-profit").text($("#label-gross-profit").val());
    $("#average-price").text($("#label-average-price").val());
    $("#quantity").text($("#label-stock").val());
    $("#edit_brand_id").attr("disabled", true);
    $("#edit_variant_id").attr("disabled", true);
    $("#edit_tech_spec_id").attr("disabled", true);
    $('#stock_minimum_status').hide()

    //set availability
    var availability = $("#label-is_use").val();
    if (availability == 'false') {
      $form.find("[name='availability']").prop("checked", false).change()
    } else {
      $form.find("[name='availability']").prop("checked", true).change()
    }
    //set stock history
    shopProduct.getStockHistory();
    shopProduct.stockConfigHandler(data);

    $('#daterange-btn').on('apply.daterangepicker', function(ev, picker) {
      shopProduct.getStockHistory();
    });
  }

  shopProduct.clickConfirmAddProduct = function() {
    if(shopProduct.processing) return;
    shopProduct.processing = true;
    var $form = $('#add-product-form');
    var query = $form.serialize();
    var is_used = "&is_use=" + $form.find("[name='availability']").prop("checked");
    var is_stock_control = '&is_stock_control=' + $('#is_stock_control').prop("checked");
    var shop_id = "&shop_id=" + $('#select_shop').val();
    
    postAjax(
      'create',
      query + is_used + shop_id + is_stock_control,
      function(data) {
        $("#new-activity-item-id").val(data.msg.id);
        shopProduct.polluteCache = true;
        $('#select_category').val(data.msg.product_category_id).trigger("change");
        shopProduct.resetSearchCondition();
        shopProduct.loadData();
        $form.find(':text, input[type="number"]').not('#stock_minimum_product').val("").end().find(":checked").prop("checked", false);

        shopProduct.processing = false;
      },
      false
    );
  }

  shopProduct.clickConfirmUpdateProduct = function() {
    if(shopProduct.processing) return;

    shopProduct.processing = true;
    var $form = $('#update-product-form');
    var query = $form.serialize();
    var is_used = "&is_use=" + $form.find("[name='availability']").prop("checked");
    var is_stock_control = '&is_stock_control=' + $('#update-product-form #is_stock_control').prop("checked");
    var stock_minimum = '&stock_minimum=' +  $('#update-product-form #stock_minimum_product').val()

    putAjax(
      'update_product',
      query + is_used + is_stock_control + stock_minimum,
      function(data) {
        $("#new-activity-item-id").val(data.msg.id);
        shopProduct.polluteCache = true;
        $('#select_category').val(data.msg.product_category_id).trigger("change");
        shopProduct.resetSearchCondition();
        shopProduct.loadData();
        $form.find(':text, input[type="number"]').not('#stock_minimum_product').val("").end().find(":checked").prop("checked", false);
        shopProduct.processing = false;
      },
      false
    );
  }

  shopProduct.resetSearchCondition = function() {
    $('#select_sort').val('latest').trigger('change', [false]);
    $("#shop-product-search-clear-btn").hide();
    $("#shop-product-search").val(null);
  }

  shopProduct.adjustScrollArea = function() {
    var $container = $('#list-search-body-section');
    var wh = $(window).height();
    var main_header = $('.main-header').outerHeight();
    var main_footor = 0;
    var header = $('.content-header').outerHeight();
    var search = $('#list-search-section').outerHeight();
    var foot = $('.admin-control-footer').outerHeight();
    $container.find('.products-box-admin').outerHeight(wh - main_header - header - search - foot - main_footor - 20);
    $('#list-search-body-section .products-box-admin').on('scroll', shopProduct.onScrollSearchList);
  }

  shopProduct.onScrollSearchList = function() {
    var scrollTop = $('#list-search-body-section .products-box-admin').scrollTop();
    var boxH = $('#list-search-body-section .products-box-admin').outerHeight();
    var listH = $('#list-search-body-section .scroll-area').outerHeight();
    var noMoreResult = $('#shop_product_search_no_more_result').val();
    if (listH - boxH <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
      $('#list-search-body-section .loading').removeClass('hide');
      shopProduct.loadData(false, function() {
        $('#list-search-body-section .loading').addClass('hide');
      });
    }
  }

  shopProduct.confirmButtonActiveControl = function(isValid, $button) {
    if (!$button || $button.length == 0) return;

    if (isValid) {
      $button.removeClass("button-inactive");
      $button.addClass("button-active");
      $button.attr("disabled", false);
    } else {
      $button.addClass("button-inactive");
      $button.removeClass("button-active");
      $button.attr("disabled", true);
    }
  }

  shopProduct.minimumStatusHandler = function (modal_id) {
    let stock_minimum_input = $(modal_id + ' #stock_minimum_product');
    let status_minimum_label = $( modal_id + ' #stock_minimum_status');

    if(stock_minimum_input.val() > 0){
      status_minimum_label.show();
    }else{
      status_minimum_label.hide();
      if(!stock_minimum_input.is(':focus')){
        stock_minimum_input.val(0);
      }
    }
  }

  shopProduct.findStockHistory = function () {
    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 Hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(30, "days"), moment()],
      },
      showDropdowns: true,
      showWeekNumbers: true,
      showISOWeekNumbers: true,
      autoApply: true,
      startDate: moment(),
      endDate: moment(),
      drops: 'down',
      parentEl: '#editProductModal',
      locale: {
        "customRangeLabel": "Pilih rentang",
      },
      maxSpan: {
        "days": 30
      },
    };

    let start = moment();
    let end = moment();

    var callback = function(start, end, label){
      let date_range_text = start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY");

      if(start.isSame(moment(), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Hari ini";
      }
      else if(start.isSame(moment().subtract(6, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "7 Hari terakhir";
      }
      else if(start.isSame(moment().startOf("month"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Bulan ini";
      }
      else if(start.isSame(moment().subtract(30, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "30 hari terakhir";
      }

      $("#daterange-btn span").html(date_range_text);

      $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
    }

    $("#daterange-btn").daterangepicker(
      options,
      callback
    );

    callback(start, end);

    $('.calendar.left').hide();
    $('.calendar.right').hide();
    $('.ranges li:last-child' ).hide();
    $('.range_inputs' ).hide();

  }

  shopProduct.stockConfigHandler = function(modal_id) {
    shopProduct.minimumStatusHandler(modal_id);

    let stock_control_toggle = $(modal_id + ' #is_stock_control');
    let stock_minimum_input = $(modal_id + ' #stock_minimum_product');
    let status_minimum_label = $( modal_id + ' #stock_minimum_status');

    // set default value stock count and stock minimum when have value from modal edit product
    if(modal_id == '#editProductModal'){
      if(stock_control_toggle.val() == 'true'){
        stock_control_toggle.prop("checked", true).trigger('change');
        stock_minimum_input.attr('disabled',false).removeClass('text-color-disabled');
      }else{
        stock_control_toggle.prop("checked", false).trigger('change');
        status_minimum_label.hide()
        stock_minimum_input.attr('disabled',true).addClass('text-color-disabled');
      }
    }

    $(stock_control_toggle).on('change', function () {
      if(stock_control_toggle.is(':checked')){
        stock_minimum_input.prop("disabled", false).removeClass('text-color-disabled'); 
        shopProduct.minimumStatusHandler(modal_id);
      }else{
        stock_minimum_input.prop("disabled", true).addClass('text-color-disabled'); 
        status_minimum_label.hide();
      }
    });

    $(stock_minimum_input).off().on('input focusout', function() {
      shopProduct.minimumStatusHandler(modal_id);
    })
  }

  var validateOption = {
    rules: {
      shop_alias_name: {
        required: true,
        pattern: /^[a-zA-Z0-9!#$%&()*+,.:;=?\s\[\]^_{}<>\-\/~`'"]+$/
      },
      product_category_id: {
        required: true,
      },
      sales_unit_price: {
        required: true,
        number: true
      },
      stock_minimum: {
        number: true
      },
      remind_interval_day: {
        number: true
      }
    },
    messages: {
      shop_alias_name: {
        required: '',
        pattern: 'Gunakan karakter umum saja.'
      },
      product_category_id: {
        required: '',
      },
      sales_unit_price: {
        required: '',
        number: 'Gunakan karakter umum saja.'
      },
      stock_minimum: {
        number: 'Gunakan karakter umum saja.',
        min: 'Jumlah stok minimal adalah 0.',
      },
      remind_interval_day: {
        number: 'Gunakan karakter umum saja.'
      }
    },
    highlight: function(element, errorClass) {
      $(element).removeClass(errorClass);
    },
    errorPlacement: function (err, element) {
      err.addClass('text-small');
      element.after(err);
    }
  }

  shopProduct.remainingProductHandler = function () {
    let total_selected = null;
    let total_unselected = null;

    if(isSelectAllProduct){
      $('#select-all-remaining-product').hide(); 
      $('#multiple-delete-button').removeClass('btn-circle-inactive').addClass('btn-circle-default');
      $('#count-selected-delete').html(total_product - shopProduct.unselected_product.length);
      $('#total-product-unselected').html(shopProduct.unselected_product.length);  
      shopProduct.unselected_product.length > 0 ? $('#select-all-remaining-product').show() : $('#select-all-remaining-product').hide();
    }else{
      shopProduct.selected_product.forEach(function(count_product_each_page){
        total_selected = total_selected + count_product_each_page.length;
      });

      total_unselected = total_product - total_selected;
      $('#total-product-unselected').html(total_unselected);  
      total_selected > 0 && total_unselected > 0 ? $('#select-all-remaining-product').show() : $('#select-all-remaining-product').hide();
    }
  }

  shopProduct.checkboxAllProductHandler = function () {
    if(isSelectAllProduct){
      if(shopProduct.unselected_product.length == total_product){
        $('#multiple-delete-button').addClass('btn-circle-inactive').removeClass('btn-circle-default');
        $('#select-all-product').prop('checked', false);
        $('#select-all-remaining-product').hide();
        shopProduct.unselected_product.length = 0;
        shopProduct.selected_product.length = 0;
        isSelectAllProduct = false;
      }
    }else{
      if( shopProduct.selected_product[page_number].length > 0){
        $('#multiple-delete-button').removeClass('btn-circle-inactive').addClass('btn-circle-default');
      
        //check if all item was checked by user 
        if($('#product_list').find('.select-product:checked').length == $('#product_list').find('.select-product').length){
          $('#select-all-product').prop('checked',true);
        }else{
          $('#select-all-product').prop('checked',false);
        }
      }else{
        $('#multiple-delete-button').addClass('btn-circle-inactive').removeClass('btn-circle-default');
        $('#select-all-product').prop('checked', false);
        $('#select-all-remaining-product').hide();
      }
    }
  }

  shopProduct.recheckedProduct = function () {
    $('.select-product').prop('checked',false);

    if(isSelectAllProduct){
      $('.select-product').prop('checked',true);
      $('#select-all-product').prop('checked',true);
      $('#count-selected-delete').html($('#product_list').find('.select-product').length);
      shopProduct.unselected_product.forEach(function(product_id){
        $(`.list-item[data-id='${product_id}']`).find('.select-product').prop('checked',false);
      });
    }else{
      if(!shopProduct.selected_product[page_number]){
        shopProduct.selected_product[page_number] = new Array();
      }else{
        shopProduct.selected_product[page_number].forEach(function(product_id){
          $(`.list-item[data-id='${product_id}']`).find('.select-product').prop('checked',true);
        });
      }
      shopProduct.checkboxAllProductHandler();
      $('#count-selected-delete').html(shopProduct.selected_product[page_number].length);
    }
  }

  onPageLoad("shop_products#index", function() {
    $('#select-all-remaining-product').hide();
    $('#cancle-all-product-selected').hide();
    $('#add-product-form').validate(validateOption);
    $('#update-product-form').validate(validateOption);

    $('#select_sort').val($('#default-filter').val()).trigger('change');
    shopProduct.loadData();

    $("#select_shop").on("change", function(){
      shopProduct.polluteCache = true;
      shopProduct.loadData();
    });
    $("#select_category").on("change", function(){
      shopProduct.polluteCache = true;
      isSelectAllProduct = false;
      shopProduct.unselected_product.length = 0;
      shopProduct.selected_product.length = 0;
      shopProduct.loadData();
    });

    $('select[name="select_shop"]').select2();
    $('#select_category').select2();
    $('#select_sort').select2();
    $('#select_use').select2();
    $('#add-admin-product_id').select2({width: '100%', containerCssClass: 'text-normal', dropdownCssClass: 'text-normal', placeholder: 'Pilih kategori terlebih dahulu'});
    $('#edit-admin-product_id, #product_category_id, #brand_id, #variant_id, #tech_spec_id, #edit_brand_id, #edit_variant_id, #edit_tech_spec_id, #edit_product_category_id').select2({width: '100%', containerCssClass: 'text-normal', dropdownCssClass: 'text-normal'});
    $('#shop-product-search-btn').on("click", function(){
      shopProduct.loadData();
      $("#shop-product-search-clear-btn").show();
    });

    $("#shop-product-search-clear-btn").on("click", function(event){
      $('.products-box-admin').removeClass('hide');
      $('.no_search_result').addClass('hide');
      $("#shop-product-search-clear-btn").hide();
      $("#shop-product-search").val(null);
      isSelectAllProduct = false;
      shopProduct.unselected_product.length = 0;
      shopProduct.selected_product.length = 0;
      shopProduct.loadData();
    })

    $("#shop-product-search").on("keyup", function(event) {
      if (event.key === 'Enter') {
        isSelectAllProduct = false;
        shopProduct.unselected_product.length = 0;
        shopProduct.selected_product.length = 0;
        shopProduct.loadData();
        $("#shop-product-search-clear-btn").show();
      }
    })

    $("#select_sort").on("change", function(event, loading){
      var load = loading == undefined ? true : loading;
      if (load) {
        isSelectAllProduct = false;
        shopProduct.unselected_product.length = 0;
        shopProduct.selected_product.length = 0;
        shopProduct.loadData();
      }
    });

    $("#select_use").on("change", function(event, loading){
      var load = loading == undefined ? true : loading;
      if (load) {
        isSelectAllProduct = false;
        shopProduct.unselected_product.length = 0;
        shopProduct.selected_product.length = 0;
        shopProduct.loadData();
      }
    });

    $("#editProductModal .product_category_edit").on("change", function(){
      var category_id = $(this).val();
      //get admin products, variants, and tech specs
      shopProduct.getProductDataForDropdown($("#edit-admin-product_id"), category_id);
      shopProduct.getProductDataForDropdown($("#edit_variant_id"), category_id);
      shopProduct.getProductDataForDropdown($("#edit_tech_spec_id"), category_id);
      $('#editProductModal input[name="admin_product_id"]').val($("#edit-admin-product_id").find("option").val() || null);
      $('#editProductModal input[name="variant_id"]').val($("#edit_variant_id").find("option").val() || null);
      $('#editProductModal input[name="tech_spec_id"]').val($("#edit_tech_spec_id").find("option").val() || null);
      //reset item detail, product no, and brand value
      $('#editProductModal input[name="item_detail"]').val(null);
      $('#editProductModal input[name="product_no"]').val(null);
      $("#edit_brand_id").val(null).trigger("change");

      //set purchase reminder
      var use_reminder = $(this).find(":selected").data("reminder");
      if (use_reminder) {
        $("#edit_purchase_reminder").show();
      } else {
        $("#edit_purchase_reminder").hide();
      }
    })
    
    $("#addProductModal .product_category_edit").on("change", function(){
      var category_id = $(this).val();
      //get admin products, variants, and tech specs
      shopProduct.getProductDataForDropdown($("#add-admin-product_id"), category_id);
      shopProduct.getProductDataForDropdown($("#variant_id"), category_id);
      shopProduct.getProductDataForDropdown($("#tech_spec_id"), category_id);
      $('#addProductModal input[name="admin_product_id"]').val($("#add-admin-product_id").find("option").val() || null);
      $('#addProductModal input[name="variant_id"]').val($("#variant_id").find("option").val() || null);
      $('#addProductModal input[name="tech_spec_id"]').val($("#tech_spec_id").find("option").val() || null);
      //reset item detail, product no, and brand value
      $('#addProductModal input[name="item_detail"]').val(null);
      $('#addProductModal input[name="product_no"]').val(null);
      $('#brand_id').val(null).trigger("change");
      $('#add-admin-product_id').attr("disabled", false);

      //set purchase reminder
      var use_reminder = $(this).find(":selected").data("reminder");
      if (use_reminder) {
        $("#add_purchase_reminder").show();
      } else {
        $("#add_purchase_reminder").hide();
      }
    })

    $("#addProductModal input, #addProductModal select").on("keyup change", function(){
      var isValid = $('#add-product-form').valid();
      var $button = $("#confirm-add-product-button");
      shopProduct.confirmButtonActiveControl(isValid, $button);
    })

    $("#editProductModal input, #editProductModal select").on("keyup change", function(){
      var isValid = $('#update-product-form').valid();
      var $button = $("#confirm-update-product-button");
      shopProduct.confirmButtonActiveControl(isValid, $button);
    })

    $("#add-admin-product_id").on("change", function(){
      let value = $(this).val();
      if(value.length>0){
        $('#addProductModal input[name="admin_product_id"]').val(value);
        var items = shopProduct.getCacheProductData();
        var category_id = $("#addProductModal .product_category_edit").val();
        var selected = items[category_id].admin_products[parseInt(value)];
        $("#addProductModal").find("[name='item_detail']").val(selected.item_detail);
        $("#brand_id").val(selected.brand_id || null).trigger("change").attr("disabled", true);
        $("#variant_id").val(selected.variant_id || null).trigger("change").attr("disabled", true);
        $("#tech_spec_id").val(selected.tech_spec_id || null).trigger("change").attr("disabled", true);
      }
    })

    $("#edit-admin-product_id").on("change", function(){
      $("#confirmationModal").modal("show");
    })

    $('#delete-product').on('click',function () {
      $('#confirmationModalDeleteProduct').modal({backdrop: 'static', keyboard: false});
      $("#confirmationModalDeleteProduct").modal("show");
    });

    $('#multiple-delete-button').on('click',function () {
      if($(this).hasClass('btn-circle-default')){
        $('#confirmationModalMultipleDeleteProduct').modal({backdrop: 'static', keyboard: false});
        $("#confirmationModalMultipleDeleteProduct").modal("show");
      }
    });

    $(document).on("modal_open", shopProduct.openAddProductModal);
    $(document).on("modal_open", shopProduct.openEditProductModal);

    $('#confirm-add-product-button').on('click', shopProduct.clickConfirmAddProduct);
    $('#confirm-update-product-button').on('click', shopProduct.clickConfirmUpdateProduct);

    $("#cancelChangeProduct").on("click", function(){
      $('#edit-admin-product_id').val($("#label-admin_product_id").val()).trigger("change");
    });

    $("#confirmChangeProduct").on("click", function(){
      $("#confirmationModal").modal("hide");
      let value = $("#edit-admin-product_id").val();
      if(value.length>0) {
        $('#editProductModal input[name="admin_product_id"]').val(value);
        var items = shopProduct.getCacheProductData();
        var category_id = $("#editProductModal .product_category_edit").val();
        var selected = items[category_id].admin_products[parseInt(value)];
        $("#editProductModal").find("[name='item_detail']").val(selected.item_detail);
        $("#edit_brand_id").val(selected.brand_id || null).trigger("change").attr("disabled", true);
        $("#edit_variant_id").val(selected.variant_id || null).trigger("change").attr("disabled", true);
        $("#edit_tech_spec_id").val(selected.tech_spec_id || null).trigger("change").attr("disabled", true);
      };
    });
    
    $('#select-all-product').on('click',function () {      
      let product_id = null;

      if(!shopProduct.selected_product[page_number]){
        shopProduct.selected_product[page_number] = new Array();
      }
      
      shopProduct.selected_product[page_number].length = 0;
      if($('#select-all-product').is(':checked')){
        
        $('.select-product').prop('checked',true).each(function () {
          product_id = $(this).closest('.list-item').data('id');
          if(product_id){
            shopProduct.selected_product[page_number].push(product_id)
          };
        });
        
        if(shopProduct.selected_product[page_number].length > 0){
          $('#multiple-delete-button').removeClass('btn-circle-inactive').addClass('btn-circle-default');
        }
        
        shopProduct.remainingProductHandler();

        $('#count-selected-delete').html(shopProduct.selected_product[page_number].length);
      }else{
        if(isSelectAllProduct){
          isSelectAllProduct = false;
          shopProduct.selected_product.length = 0
          shopProduct.unselected_product.length = 0;
        }

        $('#multiple-delete-button').addClass('btn-circle-inactive').removeClass('btn-circle-default');
        $('.select-product').prop('checked',false);
        $('#count-selected-delete').html(0);
        $('#select-all-remaining-product').hide();
      }

    })

    $(document).on('click', '.select-product', function() {
      if(!shopProduct.selected_product[page_number]){
        shopProduct.selected_product[page_number] = new Array();
      }
      
      let product_selected = $('#product_list').find('.select-product:checked').length;
      let product_id = $(this).closest('.list-item').data('id');
      let index_product_id_selected = shopProduct.selected_product[page_number].indexOf(product_id);
      let index_product_id_unselected = shopProduct.unselected_product.indexOf(product_id);
      
      if(isSelectAllProduct){
        if($(this).is(':checked')){
          shopProduct.unselected_product.splice(index_product_id_unselected, 1);
        }else{
          shopProduct.unselected_product.push(product_id);
        }
      }else{
        $(this).is(':checked') ? shopProduct.selected_product[page_number].push(product_id) : shopProduct.selected_product[page_number].splice(index_product_id_selected, 1);
        $('#count-selected-delete').html(product_selected);
      }

      shopProduct.remainingProductHandler();
      shopProduct.checkboxAllProductHandler();
    });

    $(document).on('click', '#confirmChangeProductDeleteProduct', function() {
      $('.loading-delete-product').removeClass('hide');  
      $('.confirmation-content').addClass('hide');  
      shopProduct.selected_product.length = 0;
      shopProduct.unselected_product.length = 0;
      isSelectAllProduct = false;
      product_deleted_expectation = parseInt($('#count-selected-delete').html());

      let product_id = $("#label-id").val();

      deleteAjax(
        'delete',
        {selected_product : product_id},
        function() {
          product_deleted_expectation = 0;
          $('#confirmationModalDeleteProduct').modal('hide'); 
          shopProduct.loadData();
        },
        true
      );
    });

    $('#confirmChangeProductMultipleDeleteProduct').on('click',function () {
      product_deleted_expectation = parseInt($('#count-selected-delete').html());

      let params = {
        shop_id: $('#select_shop').val(),
        product_category_id: $('#select_category').val(),
        search: $('#shop-product-search').val(),
        sort: $('#select_sort').val(),
        is_use: $('#select_use').val(),
      };
      
      if(isSelectAllProduct){
        params.unselected_product = shopProduct.unselected_product;
      }else{
        params.selected_product = shopProduct.selected_product[page_number];
      }
      
      $('.loading-delete-product').removeClass('hide');  
      $('.confirmation-content').addClass('hide');  
      
      if($('#multiple-delete-button').hasClass('btn-circle-default')){
        deleteAjax('delete', params, 
          function(){
            $('#confirmationModalMultipleDeleteProduct').modal('hide');
            product_deleted_expectation = 0;
            shopProduct.selected_product.length = 0;
            shopProduct.unselected_product.length = 0;
            isSelectAllProduct = false;
            shopProduct.loadData();
          },
          true
        );
      }
    });

    $('#select-all-remaining-product').on('click',function () {
      if(isSelectAllProduct){
        shopProduct.unselected_product.length = 0;
      }else{
        shopProduct.selected_product.length = 0;
        isSelectAllProduct = true;
      };

      $('.select-product').prop('checked',true);
      $('#select-all-product').prop('checked',true);
      $('#count-selected-delete').html(total_product);
      $('#select-all-remaining-product').hide();
      $('#multiple-delete-button').removeClass('btn-circle-inactive').addClass('btn-circle-default');
    });

    $('#cancelRequestMoreTime').on('click',function () {
      location.reload();
    });

    $('#continueRequestMoreTime').on('click',function () {
      check_progress_deleted()
    });

    $(document).on('click', 'nav .pagination a', function(e) {
      e.preventDefault();

      var page = new RegExp('[\?&]' + 'page' + '=([^&#]*)').exec($(this).attr('href'));
      if(page !== null ){
        $('#shop_product_search_current_page').val(page[1]);
      }
      else{
        $('#shop_product_search_current_page').val(1);
      }

      shopProduct.loadData(false);
      return false;
    });
  });

})(shopProduct || (shopProduct = {}));
