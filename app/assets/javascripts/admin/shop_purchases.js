(function() {
  'use strict';

  window.app = window.app || {}
  var shopPurchase = window.app.shopPurchase = {};

  shopPurchase.cache_product_data = {};
  shopPurchase.cache_supplier = {};
  shopPurchase.selected = [];
  shopPurchase.existing = [];
  shopPurchase.processing = false;
  var isSearchLoading = false;
  var item_count;
  var data_stock_list = [];
  var stock_list_count = 0;
  shopPurchase.getCacheProductData = function(category) {
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

  shopPurchase.setCacheProductData = function(category, list, variants, tech_specs) {
    this.cache_product_data[category] = {
      admin_products: list,
      variants: variants,
      tech_specs: tech_specs
    };
  }

  shopPurchase.getCacheSupplier = function(shop) {
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

  shopPurchase.setCacheSupplier = function(shop, obj) {
    this.cache_supplier[shop] = obj;
  }

  shopPurchase.isInvoice = function() {
    return $('#is_invoice').val() == 'true';
  }
  shopPurchase.isInventory = function() {
    return $('#is_inventory').val() == 'true';
  }

  //gets data to register via API
  shopPurchase.getData = function(){
    var inputDate = $("#arrival_date").val().length==0 ? new Date() : new Date($("#arrival_date").val());
    var arrival_date = new Date(inputDate.setHours(inputDate.getHours(), inputDate.getMinutes(), 0, 0));
    var $items = $("#add-invoice-form #stock-control-list .list-item")
    var invoice = {
      id: $("#invoice_id").val(),
      shop_id : $("#select_shop").val(),
      invoice_no : $("#invoice_no").val(),
      supplier_id : $("#supplier_id").val(),
      arrival_date : arrival_date,
      payment_method: $("#payment_method").val(),
      status: $("#status:checked").length,
      stock_controls : []
    }
    $items.each(function(index,item){
      item = $(item);
      var data = {
        id : item.find(".item__stock__control__id").val(),
        quantity: item.find(".item__incoming__stock").attr('data-raw-data'),
        purchase_price: (item.find(".item__incoming__stock").attr('data-raw-data') || 0)*(item.find('.item__purchase__unit__price').attr('data-raw-data') || 0),
        purchase_unit_price: item.find('.item__purchase__unit__price').attr('data-raw-data'),
        shop_product_id: item.find(".item__shop__product__id").val(),
        is_stock_control: item.find(".item__is_stock_control").is(":checked"),
        supplier_id: $("#supplier_id").val(),
        payment_method: $("#payment_method").val(),
        date: $("#arrival_date").val(),
        difference: item.find(".item__stock_difference").attr('data-raw-data')
      }
      invoice.stock_controls.push(data)
    })
    return invoice;
  }

  function no_selected_info() {
    if(shopPurchase.selected.length == 0){
      $('.no_selected_item').removeClass('hide');
    }else{
      $('.no_selected_item').addClass('hide');
    }
  }

  shopPurchase.loadData = function(empty, callback) {
    if(isSearchLoading){
      return;
    }
    if (empty == undefined) {
      empty = true;
    }
    var params = {
      shop_id: $('#select_shop').val(),
      product_category_id: $('#select_category').val(),
      search: $('#shop-product-search').val(),
      sort: $('#select_sort').val(),
      is_use: $('#select_use').val()
    };
    var $product_list = $('#product_list');
    var current_page = parseInt($('#shop_product_search_current_page').val());
    if (empty) {
      current_page = 1;
      $('#list-search-body-section .loading').removeClass('hide');
      $('#list-search-body-section .products-box-admin').scrollTop(0);
      $("#product-list-header").hide();
      $product_list.empty();
    }
    params['page'] = current_page;
    isSearchLoading = true;
    $('#list-search-body-section .no_search_result').addClass('hide');
    $('#list-search-body-section .end_of_list').addClass('hide');
    $.ajax({
      url: '/api/admin/shop_products/list.json',
      dataType: 'json',
      data: params,
      method: 'GET'
    }).then(function(data) {
      if (empty) {
        $('#shop_product_search_current_page').val('1');
      }
      if (data.product.length != 0) {
        data.product.forEach(function(item, index){
          shopPurchase.addItem(item);
        })
        $('#shop_product_search_no_more_result').val('false');
        $('#shop_product_search_current_page').val(current_page + 1);
        $('#list-search-body-section .no_search_result').addClass('hide');
        $("#product-list-header").show();
      } else if (data.product.length == 0 && data.paginator) {
        $('#shop_product_search_no_more_result').val('true');
        $('#list-search-body-section .end_of_list').removeClass('hide');
      } else {
        $('#shop_product_search_no_more_result').val('true');
        $('#list-search-body-section .no_search_result').removeClass('hide');
      }
      shopPurchase.reSelect();
      shopPurchase.handleItemEditClickEvent();
      no_selected_info();
    }).always(function(){
      if (callback != undefined) {
        callback();
      }
      isSearchLoading = false;
      $('#list-search-body-section .loading').addClass('hide');
      if ($("#check-box-icon").hasClass("fas fa-check-square")) {
        $("#product_list li").find(".fa-plus").parents(".item__add").trigger("click");
      }
    });
  }

  shopPurchase.addItem = function(item, list){
    list = list || '#product_list';
    var $list = $(list);
    var $clone = $("#add-product-item-clone").find(".list-item").clone();
    //set UI
    $clone.find(".item__name").text(item.shop_alias_name);
    $clone.find(".item__description").text(item.item_detail);
    //null check
    $clone.find(".item__price").text((item.sales_unit_price ? ("Rp"+item.sales_unit_price.toLocaleString("id-ID")) : null));
    $clone.find(".item__current__quantity").text(item.stock_quantity || 0);
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
    $clone.attr("data-stock-quantity", item.stock_quantity || 0);
    $clone.attr("data-remind-interval-day", item.remind_interval_day || 0);
    //append gross profit
    $clone.attr("data-gross-profit", ((item.sales_unit_price || 0) - (item.average_price || 0)));
    //
    if(list == ".list-wrapper"){
      $clone.find(".btn-add").addClass("color-status-ok fa-check").removeClass('fa-Plus');
    }
    //draw it
    $list.append($clone);
  }

  shopPurchase.addStockControlList = function(list){
    
    var $list = $("#stock-control-list");
    var idList = [];
    
    list.forEach(function(item, index){

      data_stock_list.push(item.data());
      var is_stock_control_status = item.data("is-stock-control");
      idList.push(item.data("id"));

      if(shopPurchase.existing.includes(item.data("id"))){
        return;
      }
      var $clone = $("#stock-control-item-clone").find(".list-item").clone();
      $clone.find(".item__count").text(index + 1);
      $clone.find(".item__name").text(item.data("shop-alias-name"));
      $clone.find(".item__description").text(item.data("item-detail"));
      $clone.find(".item__stock").text(item.data("stock-quantity"));
      $clone.find(".item__purchase__unit__price").val((item.data("purchase-unit-price") || 0).toLocaleString('id-ID'));
      $clone.find(".item__purchase__unit__price").attr('data-raw-data', item.data("purchase-unit-price"));
      $clone.find(".item__incoming__stock").val((item.quantity) ? (item.quantity).toLocaleString('id-ID') : (item.quantity));
      $clone.find(".item__incoming__stock").attr('data-raw-data', item.quantity);
      $clone.find(".item__shop__product__id").val(item.data("id"));
      $clone.find(".is_stock_confirm").attr("data-id", item.data("id"));
      $clone.find(".is_stock_back").attr("data-id", item.data("id"));
      $clone.find(".is_stock_cancel").attr("data-id", item.data("id"));
      $clone.find(".item__is_stock_control").attr("data-id", item.data("id"));
      if (is_stock_control_status == true) {
        $clone.find(".is_stock_confirm").hide();
        $clone.find(".item__is_stock_control").attr("checked", true);
      } else {
        $clone.find(".is_stock_confirm").show();
        $clone.find(".item__is_stock_control").attr("checked", false);
      }
      $clone.find(".is_stock_cancel").hide();
      $clone.find(".is_stock_back").hide();
      $clone.find("#item__total").text(0);
      $clone.find(".item__stock_difference").text((item.difference || 0).toLocaleString('id-ID'));
      $clone.find(".item__stock_difference").attr('data-raw-data', item.difference);
      
      $list.append($clone);
      shopPurchase.existing.push(item.data("id"));
    });

    var deleted_ids = shopPurchase.existing.filter(function(item){
      if (!idList.includes(item)) {
        return item;
      }
    });

    deleted_ids.forEach(function(id){
      var deleted_element = $("#stock-control-list li").find(`[value='${id}']`).parent();
      deleted_element.remove();
      shopPurchase.existing = shopPurchase.existing.filter(function(item){
        return item != id;
      })
    });

    item_count = $("#stock-control-list li").length;
    $("#item_count").text(item_count);
    $("#confirm-add-invoice-button").attr("disabled", !shopPurchase.validateForm());
    $("#confirm-edit-invoice-button").attr("disabled", !shopPurchase.validateForm());
  }

  shopPurchase.removeItem = function(id){
    var element = $(".list-wrapper .list-item").filter(function(index,item){
      return $(item).data("id") == id;
    })
    $(element).remove();
    
    $("#selected-counter span").text(shopPurchase.selected.length);
    if(shopPurchase.selected.length == 0){
      $("#selected-counter").removeClass('bg-success')
      $("#selected-counter i").removeClass('fa-check-circle')
    }

    no_selected_info();
  }

  shopPurchase.reSelect = function(){
    shopPurchase.selected.forEach(function(item){
      var id = $(item).data("id");
      var $selectedItem = $("#product_list").find(`[data-id='${id}']`);
      if($selectedItem.length>0){
        $selectedItem.find(".btn-add").addClass("color-status-ok fa-check").removeClass('fa-plus');
      }
    });
  }

  function getAjax(url, data, callback, async) {
    coreAjax('GET', url, data, callback, async);
  }

  function postAjax(url, data, callback, async) {
    coreAjax('POST', url, data, callback, async);
  }

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/' + url;
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

  shopPurchase.handleItemEditClickEvent = function(){
    $(".item__add").off().on("click", function(event){

      var $target = $(this).parents(".list-item");

      if ($target.find(".btn-add").hasClass("fa-plus")){
        $target.find(".btn-add").addClass("color-status-ok fa-check").removeClass('fa-plus')
      }else{
        $target.find(".btn-add").removeClass("color-status-ok fa-check").addClass('fa-plus')
        $("#check-box-icon").addClass("far fa-square").removeClass("fas fa-check-square");
      }

      var remove = false;

      var temp = shopPurchase.selected.filter(function(item, index){
        if(item.data("id")!=$target.data("id")){
          return true;
        }else{
          remove = true;
          return false;
        }
      });
      shopPurchase.selected = temp;

      if(!remove){
        var $selected_item = $target.clone()
        $selected_item.find(".item__add").removeClass('item__add').addClass('delete-selected-item')
        $selected_item.find(".btn-add").removeClass('color-status-ok fa-check').addClass('fa-trash-alt')
        shopPurchase.selected.push($selected_item)
      }

      $(".list-wrapper").html(shopPurchase.selected);
      var count = shopPurchase.selected.length;
      $("#selected-counter span").text(count)

      var $confirmBtn = $("#confirm-add-products-button");
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
  }

  $(document).on("click", ".delete-selected-item", function() {
    var $element = $(this).parents(".list-item");
    var id = $element.data("id");

    shopPurchase.selected = shopPurchase.selected.filter(function(item){
      return item.data("id")!=id;
    })

    shopPurchase.removeItem(id);
    var $target = $('button').parents("li[data-id='"+id+"']")
    $target.find('.btn-add').removeClass("color-status-ok fa-check").addClass('fa-plus')
  })

  shopPurchase.formatProductData = function(data, obj) {
    Object.keys(data).forEach(function(key){
      obj[key] = data[key].name;
    });
  }

  shopPurchase.getFormattedProductData = function(category) {
    var product_data = shopPurchase.getProductData(category);
    var formatted_product_data = {
      admin_products: {},
      variants: {},
      tech_specs: {}
    };
    shopPurchase.formatProductData(product_data.admin_products, formatted_product_data.admin_products);
    shopPurchase.formatProductData(product_data.variants, formatted_product_data.variants);
    shopPurchase.formatProductData(product_data.tech_specs, formatted_product_data.tech_specs);

    return formatted_product_data;
  }

  shopPurchase.getProductData = function(category) {
    if (
      Object.keys(shopPurchase.getCacheProductData(category)).length === 0
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
      
      shopPurchase.setCacheProductData(category, list, variants, tech_specs);
    }
    return shopPurchase.getCacheProductData(category);
  }

  shopPurchase.getSuppliers = function(shop) {
    var suppliers = shopPurchase.getSupplier(shop);
    var formatted_suppliers = {};
    Object.keys(suppliers).forEach(function(key){
      formatted_suppliers[key] = suppliers[key].name;
    });
    return formatted_suppliers;
  }

  shopPurchase.getSupplier = function(shop) {
    if (
      Object.keys(shopPurchase.getCacheSupplier(shop)).length === 0
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
      shopPurchase.setCacheSupplier(shop, list);
    }
    return shopPurchase.getCacheSupplier(shop);
  }

  shopPurchase.createOptionDropdown = function(data) {
    var options = "<option value=''></option>"
    Object.keys(data).forEach(function(key){
      var node = `<option value=${key}>${data[key]}</option>`
      options = options + node;
    });

    return options;
  }

  shopPurchase.getProductDataForDropdown = function($select, category_id){
    $select.empty();
    var product_data = shopPurchase.getFormattedProductData(category_id);
    if (Object.keys(product_data).length > 0) {
      //set selectors
      var options = "<option value=''></option>";
      switch($select.attr("name")) {
        case "admin_product_id":
          var options = shopPurchase.createOptionDropdown(product_data.admin_products);
          break;
        case "variant_id":
          var options = shopPurchase.createOptionDropdown(product_data.variants);
          break;
        case "tech_spec_id":
          var options = shopPurchase.createOptionDropdown(product_data.tech_specs);
          break;
      };
      $select.append(options);
    }
  }

  shopPurchase.setSupplierSelect = function($select, shop_id){
    $select.empty();
    var list = shopPurchase.getSupplier(shop_id);
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

  shopPurchase.setDifference = function($element, value){
    if (value > 0) {
      $element.removeClass('stock_minus').removeClass('stock_equal');
      $element.addClass('stock_plus');
    } else if (value < 0) {
      $element.removeClass('stock_plus').removeClass('stock_equal');
      $element.addClass('stock_minus');
    } else {
      $element.removeClass('stock_minus').removeClass('stock_plus');
    }
  }

  shopPurchase.openAddProductModal = function(event, data) {
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
    $("#confirm-add-product-button").addClass("button-inactive").attr("disabled", true);
    $('input[name="availability"]').eq(0).click();
    $('#addProductModal input[name="admin_product_id"]').val(null).trigger("change");
    $("#product_category_id").val($('#select_category').val()).trigger("change");
    $("#add-admin-product_id").val(null).trigger("change").attr("disabled", true);
    $("#brand_id").val(null).trigger("change").attr("disabled", true);
    $("#variant_id").val(null).trigger("change").attr("disabled", true);
    $("#tech_spec_id").val(null).trigger("change").attr("disabled", true);
    $('#shop_alias_name').val(null);
    $('#sales_unit_price').val(null);
    $('#remind_interval_day').val(null);
    $('#stock_minimum_status').hide();
    $('#stock_minimum_product').val(0).prop("disabled", true).addClass('text-color-disabled');
    $('#is_stock_control').prop("checked", false).trigger("change");

    shopPurchase.stockConfigHandler();
  }

  shopPurchase.openFindProductModal = function(event, data) {
    if (data !== "#findProductModal") return;

    // adjustScrollArea
    shopPurchase.adjustProductListScrollArea();

    shopPurchase.loadData();

    $('#select_category').select2({width: 'resolve'});
    $('#select_sort').select2({width: 'resolve'});
    $('#select_use').select2({width: 'resolve'});

    setTimeout(()=>{shopPurchase.reSelect()},300);
    $("#product_list .list-item").find(".btn-add").removeClass("fa-check color-status-ok ").addClass('fa-plus');
  }

  shopPurchase.clickConfirmAddProduct = function() {
    if(shopPurchase.processing)
      return;

    shopPurchase.processing = true;
    var $form = $('#add-product-form');
    var query = $form.serialize();
    var is_stock_control = '&is_stock_control=' + $('#is_stock_control').prop("checked");
    var is_use = '&is_use=' + $('#is_use').prop("checked");
    var shop_id = "&shop_id=" + $('#select_shop').val();
    postAjax(
      'shop_products/create',
      query + shop_id + is_stock_control + is_use,
      function(data) {
        $form.find(':text, input[type="number"]').not('#stock_minimum_product').val("").end().find(":checked").prop("checked", false);
        $form.find('.formated_input_number').attr('data-raw-data', '');
        shopPurchase.processing = false;
        //create element and add data
        var elem = document.createElement("div");
        var $elem = $(elem);
        $elem.data("shop-alias-name", data.msg.shop_alias_name);
        $elem.data("item-detail", data.msg.item_detail);
        $elem.data("is-stock-control", data.msg.is_stock_control);
        $elem.data("stock-quantity", 0);
        $elem.data("id", data.msg.id);

        shopPurchase.selected.push($elem);
        shopPurchase.addStockControlList(shopPurchase.selected);
        shopPurchase.addItem(data.msg,".list-wrapper");
        $("#selected-counter span").text(shopPurchase.selected.length);
      },
      false
    );
  }

  shopPurchase.clickConfirmAddProducts = function(event) {
    shopPurchase.addStockControlList(shopPurchase.selected);
  }

  shopPurchase.clickConfirmEditInvoice = function(event){
    if (stock_list_count != 0) {
      $('.item_stock_list_count').text(stock_list_count);
      $("#stockControlNotif").modal("show")
    } else {
      shopPurchase.clickConfirmEditInvoiceModal();
    }
  }
  
  shopPurchase.clickConfirmEditInvoiceModal = function(event){ 
    var data = shopPurchase.getData();
    postAjax(
      'shop_invoices/update',
      { 
        'mode' : $('#mode').val(),
        'data' : data 
      },
      function() {
        $('#invoice_list_link')[0].click();
        shopPurchase.resetData();
      },
      false
    );
  }

  shopPurchase.clickConfirmAddInvoiceModal = function(event){
    var data = shopPurchase.getData();
    postAjax(
      'shop_invoices/create',
      { 
        'mode' : $('#mode').val(),
        'data' : data 
      },
      function() {
        $('#invoice_list_link')[0].click();
        shopPurchase.resetData();
      },
      false
    );
  }

  shopPurchase.clickConfirmAddInvoice = function(event){
    if (stock_list_count != 0) {
      $('.item_stock_list_count').text(stock_list_count);
      $("#stockControlNotif").modal("show")
    } else {
      shopPurchase.clickConfirmAddInvoiceModal();
    }
  }

  shopPurchase.clickCancelAddInvoice = function(event) {
    if ($("#stock-control-list li").length == 0) {
      shopPurchase.resetData();
    } else {
      shopPurchase.showDeleteDialog(function(result) {
        if (result) {
          // reset
          shopPurchase.resetData();
        }
      });
    }
  }

  shopPurchase.validateForm = function() {
    var isValid = true;
    $('#add-invoice-form input.form-field').each(function() {
      if ( $(this).val() === '' ) {
        isValid = false;
      }
    });
    if ($("#stock-control-list li").length === 0) {
      isValid = false;
    };

    return isValid;
  }

  shopPurchase.adjustStockControlScrollArea = function() {
    var $container = $('#stock-control-list-section');
    var wh = $(window).height();
    var main_header = $('.main-header').outerHeight();
    var main_footor = 0;
    var header = $('.content-header').outerHeight();
    var input_area = $('#invoice-input-area').outerHeight();
    var button_area = $('#stock-control-item-buttons').outerHeight();
    var foot = $('.admin-control-footer').outerHeight();
    $container.find('.products-box-admin').outerHeight(wh - main_header - header - input_area - button_area - foot - main_footor - 40);
  }

  shopPurchase.adjustProductListScrollArea = function() {
    var $container = $('#list-search-body-section');
    var modal = $("#findProductModal .modal_content").outerHeight();
    var modal_header = $("#findProductModal").find('.modal-header').outerHeight();
    var search_area = $('#list-search-section').outerHeight();
    var sheet_modal_header = $('#selectAddProductModal .modal-down').outerHeight();
    var foot = $('#findProductModal .admin-control-footer').outerHeight();
    var box_height = modal - modal_header - search_area - foot - sheet_modal_header - 50;
    $container.find('.products-box-admin').outerHeight(box_height);
    $('#list-search-body-section .products-box-admin').on('scroll', shopPurchase.onScrollSearchList);
  }

  shopPurchase.onScrollSearchList = function() {
    var scrollTop = $('#list-search-body-section .products-box-admin').scrollTop();
    var boxH = $('#list-search-body-section .products-box-admin').outerHeight();
    var listH = $('#list-search-body-section .scroll-area').outerHeight();
    var noMoreResult = $('#shop_product_search_no_more_result').val();
    if (listH - boxH <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
      $('#list-search-body-section .loading').removeClass('hide');
      shopPurchase.loadData(false, function() {
        $('#list-search-body-section .loading').addClass('hide');
      });
    }
  }

  shopPurchase.changeSelectShop = function(event, doExec) {
    if (doExec != undefined && doExec == false) {
      return;
    }
    if ($("#stock-control-list li").length == 0) {
      $('#select_shop').data('val', $('#select_shop').val());
      shopPurchase.reloadSupplier();
    } else {
      shopPurchase.showDeleteDialog(function(result) {
        if (result) {
          // reset
          $('#select_shop').data('val', $('#select_shop').val());
          shopPurchase.reloadSupplier();
          shopPurchase.resetData();
        } else {
          // cancel
          $('#select_shop').val($('#select_shop').data('val')).trigger('change', [false]);
        }
      });
    }
  }

  shopPurchase.showDeleteDialog = function(callback) {
    bootbox.confirm({
      title: $('#dialog_delete_confirm_title').val(),
      message: $('#dialog_delete_confirm_message').val(),
      className: 'bootbox-wrapper',
      swapButtonOrder: true,
      centerVertical:true,
      buttons: {
        confirm: {
          label: $('#dialog_delete_confirm_ok').val(),
          className: 'btn-danger'
        },
        cancel: {
          label: $('#dialog_delete_confirm_cancel').val(),
          className: 'btn-default'
        }
      },
      callback: callback
    });
  }

  shopPurchase.reloadSupplier = function() {
    var shop_id = $("#select_shop").val();
    shopPurchase.setSupplierSelect($('#supplier_id'), shop_id);
  }

  shopPurchase.resetData = function() {
    $("#stock-control-list").empty();
    $("#selectAddProductModal .list-wrapper").empty();
    $("#selected-counter span").text("0");
    $("#invoice_no").val(null);
    $('#arrival_date').val(null);
    $('#confirm-add-invoice-button').attr('disabled', true);
    $('#confirm-edit-invoice-button').attr('disabled', true);
    shopPurchase.selected = [];
    if (shopPurchase.isInventory()) {
      $('#btn-find-product').attr("disabled", true);
    }
  }

  shopPurchase.confirmButtonActiveControl = function(isValid, $button) {
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
        number: 'Gunakan karakter umum saja.'
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

  shopPurchase.hideButton = function() {
    var status = $("#is_status").val();
    if (status == "closed"){
      $('input').prop("disabled", true);
      $('select').prop("disabled", true);
      $('button').prop("disabled", true);
      $('#btn-find-product').addClass("hide");
      $('#btn-add-product').addClass("hide");
      $('.item__destroy').addClass("hide");
    }  
  }

  shopPurchase.clickConfirmStockControl= function() {
    $(document).on("click", ".click_confirm_stock", function() {
      var item_id = $(this).closest(".is_stock_confirm").data("id") ;
      $('input[type="checkbox"][data-id= "'+ item_id +'"]').attr('checked', true);
      $('.is_stock_confirm[data-id= "'+ item_id +'"]').hide();
      $('.is_stock_back[data-id= "'+ item_id +'"]').show();
      stock_list_count = stock_list_count + 1;
    });
  }

  shopPurchase.clickLaterStockControl = function() {  
    $(document).on("click", ".click_later_stock", function() {
      var item_id = $(this).closest(".is_stock_confirm").data("id") ;
      $('.is_stock_cancel[data-id= "'+ item_id +'"]').show();
      $('.is_stock_confirm[data-id= "'+ item_id +'"]').hide();
      $('.is_stock_back[data-id= "'+ item_id +'"]').hide();
    });
  }

  shopPurchase.clickCancelStockControl = function() { 
    $(document).on("click", ".click_cancel_stock", function() {
      var item_id = $(this).closest(".is_stock_back").data("id");
      $('input[type="checkbox"][data-id= "'+ item_id +'"]').attr('checked', false);
      $('.is_stock_confirm[data-id= "'+ item_id +'"]').show();
      $('.is_stock_back[data-id= "'+ item_id +'"]').hide();
      $('.is_stock_cancel[data-id= "'+ item_id +'"]').hide();
      stock_list_count = stock_list_count - 1; 
    });
  }

  shopPurchase.clickResetStockControl = function() {  
    $(document).on("click", ".click_reset_stock", function() {
      var item_id = $(this).closest(".is_stock_cancel").data("id") ;
      $('.is_stock_cancel[data-id= "'+ item_id +'"]').hide();
      $('.is_stock_confirm[data-id= "'+ item_id +'"]').show();
      $('.is_stock_back[data-id= "'+ item_id +'"]').hide();
    });
  }

  shopPurchase.minimumStatusHandler = function() {
    if ($('#stock_minimum_product').val() > 0) {
      $('#stock_minimum_status').show();
    } else {
      $('#stock_minimum_status').hide();
      if (!$('#stock_minimum_product').is(':focus')) {
        $('#stock_minimum_product').val(0);
      }
    }
  }

  shopPurchase.stockConfigHandler = function() {
    shopPurchase.minimumStatusHandler();

    $('#is_stock_control').on("change", function() {
      var is_active = $(this).is(':checked');
      if (is_active) {
        $('#stock_minimum_product').prop("disabled", false).removeClass('text-color-disabled');
        shopPurchase.minimumStatusHandler();
      } else {
        $('#stock_minimum_product').prop("disabled", true).addClass('text-color-disabled');
        $('#stock_minimum_status').hide();
      }
    });

    $('#stock_minimum_product').off().on("input focusout", function() {
      shopPurchase.minimumStatusHandler();
    });
  }

  $(document).on("modal_open", shopPurchase.openAddProductModal);

  onPageLoad(["shop_purchases#index", "shop_purchases#edit", "shop_purchases#show"], function() {
    $('#addProductModal input[name="item_detail"]').attr('maxlength', 255);
    $('#addProductModal input[name="shop_alias_name"]').attr('maxlength', 255);

    $('#add-product-form').validate(validateOption);

    item_count = $("#stock-control-list li").length;
    $("#item_count").text(item_count);
    // $('#select_shop').select2({width: 'resolve'});
    $('#supplier_id').select2({width: 'resolve'});

    $("#select_shop").on("change", shopPurchase.changeSelectShop);
    
    shopPurchase.hideButton();

    $(document).on("click", ".cancel-btn-modal", function() {
      $('#stockControlNotif').modal("hide");
    });

    $(document).on("click", ".confirm-add-invoice-button-modal", function() {
      $('#stockControlNotif').modal("hide");
      shopPurchase.clickConfirmAddInvoiceModal();
    });

    $('#confirm-save-invoice-button').on('click', function() {
      $('#stockControlNotif').modal("hide");
      shopPurchase.clickConfirmEditInvoiceModal();
    });

    shopPurchase.clickConfirmStockControl();
    shopPurchase.clickLaterStockControl();
    shopPurchase.clickCancelStockControl();
    shopPurchase.clickResetStockControl();
    shopPurchase.hideButton();

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

    // find modal
    $("#select_category").on("change", function(event){
      shopPurchase.loadData();
    });
    $("#select_sort").on("change", function(event){
      shopPurchase.loadData();
    });
    $("#select_use").on("change", function(event){
      shopPurchase.loadData();
    });
    $('#shop-product-search-btn').on("click", function(event){
      shopPurchase.loadData();
      $("#shop-product-search-clear-btn").show();
    });
    $("#shop-product-search-clear-btn").on("click", function(event){
      shopPurchase.loadData();
      $("#shop-product-search-clear-btn").hide();
      $("#shop-product-search").val(null);
    });

    $("#shop-product-search").on("keyup", function(event) {
      if (event.key === 'Enter') {
        shopPurchase.loadData();
        $("#shop-product-search-clear-btn").show();
      }
    })

    $(document).on("click", ".item__destroy", function() {
      var $element = $(this).parents(".list-item");
      var id = $element.find(".item__shop__product__id").val();
      // remove from selected item
      shopPurchase.selected = shopPurchase.selected.filter(function(item){
        return item.data("id")!=id;
      })
      // remove from existing item
      shopPurchase.existing = shopPurchase.existing.filter(function(item){
        return item!=id;
      })
      $element.remove();
      
      //remove element from selected list
      shopPurchase.removeItem(id);
      item_count -= 1;
      $("#item_count").text(item_count);

      // validate save button
      $("#confirm-add-invoice-button").attr("disabled", !shopPurchase.validateForm());
      $("#confirm-edit-invoice-button").attr("disabled", !shopPurchase.validateForm());
    });
    
    $("#addProductModal .product_category_edit").on("change", function(){
      var category_id = $(this).val();
      //get admin products, variants, and tech specs
      if (category_id != null) {
        shopPurchase.getProductDataForDropdown($("#add-admin-product_id"), category_id);
        shopPurchase.getProductDataForDropdown($("#variant_id"), category_id);
        shopPurchase.getProductDataForDropdown($("#tech_spec_id"), category_id);
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

    $(document).on("keyup", "#stock-control-list input.form-field, #invoice_no", function(){
      $("#confirm-add-invoice-button").attr("disabled", !shopPurchase.validateForm());
      $('#confirm-edit-invoice-button').attr('disabled', !shopPurchase.validateForm());
    });

    $(document).on("keyup", ".item__purchase__unit__price, .item__incoming__stock", function(){
      var stock_list = $("#stock-control-list").find(".list-item");
      stock_list.each(function() {
        var $el = $(this);
        var unit_price = $el.find(".item__purchase__unit__price").attr("data-raw-data") ? $el.find(".item__purchase__unit__price").attr("data-raw-data") : 0;
        var quantity = $el.find(".item__incoming__stock").attr("data-raw-data");
        if (quantity == undefined) {
          $el.find("#item__total").text(0);
        } else {
          var result_item_total = unit_price*quantity;
          $el.find("#item__total").text(result_item_total.toLocaleString("id-ID"));
        }
      })
    });
    
    
    $("#addProductModal input, #addProductModal select").on("keyup change", function(){
      var isValid = $('#add-product-form').valid();
      var $button = $("#confirm-add-product-button");
      shopPurchase.confirmButtonActiveControl(isValid, $button);
    });

    $("#add-admin-product_id").on("change", function(){
      let value = $(this).val();
      if(value){
        $('#addProductModal input[name="admin_product_id"]').val(value);
        var items = shopPurchase.getCacheProductData();
        var category_id = $("#addProductModal .product_category_edit").val();
        var selected = items[category_id].admin_products[parseInt(value)];
        $("#addProductModal").find("[name='item_detail']").val(selected.item_detail);
        $("#brand_id").val(selected.brand_id || null).trigger("change").attr("disabled", true);
        $("#variant_id").val(selected.variant_id || null).trigger("change").attr("disabled", true);
        $("#tech_spec_id").val(selected.tech_spec_id || null).trigger("change").attr("disabled", true);
      }
    });

    $(document).on("modal_open", shopPurchase.openAddProductModal);
    $(document).on("modal_open", shopPurchase.openFindProductModal);

    $('#confirm-add-product-button').on('click', shopPurchase.clickConfirmAddProduct);
    $('#confirm-add-products-button').on('click', shopPurchase.clickConfirmAddProducts);
    $('#confirm-add-invoice-button').on('click', shopPurchase.clickConfirmAddInvoice);
    $('#cancel-add-invoice-button').on('click', shopPurchase.clickCancelAddInvoice);
    $('#confirm-edit-invoice-button').on('click', shopPurchase.clickConfirmEditInvoice);

    $("#selectAddProductModal .js-modal-toggle").on("click", function(event){
      let target = $(this).data('target');
      let modal = $(target);

      $(modal).fadeIn();
      $(modal).find('.tab_content').toggleClass('active');
      $(modal).find("#view-more").toggleClass("hide");
      $(modal).find("#close").toggleClass("hide");
    });

    if ($(".item__stock_difference").length > 0) {
      $(document).on('keyup', '.item__incoming__stock', function(event){
        let newValue = parseInt($(this).attr('data-raw-data'));
        let stock = parseInt($(this).parents('li').find('.item__stock').text());
        let difference = newValue-stock;

        if(isNaN(difference)) {
          $(this).parents('li').find(".item__stock_difference").text(null).removeClass("stock_equal stock_plus stock_minus");
        }else {
          $(this).parents('li').find(".item__stock_difference").text((difference).toLocaleString('id-ID')).attr('data-raw-data', difference);
          shopPurchase.setDifference($(this).parents('li').find(".item__stock_difference"), difference);
        }
      });
    }

    $("#btn-find-product").prop("disabled", true);
    $("#btn-add-product").prop("disabled", true);

    $("#add-invoice-form input").on("change", function(event){
      if($("#invoice_no").val().length>0 && $("#arrival_date").val().length>0){
        $("#btn-find-product").prop("disabled", false);
        $("#btn-add-product").prop("disabled", false);
      }
    });

    $("input#status").on('click', function() {
      if($("#invoice_no").val().length>0 && $("#arrival_date").val().length>0){
        $('#confirm-edit-invoice-button').attr('disabled', !shopPurchase.validateForm());
        $("#btn-find-product").prop("disabled", false);
        $("#btn-add-product").prop("disabled", false);
      }
    });

    $("#select-all-products").on('click', function() {
      $("#check-box-icon").toggleClass("far fa-square fas fa-check-square");
      
      if ($("#check-box-icon").hasClass("fas fa-check-square")) {
        $("#product_list li").find(".fa-plus").parents(".item__add").trigger("click");
      } else {
        $("#product_list li").find(".item__add").trigger("click");
      }
    });

    shopPurchase.adjustStockControlScrollArea();
  });

  onPageLoad(["shop_purchases#edit"], function() {
    $("#btn-find-product").prop("disabled", false);
    $("#btn-add-product").prop("disabled", false);
  });
}.call(this));
