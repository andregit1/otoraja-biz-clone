(function () {
  'use strict';
  
  window.app = window.app || {}
  var order = window.app.order = {};

  var selectedProductList = [];
  var send_timeout_id = null;
  var $template_product_list = '';
  
  //初期設定
  order.init = function(){
    var ot1 = $('#main .order-box').offset().top;
    var ot2 = $('#main .order-box-footer').offset().top;
    $('#main .order-box').outerHeight(ot2 - ot1);

    //商品が１つも選択されていない場合は、チェックアウトボタンを非活性にする。
    if($('#main-order-list li:visible').length <= 0){
      $('#btn-checkout').prop('disabled',true);
    }
  }

  order.resetModalHeight = function(){
    // modal-bodyの高さ設定
    var $selectProductsModal = $('#selectProductsModal');
    var wh = $(window).height();
    var modalh = $selectProductsModal.find('.modal-header').outerHeight();
    var tabh = $selectProductsModal.find('.tab-wrapper').outerHeight();
    $selectProductsModal.find('#product_select_list .list-box').outerHeight(wh - modalh - $('#product_select_list .search-box').outerHeight() - tabh);
    $selectProductsModal.find('#product_select_history .products-box').outerHeight(wh - modalh - $('#product_select_history .tool-box').outerHeight() - $('#product_select_history .filter-box-wrap').outerHeight() - tabh);
    $selectProductsModal.find('#product_select_search .products-box').outerHeight(wh - modalh - $('#product_select_search .product-search').outerHeight() - tabh);
  }

  //商品選択モーダル表示前処理
  order.beforeSelectProductsModalOpen = function(){

    order.resetModalHeight();

    $('#product_select_search_current_page').val('');
    $('#select_prodcut_search_word').html('');
    $('#product_select_search .product-list').html('');
    $('#product_select_search .products-box .no_search_result').removeClass('hide');
    $('#btn-manualInputBtn').addClass('hide');
    $('#selectProductsModal .manual_input').addClass('hide');
    
    var $modal = $("#selectProductsModal");
    $modal.find('.nav-link').removeClass('active');
    $modal.find('.nav-link:last').click();

    return;
  }

  //商品選択モーダル表示後処理
  order.afterSelectProductsModalClose = function(){
    // スクロール最下部へ移動
    $('#main .order-box').animate({scrollTop: $('#main .order-box')[0].scrollHeight}, 'fast');
    
    return;
  }

  //手入力モーダル表示前処理
  order.beforeManualInputModalOpen = function(){
    var $form = $('#manualInputModal');
    var search_word = app.selectProduct.getSearchWord('#select_prodcut_search_word');

    $form.find('#product-regist-shop_alias_name').val(search_word.search_word);
    $form.find('#product-regist-price').val('').change();
    $form.find('#product-regist-product_category').val('').change();
    $form.find('#product-regist-item_detail').val('').change();
    $form.find('#product-regist-product_no').val('').change();
    $form.find('#collapseOption').collapse('hide');
    $form.find('#btn-product-regist-confirm').prop('disabled',true);
  }

  //手入力モーダル入力変更時処理
  order.changeManualInputModal = function(){
    var $form = $('#manualInputModal');
    var product_name = $form.find('#product-regist-shop_alias_name').val();
    var sales_unit_price = $form.find('#product-regist-price').rpToNumber();

    if($(this).val() !== ""){
      $(this).parent().removeClass('blank');
    } else {
      $(this).parent().addClass('blank');
    }
    $form.find('#btn-product-regist-confirm').prop('disabled',true);

    if(product_name === ''){
      return false;
    }

    if(sales_unit_price === '' || !$.isNumeric(sales_unit_price)){
      return false;
    }

    $form.find('#btn-product-regist-confirm').prop('disabled',false);
  }

  order.spinner = function(){
    var target = $(this).parent().find('input');
    var step = $(this).data('step');
    var after_val = 1;

    var current_val = target.val();
    if(current_val !== ''){
        var after_val = parseFloat(current_val) + parseFloat(step); 
    }

    if (after_val > 0) {
      target.each(function(){
        $(this).val(after_val).trigger('change');
      });
    }

    return false;
  }

  //商品備考記入時にアイコンを表示
  order.changeProductNote = function(){
    var $container = $(this).parents('.order-list-item');
    var $icon = $container.find('.product__note-icon');
    var note = $(this).val();
    if(note !==""){
      $icon.removeClass('hide');
    } else {
      $icon.addClass('hide');
    }
  }

  order.showSelectProdcutTab = function(e) {
    var activeTab = e.target;
    order.resetModalHeight();
    if ($(activeTab).hasClass('select-list')) {
      window.app.selectProduct.get_product_list();
    } else if ($(activeTab).hasClass('select-history')) {
      $('#product_select_history .note').removeClass('hide');
      if ($('#customer_id').val() != '') {
        $('#chk_select_product_customer_filter').prop('disabled', false);
        $('#product_select_history .note').addClass('hide');
      } else {
        $('#chk_select_product_customer_filter').prop('disabled', true);
      }
      $('#chk_select_product_customer_filter').off('change', window.app.selectProduct.clickCustomerFilter);
      $('#chk_select_product_customer_filter').bootstrapToggle().change();
      $('#chk_select_product_customer_filter').on('change', window.app.selectProduct.clickCustomerFilter);
      window.app.selectProduct.get_product_history(true, true);
    }
  }

  function addEvents() {
    order.init();

    $(document).on('click','.spinner',order.spinner);
    $(document).on('change', '#main-order-list .product__note', order.changeProductNote);

    //商品選択モーダル
    var $selectProductsModal = $('#selectProductsModal');
    //手入力モーダル
    var $manualInputModal = $('#manualInputModal');

    $selectProductsModal.on('modal_open', order.beforeSelectProductsModalOpen);
    $selectProductsModal.on('modal_close', order.afterSelectProductsModalClose);
    $manualInputModal.on('modal_open', order.beforeManualInputModalOpen);
    $manualInputModal.on('modal_close', order.afterManualInputModalClose);
    $manualInputModal.on('change','#product-regist-price,#product-regist-product_category,#product-regist-item_detail,#product-regist-product_no', order.changeManualInputModal);
    $manualInputModal.on('keyup','#product-regist-shop_alias_name', order.changeManualInputModal);
    $selectProductsModal.find('.dropdown-menu .dropdown-item').on('click', window.app.selectProduct.changeHistorySearchScope);
    $('#search-detail-inner').on('hidden.bs.collapse', order.resetModalHeight);
    $('#search-detail-inner').on('shown.bs.collapse', order.resetModalHeight);

    $selectProductsModal.find('a[data-toggle="tab"]').on('shown.bs.tab', order.showSelectProdcutTab);

  }

  onPageLoad([
    "maintenance_log#new",
    "maintenance_log#create",
    "maintenance_log#edit",
    "maintenance_log#update"
  ], function () {
    addEvents();
  });
  onPageLoad("maintenance_log#show", function () {
    order.init();
  });
}.call(this));
