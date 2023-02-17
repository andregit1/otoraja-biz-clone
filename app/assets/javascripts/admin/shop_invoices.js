(function() {
  'use strict';

  window.app = window.app || {}
  var shopInvoice = window.app.shopInvoice = {};

  shopInvoice.cache_supplier = [];
  shopInvoice.cache_product_data = {};
  shopInvoice.selected = [];
  shopInvoice.existing = [];
  shopInvoice.processing = false;
  shopInvoice.invoiceId = 0;
  shopInvoice.originalItems = [];
  shopInvoice.destroyItems = [];
  shopInvoice.formState = ""
  shopInvoice.isClosed = false;
  var isSearchLoading = false;


  shopInvoice.getCacheSupplier = function(shop) {
    if (shop === undefined) {
      return this.cache_supplier;
    } else {
      var list = this.cache_supplier[shop];
      if (list === undefined) {
        list = {};
      }
      return list;
    }
  }

  shopInvoice.setCacheSupplier = function(shop, obj) {
    this.cache_supplier[shop] = obj;
  }

  shopInvoice.getCacheProductData = function(category) {
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

  shopInvoice.setCacheProductData = function(category, list, variants, tech_specs) {
    this.cache_product_data[category] = {
      admin_products: list,
      variants: variants,
      tech_specs: tech_specs
    };
  }

  function no_selected_info() {
    if(shopInvoice.selected.length == 0){
      $('.no_selected_item').removeClass('hide');
    }else{
      $('.no_selected_item').addClass('hide');
    }
  }

  shopInvoice.loadData = function(empty, callback) {
    if(isSearchLoading){
      return;
    }
    $('#paginator').empty();
    if (empty == undefined) {
      empty = true;
    }
    var params = {
      shop_id: $('#select_shop').val(),
      supplier_id: $('#select_supplier').val(),
      mode: $('#mode').val(),
      sort: $('#select_invoice_sort').val(),
      status: $('#select_invoice_status').val(),
      search: $('#shop-invoice-search').val(),
    };
    var $invoice_list = $('#invoice_list');
    var current_page = parseInt($('#shop_invoice_search_current_page').val());
    $('.loading').removeClass('hide');
    if (empty) {
      current_page = 1;
      $('#list-invoice-search-body-section .products-box-admin').scrollTop(0);
      $invoice_list.empty();
    }
    params['page'] = current_page;
    isSearchLoading = true;
    $invoice_list.empty();
    $.ajax({
      url: '/api/admin/shop_invoices/list.json',
      dataType: 'json',
      data: params,
      method: 'GET'
    }).then(function(data) {
      if (empty) {
        $('#shop_invoice_search_current_page').val('1');
      }

      $('#paginator').html(data.paginator);
      if (data.invoices.length != 0) {
        data.invoices.forEach(function(item, index){
          shopInvoice.addItem(item);
        })
        $('#shop_invoice_search_no_more_result').val('false');
        $('#shop_invoice_search_current_page').val(current_page + 1);
        $('#list-invoice-search-body-section, .row-invoice-header, .card-body-invoice').removeClass('hide');
        $('.no_search_result').addClass('hide');
      } else {
        $('#shop_invoice_search_no_more_result').val('true');
        $('.no_search_result').removeClass('hide');
        $('#list-invoice-search-body-section, .row-invoice-header, .card-body-invoice').addClass('hide');
      }
      shopInvoice.handleItemEditClickEvent();
      no_selected_info();
    }).always(function(){
      if (callback != undefined) {
        callback();
      }
      isSearchLoading = false;
      $('.loading').addClass('hide');
    });
  }

  shopInvoice.addItem = function(item){
    var $list = $('#invoice_list');
    var $clone = $("#edit-invoice-item-clone").find(".list-item").clone();
    if (item.status=="closed") {
      $clone.addClass("closed-item");
    }
    //set UI
    $clone.find(".item__arrival__date").text(moment(new Date(item.arrival_date)).format("DD-MM-YYYY"));
    $clone.find(".item__invoice__no").text(item.invoice_no);
    $clone.find(".item__supplier__name").text(item.supplier_name);
    $clone.find(".item__status").val(item.status);
    if (item.status === "open") {
      $clone.find(".item__draft").html(`<span>Terbuka</span><span class="ml-2"><i class="fa fa-trash-alt delete-invoice"></i></span>`);
      $clone.find(".invoice-list-btn").html(`<a class="btn btn-primary" href="/admin/shop_invoices/`+item.id+`/edit"><i class="fas fa-edit"></i></a>`);
    } else {
      $clone.find(".item__draft").html(`<span>Final <i class="fas fa-lock"></i> </span>`);
      $clone.find(".invoice-list-btn").html(`<a class="btn btn-primary" href="/admin/shop_invoices/`+item.id+`/show"><i class="fas fa-eye"></i></a>`);
    }
    //set data attributes
    $clone.data("id", item.id);
    //list it
    var productList = $clone.find(".item__product__list");
    item.shop_products.every(function(product, index){
      if (index <= 2) {
        productList.append(`<li class='text-truncate'>${product.shop_alias_name}</li>`);
        return true;
      } else {
        productList.append(`<li class='text-truncate'>...And ${item.shop_products.length-index} more.</li>`);
        return false;
      }
    })
    //draw it
    $list.append($clone);
  }

  shopInvoice.loadProductData = function(empty, callback) {
    if (empty == undefined) {
      empty = true;
    }
    var params = {
      shop_id: $('#select_shop').val(),
      supplier_id: $('#select_supplier').val(),
      product_category_id: $('#select_category').val(),
      search: $('#shop-product-search').val(),
      sort: $('#select_sort').val(),
      is_use: $('#select_use').val()
    };
    var $product_list = $('#product_list');
    var current_page = parseInt($('#shop_product_search_current_page').val());
    if (empty) {
      current_page = 1;
      $('#list-search-body-section .products-box-admin').LoadingOverlay('show', {zIndex: 9999});
      $('#list-search-body-section .products-box-admin').scrollTop(0);
    }
    params['page'] = current_page;
    isSearchLoading = true;
    no_selected_info();
    $.ajax({
      url: '/api/admin/shop_products/list.json',
      dataType: 'json',
      data: params,
      method: 'GET'
    }).then(function(data) {
      if (empty) {
        $product_list.empty();
        $('#shop_product_search_current_page').val('1');
      }
      if (data.length != 0) {
        data.product.forEach(function(item, index){
          shopInvoice.addProductItem(item);
        })
        $('#shop_product_search_no_more_result').val('false');
        $('#shop_product_search_current_page').val(current_page + 1);
        $('#list-search-body-section .no_search_result').addClass('hide');
      } else {
        $('#shop_product_search_no_more_result').val('true');
        $('#list-search-body-section .no_search_result').removeClass('hide');
      }
      
      no_selected_info();
      shopInvoice.reSelect();
      shopInvoice.handleItemEditClickEvent();
    }).always(function(){
      if (callback != undefined) {
        callback();
      }
      isSearchLoading = false;
      $('#list-search-body-section .products-box-admin').LoadingOverlay('hide');
    });
  }

  shopInvoice.addProductItem = function(item, list){
    list = list || '#product_list'
    var $list = $(list);
    var $clone = $("#add-product-item-clone").find(".list-item").clone();
    //set UI
    $clone.find(".item__name").text(item.shop_alias_name);
    $clone.find(".item__description").text(item.item_detail);
    //null check
    $clone.find(".item__price").text((item.sales_unit_price ? item.sales_unit_price.toLocaleString("id-ID") : null));
    $clone.find(".item__current__quantity").text(item.stock_quantity || item.product_stock || 0);
    $clone.find(".item__min__quantity").text(item.stock_minimum || 0);

    $clone.attr("data-id", item.id);
    $clone.attr("data-shop-id", item.shop_d);
    $clone.attr("data-admin-product-id", item.admin_product_id);
    $clone.attr("data-admin-product-no", item.admin_product_no);
    $clone.attr("data-product-category-id", item.product_category_id);
    $clone.attr("data-product-name", item.shop_alias_name);
    $clone.attr("data-shop-alias-name", item.shop_alias_name);
    $clone.attr("data-product-no", item.product_no);
    $clone.attr("data-sales-unit-price", item.sales_unit_price);
    $clone.attr("data-purchase-unit-price", item.purchase_unit_price);
    $clone.attr("data-shop-alias-name", item.shop_alias_name);
    $clone.attr("data-item-detail", item.item_detail);
    $clone.attr("data-is-stock-control", item.is_stock_control);
    $clone.attr("data-is-use", item.is_use);
    $clone.attr("data-average-price", item.average_price || 0);
    $clone.attr("data-stock-minimum", item.stock_minimum);
    $clone.attr("data-stock-quantity", item.stock_quantity || item.product_stock || 0);
    $clone.attr("data-remind-interval-day", item.remind_interval_day || 0);
    $clone.attr("data-stock-control-id", item.stock_control_id || null);
    $clone.attr("data-quantity", item.quantity);
    //append gross profit
    $clone.attr("data-gross-profit", ((item.sales_unit_price || 0) - (item.average_price || 0)));
    //
    if (list == ".list-wrapper") {
      $clone.find(".btn-add").addClass("fa-trash-alt").removeClass('fa-Plus');
      $clone.find(".item__add").removeClass('item__add').addClass('delete-selected-item')
    }
    //draw it
    $list.append($clone);
    return $clone
  }

  shopInvoice.addStockControlItem = function(item, list, index){
    var $list = $(list);
    var $clone = $("#stock-control-item-clone").find(".list-item").clone();
    $clone.find(".item__count").text(index);
    $clone.find(".item__name").text(item.data("shop-alias-name"));
    $clone.find(".item__stock").text(item.data("stock-quantity"));
    $clone.find(".item__purchase__unit__price").val((item.data("purchase-unit-price") || 0).toLocaleString('id-ID'));
    $clone.find(".item__purchase__unit__price").attr('data-raw-data', item.data("purchase-unit-price"));
    $clone.find(".item__incoming__stock").val((item.data("quantity")) ? (item.data("quantity")).toLocaleString('id-ID') : (item.data("quantity")));
    $clone.find(".item__incoming__stock").attr('data-raw-data', item.data("quantity"));
    $clone.find(".item__shop__product__id").val(item.data("id"));
    $list.append($clone);
  }

  shopInvoice.addStockControlList = function(list, status){
    var $list = $("#stock-control-list");
    $list.empty();
    list.forEach(function(item, index){
      var $clone = $("#stock-control-item-clone").find(".list-item").clone();
      $clone.find(".item__count").text(index+1);
      $clone.find(".item__name").text(item.shop_alias_name);
      $clone.find(".item__stock").text(item.product_stock);
      $clone.find(".item__stock__at__close").text((status=='open' ? item.product_stock : item.stock_at_close));
      $clone.find(".item__stock__control__id").val(item.stock_control_id);
      $clone.find(".item__purchase__unit__price").val((item.purchase_unit_price || 0).toLocaleString('id-ID'));
      $clone.find(".item__purchase__unit__price").attr('data-raw-data', item.purchase_unit_price);
      $clone.find(".item__incoming__stock").val((item.quantity) ? (item.quantity).toLocaleString('id-ID') : (item.quantity));
      $clone.find(".item__incoming__stock").attr('data-raw-data', item.quantity);
      $clone.find(".item__shop__product__id").val(item.shop_product_id);
      $clone.find(".item__stock_difference").text((item.difference || 0).toLocaleString('id-ID'));
      $clone.find(".item__stock_difference").attr('data-raw-data', item.difference);
      shopInvoice.setDifference($clone.find(".item__stock_difference"), item.difference);
      
      $list.append($clone);
    })
  }

  shopInvoice.updateStockControlList = function(list, status){
    var $list = $("#stock-control-list");
    //$list.empty();
    list.forEach(function(item, index){
      if(shopInvoice.existing.includes(item)){
        return;
      }

      var $clone = $("#stock-control-item-clone").find(".list-item").clone();
      $clone.find(".item__count").text(index+1);
      $clone.find(".item__name").text(item.data("shop-alias-name"));
      $clone.find(".item__stock").text(item.data("stock-quantity"));
      $clone.find(".item__stock__at__close").text(item.data("stock-quantity"));
      $clone.find(".item__stock__control__id").val(item.data("stock-control-id"));
      $clone.find(".item__purchase__unit__price").val((item.data("purchase-unit-price") || 0).toLocaleString('id-ID'));
      $clone.find(".item__purchase__unit__price").attr('data-raw-data', item.data("purchase-unit-price"));
      $clone.find(".item__average__price").val((item.data("average-price") || 0).toLocaleString('id-ID'));
      $clone.find(".item__average__price").attr('data-raw-data', item.data("average-price"));
      $clone.find(".item__incoming__stock").val((item.data("quantity")) ? (item.data("quantity")).toLocaleString('id-ID') : (item.data("quantity")));
      $clone.find(".item__incoming__stock").attr('data-raw-data', item.data("quantity"));
      $clone.find(".item__shop__product__id").val(item.data("id"));
      $clone.find(".item__id").val(item.data("id"));
      $list.append($clone);
      $clone.find('.show_close_only').addClass('hide');
      shopInvoice.existing.push(item);
    });
    shopInvoice.originalItems.forEach(function(item, index){
      var $item = $("#stock-control-list .list-item").eq(index);
    });
  }

  shopInvoice.removeItem = function(id){
    var element = $(".list-wrapper .list-item").filter(function(index,item){
      return $(item).data("id") == id;
    })
    $(element).remove();
    no_selected_info();
    $("#selected-counter span").text(shopInvoice.selected.length);
    if(shopInvoice.selected.length == 0){
      $("#selected-counter").removeClass('bg-success')
      $("#selected-counter i").removeClass('fa-check-circle')
    }
  }

  shopInvoice.reSelect = function(){
    shopInvoice.selected.forEach(function(item){
      if(!shopInvoice.existing.includes(item)){
        shopInvoice.existing.push(item);
      }
      var id = $(item).data("id")
      var $selectedItem = $("#product_list").find(`[data-id='${$(item).data("id")}']`)
      if($selectedItem.length>0){
        $selectedItem.find(".btn-add").addClass("color-status-ok fa-check").removeClass('fa-plus');
        $("#selected-counter").addClass("bg-success");
        $("#selected-counter i").addClass("fa-check-circle");
      }else{
        $("#selected-counter").removeClass("bg-success");
        $("#selected-counter i").removeClass("fa-check-circle");
      }
    });
  }

  shopInvoice.update = function() {
    $('#invoice_list').LoadingOverlay('show');
    var params = {
      shop_invoices: shopInvoice.getHot().getSourceData(),
      shop_id: $('#select_shop').val(),
      invoice_category_id: $('#select_category').val(),
    };
    putAjax(
      'shop_invoices/update.json',
      params,
      function(data) {
        $('#invoice_list').LoadingOverlay('hide');
        if (data.msg === 'success') {
          shopInvoice.loadData();
        } else {
          alert(data.msg);
        }
      },
      false
    );
  }

  shopInvoice.getSupplier = function(shop) {
    if (
      Object.keys(shopInvoice.getCacheSupplier(shop)).length === 0
    ) {
      var list = {};
      getAjax(
        `suppliers/${shop}`,
        null,
        function(data) {
          list = data;
        },
        false
      );
      shopInvoice.setCacheSupplier(shop, list);
    }
    return shopInvoice.getCacheSupplier(shop);
  }

  shopInvoice.setDifference = function($element, value){
    if (value > 0) {
      $element.removeClass('stock_minus').removeClass('stock_equal');
      $element.addClass('stock_plus');
    } else if (value < 0) {
      $element.removeClass('stock_plus').removeClass('stock_equal');
      $element.addClass('stock_minus');
    } else {
      $element.removeClass('stock_minus').removeClass('stock_plus');
      $element.addClass('stock_equal');
    }
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
    coreAjax('DELETE', url, data, callback, async);
  }

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/' + url
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

  shopInvoice.handleItemEditClickEvent = function(){
    $("#invoice_list .list-item").on("click", function(event){
      //target contains all data to populate edit form
      var $target = $(this);
      shopInvoice.invoiceId = $target.data("id");
      shopInvoice.isClosed = $target.hasClass("closed-item");
    })
  }

  shopInvoice.formatProductData = function(data, obj) {
    Object.keys(data).forEach(function(key){
      obj[key] = data[key].name;
    });
  }

  shopInvoice.getFormattedProductData = function(category) {
    var product_data = shopInvoice.getProductData(category);
    var formatted_product_data = {
      admin_products: {},
      variants: {},
      tech_specs: {}
    };
    shopInvoice.formatProductData(product_data.admin_products, formatted_product_data.admin_products);
    shopInvoice.formatProductData(product_data.variants, formatted_product_data.variants);
    shopInvoice.formatProductData(product_data.tech_specs, formatted_product_data.tech_specs);

    return formatted_product_data;
  }

  shopInvoice.getProductData = function(category) {
    if (
      Object.keys(shopInvoice.getCacheProductData(category)).length === 0
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
        'shop_products/admin_products.json',
        params,
        function(data) {
          data.forEach(function(val){
            list[val.id] = val;
          });
        },
        false
      );
      getAjax(
        'shop_products/variants.json',
        params,
        function(data) {
          data.forEach(function(val){
            variants[val.id] = val;
          });
        },
        false
      );
      getAjax(
        'shop_products/tech_specs.json',
        params,
        function(data) {
          data.forEach(function(val){
            tech_specs[val.id] = val;
          });
        },
        false
      );
      
      shopInvoice.setCacheProductData(category, list, variants, tech_specs);
    }
    return shopInvoice.getCacheProductData(category);
  }

  shopInvoice.createOptionDropdown = function(data) {
    var options = "<option value=''></option>"
    Object.keys(data).forEach(function(key){
      var node = `<option value=${key}>${data[key]}</option>`
      options = options + node;
    });

    return options;
  }

  shopInvoice.getProductDataForDropdown = function($select, category_id){
    $select.empty();
    var product_data = shopInvoice.getFormattedProductData(category_id);
    if (Object.keys(product_data).length > 0) {
      //set selectors
      var options = "<option value=''></option>";
      switch($select.attr("name")) {
        case "admin_product_id":
          var options = shopInvoice.createOptionDropdown(product_data.admin_products);
          break;
        case "variant_id":
          var options = shopInvoice.createOptionDropdown(product_data.variants);
          break;
        case "tech_spec_id":
          var options = shopInvoice.createOptionDropdown(product_data.tech_specs);
          break;
      };
      $select.append(options);
    }
  }

  shopInvoice.getStockHistory = function(product_id){
    var params = {
      shop_product_id: product_id
    };
    getAjax(
      'shop_products/stock_controls.json',
      params,
      function(data) {
        $("#purchase_history").empty();
        data.forEach(function(item){
          shopInvoice.addPurchaseHistory(item);
        })
      },
      false
    );
  }

  shopInvoice.getUpdateData = function(){
    var inputDate = new Date($("#arrival_date").val());
    var arrival_date = new Date(inputDate.setHours(inputDate.getHours()));
    var $items = $("#edit-invoice-form #stock-control-list .list-item")
    
    var invoice = {
      id : shopInvoice.invoiceId,
      shop_id : $("#shop_id").val(),
      invoice_no : $("#invoice_no").val(),
      supplier_id : $("#supplier_id").val(),
      arrival_date : arrival_date,
      payment_method: $("#payment_method").val(),
      status: $("#status:checked").length,
      stock_controls : [],
      destroy_items : []
    }
    $items.each(function(index,item){
      item = $(item);
      var data = {
        id : item.find(".item__stock__control__id").val(),
        shop_invoice_id : shopInvoice.invoiceId,
        quantity: item.find(".item__incoming__stock").attr('data-raw-data'),
        purchase_price: (item.find(".item__incoming__stock").attr('data-raw-data') || 0)*(item.find('.item__purchase__unit__price').attr('data-raw-data')||0),
        purchase_unit_price: item.find('.item__purchase__unit__price').attr('data-raw-data'),
        shop_product_id: item.find(".item__shop__product__id").val(),
        supplier_id: $("#supplier_id").val(),
        payment_method: $("#payment_method").val(),
        date: $("#arrival_date").val(),
        difference: item.find(".item__stock_difference").attr('data-raw-data') || item.find(".item__incoming__stock").attr('data-raw-data')
      }
      invoice.stock_controls.push(data);
    })

    invoice.destroy_items = shopInvoice.destroyItems;
    return invoice;
  }

  shopInvoice.compareState = function(){
    var newState = JSON.stringify($("#edit-invoice-form").serializeArray());
    $("#confirm-edit-invoice-button").attr("disabled", newState==shopInvoice.formState);
  }

  shopInvoice.validateForm = function() {
    var isValid = true;
    $('#stock-control-list .form-field').each(function() {
      if ( $(this).val() === '' ) {
          isValid = false;
      }
    });
    $("#confirm-edit-invoice-button").attr("disabled", !isValid);
  }

  shopInvoice.adjustStockControlScrollArea = function() {
    var $container = $('#list-invoice-search-body-section');
    var wh = $(window).height();
    var main_header = $('.main-header').outerHeight();
    var main_footor = 0;
    var header = $('.content-header').outerHeight();
    var search_area = $('#list-invoice-search-section').outerHeight();
    $container.find('.products-box-admin').outerHeight(wh - main_header - header - search_area - main_footor - 40);
    $('#list-invoice-search-body-section .products-box-admin').on('scroll', shopInvoice.onScrollSearchListStockControl);
  }

  shopInvoice.onScrollSearchListStockControl = function() {
    var scrollTop = $('#list-invoice-search-body-section .products-box-admin').scrollTop();
    var boxH = $('#list-invoice-search-body-section .products-box-admin').outerHeight();
    var listH = $('#list-invoice-search-body-section .scroll-area').outerHeight();
    var noMoreResult = $('#shop_invoice_search_no_more_result').val();
    if (listH - boxH <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
      $('#list-invoice-search-body-section .loading').removeClass('hide');
      shopInvoice.loadData(false, function() {
        $('#list-invoice-search-body-section .loading').addClass('hide');
      });
    }
  }

  shopInvoice.getInvoice = function(invoice_id) {
    var invoice = null;
    getAjax(
      `shop_invoices/${invoice_id}`,
      null,
      function(data) {
        invoice = data.invoice;
      },
      false
    );
    return invoice;
  }

  shopInvoice.openEditInvoiceModal = function(event, data) {	
    if (data !== "#editInvoiceModal") return;
    $("#confirm-edit-invoice-button").attr("disabled", true);
    var data = shopInvoice.getInvoice(shopInvoice.invoiceId);
    $("#shop_id").val(data.shop_id);
    //set invoice no
    $("#invoice_no").val(data.invoice_no);
    //set supplier
    $("#supplier_id").val(data.supplier_id);
    //set payment
    $("#payment_method").val(data.payment_method);
    //set arrival date
    var locale = window.navigator.userLanguage || window.navigator.language;
    //so Mark can test
    if(locale=="en-US"){
      locale = "ja-JP"
    }
    $("#arrival_date").val(moment(new Date(data.arrival_date)).format("YYYY-MM-DDTHH:mm"));
    //set status
    $("#status").prop("checked", data.status == "closed");

    //add stock control list
    shopInvoice.originalItems = data.shop_products
    $(".list-wrapper").empty();
    if(shopInvoice.originalItems.length){
      shopInvoice.selected = [];
      shopInvoice.originalItems.forEach(function(item, index){
        shopInvoice.addProductItem(item, ".list-wrapper");
      })
      $(".list-wrapper .list-item").each(function(index, item){
        var $clone = $(item).clone();
        $clone.data("disabled", true);
        shopInvoice.selected.push($clone);
      })
      $("#selected-counter span").text(shopInvoice.originalItems.length);
    }
    var $list = $("#stock-control-list");
    $list.empty();
    data.shop_products.forEach(function(item, index){
      var $clone = $("#stock-control-item-clone").find(".list-item").clone();
      $clone.find(".item__count").text(index + 1);
      $clone.find(".item__name").text(item.shop_alias_name);
      $clone.find(".item__stock").text(item.product_stock);
      $clone.find(".item__stock__at__close").text((data.status=='open' ? item.product_stock : item.stock_at_close));
      $clone.find(".item__stock__control__id").val(item.stock_control_id);
      $clone.find(".item__purchase__unit__price").val((item.purchase_unit_price || 0).toLocaleString('id-ID'));
      $clone.find(".item__purchase__unit__price").attr('data-raw-data', item.purchase_unit_price);
      $clone.find(".item__average__price").val((item.average_price || 0).toLocaleString('id-ID'));
      $clone.find(".item__average__price").attr('data-raw-data', item.average_price);
      $clone.find(".item__incoming__stock").val((item.quantity || 0).toLocaleString('id-ID'));
      $clone.find(".item__incoming__stock").attr('data-raw-data', item.quantity);
      $clone.find(".item__shop__product__id").val(item.shop_product_id);
      $clone.find(".item__stock_difference").text((item.difference || 0).toLocaleString('id-ID'));
      $clone.find(".item__stock_difference").attr('data-raw-data', item.difference);
      shopInvoice.setDifference($clone.find(".item__stock_difference"), item.difference);
      if (data.status=='open') {
        $clone.find('.show_close_only').addClass('hide');
      }
      $list.append($clone);
    });

    //set form state
    shopInvoice.formState = JSON.stringify($("#edit-invoice-form").serializeArray());
    //reset events
    //disable all inputs if the item is closed
    if (shopInvoice.isClosed) {
      $("#edit-invoice-form input, #edit-invoice-form select, #edit-invoice-form button").attr("disabled", true);
    } else {
      $("#edit-invoice-form input, #edit-invoice-form select, #edit-invoice-form button").attr("disabled", false);
      $("#stock-control-list .list-item .item__destroy").off().on("click", function(event){
        var $element = $(this).parents(".list-item");
        var stockControlId = $element.find(".item__stock__control__id").val();
        shopInvoice.destroyItems.push(stockControlId);
        $element.remove();
        shopInvoice.compareState();
      });
    }
  }

  shopInvoice.openAddProductModal = function(event, data) {
    if (data !== "#addProductModal") return;

    $('#add-admin-product_id').select2({
      width: 'resolve',
      placeholder: 'Pilih kategori terlebih dahulu'
    });
    $('#product_category_id').select2({width: 'resolve'});
    $('#brand_id').select2({width: 'resolve'});
    $('#variant_id').select2({width: 'resolve'});
    $('#tech_spec_id').select2({width: 'resolve'});

    $('#addProductModal').find("input[type='text']").val(null);
    $("#confirm-add-product-button").attr("disabled", true);
    $('input[name="availability"]').eq(0).click();
    $('#addProductModal input[name="admin_product_id"]').val(null).trigger("change");
    $("#product_category_id").val($('#select_category').val()).trigger("change");
    $("#add-admin-product_id").val(null).trigger("change").attr("disabled", true);
    $("#brand_id").val(null).trigger("change").attr("disabled", true);
    $("#variant_id").val(null).trigger("change").attr("disabled", true);
    $("#tech_spec_id").val(null).trigger("change").attr("disabled", true);
    $('#shop_alias_name').val(null);
    $('#sales_unit_price').val(null);
    $('#stock_minimum').val(null);
    $('#remind_interval_day').val(null);
    setTimeout(()=>{shopInvoice.reSelect()},300);
  }

  shopInvoice.openFindProductModal = function(event, data) {
    if (data !== "#findProductModal") return;

    // adjustScrollArea
    shopInvoice.adjustProductListScrollArea();

    shopInvoice.loadProductData();

    $('#select_category').select2({width: 'resolve'});
    $('#select_sort').select2({width: 'resolve'});
    $('#select_use').select2({width: 'resolve'});

    setTimeout(()=>{shopInvoice.reSelect()},300);
    $("#product_list .list-item").find(".icon-Plus").removeClass("btn-circle-primary");
  }


  shopInvoice.adjustProductListScrollArea = function() {
    var $container = $('#list-search-body-section');
    var modal = $("#findProductModal .modal_content").outerHeight();
    var modal_header = $("#findProductModal").find('.modal-header').outerHeight();
    var search_area = $('#list-search-section').outerHeight();
    var sheet_modal_header = $('#selectAddProductModal .modal-down').outerHeight();
    var foot = $('#findProductModal .admin-control-footer').outerHeight();
    var box_height = modal - modal_header - search_area - foot - sheet_modal_header - 50;
    $container.find('.products-box-admin').outerHeight(box_height);
    $('#list-search-body-section .products-box-admin').on('scroll', shopInvoice.onScrollSearchList);
  }

  shopInvoice.onScrollSearchList = function() {
    var scrollTop = $('#list-search-body-section .products-box-admin').scrollTop();
    var boxH = $('#list-search-body-section .products-box-admin').outerHeight();
    var listH = $('#list-search-body-section .scroll-area').outerHeight();
    var noMoreResult = $('#shop_product_search_no_more_result').val();
    if (listH - boxH <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
      $('#list-search-body-section .loading').removeClass('hide');
      shopInvoice.loadProductData(false, function() {
        $('#list-search-body-section .loading').addClass('hide');
      });
    }
  }

  shopInvoice.reloadSupplier = function() {
    var shop_id = $("#select_shop").val();
    shopInvoice.setSupplierSelect($('#supplier_id'), shop_id);
  }

  shopInvoice.setSupplierSelect = function($select, shop_id){
    $select.empty();
    var list = shopInvoice.getSupplier(shop_id);
    if (Object.keys(list).length > 0) {
      //set selectors
      var options = "";
      Object.keys(list).forEach(function(key){
        var node = `<option value=${key}>${list[key]}</option>`;
        options = options + node;
      });
      $select.append(options);
    }
  }

  onPageLoad("shop_invoices#index", function() {
    // shopInvoice.adjustStockControlScrollArea();
    shopInvoice.loadData();

    // invoice list
    $('#select_supplier').select2();
    $('#select_invoice_status').select2();
    $('#select_invoice_sort').select2();

    $("#select_supplier").on("change", function(){
      shopInvoice.loadData();
      shopInvoice.reloadSupplier();
    });
    $("#select_invoice_sort").on("change", function(event){
      shopInvoice.loadData();
    });
    $("#select_invoice_status").on("change", function(event){
      shopInvoice.loadData();
    });
    $('#shop-invoice-search-btn').on("click", function(){
      shopInvoice.loadData();
      $("#shop-invoice-search-clear-btn").show();
    });
    $("#shop-invoice-search-clear-btn").on("click", function(event){
      $('.products-box-admin').removeClass('hide');
      $('.no_search_result').addClass('hide');
      $("#shop-invoice-search-clear-btn").hide();
      $("#shop-invoice-search").val(null);
      shopInvoice.loadData();
    })

    $("#shop-invoice-search").on("keyup", function(event) {
      if (event.key === 'Enter') {
        shopInvoice.loadData();
        $("#shop-invoice-search-clear-btn").show();
      }
    })

    // format price number
    $(document).on('input', '.formated_input_number', function(event) {
      var selection = window.getSelection().toString();
      if ( selection !== '' ) {
        return;
      }
      if ( $.inArray( event.keyCode, [38,40,37,39] ) !== -1 ) {
        return;
      }
      var $this = $( this );

      var input = $this.val();
      input = input.replace(/[\D\s\._\-]+/g, "");
      input = input && parseInt( input, 10 );

      $this.val( function() {
        return ( input < 0 ) ? "" : input.toLocaleString( "id-ID" );
      });
      $this.attr('data-raw-data', function() {
        return ( input < 0 ) ? "" : input;
      });
    });

    // paginate
    $(document).on('click', 'nav .pagination a', function(e) {
      e.preventDefault();
      var page = new RegExp('[\?&]' + 'page' + '=([^&#]*)').exec($(this).attr('href'));

      if(page !== null ){
        $('#shop_invoice_search_current_page').val(page[1]);
      }
      else{
        $('#shop_invoice_search_current_page').val(1);
      }
      shopInvoice.loadData(false);
      return false;
    });

    // edit invoice
    $("#confirm-add-invoice-button").on("click", function(){
      shopInvoice.update();
    });

    // find modal
    $("#select_category").on("change", function(event){
      shopInvoice.loadProductData();
    });
    $("#select_sort").on("change", function(event){
      shopInvoice.loadProductData();
    });
    $("#select_use").on("change", function(event){
      shopInvoice.loadProductData();
    });
    $('#shop-product-search-btn').on("click", function(event){
      shopInvoice.loadProductData();
      $("#shop-product-search-clear-btn").show();
    });
    $("#shop-product-search-clear-btn").on("click", function(event){
      shopInvoice.loadProductData();
      $("#shop-product-search-clear-btn").hide();
      $("#shop-product-search").val(null);
    });

    $("#add-admin-product_id").on("change", function(){
      let value = $(this).val();
      if(value){
        $('#addProductModal input[name="admin_product_id"]').val(value);
        var items = shopInvoice.getCacheProductData();
        var category_id = $("#addProductModal .product_category_edit").val();
        var selected = items[category_id].admin_products[parseInt(value)];
        $("#addProductModal").find("[name='item_detail']").val(selected.item_detail);
        $("#brand_id").val(selected.brand_id || null).trigger("change").attr("disabled", true);
        $("#variant_id").val(selected.variant_id || null).trigger("change").attr("disabled", true);
        $("#tech_spec_id").val(selected.tech_spec_id || null).trigger("change").attr("disabled", true);
      }
    });

    $(document).on("modal_open", shopInvoice.openEditInvoiceModal);

    $('#confirm-edit-invoice-button').on('click',function(){
      var data = shopInvoice.getUpdateData();
      postAjax(
        'shop_invoices/update?mode=' + $('#mode').val(),
        { 'data' : data },
        function() {
          $("#invoice_list").empty();
          shopInvoice.loadData();
        },
        false
      );
    });

    $(document).on("keyup","#addProductModal input[name='shop_alias_name']", function(){
      $("#confirm-add-product-button").attr("disabled", false);
    });

    $(document).on("keyup", "#edit-invoice-form input", function(event){
      shopInvoice.compareState();
      shopInvoice.validateForm();
    });
    $(document).on("change", "#edit-invoice-form select, #edit-invoice-form input[type='checkbox'], #edit-invoice-form input[type='date']", function(event){
      shopInvoice.compareState();
      shopInvoice.validateForm();
    });

    $(document).on('click', '.delete-invoice', function(event){
      event.stopImmediatePropagation();
      var item = $(this).parents('li');
      var id = $(this).parents('li').data("id");
      deleteAjax(
        `shop_invoices/${id}`,
        {},
        function(data) {
          item.remove();
        },
        true
      );
    });

    //product events
    $(document).on("click", ".item__destroy", function(){
      var $element = $(this).parents(".list-item");
      var id = $element.find(".item__shop__product__id").val();

      shopInvoice.selected = shopInvoice.selected.filter(function(item){
        return item.data("id")!=id
      });
      $element.remove();
      //remove element from selected list
      shopInvoice.removeItem(id);
    });

    $("#addProductModal .product_category_edit").on("change", function(){
      var category_id = $(this).val();
      //get admin products, variants, and tech specs
      if (category_id != null) {
        shopInvoice.getProductDataForDropdown($("#add-admin-product_id"), category_id);
        shopInvoice.getProductDataForDropdown($("#variant_id"), category_id);
        shopInvoice.getProductDataForDropdown($("#tech_spec_id"), category_id);
      }
      $('#addProductModal input[name="admin_product_id"]').val($("#add-admin-product_id").find("option").val() || null);
      $('#addProductModal input[name="variant_id"]').val($("#variant_id").find("option").val() || null);
      $('#addProductModal input[name="tech_spec_id"]').val($("#tech_spec_id").find("option").val() || null);
      //reset item detail, product no, and brand value
      $('#addProductModal input[name="item_detail"]').val(null);
      $('#addProductModal input[name="product_no"]').val(null);
      $("#brand_id").val(null).trigger("change");
      $('#add-admin-product_id').attr("disabled", false);
    });

    $(document).on("modal_open", shopInvoice.openAddProductModal);
    $(document).on("modal_open", shopInvoice.openFindProductModal);

    $(document).on("click", "#product_list .item__add", function(event){
      //target contains all data to populate edit form
      var $target = $(this).parents(".list-item");

      if ($target.find(".btn-add").hasClass("fa-plus")){
        $target.find(".btn-add").addClass("color-status-ok fa-check").removeClass('fa-plus')
      }else{
        $target.find(".btn-add").removeClass("color-status-ok fa-check").addClass('fa-plus')
      }
      var remove = false;

      var temp = shopInvoice.selected.filter(function(item, index){
        if(item.data("id")!=$target.data("id")){
          return true;
        }else{
          remove = true;
          return false;
        }
      })
      shopInvoice.selected = temp;

      if(!remove){
        var $selected_item = $target.clone()
        $selected_item.find(".item__add").removeClass('item__add').addClass('delete-selected-item')
        $selected_item.find(".btn-add").removeClass('color-status-ok fa-check').addClass('fa-trash-alt')
        shopInvoice.selected.push($selected_item)
      }
      
      $(".list-wrapper").html(shopInvoice.selected);

      var count = shopInvoice.selected.length;
      $("#selected-counter span").text(count);
      var $confirmBtn = $("#confirm-add-products-button");
      count > 0 ? $confirmBtn.removeAttr("disabled") : $confirmBtn.attr("disabled", true);
      if (count > 0){
        $confirmBtn.removeAttr("disabled")
        $("#selected-counter").addClass("bg-success");
        $("#selected-counter i").addClass("fa-check-circle");
      }else{
        $confirmBtn.attr("disabled", true)
        $("#selected-counter").removeClass("bg-success");
        $("#selected-counter i").removeClass("fa-check-circle");
      }
      no_selected_info();
    });

    $(document).on("click", ".delete-selected-item", function() {
      var $element = $(this).parents(".list-item");
      var id = $element.data("id");
  
      shopInvoice.selected = shopInvoice.selected.filter(function(item){
        return item.data("id")!=id;
      })
  
      shopInvoice.removeItem(id);
      var $target = $('button').parents("li[data-id='"+id+"']")
      $target.find('.btn-add').removeClass("color-status-ok fa-check").addClass('fa-plus')
    })

    $('#confirm-add-product-button').on('click',function(){
      if(shopInvoice.processing) {
        return;
      }
      shopInvoice.processing = true;
      var $form = $('#add-product-form');
      var query = $form.serialize();
      query += `&sales_unit_price=${$form.find('#sales_unit_price').attr('data-raw-data')}`;
      query += `&stock_minimum=${$form.find('#stock_minimum').attr('data-raw-data')}`;
      var is_used = "&is_use=" + $form.find('input[name="availability"]:checked').val();
      var is_stock_control = $form.find('#stock_minimum').val().length > 0 ? "&is_stock_control=true" : "&is_stock_control=false";
      var shop_id = "&shop_id=" + $('#select_shop').val();

      postAjax(
        'shop_products/create',
        query + is_used + shop_id + is_stock_control,
        function(data) {
          $form.find(':text, input[type="number"]').val("").end().find(":checked").prop("checked", false);
          shopInvoice.processing = false;
          var $clone = $("#add-product-item-clone").find(".list-item").clone();
          $clone.find(".item__name").text(data.msg.shop_alias_name);
          $clone.find(".item__description").text(data.msg.item_detail);
          //create element and add data
          $clone.find(".item__price").text((data.msg.sales_unit_price ? data.msg.sales_unit_price.toLocaleString("id-ID") : null));
          $clone.find(".item__current__quantity").text(0);
          $clone.find(".item__min__quantity").text(data.msg.stock_minimum || 0);
          $clone.data("shop-alias-name", data.msg.shop_alias_name);
          $clone.data("stock-quantity", 0);
          $clone.data("id", data.msg.id);
          $clone.find(".icon-Plus").addClass("btn-circle-primary");
          shopInvoice.selected.push($clone);
          shopInvoice.updateStockControlList(shopInvoice.selected);
          $("#selected-counter span").text(shopInvoice.selected.length);
          shopInvoice.compareState();
          shopInvoice.validateForm();
        },
        false
      );
    });

    // open add product modal
    $('#confirm-add-products-button').on('click', function(event){
      shopInvoice.updateStockControlList(shopInvoice.selected);
      shopInvoice.validateForm();
    })

    $("#selectAddProductModal .js-modal-toggle").on("click", function(event){
      let target = $(this).data('target');
      let modal = $(target);

      $(modal).fadeIn();
      $(modal).find('.tab_content').toggleClass('active');
      $(modal).find("#view-more").toggleClass("hide");
      $(modal).find("#close").toggleClass("hide");
    });

    if($(".item__stock_difference").length>0){
      $(document).on('keyup', '.item__incoming__stock', function(event){
        let newValue = parseInt($(this).attr('data-raw-data'));
        let stock = parseInt($(this).parents('li').find('.item__stock__at__close').text());
        let difference = newValue-stock;

        if(isNaN(difference)) {
          $(this).parents('li').find(".item__stock_difference").text(null).removeClass("stock_equal stock_plus stock_minus");
        }else {
          $(this).parents('li').find(".item__stock_difference").text((difference).toLocaleString('id-ID')).attr('data-raw-data', difference);
          shopInvoice.setDifference($(this).parents('li').find(".item__stock_difference"), difference);
        }
      });
    }

    $("#cancel-add-product-button").on("click", function(event){
      $("#add-admin-product_id").val(null);
      $("#remind_interval_day").val(null);
    });
  });

}.call(this));
