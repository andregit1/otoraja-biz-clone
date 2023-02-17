(function () {

  'use strict';

  var jqxhr = null;
  var rerunSuggestAjax = false;
  var allowSuggest = true;
  var isCashPurchase = false;
  let find_sms_customer_data = null;
  let find_sms_customer_info = null;

  // チェックアウト完了モーダル表示
  function addOpenCheckedoutModalEvent() {
    $(function(){
      if($('#open-checkedout-modal').length) {
        $('#open-checkedout-modal').click();
      }
    });
  }

  // 支払い方法&レシート出力方法選択モーダル
  function addPaymentEvent() {
    $('input[name=payment_method_id]').on('change',function(event){
      judgmentActivateCheckOutButton();
      isCashSelected();
    });

    $('input[name^=receipt_output_method_]').on('change',function(){
      judgmentActivateCheckOutButton();

      if( $(this).val() == $('#receipt_output_method_no').val() ) {
        $('#receipt_output_method_paper').prop('checked', false);
        $('#receipt_output_method_sms').prop('checked', false);
      } else {
        if($('#receipt_output_method_no:checked').length) {
          $('#receipt_output_method_no').prop('checked', false);
        }
      }

      let isCheckedPaper = $('#receipt_output_method_paper:checked').length;
      let isCheckedSMS = $('#receipt_output_method_sms:checked').length;
      let isWhatsApp = $("#customer_send_type").val() == "wa";
      
      if(isCheckedPaper && isCheckedSMS) {
        // レシート発行 & SMS送信
        $('#checkout-button-default').addClass('hidden');
        $('#checkout-button-both').removeClass('hidden');
        $('#checkout-button-print').addClass('hidden');
        $('#checkout-button-send').addClass('hidden');
      } else if(isCheckedPaper) {
        // レシート発行
        $('#checkout-button-default').addClass('hidden');
        $('#checkout-button-both').addClass('hidden');
        $('#checkout-button-print').removeClass('hidden');
        $('#checkout-button-send').addClass('hidden');
      } else if(isCheckedSMS || isWhatsApp) {
        // SMS送信
        $('#checkout-button-default').addClass('hidden');
        $('#checkout-button-both').addClass('hidden');
        $('#checkout-button-print').addClass('hidden');
        $('#checkout-button-send').removeClass('hidden');
      } else {
        // Checkout without options
        $('#checkout-button-default').removeClass('hidden');
        $('#checkout-button-both').addClass('hidden');
        $('#checkout-button-print').addClass('hidden');
        $('#checkout-button-send').addClass('hidden');
      }
    }); 

    // レシート発行 & SMS送信 のCheckoutボタンが押された場合
    $('#checkout-button-both').on('click',function(){
      if($("#payment_method_id_1:checked").length){
        $('#open-calculator-modal').click();
      }
      else if($('#receipt_output_method_sms:checked').length) {
        if($('#customer_tel').val()) {
          submit();
        } else {
          $('#open-sms-receipt-modal').click();
        }
      } else {
        submit();
      }
    });

    // SMS送信のCheckoutボタンが押された場合
    $('#checkout-button-send').on('click',function(){
        if($("#payment_method_id_1:checked").length){
          $('#open-calculator-modal').click();
        }
        else if($('#customer_tel').val()) {
          submit();
        } else {
          $('#open-sms-receipt-modal').click();
        }
    });

    $('#checkout-button-default, #checkout-button-print').on('click',function(){
      if($("#payment_method_id_1:checked").length){
        $('#open-calculator-modal').click();
      }
      else {
        submit();
      }
    });

    //handling the workflow for cash payment. Triggered by confirming order via preview
    $('#order-preview-confirm').on('click',function(){
      if($('#receipt_output_method_sms:checked').length) {
        if($('#customer_tel').val()) {
          submit();
        } else {
          $('#open-sms-receipt-modal').click();
        }
      } else {
        submit();
      }
    });
  };

  // 電話番号未登録者用レシートSMS送信モダール
  function addRegistCustomerEvent() {
    $('#phone_national').on('keyup',function(){
      if($(this).val()) {
        judgmentActivateResistration();
        $('#input-tel-box').removeClass('blank');
      } else {
        $('#input-tel-box').addClass('blank');
      }
      customeSuggest();
    });

    $('#new_customer_name').on('keyup',function(){
      if($(this).val()) {
        $('#input-name-box').removeClass('blank');
      } else {
        $('#input-name-box').addClass('blank');
      }
      customeSuggest();
    });

    $('#customer-registration-btn').on('click',function(){
      if (jqxhr) {
        jqxhr.abort();
        jqxhr = null;
      }

      showLoading();

      // 電話番号形式チェック
      $.ajax({
        url: '/api/customers/valid_phone_number.json',
        method: 'POST',
        dataType: "json",
        data: {
          phone_country_code: $('#phone_country_code').val(),
          phone_national: $('#phone_national').val(),
        }
      }).done(function (data) {
        if(data.valid) {
          $('#phone_valid_err_msg').text('');

          findSmsCustomer(
            $('#phone_country_code').val(),
            $('#phone_national').val(),
            function() {
              if(find_sms_customer_data) {
                if(find_sms_customer_data.to_agree) {
                  openTermsModalFromCheckout();
                  return;
                }
                
                let customer_name = $('#new_customer_name').val() || find_sms_customer_data.name;
                $('#customer_id').val(find_sms_customer_info.id);
                $('#customer_tel').val(find_sms_customer_info.tel);
                $('#customer_name').val(customer_name);
                $('#maintenance_log_name').val(customer_name);
                submit();
              }
              else {
                if($('#customer_terms_agreed_at').val()) {  // 規約同意済みの場合
                  sendConfirmMessage(function(){
                    $('#sms-confirm-block').show();
                    $('#customer-regist-block').hide();
                  });
                } else {
                  openTermsModalFromCheckout();
                }
              }
            }
          );
        } else {
          $('#phone_valid_err_msg').text(data.err_msg);
        }
      }).fail(function() {
        $('#phone_valid_err_msg').text('Communication error');
      }).always(function() {
        hideLoading();
      });;
    });

    $('#optin-btn').on('click',function(){
      if (jqxhr) {
        jqxhr.abort();
        jqxhr = null;
      }

      showLoading();

      // 電話番号形式チェック
      $.ajax({
        url: '/api/customers/valid_phone_number.json',
        method: 'POST',
        dataType: "json",
        data: {
          phone_country_code: $('#optin_phone_country_code').val(),
          phone_national: $('#optin_phone_national').val(),
        }
      }).done(function (data) {
        if(data.valid) {
          $('#optin_phone_valid_err_msg').text('');
          //submit and handle sending message server side
          $('#customer_tel').val($('#optin_phone_country_code').val()+$('#optin_phone_national').val());
          submit();
          
        } else {
          $('#optin_phone_valid_err_msg').text(data.err_msg);
        }
      }).fail(function() {
        $('#optin_phone_valid_err_msg').text('Communication error');
      }).always(function() {
        hideLoading();
      });;
    });

    $('#terms-agree-button').on('click',function(){
      // 規約同意ボタン押下後は検索処理は動作させないようにする
      allowSuggest = false;

      // 規約同意日時を保持
      $('#customer_terms_agreed_at').val(moment.utc().format("YYYY-MM-DD HH:mm:ss"));
      
      let send_dm = $('#send_dm').prop('checked');
      $('#customer_send_dm').val(send_dm);
      $(this).prop('disabled', true);

      if(find_sms_customer_info) {
        let customer_name = $('#new_customer_name').val() || find_sms_customer_data.name;
        $('#customer_id').val(find_sms_customer_info.id);
        $('#customer_tel').val(find_sms_customer_info.tel);
        $('#customer_name').val(customer_name);
        $('#maintenance_log_name').val(customer_name);
        submit();
      } else {
        sendConfirmMessage(function(){
          $('#terms-modal-close').click();
          $('#sms-confirm-block').show();
          $('#customer-regist-block').hide();
        });
      }
    });

    $('#sms-resend-btn').on('click',function(){
      let self = this;
      $(self).prop('disabled', true);
      $('#phone_national').prop("readOnly", true);

      showLoading();

      // 電話番号形式チェック
      $.ajax({
        url: '/api/customers/valid_phone_number.json',
        method: 'POST',
        dataType: "json",
        data: {
          phone_country_code: $('#phone_country_code').val(),
          phone_national: $('#phone_national').val(),
        }
      }).done(function (data) {
        if(data.valid) {

          findSmsCustomer(
            $('#phone_country_code').val(),
            $('#phone_national').val(),
            function() {
              sendConfirmMessage(function(){
                $(self).prop('disabled', false);
              });
            }
          );

          $('#phone_valid_err_msg').text('');
        } else {
          $('#phone_valid_err_msg').text(data.err_msg);
        }
      }).fail(function() {
        $(self).prop("disabled", false);
        $('#phone_valid_err_msg').text('Communication error');
      }).always(function() {
        $('#phone_national').prop("readOnly", false);
        hideLoading();
      });
    });

    $('#sms-confirm-btn').on('click',function(){
      if(find_sms_customer_info) {
        $('#customer_id').val(find_sms_customer_info.id);
      }
      let confirm_tel = $('#confirm_tel').val();
      let customer_name = $('#new_customer_name').val();
      $('#customer_tel').val(confirm_tel);
      $('#customer_name').val(customer_name);
      $('#maintenance_log_name').val(customer_name);
      submit();
    });
  };

  function openTermsModalFromCheckout() {
    // 会計ボタンか顧客情報ボタンどちらから開くかによって、同意ボタンの表示を切り替える
    $('#terms-agree-button').prop('disabled', false);
    $('#terms-agree-button').show();
    $('#c-suggest-terms-agree-button').prop('disabled', true);
    $('#c-suggest-terms-agree-button').hide();

    $('#open-terms-modal').click();
  }

  // 電話番号登録確認用メッセージ送信
  function sendConfirmMessage(callback) {
    showLoading();
    $.ajax({
      url: '/maintenance_log/send_confirm_sms.json',
      method: 'POST',
      dataType: "json",
      data: {
        phone_country_code: $('#phone_country_code').val(),
        phone_national: $('#phone_national').val()
      }
    }).done(function (data) {
      if(data.valid) {
        $('#confirm_tel').val(data.tel);
      }
    }).always(() => {
      callback();
      hideLoading();
    });
  }

  // 顧客情報登録ボタンの表示非表示&活性非活性を判定
  function judgmentActivateResistration() {
    if($('#phone_national').val()) {
      $('#customer-registration-btn').prop('disabled', false);
    } else {
      $('#customer-registration-btn').prop('disabled', true);
    }
  }

  // 顧客検索
  function customeSuggest() {
    if(!allowSuggest) {
      return;
    }

    let word = `${$('#phone_national').val()} ${$('#new_customer_name').val()}`;
    word = word.replace(/^\s+|\s+$/g,'');
    if (word.length < 3) {
      if (jqxhr) {
        jqxhr.abort();
        jqxhr = null;
      } else {
        resetSearchResult();
      }
      return;
    }

    // 連続通信防止　通信中に処理が発生した場合、通信完了後に実行
    if (jqxhr) {
      rerunSuggestAjax = true;
      return;
    }

    searching();
    let tel_query = $('#phone_national').val();
    let name_query = $('#new_customer_name').val();
    jqxhr = $.ajax({
      url: "/api/customers/suggest_byfield.json",
      dataType: "json",
      data: {
        name: name_query,
        tel: tel_query,
      }
    }).done(function (data) {

      jqxhr = null
      if(rerunSuggestAjax) {
        rerunSuggestAjax = false;
        customeSuggest();
      } else {
        unsearching();
      }
    
      resetSearchResult();

      // 電話番号無しの顧客を除外
      let suggest_list = $.map(data, function(item) {
        if(!item.tel) return;

        return item;
      })

      if (suggest_list.length == 0) {
        judgmentActivateResistration();
        return;
      }

      $('#customer_list .search_result').html($.map(suggest_list, function(item) {
        var number_plate = $.map(item.number_plate, function(num) {
          return $('<p>', {html: highlight(num, word)});
        });
        var bikes_info = $.map(item.bikes_info, function(num) {
          return $('<p>', {html: highlight(num, word)});
        });
        return $('<tr>', {class: 'suggest_record', 'data-value': JSON.stringify(item)})
        .append($('<td>', {class: 'name_tel_col'}).append($('<p>', {html: highlight(item.name, word)})).append($('<p>', {html: highlight(item.tel_national_hyphen, word)})))
        .append($('<td>', {class: 'vehicle_col'}).append(number_plate))
        .append($('<td>', {class: 'vehicle_info_col'}).append(bikes_info))
        .append($('<td>', {html: '<i class="fas fa-chevron-right"></i>', class: 'search_result_add add_col'}));
      }));

      $('#customer_list .search_result').show();
      $('#customer_list .search_header').show();
      $('#phone_valid_err_msg').text('');

      $('#customer_list .suggest_record').click(function() {
        let item = JSON.parse($(this).attr('data-value'));

        if(item.tel) {
          $('#customer_id').val(item.id);
          $('#customer_tel').val(item.tel);
          $('#customer_name').val(item.name);
          $('#customer_send_dm').val(item.send_dm);
          $('#customer_terms_agreed_at').val(item.terms_agreed_at);
          $('#maintenance_log_name').val(item.name);
          submit();
        } else {
          // TODO
        }
      });
    }).fail(function() {
      resetSearchResult();
      judgmentActivateResistration();
      unsearching();
    });
  }

  function judgmentActivateCheckOutButton() {
    let isReceiptMethodChecked = $('[name^=receipt_output_method_]:checked').length
    let isPaymentMethodChecked = $('[name=payment_method_id]:checked').length
    let isWhatsApp = $("#customer_send_type").val() == "wa";
    if(isReceiptMethodChecked && isPaymentMethodChecked) {
      $('.js-charge-complete').prop('disabled', false);
    } else if(isPaymentMethodChecked && isWhatsApp){
      $('.js-charge-complete').prop('disabled', false);
    }else{
      $('.js-charge-complete').prop('disabled', true);
    }
  }

  function isCashSelected(){
    var paymentMethod = event.currentTarget.id;

    isCashPurchase = paymentMethod == 'payment_method_id_1';
  }

  // キャッシュ払いの場合
  function updateCashPaymentDetails(){
    if($("#payment_method_id_1:checked").length){
      var amount_paid = $("#order-preview-paid").rpToNumber();
      var adjustment = $("#order-preview-adjustment").rpToNumber();;
      $("#maintenance_log_amount_paid").val(amount_paid);
      $("#maintenance_log_adjustment").val(adjustment);
    }
  }

  function submit() {
    showLoading();
    if(isCashPurchase){
      updateCashPaymentDetails();
    }
    
    $('#maintenance-log-form').submit();
  }

  function showLoading(){
    $('.wrapper').LoadingOverlay('show', {size: 20});
  }

  function hideLoading(){
    $('.wrapper').LoadingOverlay('hide');
  }

  function searching() {
    $('.search-spinner').show();
  }

  function unsearching() {
    $('.search-spinner').hide();
  }

  function resetSearchResult() {
    $('#customer_list .search_result').hide();
    $('#customer_list .search_header').hide();
    $('#customer_list .search_result').html('');
  }

  function highlight(str, search_word) {
    if (str == null) return str;
    var word_re = new RegExp('(' + search_word.split(' ').join('|') + ')', 'gi');
    return str.replace(word_re, '<span class="highlight">$&</span>');
  }

  function findSmsCustomer(phone_country_code, phone_national, callback) {
    showLoading();
    find_sms_customer_data = null;
    find_sms_customer_info = null;

    $.ajax({
      url: '/api/customers/find.json',
      dataType: 'json',
      data: {
        phone_country_code: phone_country_code,
        phone_national: phone_national,
      }
    }).done(function (data) {
      let item = data.customer;

      if(item.id) {
        find_sms_customer_data = item;
        find_sms_customer_info = {
          'id': item.id,
          'tel': item.tel, 
          'tel_national': item.tel_national,
          'tel_national_hyphen': item.tel_national_hyphen,
          'tel_country_code': item.tel_country_code,
          'customer_name': $('#new_customer_name').val() || item.name,
          'send_dm': item.send_dm,
          'terms_agreed_at': item.terms_agreed_at,
          'number_plate_area': item.number_plate_area,
          'number_plate_number': item.number_plate_number,
          'number_plate_pref': item.number_plate_pref,
          'expiration_year': item.expiration_year,
          'expiration_month': item.expiration_month,
          'maker': item.maker,
          'model': item.model,
          'color': item.color,
          'owned_bikes_count': item.bikes_info.length
        }
      }

      callback();
    }).fail(function() {
    }).always(function() {
      hideLoading();
    });
  }

  function sendWhatsAppMessage(){
    let phone_numeber = $("#optin_phone_national").val();
    let country_code = $('#optin_phone_country_code').val();

    $.ajax({
      url: 'https://waba.damcorp.id/whatsapp/sendHsm/otoraja_param_test',
      method: 'POST',
      dataType: "application/json",
      data: {
        phone_country_code: $('#optin_phone_country_code').val(),
        phone_national: $('#optin_phone_national').val(),
      }
    }).done(function (data) {
      if(data.valid) {
        $('#optin_phone_valid_err_msg').text('');
        //if phonenumber is valid, send text using whatsapp
        
      } else {
        $('#optin_phone_valid_err_msg').text(data.err_msg);
      }
    }).fail(function() {
      $('#optin_phone_valid_err_msg').text('Communication error');
    }).always(function() {
      hideLoading();
    });;
  }
  
  function addEvents() {
    addOpenCheckedoutModalEvent();
    addRegistCustomerEvent();
    addPaymentEvent();
  }
  onPageLoad([
    "maintenance_log#new",
    "maintenance_log#create",
    "maintenance_log#edit",
    "maintenance_log#update",
  ], function () {
    addEvents();
  });
}.call(this));
  