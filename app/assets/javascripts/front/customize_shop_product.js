(function () {
  'use strict';
  window.app = window.app || {}
  var customizeShopProductList = window.app.customizeShopProductList = {};

  var send_timeout_id = null;
  const CUSTOMIZE_LIST_API = '/api/customize_shop_product_lists/';
  const SHOP_PRODUCT_API = '/api/shop_products/' ;

  var selectedProductIds = [];

  var isSearchLoading = false;
  var isHistoryLoading = false;

  customizeShopProductList.startListLoading = function() {
    $('#customizeShopProductListModal .modal_content').LoadingOverlay('show');
  }
  customizeShopProductList.startDetailLoading = function() {
    $('#customizeShopProductDetailModal .modal_content').LoadingOverlay('show');
  }
  customizeShopProductList.startSelectLoading = function() {
    $('#selectAddProductModal .modal_content').LoadingOverlay('show');
  }
  customizeShopProductList.endLoading = function() {
    $('.modal_content').LoadingOverlay('hide');
  }
  customizeShopProductList.init = function() {
  }

  customizeShopProductList.beforeCustomizeShopProductListOpen = function() {
    customizeShopProductList.resetCustomizeShopProductListModalHeight();
    customizeShopProductList.startListLoading();
    customizeShopProductList.loadCustomizeShopProductList();
  }

  customizeShopProductList.loadCustomizeShopProductList = function() {
    var params = {};
    var maxItems = $('#customizeShopProductListModal .max-items').text();
    getAjax(
      CUSTOMIZE_LIST_API,
      params,
      function(data) {
        var $listBox = $('#customizeShopProductListModal .list-sotable');
        $listBox.empty();
        $('#btn-update-customize-list-order').prop('disabled', true);
        $('#customizeShopProductListModal .selected-items').text(data.length);
        $('#btn-create-new-customize-list').prop('disabled', false);
        if (data.length > 0) {
          var $listRecord = $('#customize-list-clone-box .list-record').first();
          $.each(data, function(index, value) {
            var $cloneListRecord = $listRecord.clone();
            $cloneListRecord.find('.list-name').append(value.name);
            $cloneListRecord.find('.customize_shop_list_id').val(value.id);
            $cloneListRecord.find('.list-detail').attr('data-list-id', value.id);
            $listBox.append($cloneListRecord);
          });
          if (maxItems <= data.length) {
            $('#btn-create-new-customize-list').prop('disabled', true);
          }
        } else {
          customizeShopProductList.showNewListNameModal();
        }
        $listBox.find('.list-detail').on('click', customizeShopProductList.clickListDetail);
        $listBox.sortable({
          handle: '.handle',
          cursor: 'move',
          opacity: 0.5,
          placeholder: 'vacant',
          update: function(event, ui) {
            $('#btn-update-customize-list-order').prop('disabled', false);
          }
        });
        $listBox.disableSelection();
      },
      true
    );
  }

  customizeShopProductList.filterCustomizeList = function() {
    var search_word = $('#customize_lists_search_word').text();
    var $listRecords = $('#customizeShopProductListModal .list-sotable .list-record');
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

  customizeShopProductList.keyupAddProdcutSearch = function(e) {
    var input = $(this).html();
    input = input.replace(/<span .*?>(.*?)<\/span>|&nbsp;/g, "");
    input = input.replace(/^\s+|\s+$/g, "");
    if (input == '') {
      $(this).html($(this).html().replace(/&nbsp;$/g, "") + '&nbsp;');
    }
    if (send_timeout_id) {
      clearTimeout(send_timeout_id);
    }
    send_timeout_id = setTimeout(function(){customizeShopProductList.getAddProductSuggest(true)}, 500);
  }

  customizeShopProductList.getAddProductSuggest = function(empty, callback) {
    var params = customizeShopProductList.getSearchWord();
    var $modal = $("#selectAddProductModal");
    var $listBox = $modal.find('#customize_item_add_search .list');
    var current_page = parseInt($('#add_product_search_current_page').val());
    if (empty) {
      current_page = 1;
    }
    params['page'] = current_page;
    isSearchLoading = true;
    customizeShopProductList.searching();
    if (params['search_word'] != '') {
      $('#add-product-search-detail-inner').collapse('hide');
    } else {
      $('#add-product-search-detail-inner').collapse('show');
    }
    $.ajax({
      type: 'GET',
      dataType: 'json',
      url: `${SHOP_PRODUCT_API}suggest`,
      data: params,
      async: true
    }).done(function(data) {
      if (empty) {
        $listBox.empty();
        $('#add_product_search_current_page').val('1');
      }
      if (data.length > 0) {
        customizeShopProductList.buildAddProdcutList(data, $listBox);
        if (current_page == 1) {
          $('#customize_item_add_search .list').scrollTop(0);
        }
        $('#add_product_search_no_more_result').val('false');
        $('#add_product_search_current_page').val(current_page + 1);
        $('#customize_item_add_search .no-reslut').addClass('hide');
      } else {
        $('#add_product_search_no_more_result').val('true');
        $('#customize_item_add_search .no-reslut').removeClass('hide');
      }
    }).always(function() {
      if (callback != undefined) {
        callback();
      }
      isSearchLoading = false;
      customizeShopProductList.unsearching();
    });
  }

  customizeShopProductList.getSearchWord = function(){
    var word = '';
    var $search_word = $('#add_product_search_word');
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

  customizeShopProductList.searching = function() {
    var $container = $('#customize_item_add_search');
    $container.find('.searching').removeClass('hide');
    $container.find('.unsearching').addClass('hide');
  }

  customizeShopProductList.unsearching = function() {
    var $container = $('#customize_item_add_search');
    $container.find('.unsearching').removeClass('hide');
    $container.find('.searching').addClass('hide');
  }

  customizeShopProductList.beforeCustomizeShopProductDetailOpen = function() {
    customizeShopProductList.resetCustomizeShopProductDetailModalHeight();
    $('#can_add_all').bootstrapToggle();
    customizeShopProductList.startDetailLoading();
    customizeShopProductList.loadCustomizeShopProductDetail();
    customizeShopProductList.resetSelectAddProductModal();
  }

  customizeShopProductList.loadCustomizeShopProductDetail = function() {
    var $modal = $('#customizeShopProductDetailModal');
    var index = $modal.find('.customize_shop_list_id').val();
    var params = {};
    getAjax(
      `${CUSTOMIZE_LIST_API}${index}`,
      params,
      function(data) {
        var $listBox = $modal.find('.list-sotable');
        var $cloneBox = $('#customize-detail-clone-box');
        var $listRecord = $cloneBox.find('.list-record').first();
        var $inclusionProductRecord = $cloneBox.find('.inclusion-product-record').first();
        $listBox.empty();
        selectedProductIds = [];
        if (data.customize_shop_product_list) {
          $modal.find('.info-box .list_name').text(data.customize_shop_product_list.name);
          $('#selectAddProductModal').find('.customize_list_name').text(data.customize_shop_product_list.name);
          $modal.find('#can_add_all').prop('checked', data.customize_shop_product_list.can_add_all).change();
          $.each(data.customize_shop_product_list.customize_shop_product_details, function(index, value) {
            var $cloneListRecord = $listRecord.clone();
            selectedProductIds.push(value.shop_product.id);
            $cloneListRecord.find('.customize_shop_detail_id').val(value.id);
            $cloneListRecord.find('.customize_shop_detail_shop_product_id').val(value.shop_product.id);
            $cloneListRecord.find('.customize_shop_detail_destroy').val(false);

            $cloneListRecord.find('.list-detail').attr('data-list-id', value.shop_product.id);
            var product_name = value.shop_product.product_name;
            if (value.shop_product.product_no) {
              product_name = `${product_name}[${value.shop_product.product_no}]`;
            }
            $cloneListRecord.find('.list-name').append(product_name);
            var $inclusionProducts = $cloneListRecord.find('.inclusion-products');
            if (value.shop_product.inclusion_products) {
              $.each(value.shop_product.inclusion_products, function(i, v) {
                var $cloneInclusionProductRecord = $inclusionProductRecord.clone();
                var item_name = v.item_name;
                if (v.product_no) {
                  item_name = `${item_name}[${v.product_no}]`;
                }
                $cloneInclusionProductRecord.find('.inclusion-item-name').append(item_name);
                $inclusionProducts.append($cloneInclusionProductRecord);
              });
            }
            $listBox.append($cloneListRecord);
          });
        }
        customizeShopProductList.updateCustomizeShopProductDetailCount();
        customizeShopProductList.setListEventCustomizeShopProductDetail();
      },
      true
    );
  }

  customizeShopProductList.setListEventCustomizeShopProductDetail = function() {
    var $modal = $('#customizeShopProductDetailModal');
    var $listBox = $modal.find('.list-sotable');
    $listBox.find('.list-detail').off('click', customizeShopProductList.removeDetailListItem);
    $listBox.find('.list-detail').on('click', customizeShopProductList.removeDetailListItem);
    $listBox.sortable({
      handle: '.handle',
      cursor: 'move',
      opacity: 0.5,
      placeholder: 'vacant',
    });
    $listBox.disableSelection();
  }

  customizeShopProductList.updateCustomizeShopProductDetailCount = function() {
    var $modal = $('#customizeShopProductDetailModal');
    $modal.find('.selected-items').text(selectedProductIds.length);
    var maxItems = $modal.find('.max-items').text();
    if (maxItems >= selectedProductIds.length) {
      $('#btn-list-detail-add-items').prop('disabled', false);
    } else {
      $('#btn-list-detail-add-items').prop('disabled', true);
    }
  }

  customizeShopProductList.addCustomizeShopProductDetail = function(item) {
    var $modal = $('#customizeShopProductDetailModal');
    var maxItems = $modal.find('.max-items').text();
    if (maxItems <= selectedProductIds.length) {
      return;
    }
    var $listBox = $modal.find('.list-sotable');
    var $cloneBox = $('#customize-detail-clone-box');
    var $listRecord = $cloneBox.find('.list-record').first();
    var $inclusionProductRecord = $cloneBox.find('.inclusion-product-record').first();
    var $cloneListRecord = $listRecord.clone();
    selectedProductIds.push(parseInt(item.id));
    $cloneListRecord.find('.customize_shop_detail_shop_product_id').val(item.id);
    $cloneListRecord.find('.customize_shop_detail_destroy').val(false);
    $cloneListRecord.find('.list-detail').attr('data-list-id', item.id);
    var product_name = item.product_name;
    if (item.product_no) {
      product_name = `${product_name}[${item.product_no}]`;
    }
    $cloneListRecord.find('.list-name').append(product_name);
    var $inclusionProducts = $cloneListRecord.find('.inclusion-products');
    if (item.inclusion_products) {
      $.each(item.inclusion_products, function(i, v) {
        var $cloneInclusionProductRecord = $inclusionProductRecord.clone();
        var item_name = v.item_name;
        if (v.product_no) {
          item_name = `${item_name}[${v.product_no}]`;
        }
        $cloneInclusionProductRecord.find('.inclusion-item-name').append(item_name);
        $inclusionProducts.append($cloneInclusionProductRecord);
      });
    }
    $listBox.prepend($cloneListRecord);
    customizeShopProductList.updateCustomizeShopProductDetailCount();
    var mItems = $('#customizeShopProductDetailModal .max-items').text();
    if (mItems <= selectedProductIds.length) {
      $('#btn-list-detail-add-items').prop('disabled', true);
      $('#selectAddProductModal .js-modal-close').click();
    }
    customizeShopProductList.setListEventCustomizeShopProductDetail();
  }

  customizeShopProductList.removeDetailListItem = function() {
    var id = $(this).attr('data-list-id');
    var $container = $(this).closest('.list-record');
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
      callback: function (result) {
        if (result) {
          selectedProductIds = selectedProductIds.filter(n => n != parseInt(id));
          if ($container.find('.customize_shop_detail_id').val() == '') {
            $container.remove();
          } else {
            $container.hide();
            $container.find('.customize_shop_detail_destroy').val(true);
          }
          customizeShopProductList.updateCustomizeShopProductDetailCount();
        }
      }
    });
  }

  customizeShopProductList.addSearchKeywordTag = function(){
    var text = $(this).text();
    var $filter_list = $('#add_product_search_detail .filter-box');
    var insert_item = '<span class="tag" contenteditable="false">'+text+'</span>';
    if ($filter_list.find('span').length > 0) {
      $filter_list.find('span:last-child').after(insert_item);
    } else {
      $filter_list.prepend(insert_item + '&nbsp;');
    }
    $('#add_product_search_word').val(text).trigger('keyup');
    return false;
  }

  customizeShopProductList.removeSearchKeywordTag = function(){
    $(this).remove();
    $('#add_product_search_word').trigger('keyup');
  }

  customizeShopProductList.resetSelectAddProductModal = function() {
    var $modal = $("#selectAddProductModal");
    var $listBox = $modal.find('#customize_item_add_search .list');
    $listBox.empty();
    $('#add_product_search_word').html('');
    $('#add-product-search-detail-inner').collapse('show');
  }

  customizeShopProductList.beforeSelectAddProductModalOpen = function() {
    var $modal = $("#selectAddProductModal");
    $modal.find('.nav-link:first').click();
    customizeShopProductList.getAddProductHistory(true, true);
  }

  customizeShopProductList.getAddProductHistory = function(empty, overlay, callback) {
    var $modal = $("#selectAddProductModal");
    var $listBox = $modal.find('#customize_item_add_history .list');
    var current_page = parseInt($('#add_product_history_current_page').val());
    if (empty) {
      current_page = 1;
    }
    var params = {};
    params['page'] = current_page;
    isHistoryLoading = true;
    if (overlay) {
      customizeShopProductList.startSelectLoading();
    }
    $.ajax({
      type: 'GET',
      dataType: 'json',
      url: `${SHOP_PRODUCT_API}history`,
      data: params,
      async: true
    }).done(function(data) {
      if (empty) {
        $listBox.empty();
        $('#add_product_history_current_page').val('1');
      }
      if (data.length > 0) {
        customizeShopProductList.buildAddProdcutList(data, $listBox);
        if (current_page == 1) {
          $('#customize_item_add_history .list').scrollTop(0);
        }
        $('#add_product_history_no_more_result').val('false');
        $('#add_product_history_current_page').val(current_page + 1);
        $('#customize_item_add_history .no-reslut').addClass('hide');
      } else {
        $('#add_product_history_no_more_result').val('true');
        $('#customize_item_add_history .no-reslut').removeClass('hide');
      }
    }).always(function() {
      if (callback != undefined) {
        callback();
      }
      isHistoryLoading = false;
      if (overlay) {
        customizeShopProductList.endLoading();
      }
    });
  }

  customizeShopProductList.buildAddProdcutList = function(data, $listBox) {
    var $cloneBox = $('#customize-list-add-product-clone-box');
    var $listRecord = $cloneBox.find('.list-record').first();
    var $inclusionProductRecord = $cloneBox.find('.inclusion-product-record').first();
    $.each(data, function(index, value) {
      var $cloneListRecord = $listRecord.clone();
      $cloneListRecord.find('.shop_product_id').val(value.id);
      $cloneListRecord.find('.product_name').val(value.product_name);
      $cloneListRecord.find('.list-name').append(value.product_name);
      var $inclusionProducts = $cloneListRecord.find('.inclusion-products');
      if (value.inclusion_products) {
        $.each(value.inclusion_products, function(i, v) {
          var $cloneInclusionProductRecord = $inclusionProductRecord.clone();
          $cloneInclusionProductRecord.find('.inclusion-item-name').append(v.item_name);
          $inclusionProducts.append($cloneInclusionProductRecord);
        });
      }
      if (selectedProductIds.indexOf(parseInt(value.id)) != -1) {
        $cloneListRecord.find('.add-product').prop('disabled', true);
        $cloneListRecord.find('.add-product').addClass('btn-circle-primary');
        $cloneListRecord.find('.add-product').removeClass('btn-outline-circle-default');
      } else {
        $cloneListRecord.find('.add-product').prop('disabled', false);
        $cloneListRecord.find('.add-product').removeClass('btn-circle-primary');
        $cloneListRecord.find('.add-product').addClass('btn-outline-circle-default');
        $cloneListRecord.find('.add-product').on('click', customizeShopProductList.clickAddProdcut);
      }
      $listBox.append($cloneListRecord);
    });
  }

  customizeShopProductList.clickAddProdcut = function() {
    var $container = $(this).closest('.list-record');
    var item = {};
    item.id = $container.find('.shop_product_id').val();
    item.product_name = $container.find('.product_name').val();
    item.inclusion_products = $container.find('.inclusion-products li').map(function(i, e){
      return {item_name: $(e).find('.inclusion-item-name').text()};
    });
    customizeShopProductList.addCustomizeShopProductDetail(item);
    $(this).prop('disabled', true);
    $(this).addClass('btn-circle-primary');
    $(this).removeClass('btn-outline-circle-default');
  }

  customizeShopProductList.showAddProdcutTab = function(e) {
    var activeTab = e.target;
    if ($(activeTab).hasClass('search')) {
      customizeShopProductList.showAddProdcutSearchTab();
    } else if ($(activeTab).hasClass('history')) {
      customizeShopProductList.showAddProdcutHistoryTab();
    }
  }

  customizeShopProductList.showAddProdcutHistoryTab = function() {
    $(document).off('click', '#add_product_search_detail .tag-list__item a', customizeShopProductList.addSearchKeywordTag);
    $(document).off('click', '#add_product_search_detail .filter-box .tag', customizeShopProductList.removeSearchKeywordTag);
  }

  customizeShopProductList.showAddProdcutSearchTab = function() {
    customizeShopProductList.resetAddProductModalHeight();
    $(document).on('click', '#add_product_search_detail .tag-list__item a', customizeShopProductList.addSearchKeywordTag);
    $(document).on('click', '#add_product_search_detail .filter-box .tag', customizeShopProductList.removeSearchKeywordTag);
  }

  customizeShopProductList.resetCustomizeShopProductListModalHeight = function(){
    var $modal = $('#customizeShopProductListModal');
    var wh = $(window).height();
    var h1 = $modal.find('.modal-header').outerHeight();
    var h2 = $modal.find('.search-box').outerHeight();
    var h3 = $modal.find('.modal-footer').outerHeight();
    $modal.find('.modal-body .lists-box').outerHeight(wh - h1 - h2 - h3);
  }

  customizeShopProductList.resetCustomizeShopProductDetailModalHeight = function(){
    var $modal = $('#customizeShopProductDetailModal');
    var wh = $(window).height();
    var h1 = $modal.find('.modal-header').outerHeight();
    var h2 = $modal.find('.info-box').outerHeight();
    var h3 = $modal.find('.modal-footer').outerHeight();
    $modal.find('.modal-body .lists-box').outerHeight(wh - h1 - h2 - h3);
  }

  customizeShopProductList.resetAddProductModalHeight = function() {
    var $container = $('#customize_item_add_search');
    var h1 = $container.outerHeight();
    var h2 = $container.find('.product-search').outerHeight();
    $container.find('.list-wrapper').outerHeight(h1 - h2);
  }

  customizeShopProductList.clickListDetail = function(e) {
    var $customizeShopListId = $('#customizeShopProductDetailModal .customize_shop_list_id');
    $customizeShopListId.val($(this).attr('data-list-id'));
  }

  customizeShopProductList.showNewListNameModal = function(){
    $('#dialogInputNewCustomizeListName').modal('show');
  }
  customizeShopProductList.hideNewListNameModal = function(){
    $('#dialogInputNewCustomizeListName').modal('hide');
  }

  customizeShopProductList.showEditListNameModal = function(){
    $('#dialogInputEditCustomizeListName').modal('show');
  }
  customizeShopProductList.hideEditListNameModal = function(){
    $('#dialogInputEditCustomizeListName').modal('hide');
  }

  customizeShopProductList.closeDetailModal = function(){
    var $modal = $('#customizeShopProductDetailModal');
    $modal.find('.close').click();
  }

  customizeShopProductList.createCustomizeList = function() {
    var params = {
      name: $('#new_customize_list_name').val()
    };
    customizeShopProductList.startDetailLoading();
    postAjax(
      CUSTOMIZE_LIST_API,
      params,
      function(data) {
        customizeShopProductList.hideNewListNameModal();
        var $detail_open_button = $('#customize-list-clone-box .open_detail_dialog .list-detail');
        $detail_open_button.attr('data-list-id', data.customize_shop_product_list.id);
        $detail_open_button.click();
      },
      true
    );
  }

  customizeShopProductList.deleteCustomizeList = function() {
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
      callback: function (result) {
        if (result) {
          var $modal = $('#customizeShopProductDetailModal');
          var index = $modal.find('.customize_shop_list_id').val();
          customizeShopProductList.startDetailLoading();
          deleteAjax(
            `${CUSTOMIZE_LIST_API}${index}`,
            {},
            function(data) {
              $('#customize_detail_deleted_alert').toast('show');
              customizeShopProductList.closeDetailModal();
            },
            true
          );
        }
      }
    });
  }

  customizeShopProductList.updateCustomizeList = function() {
    var $modal = $('#customizeShopProductDetailModal');
    var index = $modal.find('.customize_shop_list_id').val();
    var $listBox = $modal.find('.list-sotable .list-record');
    var listDetail = [];
    $listBox.each(function(index, elem){
      var $e = $(elem);
      listDetail.push({
        id: $e.find('.customize_shop_detail_id').val(),
        shop_product_id: $e.find('.customize_shop_detail_shop_product_id').val(),
        _destroy: $e.find('.customize_shop_detail_destroy').val(),
      });
    });
    var params = {
      customize_shop_product_list: {
        name: $modal.find('.info-box .list_name').text(),
        can_add_all: $modal.find('#can_add_all').prop('checked'),
        customize_shop_product_details: listDetail
      }
    };
    customizeShopProductList.startDetailLoading();
    putAjax(
      `${CUSTOMIZE_LIST_API}${index}`,
      params,
      function(data) {
        $('#customize_detail_updated_alert').toast('show');
        customizeShopProductList.closeDetailModal();
      },
      true
    );
  }

  customizeShopProductList.updateCustomizeListOrder = function() {
    var $modal = $('#customizeShopProductListModal');
    var $listBox = $modal.find('.list-sotable .list-record');
    var listDetail = [];
    $listBox.each(function(index, elem) {
      var id = $(elem).find('.customize_shop_list_id').val();
      listDetail.push({id: id});
    });
    var params = {
      'customize_shop_product_list': listDetail
    };
    customizeShopProductList.startListLoading();
    putAjax(
      `${CUSTOMIZE_LIST_API}update_list`,
      params,
      function(data) {
        $('#customize_list_updated_alert').toast('show');
        $('#btn-update-customize-list-order').prop('disabled', true);
      },
      true
    );
  }

  customizeShopProductList.editCustomizeListName = function() {
    $('#customizeShopProductDetailModal').find('.info-box .list_name').text($('#edit_customize_list_name').val());
    customizeShopProductList.hideEditListNameModal();
  }

  customizeShopProductList.onScrollSearchList = function() {
    var scrollTop = $('#customize_item_add_search .list-wrapper').scrollTop();
    var boxH = $('#customize_item_add_search .list-wrapper').outerHeight();
    var listH = $('#customize_item_add_search .scroll-area').outerHeight();
    var noMoreResult = $('#add_product_search_no_more_result').val();
    if (listH - boxH - 10 <= scrollTop && !isSearchLoading && noMoreResult != 'true') {
      $('#customize_item_add_search .loading').removeClass('hide');
      customizeShopProductList.getAddProductSuggest(false, function() {
        $('#customize_item_add_search .loading').addClass('hide');
      });
    }
  }

  customizeShopProductList.onScrollHistoryList = function() {
    var scrollTop = $('#customize_item_add_history .list-wrapper').scrollTop();
    var boxH = $('#customize_item_add_history .list-wrapper').outerHeight();
    var listH = $('#customize_item_add_history .scroll-area').outerHeight();
    var noMoreResult = $('#add_product_history_no_more_result').val();
    if (listH - boxH - 10 <= scrollTop && !isHistoryLoading && noMoreResult != 'true') {
      $('#customize_item_add_history .loading').removeClass('hide');
      customizeShopProductList.getAddProductHistory(false, false, function() {
        $('#customize_item_add_history .loading').addClass('hide');
      });
    }
  }

  function addEvents() {
    var $customizeShopProductListModal = $('#customizeShopProductListModal');
    var $customizeShopProductDetailModal = $('#customizeShopProductDetailModal');
    var $selectAddProductModal = $('#selectAddProductModal');
    $customizeShopProductListModal.on('modal_open', customizeShopProductList.beforeCustomizeShopProductListOpen);
    $customizeShopProductDetailModal.on('modal_open', customizeShopProductList.beforeCustomizeShopProductDetailOpen);
    $customizeShopProductDetailModal.on('modal_close', function(){
      customizeShopProductList.startListLoading();
      customizeShopProductList.loadCustomizeShopProductList();
    });
    $selectAddProductModal.on('modal_open', customizeShopProductList.beforeSelectAddProductModalOpen);

    $('#dialogInputNewCustomizeListName').on('shown.bs.modal', function() {
      $(this).before($('.modal-backdrop'));
      $(this).css("z-index", parseInt($('.modal-backdrop').css('z-index')) + 1);
      $('#new_customize_list_name').val('');
    });
    $('#dialogInputEditCustomizeListName').on('shown.bs.modal', function() {
      $(this).before($('.modal-backdrop'));
      $(this).css("z-index", parseInt($('.modal-backdrop').css('z-index')) + 1);
      $('#edit_customize_list_name').val($customizeShopProductDetailModal.find('.info-box .list_name').text());
    });

    $('#customize_lists_search_word').keyup(function(e) {
      customizeShopProductList.filterCustomizeList();
    });
    $('#add_product_search_word').keyup(customizeShopProductList.keyupAddProdcutSearch);

    $('#add-product-search-detail-inner').on('hidden.bs.collapse', customizeShopProductList.resetAddProductModalHeight);
    $('#add-product-search-detail-inner').on('shown.bs.collapse', customizeShopProductList.resetAddProductModalHeight);
    $selectAddProductModal.find('a[data-toggle="tab"]').on('shown.bs.tab', customizeShopProductList.showAddProdcutTab);

    $customizeShopProductListModal.find('.open_detail_dialog .list-detail').on('click', customizeShopProductList.clickListDetail);

    $('#btn-create-new-customize-list').on('click', function() {
      customizeShopProductList.showNewListNameModal();
    });
    $('#btn_create_customize_list').on('click', customizeShopProductList.createCustomizeList);
    $('#btn-edit-customize-list').on('click', function() {
      customizeShopProductList.showEditListNameModal();
    });
    $('#btn_update_customize_list_name').on('click', customizeShopProductList.editCustomizeListName);
    $customizeShopProductDetailModal.find('.btn-delete').on('click', customizeShopProductList.deleteCustomizeList);
    $('#btn-update-customize-list').on('click', customizeShopProductList.updateCustomizeList);
    $('#btn-update-customize-list-order').on('click', customizeShopProductList.updateCustomizeListOrder);

    $('#customize_item_add_search .list-wrapper').on('scroll', customizeShopProductList.onScrollSearchList);
    $('#customize_item_add_history .list-wrapper').on('scroll', customizeShopProductList.onScrollHistoryList);
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

  function coreAjax(method, url, params, callback, async) {
    if (async == null) {
      async = true;
    }
    $.ajax({
      url: url,
      type: method,
      dataType: 'json',
      data: params,
      async: async,
    }).fail(function (xhr, status, error) {
      console.error(error);
    }).done(function (data) {
      callback(data);
    }).always(function() {
      customizeShopProductList.endLoading();
    });
  }

  onPageLoad([
    "maintenance_log",
    "checkin"
  ], function () {
    addEvents();
  });

}.call(this));
