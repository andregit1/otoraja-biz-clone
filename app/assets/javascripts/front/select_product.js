(function () {
    'use strict';
    
    window.app = window.app || {}
    var selectProduct = window.app.selectProduct = {};
  
    var selectedProductList = [];
    var tmpSelectProductList = [];
    var send_timeout_id = null;
    var send_timeout_id_history = null;
    var cocoonId = 'cocoon-add'
    var isSearchLoading = false;
    var isHistoryLoading = false;

    selectProduct.mainOrderList = null;

    selectProduct.lastAddedProduct = function(){
      return selectedProductList.pop();
    }

    //商品選択モーダル初期化
    selectProduct.init = function(){
      //選択済み商品リストの更新
      selectProduct.updateSelectedProductList();
      selectProduct.getShopSearchTags();
    }

    selectProduct.getSearchWord = function(target_id){
      var word = '';
      var $search_word = $(target_id);
      var input = $search_word.html();

      $search_word.find('.tag').each(function(){
        word += $(this).text();
        word += " ";
      });
      
      input = input.replace(/<span .*?>(.*?)<\/span>|&nbsp;/g, "");
      input = input.replace(/^\s+|\s+$/g, "");

      return {
        'preset_input_word': word,
        'manual_input_word': input,
        'search_word': word + input
      };
    }

    selectProduct.updateSelectedProductList = function(){
      $('#main-order-list li').each(function(){
        var product = {
          id: $(this).find('.hidden_shop_product_id').val()
        }
        selectedProductList.push(product);
      });
    }

    selectProduct.searchingBySearch = function() {
      $('#product_select_search .searching').removeClass('hide');
      $('#product_select_search .unsearching').addClass('hide');
      $('#product_select_search .products-box .no_search_result').addClass('hide');
      $('#btn-manualInputBtn').addClass('hide');
    }
  
    selectProduct.unsearchingBySearch = function() {
      $('#product_select_search .unsearching').removeClass('hide');
      $('#product_select_search .searching').addClass('hide');
    }

    selectProduct.searchingByHistory = function() {
      $('#product_select_history .searching').removeClass('hide');
      $('#product_select_history .unsearching').addClass('hide');
    }
  
    selectProduct.unsearchingByHistory = function() {
      $('#product_select_history .unsearching').removeClass('hide');
      $('#product_select_history .searching').addClass('hide');
    }

    // 商品サジェスト取得
    selectProduct.get_product_suggests = function(empty, callback) {
      var params = selectProduct.getSearchWord('#select_prodcut_search_word');
      var $product_list = $('#product_select_search .product-list');
      var current_page = parseInt($('#product_select_search_current_page').val());
      if (empty) {
        current_page = 1;
      }
      params['page'] = current_page;
      isSearchLoading = true;
      selectProduct.searchingBySearch();
      $.ajax({
        url: "/api/shop_products/suggest.html",
        dataType: "html",
        data: params
      }).then(function(data) {
        if (empty) {
          $product_list.html('');
          $('#product_select_search_current_page').val('1');
        }
        if (data.length != 0) {
          $product_list.append($(data));
          if (current_page == 1) {
            $('#product_select_search .products-box').scrollTop(0);
          }
          $('#product_select_search_no_more_result').val('false');
          $('#product_select_search_current_page').val(current_page + 1);
          $('#product_select_search .products-box .no_search_result').addClass('hide');
        } else {
          if (current_page == 1) {
            $('#product_select_search_no_more_result').val('true');
            $('#product_select_search .products-box .no_search_result').removeClass('hide');
          }
          //検索文字数が3文字以上のときのみマニュアルインプットボタンを表示
          if(params.search_word.length >= 3){
            $('#btn-manualInputBtn').removeClass('hide');
          }
        }
        if (current_page > 1) {
          $('.manual_input').removeClass('hide');
        } else {
          $('.manual_input').addClass('hide');
        }
        //選択済みの商品を追加できないようにする。
        for (var i = 0, max = selectedProductList.length; i < max; i++) {
          var $item = $product_list.find('.shop-product-'+selectedProductList[i].id);
          $item.find('.btn-add_product').addClass('disabled');
        }
      }).always(function(){
        if (callback != undefined) {
          callback();
        }
        isSearchLoading = false;
        selectProduct.unsearchingBySearch();
      });
    }

    selectProduct.get_product_history = function(empty, overlay, callback) {
      var $product_list = $('#product_select_history .product-list');
      var product_customer_filter = $('#chk_select_product_customer_filter').prop('checked');
      var customer_id = product_customer_filter ? $('#customer_id').val() : undefined;
      var search_scope = product_customer_filter ? selectProduct.getHistorySearchScope() : undefined;
      var params = selectProduct.getSearchWord('#select_prodcut_history_search_word');
      params['customer_id'] = customer_id;
      params['search_scope'] = search_scope;
      var current_page = parseInt($('#product_select_history_current_page').val());
      if (empty) {
        current_page = 1;
      }
      params['page'] = current_page;
      isHistoryLoading = true;
      if (overlay) {
        $('#product_select_history').LoadingOverlay('show');
      }
      selectProduct.searchingByHistory();
      $.ajax({
        url: "/api/shop_products/history.html",
        dataType: "html",
        data: params
      }).then(function(data) {
        if (empty) {
          $product_list.html('');
          $('#product_select_history_current_page').val('1');
        }
        if (data.length != 0) {
          $product_list.append($(data));
          if (current_page == 1) {
            $('#product_select_history .products-box').scrollTop(0);
          }
          $('#product_select_history_no_more_result').val('false');
          $('#product_select_history_current_page').val(current_page + 1);
          $('#product_select_history .products-box .no_search_result').addClass('hide');
        } else {
          $('#product_select_history_no_more_result').val('true');
          $('#product_select_history .products-box .no_search_result').removeClass('hide');
        }
        // 選択済みの商品を追加できないようにする。
        for (var i = 0, max = selectedProductList.length; i < max; i++) {
          var $item = $product_list.find('.shop-product-'+selectedProductList[i].id);
          $item.find('.btn-add_product').addClass('disabled');
        }
      }).always(function(){
        if (callback != undefined) {
          callback();
        }
        isHistoryLoading = false;
        if (overlay) {
          $('#product_select_history').LoadingOverlay('hide');
        }
        selectProduct.unsearchingByHistory();
      });
    }

    selectProduct.get_product_list = function(e) {
      var $container = $('#product_select_list');
      var $product_list = $container.find('.list-box .product-list');
      if ( ! $container.find('.list-detail-box').hasClass('hide')) {
        $container.find('.list-detail-box').addClass('hide');
        $container.find('.list-box').removeClass('hide');
      }

      $('#product_select_list').LoadingOverlay('show');
      $.ajax({
        url: "/api/shop_products/list.html",
        dataType: "html",
        data: {}
      }).then(
        function(data) {
          $product_list.html('');
          $container.find('.no-list-box').addClass('hide');
          $container.find('.list-box').addClass('hide');
          if (data.length != 0) {
            $container.find('.list-box').removeClass('hide');
            $product_list.html(data);
          } else {
            $container.find('.no-list-box').removeClass('hide');
          }

          // 選択済みの商品を追加できないようにする。
          for (var i = 0, max = selectedProductList.length; i < max; i++) {
            var $item = $product_list.find('.shop-product-'+selectedProductList[i].id);
            $item.find('.btn-add_product').addClass('disabled');
          }
        }
      ).always(function(){
        $('#product_select_list').LoadingOverlay('hide');
      });
    }

    selectProduct.getHistorySearchScope = function() {
      return $('#product_select_history .dropdown .dropdown-item.active').val();
    }

    selectProduct.disableHistorySearchScope = function() {
      $('#product_select_history .dropdown .dropdown-toggle').addClass('hide');
    }

    selectProduct.enableHistorySearchScope = function() {
      $('#product_select_history .dropdown .dropdown-toggle').removeClass('hide');
    }

    selectProduct.clickCustomerFilter = function() {
      var product_customer_filter = $('#chk_select_product_customer_filter').prop('checked');
      if (product_customer_filter) {
        selectProduct.enableHistorySearchScope();
      } else {
        selectProduct.disableHistorySearchScope();
      }
      selectProduct.get_product_history(true, true);
    }

    selectProduct.changeHistorySearchScope = function() {
      $(this).closest('.dropdown-menu').find('.dropdown-item').removeClass('active');
      $(this).addClass('active');
      var visibleItem = $('#selectProductsModal').find('.dropdown-toggle', $(this).closest('.dropdown'));
      visibleItem.text($(this).text());
      visibleItem.dropdown('toggle');
      selectProduct.get_product_history(true, true);
      return false;
    }

    //選択済み商品一覧に追加
    selectProduct.addProductByList = function(){
      
      var $item = $(this).parents('.product-list-item');
      var $inclusion_product = $item.find('.inclusion_product');
      var inclusion_products = $inclusion_product.map((k,v)=>{
        return {
          id: $(v).data('id'),
          product_no: $(v).data('product-no'),
          item_name: $(v).data('item-name'),
          category_name: $(v).data('category-name'),
          item_detail: $(v).data('item-detail'),
          quantity: $(v).data('quantity'),
        };
      });
      var product = {
        id: $item.data('id'),
        name: $item.data('product-name'),
        product_no: $item.data('product-no'),
        category_name: $item.data('product-category-name'),
        quantity: 1,
        stock_quantity: $item.data('stock'),
        sales_unit_price: $item.data('sales-unit-price'),
        inclusion_products: inclusion_products
      }
      var index = selectedProductList.findIndex(function(item){
        return item.id == product.id;
      });

      if( index === -1){
        selectedProductList.push(product);
      } else {
        selectedProductList[index].quantity = $item.find('.quantity').val();
      }

      //追加する要素
      var exist = $('#main-order-list').find('#maintenance_log_detail-'+product.id)[0];
      if(typeof exist === 'undefined'){
        $('#cocoon-add').click();
      }

      //Addボタン非表示、個数入力欄表示
      $(this).addClass('disabled');
      $(this).next().addClass('disabled');

      return false;
    }

    //手入力で商品追加
    selectProduct.addProductByForm = function(){
      
      var $form = $('#manualInputModal');
      var product_name = $form.find('#product-regist-shop_alias_name').val();
      var category = $form.find('#product-regist-product_category').val();
      var sales_unit_price = $form.find('#product-regist-price').rpToNumber();
      var item_detail = $form.find('#product-regist-item_detail').val();
      var product_no = $form.find('#product-regist-product_no').val();

      var product = {
        id: '',
        shop_alias_name: product_name,
        item_detail: item_detail,
        product_no: product_no,
        product_category_id: category,
        sales_unit_price: sales_unit_price,
        is_stock_control: 0,
        is_use: 1
      }
      // console.log(product);

      $.ajax({
        url: "/api/shop_products/create",
        method: 'POST',
        dataType: "json",
        data: product
      }).done(function(data) {
        if(data.status === 'success'){
          var data = data.data;
          var product_name = data.shop_alias_name + data.item_detail;
          var product = {
            id: data.id,
            name: product_name,
            product_no: data.product_no,
            category_name: '',
            quantity: 1,
            stock_quantity: '',
            sales_unit_price: data.sales_unit_price
          }

          selectedProductList.push(product);
          $('#cocoon-add').click();

          var modal = $("#manualInputModal");
          $(modal).fadeOut();
          $(modal).find('.modal_content').removeClass('slide');

          var selectProductsModal = $('#selectProductsModal');
          $(selectProductsModal).fadeOut();
          $(selectProductsModal).find('.modal_content').removeClass('slide');
        } else {
          alert('error')
        }
      }).fail(function(data){
        console.log(data);
      }).always(function(data){
        console.log(data);
      });
      
      return false;
    }
  
    selectProduct.beforeProductInsert = function(e, insertedItem, originalEvent){
      if (originalEvent.target.id != cocoonId) {
        return;
      }

      var index = selectedProductList.length - 1;
      var lastAddedProduct = selectedProductList[index];
      var $insertedItem = $(insertedItem);
      var subtotal = parseInt(lastAddedProduct.sales_unit_price) * parseInt(lastAddedProduct.quantity);
      var time = new Date().getTime();
      var product_name = lastAddedProduct.name;
      if(lastAddedProduct.product_no !==''){
        product_name += ' ['+ lastAddedProduct.product_no + ']';
      }

      $insertedItem.attr('id','maintenance_log_detail-'+lastAddedProduct.id)
      $insertedItem.find('.hidden_shop_product_id').val(lastAddedProduct.id);
      $insertedItem.find('.hidden_name').val(lastAddedProduct.name);
      $insertedItem.find('.hidden_product_no').val(lastAddedProduct.product_no);
      $insertedItem.find('.hidden_description').val(lastAddedProduct.category_name);
      $insertedItem.find('.hidden_unit_price').val(lastAddedProduct.sales_unit_price);
      $insertedItem.find('.form-input-unit-price').val(lastAddedProduct.sales_unit_price.toLocaleString("id-ID"));
      $insertedItem.find('.hidden_quantity').val(lastAddedProduct.quantity);
      $insertedItem.find('.quantity').val(lastAddedProduct.quantity);
      $insertedItem.find('.hidden_sub_total_price').val(subtotal);

      $insertedItem.find('.product__name').text(product_name);
      $insertedItem.find('.product__attribute').text(lastAddedProduct.category_name);
      $insertedItem.find('.product__price span').text(app.util.formatRupiah(lastAddedProduct.sales_unit_price));
      $insertedItem.find('.product__quantity span').text(lastAddedProduct.quantity);
      $insertedItem.find('.btn-product-detail-toggle').attr('data-target','#maintenance_log_collapse-'+time);
      $insertedItem.find('.product__detail').attr('id','maintenance_log_collapse-'+time);

      insertedItem = $insertedItem;
      return true;
    }

    selectProduct.afterProductInsert = function(e, insertedItem, originalEvent){
      if (originalEvent.target.id != cocoonId) {
        return;
      }
      //set associationInsertionNode for mechanic selection
      var id = insertedItem.attr("id");
      $(insertedItem)
        .find(".select-mechanics a")
        .data("associationInsertionNode", `#${id} .selected-mechanics-list`);
  
      //メカニックアイコン更新
      selectProduct.updateMechanicIcon(insertedItem);

      // セット商品追加
      var index = selectedProductList.length - 1;
      var lastAddedProduct = selectedProductList[index];
      if (lastAddedProduct.inclusion_products != undefined && lastAddedProduct.inclusion_products.length > 0) {
        $(insertedItem)
          .find(".related-products a")
          .data("associationInsertionNode", `#${id} .related-products`);

        var $add_related_product = $(insertedItem).find('.add-related-product');
        var template_val = $add_related_product.data('association-insertion-template');
        $.each(lastAddedProduct.inclusion_products, (k,v) => {
          var $template = $(template_val);
          var quantity = v.quantity;
          var product_name = v.item_name;
          if(v.item_name !== ''){
            product_name += ' [' + v.product_no + ']';
          }

          $template.find('.hidden_shop_product_id').val(v.id);
          $template.find('.hidden_category_name').val(v.category_name);
          $template.find('.hidden_product_no').val(v.product_no);
          $template.find('.hidden_item_name').val(v.item_name);
          $template.find('.hidden_item_detail').val(v.item_detail);
          $template.find('.hidden_quantity').val(quantity);

          $template.find('.product__inclusion-product-name').text(product_name);
          $template.find('.product__inclusion-product-quantity').text(quantity == undefined || quantity== ''? '--':`x ${quantity}`);
          $add_related_product.data('association-insertion-template', $template.html());
          $add_related_product.click();
        });
      }
    }

    selectProduct.afterProductRemove = function(e, insertedItem, originalEvent){
      var id = insertedItem.find('.hidden_shop_product_id').val();
      var target = '.shop-product-' + id;
      selectedProductList.forEach((item, index) => {
        if(item.id == id) {
          selectedProductList.splice(index, 1);
        }
      });
      $('#selectProductsModal ' + target).find('.btn-add_product').removeClass('disabled');
      selectProduct.updateMechanicIcon(insertedItem);
    }

    selectProduct.updateMechanicIcon = function(insertedItem){
      var $container = $(insertedItem).parents('.order-list-item');
      var $mechanics = $container.find('.selected-mechanic-wrapper');
      var $icon = $container.find('.product__mechanic-icon');
      var num = 0;
      $mechanics.each(function(){
        if($(this).is(':visible')){
          num++;
        }
      });
      if(num > 0){
        $container.find('.product__mechanic-icon').removeClass('hide');
        $icon.removeClass('hide');
        $icon.find('.badge').text(num);
      } else {
        $icon.addClass('hide');
      }
    }

    selectProduct.getShopSearchTags = function(){
      var $shop_search_tags = $("#search-detail-inner ul");
      var $add_product_search_tags = $('#add-product-search-detail-inner ul');
      $.ajax({
        url: "/api/shop_products/quicksearch.html",
        dataType: "html",
      })
      .then(function(data) {
        if (data.length != 0) {
          $shop_search_tags.html(data);
          $add_product_search_tags.html(data);
        }
      })
    }

    // 商品サジェスト取得
    selectProduct.get_checkin_history = function(e) {

      var $checkinHistoryModal = $('#checkinHistoryModal');
      var $modal_header = $checkinHistoryModal.find('.modal-header');
      var $modal_body = $checkinHistoryModal.find('.modal-body');
      var customer_id = $('#customer_id').val();
      var maintenance_log_id = $('#maintenance_log_id').val();
      var readonly = $('#order_readonly').val() === undefined ? 'false' : $('#order_readonly').val();

      var wh = $(window).height();
      var h1 = $modal_header.outerHeight();
      
      if(customer_id === ''){
        $modal_body.html('');
        $('#no-history').show();
        return;
      } else {
        $('#no-history').hide();
      }
      $modal_body.outerHeight(wh - h1).css('overflow','scroll').LoadingOverlay('show');
      $.ajax({
        url: "/api/customers/"+customer_id+"/histories.html",
        dataType: "html",
        data: {
          maintenance_log_id: maintenance_log_id,
          customer_id: customer_id,
          readonly: readonly
        }
      }).done(function (data) {
        if (data.length == 0) {
          $modal_body.html('');
          $('#no-history').show();
          return;
        }

        $modal_body.html(data);

        //選択済みの商品を追加できないようにする。
        for(var i = 0,max = selectedProductList.length; i < max; i++){
          $('#history-shop-product-'+selectedProductList[i].id).find('.btn-add_product_history').addClass('disabled');
        }
      }).fail(function() {
      }).always(function() {
        $('.modal-body',checkinHistoryModal).LoadingOverlay('hide');
      });
    }

    selectProduct.addSearchKeywordTag = function(){
      var text = $(this).text();
      var $filter_list = $('#search-detail .filter-box');
      var insert_item = '<span class="tag" contenteditable="false">'+text+'</span>';
      
      if ($filter_list.find('span').length > 0) {
        $filter_list.find('span:last-child').after(insert_item);
      } else {
        $filter_list.prepend(insert_item + '&nbsp;');
      }

      $('#select_prodcut_search_word').val(text).trigger('keyup');

      return false;
    }

    selectProduct.removeSearchKeywordTag = function(){
      $(this).remove();
      $('#select_prodcut_search_word').trigger('keyup');
    }

    selectProduct.addAllListItem = function(e) {
      $(this).closest('.list-record').find('.list-detail .btn-add_product:not(.disabled)').each(function(i, e){$(e).click();});
      $('#selectProductsModal .close').click();
    }

    selectProduct.showListDetail = function(e) {
      var $container = $('#product_select_list');
      var $detailList = $container.find('.list-detail-box .product-list');
      $detailList.empty();
      $(this).closest('.list-record').find('.list-detail li').each(function(i, e){$detailList.append($(e).clone());});
      $container.find('.list-detail-box .list-name').html($(this).closest('.list-record').find('.list-name').html());
      // 選択済みの商品を追加できないようにする。
      for (var i = 0, max = selectedProductList.length; i < max; i++) {
        var $item = $detailList.find('.shop-product-'+selectedProductList[i].id);
        $item.find('.btn-add_product').addClass('disabled');
      }
      $container.find('.list-detail-box').removeClass('hide');
      $container.find('.list-box').addClass('hide');
      var $selectProductsModal = $('#selectProductsModal');
      var wh = $(window).height();
      var modalh = $selectProductsModal.find('.modal-header').outerHeight();
      var tabh = $selectProductsModal.find('.tab-wrapper').outerHeight();
      var navh = $container.find('.nav-box').outerHeight();
      var footh = $container.find('.detail-footer').outerHeight();
      $container.find('.products-box').outerHeight(wh - modalh - navh - footh - tabh);
    }

    selectProduct.backToList = function() {
      $('#product_select_list .list-detail-box').addClass('hide');
      $('#product_select_list .list-box').removeClass('hide');
    }

    selectProduct.addAllListProducts = function() {
      $('#product_select_list .list-detail-box .product-list .btn-add_product:not(.disabled)').each(function(i, e){$(e).click();});
      $('#selectProductsModal .close').click();
    }

    selectProduct.filterCustomizeList = function() {
      var search_word = $('#product_select_lists_search_word').text();
      var $listRecords = $('#product_select_list .lists-box .product-list .list-record');
      if (search_word == '') {
        $listRecords.removeClass('hide');
      } else {
        $listRecords.filter(
          function(i,e){
            return $(e).find('.list-name').text().toLowerCase().indexOf(search_word.toLowerCase()) != -1;
          }
        ).removeClass('hide');
        $listRecords.filter(
          function(i,e){
            return $(e).find('.list-name').text().toLowerCase().indexOf(search_word.toLowerCase()) == -1;
          }
        ).addClass('hide');
      }
    }

    selectProduct.onScrollSearchList = function() {
      var scrollTop = $('#product_select_search .products-box').scrollTop();
      var boxH = $('#product_select_search .products-box').outerHeight();
      var listH = $('#product_select_search .scroll-area').outerHeight();
      var noMoreResult = $('#product_select_search_no_more_result').val();
      if (listH - boxH - 10 <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
        $('#product_select_search .loading').removeClass('hide');
        selectProduct.get_product_suggests(false, function() {
          $('#product_select_search .loading').addClass('hide');
        });
      }
    }

    selectProduct.onScrollHistoryList = function() {
      var scrollTop = $('#product_select_history .products-box').scrollTop();
      var boxH = $('#product_select_history .products-box').outerHeight();
      var listH = $('#product_select_history .scroll-area').outerHeight();
      var noMoreResult = $('#product_select_history_no_more_result').val();
      if (listH - boxH - 10 <= scrollTop && !isHistoryLoading && noMoreResult != 'true') {
        $('#product_select_history .loading').removeClass('hide');
        selectProduct.get_product_history(false, false, function() {
          $('#product_select_history .loading').addClass('hide');
        });
      }
    }

    function addEvents() {
      selectProduct.init();
      //商品選択
      $(document).on('click','.btn-add_product',selectProduct.addProductByList);
      $(document).on('click','.btn-add_product_history',selectProduct.addProductByList);
      $(document).on('click','#btn-product-regist-confirm',selectProduct.addProductByForm);

      $(document).on('click','#product_select_list .add-all', selectProduct.addAllListItem);
      $(document).on('click','#product_select_list .list-detail', selectProduct.showListDetail);
      $(document).on('click','#product_select_list .back-to-list', selectProduct.backToList);

      $(document).on('cocoon:before-insert', selectProduct.beforeProductInsert);
      $(document).on('cocoon:after-insert', selectProduct.afterProductInsert);
      $(document).on('cocoon:after-remove', selectProduct.afterProductRemove);

      //プリセットタグから検索キーワードの追加、削除
      $(document).on('click','#search-detail .tag-list__item a', selectProduct.addSearchKeywordTag);
      $(document).on('click','#search-detail .filter-box .tag',selectProduct.removeSearchKeywordTag);

      $('#checkinHistoryModal').on('modal_open', selectProduct.get_checkin_history);

      $('#select_prodcut_search_word').keyup(function(e) {
        var input = $(this).html();
        input = input.replace(/<span .*?>(.*?)<\/span>|&nbsp;/g, "");
        input = input.replace(/^\s+|\s+$/g, "");
        if (input == '') {
          $(this).html($(this).html().replace(/&nbsp;$/g, "") + '&nbsp;');
        }
        if(send_timeout_id){
          clearTimeout(send_timeout_id);
        }
        send_timeout_id = setTimeout(function(){selectProduct.get_product_suggests(true)}, 500);
      });

      $('#select_prodcut_history_search_word').keyup(function(e) {
        if(send_timeout_id_history){
          clearTimeout(send_timeout_id_history);
        }
        send_timeout_id_history = setTimeout(function(){selectProduct.get_product_history(true, false)}, 500);
      });

      $('#product_select_lists_search_word').keyup(function(e) {
        selectProduct.filterCustomizeList();
      });

      $('#btn-add-all-list-products').on('click', selectProduct.addAllListProducts);

      $('#product_select_search .products-box').on('scroll', selectProduct.onScrollSearchList);
      $('#product_select_history .products-box').on('scroll', selectProduct.onScrollHistoryList);
    }

    onPageLoad([
      "maintenance_log#new",
      "maintenance_log#create",
      "maintenance_log#edit",
      "maintenance_log#update"
    ], function () {
      addEvents();
    });

    onPageLoad("maintenance_log#show", function() {
      $('#checkinHistoryModal').on('modal_open', selectProduct.get_checkin_history);
    });
  }.call(this));
