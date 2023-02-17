(function () {

  'use strict';

  let jqxhr = null;
  let rerunSuggestAjax = false;
  let allowSuggest = true;
  let loaded = false;
  let find_customer_data = null;
  let find_customer_info = null;

  const blank_calendar_text = '--.--.----';

  // 顧客検索モーダル
  function addCustomerSuggestModalEvent() {
    $('.customer-edit-button').on('click',function(){
      if($('#completed_customer_suggest').val()) {
        $('#open-customer-info-modal').click();
      } else {
        $('#open-customer-suggest-modal').click();
      }
    });

    $('#c-suggest-phone_national').on('keyup',function(){
      if($(this).val()) {
        $('#c-suggest-input-tel-box').removeClass('blank');
      } else {
        $('#c-suggest-input-tel-box').addClass('blank');
      }
      judgmentActivateResistration();
      customeSuggest();
    });

    $('#c-suggest-customer_name').on('keyup',function(){
      if($(this).val()) {
        $('#c-suggest-input-name-box').removeClass('blank');
      } else {
        $('#c-suggest-input-name-box').addClass('blank');
      }
      judgmentActivateResistration();
      customeSuggest();
    });

    $('#c-suggest-number_plate_number, #c-suggest-number_plate_pref').on('keyup',function(){
      if($('#c-suggest-number_plate_number').val() && $('#c-suggest-number_plate_pref').val()) {
        $('#c-suggest-input-numberplate-box').removeClass('blank');
      } else {
        $('#c-suggest-input-numberplate-box').addClass('blank');
      }
      judgmentActivateResistration();
      customeSuggest();
    });

    // 顧客新規登録
    $('#c-suggest-customer-registration-btn').on('click',function(){
      if (jqxhr) {
        jqxhr.abort();
        jqxhr = null;
      }

      if($('#c-suggest-phone_national').val()) {
        validPhoneNumber();
      } else {
        openTermsModalFromCustomer();
      }
    });

    // 規約同意
    $('#c-suggest-terms-agree-button').on('click',function(){
      // 規約同意ボタン押下後は検索処理は動作させないようにする
      allowSuggest = false;

      // 規約同意日時を保持
      $('#customer_terms_agreed_at').val(moment.utc().format("YYYY-MM-DD HH:mm:ss"));
      
      let send_dm = $('#send_dm').prop('checked');
      $('#customer_send_dm').val(send_dm);
      $(this).prop('disabled', true);

      if(find_customer_info) {
        reflectCustomerInfo(find_customer_info);
  
        showCustomerInfoButtons();
        $('#customer-suggest-modal-close').click();
        $('#completed_customer_suggest').val(true);
        openCustomerInfoModal();
      }
      else {
        if($('#c-suggest-phone_national').val()) {
          sendConfirmMessage($('#c-suggest-phone_country_code').val(), $('#c-suggest-phone_national').val(),
          function(){
            $('#terms-modal-close').click();
            showSmsConfirm();
          });
        } else {
          openCustomerInfoModal();
        }
      }
    });

    // 確認SMS再送信
    $('#c-suggest-sms-resend-btn').on('click',function(){
      let self = this;
      $(self).prop('disabled', true);
      $('#c-suggest-phone_national').prop("readOnly", true);

      showLoading();

      // 電話番号形式チェック
      $.ajax({
        url: '/api/customers/valid_phone_number.json',
        method: 'POST',
        dataType: "json",
        data: {
          phone_country_code: $('#c-suggest-phone_country_code').val(),
          phone_national: $('#c-suggest-phone_national').val(),
        }
      }).done(function (data) {
        if(data.valid) {
          findCustomer(
            $('#c-suggest-phone_country_code').val(),
            $('#c-suggest-phone_national').val(),
            $('#c-suggest-number_plate_area').val(),
            $('#c-suggest-number_plate_number').val(),
            $('#c-suggest-number_plate_pref').val(),
            function() {
              sendConfirmMessage($('#c-suggest-phone_country_code').val(), $('#c-suggest-phone_national').val(),
              function(){
                $(self).prop('disabled', false);
              });
            }
          );
          $('#c-suggest-phone_valid_err_msg').text('');
        } else {
          $('#c-suggest-phone_valid_err_msg').text(data.err_msg);
        }
      }).fail(function() {
        $(self).prop("disabled", false);
        $('#c-suggest-phone_valid_err_msg').text('Communication error');
      }).always(function() {
        $('#c-suggest-phone_national').prop("readOnly", false);
        hideLoading();
      });
    });

    // SMS受信確認
    $('#c-suggest-sms-confirm-btn').on('click',function(){
      if(find_customer_info) {
        reflectCustomerInfo(find_customer_info);
        showCustomerInfoButtons();
        $('#customer-suggest-modal-close').click();
        $('#completed_customer_suggest').val(true);
      }
      openCustomerInfoModal();
    });
  };

  // 顧客情報詳細入力モダール
  function addCustomerInfoModalEvent() {
    $('#c-info-confirm').on('click',function(){
      if($('#c-info-phone_national').val()) {
        showLoading();
        $.ajax({
          url: '/api/customers/valid_phone_number.json',
          method: 'POST',
          dataType: "json",
          data: {
            phone_country_code: $('#c-info-phone_country_code').val(),
            phone_national: $('#c-info-phone_national').val(),
          }
        }).done(function (data) {
          if(data.valid) {
            // 電話番号に変更があれば確認SMS送信
            if($('#c-suggest-confirm_tel').val() == data.tel) {
              confirmCustomerInfo();
            } else {
              findCustomer(
                $('#c-info-phone_country_code').val(),
                $('#c-info-phone_national').val(),
                $('#c-info-number_plate_area').val(),
                $('#c-info-number_plate_number').val(),
                $('#c-info-number_plate_pref').val(),
                function() {
                  sendConfirmMessage($('#c-info-phone_country_code').val(), $('#c-info-phone_national').val(),
                  function(){
                    $('#open-sms-confirm-modal').click();
                    if(find_customer_info) {
                      $('#customer_id').val(find_customer_info.id);
                    } else {
                      $('#customer_id').val('');
                    }
                  });
                }
              );
            }

            $('#c-info-phone_valid_err_msg').text('');
          } else {
            $('#c-info-phone_valid_err_msg').text(data.err_msg);
          }
        }).fail(function() {
          $('#c-info-phone_valid_err_msg').text('Communication error');
        }).always(function() {
          hideLoading();
        });;
      } else {
        confirmCustomerInfo();
      }
    });

    $('#c-info-sms-resend-btn').on('click',function(){
      findCustomer(
        $('#c-info-phone_country_code').val(),
        $('#c-info-phone_national').val(),
        $('#c-info-number_plate_area').val(),
        $('#c-info-number_plate_number').val(),
        $('#c-info-number_plate_pref').val(),
        function() {
          sendConfirmMessage($('#c-info-phone_country_code').val(), $('#c-info-phone_national').val(),
          function(){
            if(find_customer_info) {
              $('#customer_id').val(find_customer_info.id);
            } else {
              $('#customer_id').val('');
            }
          });
        }
      );
    });

    $('#c-info-sms-confirm-btn').on('click',function(){
      $('#close-sms-confirm-modal').click();
      confirmCustomerInfo();
    });

    $('#c-info-phone_national').on('keyup',function(){
      judgmentActivateCustomerInfoConfirm();
    });

    $('#c-info-number_plate_number, #c-info-number_plate_pref').on('keyup',function(){
      judgmentActivateCustomerInfoConfirm();
    });

    $('#open-customer-info-modal').on('click',function(){
      if($('#refrect_customer_info').val()) {
        let customer_info = {
          'tel': $('#customer_tel').val(), 
          'tel_national': $('#temp_tel_national').val(),
          'tel_national_hyphen': $('#display-customer-tel').text(),
          'tel_country_code': $('#temp_tel_country_code').val(),
          'customer_name': $('#maintenance_log_name').val(),
          'number_plate_area': $('#maintenance_log_number_plate_area').val(),
          'number_plate_number': $('#maintenance_log_number_plate_number').val(),
          'number_plate_pref': $('#maintenance_log_number_plate_pref').val(),
          'expiration_year': $('#maintenance_log_expiration_year').val(),
          'expiration_month': $('#maintenance_log_expiration_month').val(),
          'maker': $('#maintenance_log_maker').val(),
          'model': $('#maintenance_log_model').val(),
          'color': $('#maintenance_log_color').val()
        }
        reflectCustomerInfo(customer_info);
      }
    });
  }

  function addChargeModalEvent(){
    $("#btn-checkout").on("click", function(event){
      let receipt_type = $("#customer_receipt_type").val();
      let send_type = $("#customer_send_type").val();
      let isWhatsApp = $("#customer_send_type").val() == ("wa" || "sms_wa");
      if(send_type && $("#receipt_output_method_sms:checked").length == 0){
        if(send_type=="sms" || send_type=="sms_wa")
          $("#receipt_output_method_sms").click();
      }
      if(receipt_type || isWhatsApp){
        if($("#receipt_output_method_sms:checked").length == 0 && receipt_type=="paper"){
          $("#receipt_output_method_paper").click();
        }
          
        if($("#receipt_output_method_no:checked").length == 0 && receipt_type=="no"){
          $("#receipt_output_method_no").click();
        }

        $("#receipt-actions").hide();
      }
    })
  }

  // 年月選択
  function addYearPickerEvent() {
    $("#yearPicker").yearPicker({
      callback : function(month, year){
        $('#selected-expiration-year').val(year);
        $('#selected-expiration-month').val(month);
      }
    });

    $('#expiration-confirm-button').on('click',function(){
      let year = $('#selected-expiration-year').val();
      let month = $('#selected-expiration-month').val();

      setExpiration(month, year);
    });

    $('#c-info-clear-expiration').on('click',function(){
      resetExpiration();
    });
  }

  // バイクメーカー選択
  function addBikePickerEvent() {
    $("#bikePicker .badge").pill({
      onClick : function(value, index){
        $('#selected-maker').val(value);
        $('#confirm-maker-button').prop('disabled', false);
      }
    });
  
    $('#confirm-maker-button').on('click',function(){
      let maker = $('#selected-maker').val();
      setMaker(maker);
    });
  
    $('#typeCollapse').on('shown.bs.collapse', function () {
      $("#typeCollapseToggleMore").hide();
      $("#typeCollapseToggleClose").show();
    })
  
    $('#typeCollapse').on('hidden.bs.collapse', function () {
      $("#typeCollapseToggleMore").show();
      $("#typeCollapseToggleClose").hide();
    })

    $('#c-info-clear-maker').on('click',function(){
      resetMaker();
    });
  }

  // バイクカラー選択
  function addColorPickerEvent() {
    $("#colorPicker").colorPill({
      items : [ 
        "white", 
        "black", 
        "blue", 
        "grey", 
        "red", 
        "green", 
        "yellow", 
        "orange", 
        "pink", 
        "purple", 
        "brown", 
        "silver", 
        "gold", 
        "other" 
      ],
      callback: function(data){
        $('#selected-color').val(data);
        $('#confirm-color-button').prop('disabled', false);
      }
    });

    $('#confirm-color-button').on('click',function(){
      let color = $('#selected-color').val();
      setColor(color);
    });

    $('#c-info-clear-color').on('click',function(){
      resetColor();
    });
  }

  // カレンダー
  function addCalendarEvent(){

    $("#customer-checkin, #customer-checkout").on("click", function(event){
      let selected_date = reformatDate($(event.target).text())

      $("#calendar").html("");
      $("#calendar").calendar({
        locale:"id-ID",
        selectedDate: selected_date, 
        limitFutureDays: 0,  
        onSelect: function(date, self){
          let target = self.settings.updateTarget;

          if(target) {
            switch(target.id) {
              case 'customer-checkin':
                $('#selected-checkin-date').val(date);
                break;
              case 'customer-checkout':
                $('#selected-checkout-date').val(date);
                break;
            }
          }
        }
      });

      $(document).trigger('calendar_open', event);
    })

    function reformatDate(target) //string
    {
      return target.match(/^\d/) ? moment(target.split('.').reverse().join('-')).toDate() : '';
    }

    $(document).on('modal_close', function(event, data){
      if(data == '#calendarModal') {
        $('#selected-checkin-date').val('');
        $('#selected-checkout-date').val('');
      }
    })

    $('#calendar-button button').on('click', function() {
      let checkin_date = $('#selected-checkin-date').val();
      let checkout_date = $('#selected-checkout-date').val();
       
      if(checkin_date) {
        $('#customer-checkin').text(checkin_date);
      }

      if(checkout_date) {
        $('#customer-checkout').text(checkout_date);
      }
    });

    $('#checkin-date-confirm').on('click',function(event){

      var checkin = reformatDate($('#customer-checkin').text());
      var checkout = reformatDate($('#customer-checkout').text());
      if(checkin && checkout){
        var checkin_date_time = new Date(checkin.getFullYear(),checkin.getMonth(),checkin.getDate(),$("#checkin_hour").val(),$("#checkin_minute").val());
        var checkout_date_time = new Date(checkout.getFullYear(),checkout.getMonth(),checkout.getDate(),$("#checkout_hour").val(),$("#checkout_minute").val());
        if(checkin_date_time > checkout_date_time){
          $("#calendar-error").removeClass("display-none");
          setTimeout(function(){
            $("#calendar-error").addClass("display-none");
          },5000);
          event.stopImmediatePropagation();
          return false;
        }
      } else if (checkout) {
        // チェックアウト日時入力時はチェックイン入力必須
        $("#checkin-required-error").show();
        setTimeout(function(){
          $("#checkin-required-error").hide();
        },5000);
        event.stopImmediatePropagation();
        return false;
      }
         

      let blank_date_text = 'Current';
      let blank_time_text = 'time';
      let checkin_date_text = $('#customer-checkin').text();
      let checkin_hour = formatTime($('#checkin_hour').val() || '00');
      let checkin_minute = formatTime($('#checkin_minute').val() || '00');
      let checkout_date_text = $('#customer-checkout').text();
      let checkout_hour = formatTime($('#checkout_hour').val() || '00');
      let checkout_minute = formatTime($('#checkout_minute').val() || '00');

      if(checkin_date_text.match(/^\d/)) {
        let checkin_date = checkin_date_text.split('.').reverse().join('-');
        let checkin_datetime = `${checkin_date} ${checkin_hour}:${checkin_minute}`;
        let utc_checkin_datetime = moment(checkin_datetime).subtract(7, "hours").format('YYYY-MM-DD HH:mm:ss');

        $('#checkinDate').text(checkin_date_text);
        $('#checkinTime').text(`${checkin_hour}:${checkin_minute}`);
        $('#checkin_datetime').val(utc_checkin_datetime);
      } else {
        $('#checkinDate').text(blank_date_text);
        $('#checkinTime').text(blank_time_text);
        $('#checkin_datetime').val('');
      }

      if(checkout_date_text.match(/^\d/)) {
        let checkout_date = checkout_date_text.split('.').reverse().join('-');
        let checkout_datetime = `${checkout_date} ${checkout_hour}:${checkout_minute}`;
        let utc_checkout_datetime = moment(checkout_datetime).subtract(7, "hours").format('YYYY-MM-DD HH:mm:ss');

        $('#checkoutDate').text(checkout_date_text);
        $('#checkoutTime').text(`${checkout_hour}:${checkout_minute}`);
        $('#checkin_checkout_datetime').val(utc_checkout_datetime);
        
        if(!$('#receipt-button').length) {
          // レシートボタンが存在しない = 未チェックアウト
          // 未チェックアウト時にチェックアウト時間を入力した場合SAVE不可
          $('#saveForm').prop('disabled', true);
        }
      } else {
        $('#checkoutDate').text(blank_date_text);
        $('#checkoutTime').text(blank_time_text);
        $('#checkin_checkout_datetime').val('');
      }
    });

    $('#checkinCheckoutTime').on('click',function(){
      let checkin_date_text = $('#checkinDate').text();
      let checkout_date_text = $('#checkoutDate').text();

      if(checkin_date_text.match(/^\d/)) {
        let checkin_hour = $('#checkinTime').text().split(':')[0];
        let checkin_minute = $('#checkinTime').text().split(':')[1];
        $('#customer-checkin').text(checkin_date_text);
        $('#checkin_hour').val(checkin_hour);
        $('#checkin_minute').val(checkin_minute);
      }

      if(checkout_date_text.match(/^\d/)) {
        let checkout_hour = $('#checkoutTime').text().split(':')[0];
        let checkout_minute = $('#checkoutTime').text().split(':')[1];
        $('#customer-checkout').text(checkout_date_text);
        $('#checkout_hour').val(checkout_hour);
        $('#checkout_minute').val(checkout_minute);
      }
    });

    $("#checkin_hour, #checkout_hour").on("keyup", function(event){
      let self = this;
      let hour = $(self).val();
      if(hour > 23) {
        $(self).val(23);
      }
    });

    $("#checkin_minute, #checkout_minute").on("keyup", function(event){
      let self = this;
      let minute = $(self).val();
      if(minute > 59) {
        $(self).val(59);
      }
    });

    $('#clear-checkin-date').on('click',function(){
      $('#customer-checkin').text(blank_calendar_text);
      $('#checkin_hour').val('');
      $('#checkin_minute').val('');
    });

    $('#clear-checkout-date').on('click',function(){
      $('#customer-checkout').text(blank_calendar_text);
      $('#checkout_hour').val('');
      $('#checkout_minute').val('');
    });
  }

  //
  function formatTime(num) {
    let digit = 2;
    if(num.length != digit) {
      num = `0${num}`;
    }

    // ハイフンorドットが含まれていたら0とする
    if(num.match(/[-.]/)) {
      num = '00';
    }
    return num;
  }

  // 合計対応
  function addTotalNumberPickerEvent(){
    var total = 0;
    var isDiscount = false;
    var locale = "id-ID";
    var value;
    var adjustedAmount;
    isDiscount;
    $("#numberPad").numberPad({
      onInput:function(newValue){
        //mask a decimal entry. This will only appear as 0 on the UI
        if(newValue == '.'|| newValue=='')
          value = 0;
        else{
          isDiscount = newValue<=total;

          adjustedAmount = Math.abs(newValue - total);
          value = newValue;
          $("#numberInput").val(value).toLocaleString(locale);
          if(isDiscount){
            $("#number-pad-total-alert").fadeOut('fast');
            $("#numberPadModal button").removeAttr("disabled");
          }else{
            //attempt to input price greater than sales price XXXX
            $("#number-pad-total-alert").fadeIn('fast');
            $("#numberPadModal button").attr("disabled", true);
          }
        }
      },
      currentValue : $('#maintenance_log_total_price').val()
    })
  
    $(document).on("modal_open", function(event, data) {	
      if (data !== "#numberPadModal") return;	
      var $input = $("#numberInput");	
      if (!isMobileDevice()) {	
        handleKeyboardInput();	
      }	
      getTotal();	
      var adjustedTotal = $("#maintenance_log_total_price").val();	
      $input.val(adjustedTotal).toLocaleString(locale) || 0;
      var adjustment = $("#adjustedAmount")	
        .rpToNumber()	
        .toLocaleString(locale);	
      $(data)	
        .find("#list-price")	
        .text(total)	
        .toLocaleString(locale);	
      $(data)	
        .find("#priceDifference")	
        .text(adjustment);	
      $(document).trigger("picker_open", adjustedTotal);	
    });
  
    $(document).on("modal_close", function(event, data){
      if(data!=='#numberPadModal')
        return;
        //reset number pad
      $(document).trigger('picker_close')
    });

    $(document).on("click", "#numberPadModal button", function(event, data){
      updateUI();
    });

    $(document).on("update_quantity", function(event, data){
      resetTotalPrices();
    });

    $(document).on("update_unit_price", function(){
      resetTotalPrices();
    });

    $(document).on("update_discount", function(){
      resetTotalPrices();
    });

    function updateUI(){
      //update UI
      
      if(value===undefined){
        value = $('#maintenance_log_total_price').val() || 0
      }
      
      $("#totalPrice").text(`${value}`).toLocaleString(locale);
      $('#maintenance_log_total_price').val(value);
      
      setDiscountAmount();
    }

    function getTotal(){
      total = 0;
      $("#main-order-list li:visible .hidden_sub_total_price").each(function(index,item){
        if($(item).val()){
          total = total+parseFloat($(item).val());
        }
      })

      return total || 0;
    }

    function setDiscountAmount(){
      adjustedAmount = adjustedAmount || 0;
      $("#adjustedAmount").text(`${adjustedAmount}`).toLocaleString(locale);

      $("#discountIndicator").text(`${isDiscount?"-Rp.":"+Rp."}`);

      $("#priceDifference").text(`${adjustedAmount}`).toLocaleString(locale);
      var s = `(${isDiscount?"-":"+"}Rp.${$("#priceDifference").text()})`
      $("#priceDifference").text(`${s}`)
    }

    function resetTotalPrices(){
      value = $('#maintenance_log_total_price').val();
      adjustedAmount = 0;
      setDiscountAmount();
    }

    function handleKeyboardInput() {
      var $input = $("#numberInput");
      $input.removeAttr("readonly");
      $input.on("keyup", function(event) {
        $(document).trigger("number_pad_keyboard_update", {
          target: $input,
          inputValue: $input.val()
        });
      });
    
      $input.on("focus", function(event) {
        $input.val(null);
        $(document).trigger("number_pad_keyboard_update", {
          target: $input,
          inputValue: $input.val()
        });
      });
    }
  }

  // 割引対応
  function addDiscountNumberPickerEvent(){

    var container;
    var originalPrice;
    var target;
    var price;
    var value;
    var quantity;
    var discountType;
    var discountRate;
    var discountAmount;
    var hiddenDiscount;
    var subTotal;
    var locale = "id-ID";
    var changed = false;
    var valueNumber;

    $("#numberPadDiscount").numberPad({
      onInput:function(newValue, prevValue, settings){
        changed = true;

        //mask a decimal entry. This will only appear as 0 on the UI
        if(newValue == '.'||newValue=='')
        newValue = 0;

        target = settings.targetValue;

        price = $("#discount-list-price").rpToNumber();
        
        var type = $("input[name='discount-options']:checked").attr('id');
        
        discountRate = $("#discountInput").val(newValue).val();

        subTotal = $("#discount-selling-price").setDiscountPrice(type, price, newValue).text();

        discountAmount = price - subTotal;

        $("#discount-selling-price").toLocaleString(locale);

        $("#discountInput").toLocaleString(locale);

        //reset to original price when null-ish
        if(!newValue||newValue==""||newValue==0){
          $("#discount-selling-price").text(price).toLocaleString(locale);
          subTotal = price
        }
      }
    });

    $(document).delegate(".form-input-discount-amount", "click", function(event){
      target = event.target;
      container = $(event.target).parents('li');
      hiddenDiscount = $(container).find(".hidden_discount_type").val();
      subTotal = $(container).find(".hidden_sub_total_price").val();
      discountType = hiddenDiscount ? getDiscountType(hiddenDiscount) : '%';
      discountRate = $(container).find(".hidden_discount_rate").val();
      discountAmount = $(container).find(".hidden_discount_amount").val();
      originalPrice = $(container).find('.hidden_unit_price').val();
      quantity = $(container).find('.quantity').val();
      value = $(container).find('.form-input-discount-amount').val();
      valueNumber = $(container).find('.form-input-discount-amount').rpToNumber();

      $(document).trigger('number_pad_target_update', {target : target, inputValue: value})

      $('#discount-list-price').text(originalPrice * quantity).toLocaleString(locale)

      $('#discountInput').val(value)

      if(discountType==='%')
        $('#percent').trigger("click", false)
      if(discountType==='Rp.')
        $('#cash').trigger("click", false)
      
      if(!subTotal)
        $('#discount-selling-price').text(originalPrice).toLocaleString(locale)
      else
        $('#discount-selling-price').text(subTotal).toLocaleString(locale)

        if(valueNumber)
          $(document).trigger("picker_open", valueNumber)
    });

    //handle changing discount type
    $("#discount-button-group .btn").on("click", function(event, data){
      //dont act on trigger when setting the proper radio button
      //when the modal is opened.
      if(data==false){
        return
      }

      var type = $(event.target).text();

      if(type)
        discountType = type.trim();

      $("#discount-selling-price").text(originalPrice);
      
      $(document).trigger("discount_type_change", discountType);

    })

    //reset when discount type is changed
    $(document).on("discount_type_change", function(event, data){
      //reset number pad
      $(document).trigger('picker_close')
    })

    $(document).on("modal_open", function(event, data){
      if(data!=='#numberPadDiscountModal')
      return;
    });

    $(document).on("modal_close", function(event, data){
      if(data!=='#numberPadDiscountModal')
      return;
      //reset number pad
      $(document).trigger('picker_close')
    });

    $(document).on('click', '#numberPadDiscountModal button', function(event){
      if(changed){
        updateUI();
          
        updateTotal();

        $(document).trigger('update_discount');
      }
          
      changed = false;
    })

    function getDiscountType(value){
      switch(value){
        case 'Rp.': return 'value'
        case '%'  : return 'rate'
        case 'value'  : return 'Rp.'
        case 'rate'  : return '%'
      }
    }

    function updateUI(){
      
      var quantity = $(container).find(".hidden_quantity").val();

      $(target).val($("#discountInput").val())

      $(container).find(".product__price").text(subTotal).toLocaleString(locale);

      $(container).find(".input-group-discount .input-group-text").text(discountType);

      $(container).find(".hidden_discount_type").val(getDiscountType(discountType));

      $(container).find(".hidden_sub_total_price").val(subTotal);

      $(container).find(".hidden_discount_rate").val(discountRate);

      $(container).find(".hidden_discount_amount").val(discountAmount);
    }

  }

  // 数量変更
  function addHandleItemQuantityEvent(){
    var container;
    var quantity;
    var subTotal;
    var discountedPrice;
    var locale = "id-ID"
    $(document).delegate(".spinner-box .spinner","click", function(event){
      container = $(event.target).parents("li");
      setTimeout(function(){
        quantity = $(event.target).parents(".spinner-box").find(".quantity").val();
        updateQuantity();
        $(document).trigger('update_quantity', {'container':container, 'quantity':quantity});
      },100)
    })

    $(document).on('update_quantity', function(event, data){
      container = data.container;
      quantity = data.quantity;
      updateQuantity();
    })

    function updateQuantity(){
      //
      recalculateUI();

      updateUI();

      updateTotal();
    }

    function recalculateUI(){
      var unit_price = $(container).find(".hidden_unit_price").val();
      var discount_type = $(container).find(".hidden_discount_type").val();

      var price = Math.floor(unit_price * quantity);

      var rate = $(container).find(".hidden_discount_rate").val();

      subTotal =  price - (price - $.fn.getDiscountPrice(discount_type, price, rate))
    }

    function updateUI(){
      quantity = quantity || 1;
      $(container).find(".product__price").text(subTotal).toLocaleString(locale);
      $(container).find(".hidden_sub_total_price").val(subTotal)
      $(container).find(".hidden_quantity").val(quantity)
      $(container).find(".product__quantity span").text(quantity)
    }
  }

  // 商品追加対応
  function addHandleItemAddedEvent(){
    $(document).on('cocoon:after-insert', function(event, target){
      setTimeout(function(){updateTotal()},100);
    });
    $(document).on('cocoon:after-remove', function(event, target){
      setTimeout(function(){updateTotal()},100);
    });
  }

  // 商品毎メカニック対応
  function addSelectItemMechanicEvent(){

    var container;
    var mechanicList = [];
    var button;
    var buttons;
    var currentItem;
    var selectMechanicAction = false;

    function setPills(){
      $("#selectItemMechanicModal .badge").pill({
        style: 'badge-outline',
        onClick : function(value, index, event){
          getMechanics();
          highlightItems();
          var target = $(event.target)
          var item = {
            name:target[0].childNodes[0].nodeValue.trim(), 
            id:target.data("id"),
            html: target
                  .clone()
          }
            
          if(exists(item))
            return;
  
          mechanicList.push(item);

          highlightItems();
         }
      });
    }

    setPills();

    //trigger
    $(document).delegate(".btn-select-mechanics","click", function(event){
      getContainer(event.target);
      getMechanics();
      button = $(container).find(".add-mechanics")
    });

    //remove
    $(document).delegate(".select-mechanics .badge a","click", function(event){
       //remove from array and update
       var target = $(event.target).parents(".badge");
       removeItem(target);
       $(this).find('.remove_fields').click();
    });

    //select
    $(document).delegate("#selectItemMechanicModal .badge", "click", function(event){

    })

    //main mechanic selected
    $(document).on('selected_main_mechanic', function(event, id){
        var listItems = $(".order-list-item");
        var target = $("#selectItemMechanicModal").find(`[data-id="${id}"]`)
        target.addClass("main-mechanic")
        listItems.each(function(index, item){
           mechanicList = [];
           button = $(item).find(".add-mechanics");
           getContainer(button);
           getMechanics();


           if(container.find(".badge-mechanic").length>=1)
            return;


          //if there is already a mechanic assigned which is not the main mechanic, skip;
          //  if(
          //    container.find(".badge-mechanic").length>=1 && container.find(".main-mechanic").length==0 ||
          //    container.find(".badge-mechanic").length>1 && container.find(".main-mechanic").length==1
          //  )
          //   {
          //     return;
          //   }
            
          //  //if there is a main mechanic, replace
          //   var selectedMainMechanic = container.find(".main-mechanic");
            
          //   if(selectedMainMechanic.length==1){
          //   removeItem(selectedMainMechanic)
          //   selectedMainMechanic.find(".remove_fields").click();
          //   selectedMainMechanic.parents(".selected-mechanic-wrapper").remove();
          //   }

            $(target).click();
            $("#selectItemMechanicModal button").click();

            container.find(".product__mechanic-icon .badge").addClass("-background-red")
        })
    })

    //confirm
    $(document).delegate("#selectItemMechanicModal button", "click", function(event){
      container.find(".selected-mechanic-wrapper").remove();
      mechanicList.forEach(function(item, index){
          selectMechanicAction = true;
          currentItem = $(item.html);
          button.click();
      })
    })

    $(document).on("modal_open", function(event, data){
      if(data!=='#selectItemMechanicModal')
       return;
       highlightItems();
    });

    $(document).on("modal_close", function(event, data){
      if(data!=='#selectItemMechanicModal')
       return;
        mechanicList = [];
       $("#selectItemMechanicModal").find(".badge").removeClass("-selected");
    });

    $(document).on('cocoon:before-insert', function(event, insertedItem, originalEvent){
      if(!selectMechanicAction)
        return;
      var $insertedItem = $(insertedItem);
      var isMainMechanic = currentItem.hasClass("main-mechanic");
      var innerHtml = currentItem[0].childNodes[0].nodeValue.trim() + $insertedItem.find(".remove_fields").prop("outerHTML");
      var id = currentItem.data("id") || currentItem.attr("id")
      $insertedItem.find(".hidden_maintenance_log_detail_id").val(container.find(".hidden_shop_product_id").val())
      $insertedItem.find(".hidden_shop_staff_id").val(id)
      $insertedItem
        .find("span.badge")
        .html(innerHtml)
        .addClass(`${isMainMechanic?"main-mechanic": ""}`)
        .attr("id", id)

      selectMechanicAction = false;
      insertedItem = $insertedItem;

      return insertedItem;
    });

    $(document).on('cocoon:after-insert', function(event, insertedItem, originalEvent){
      
    }); 

    function getMechanics(){
      var temp = container.find(".select-mechanics .badge");

      if(temp.length==0){
        return;
      }

      temp.each((index, item)=>{
          var item =  {
            name : $(item)[0].childNodes[0].nodeValue.trim(),
            id : parseInt($(item).attr("id")),
            html: item
          }
          if(!exists(item))
            mechanicList.push(item);
      })
    }

    function exists(item){
      return mechanicList.some(mechanic => mechanic.id === item.id )
    }

    function getContainer(item){
      var temp = $(item).parents("li");
      if(container && container.attr("id")!==temp.attr("id"))
        mechanicList = [];
      container = temp;
      getMechanics();
    }

    function highlightItems(){
      mechanicList.forEach(function(item,index){
        $("#selectItemMechanicModal").find(`[data-id='${item.id}']`).addClass("-selected")
      })
    }

    function removeItem(target){
       var temp = mechanicList.filter((item)=>{
          return item.id != parseInt($(target).attr("id"));
       })
       mechanicList = temp;
    }

    function init(){
      var mainMechanic = $("#selectMainMechanic").text().trim();
      var selectedMechanics = $(".order-list-item .badge-mechanic");
      selectedMechanics.each(function(index, item){
          if($(item)[0].childNodes[0].nodeValue.trim()===mainMechanic){
            $(item).addClass("main-mechanic")
          }
      })
    }

    init();
  }

  // 手入力商品対応
  function addManualNumberPickerEvent(){
    var input;
    var _newValue;
    var numberPadInput = $("#numberInputManual");

    $(document).delegate("#product-regist-price", "click", function(event){
      input = $(event.target);
      _newValue = '';
    });

    $('#numberPadManualModal button').on('click', function() {
      if (_newValue && _newValue !== '') {
        input.val(`${_newValue}`).toLocaleString("id-ID");
        input.change();
      }
      input = undefined;
    });

    $("#numberPadManual").numberPad({
      onInput:function(newValue, prevValue, element, settings){
        //mask a decimal entry. This will only appear as 0 on the UI
        if(newValue == '.'|| newValue=='')
          newValue = 0;

        $("#numberInputManual").val(newValue).toLocaleString("id-ID");
  
        //update UI
        // $("#product-regist-price").val(`${newValue}`).toLocaleString("id-ID");
        _newValue = newValue;

      },
    })
  
    $(document).on("modal_open", function(event, data){
      if(data!=='#numberPadManualModal'||$("#product-regist-price").val()=="")
        return;

      _newValue = $("#product-regist-price").rpToNumber()
      $("#numberInputManual").val($("#product-regist-price").val());
      $(document).trigger("picker_open", _newValue)

    });
    
    $(document).on("modal_close", function(event, data){
      if(data!=='#numberPadManualModal')
        return;
      updateTotal();
      //reset number pad
      numberPadInput.val(null);
      $(document).trigger('picker_close')
    });
  }

  // 単価入力
  function addPriceNumberPickerEvent(){
    var container;
    var input;
    var focused = false;
    var quantity;
    var subTotal;
    var discount;
    var discountedPrice;
    var value;
    var locale = 'id-ID';

    $(document).on("click",".form-input-unit-price", function(event){
      focused = true;
      container = $(event.target).parents("li");
      input = $(event.target);
    });

    $("#numberPadPrice").numberPad({
      onInput:function(newValue){
        //mask a decimal entry. This will only appear as 0 on the UI
        if(newValue == '.'|| newValue=='')
          value = 0;
        else
          value = newValue
        $("#numberInputPrice").val(value).toLocaleString("id-ID");

      },
    });

    function recalculateUI(){
      var unit_price = $(container).find(".hidden_unit_price").val();
      var discount_type = $(container).find(".hidden_discount_type").val();
      quantity = $(container).find('.hidden_quantity').val();
      if(discount_type === 'rate'){
        var price = unit_price * quantity;
        var rate = $(container).find(".hidden_discount_rate").val();
        var discount_amount = Math.floor(price*(rate/100));
      } else {
        var discount_amount = $(container).find(".hidden_discount_amount").val();
      }
      subTotal =  (unit_price * quantity) - discount_amount;

    }

    function updateUI(){
      //update UI
      $(input).val(`${value}`).toLocaleString("id-ID");
      $('.hidden_unit_price',container).val(`${value}`);
      recalculateUI()
      $(container).find(".product__price").text(subTotal).toLocaleString("id-ID");
      $(container).find(".hidden_sub_total_price").val(subTotal)
      $(container).find(".hidden_quantity").val(quantity)
    }
  
    $(document).on("modal_open", function(event, data){
      if(data!=='#numberPadPriceModal')
        return;
      value = $(input).rpToNumber();
      
      $("#numberInputPrice").val($(input).val());
      
      $(document).trigger("picker_open", value)
    });
    
    $(document).on("modal_close", function(event, data){
      if(data!=='#numberPadPriceModal')
        return;
        //reset number pad
      $(document).trigger('picker_close')
    });

    $(document).on("click", "#numberPadPriceModal button", function(event){
      updateUI();

      updateTotal();

      $(document).trigger('update_unit_price');
    })
  }

  // 数量入力
  function addQuantityNumberPickerEvent(){
    var container;
    var input;
    var focused = false;
    var quantity;

    $(document).on("click",".quantity.js-modal-open", function(event){
      focused = true;
      container = $(event.target).parents("li");
      input = $(event.target);
    });

    $("#numberPadQuantity").numberPad({
      useDecimal: true,
      truncateDecimal: 1,
      onInput:function(newValue,prevValue, element){
        //mask a decimal entry. This will only appear as 0 on the UI
        if(newValue == '.'|| newValue=='')
          newValue = 0;
        element.currentValue = newValue;

        $("#numberInputQuantity").val(newValue);
      },
    });

    function updateUI(){
      quantity = quantity || 1;
      container.find(".hidden_quantity").val(quantity)
    }

    $(document).delegate("#numberPadQuantityModal button", "click", function(event){
        var q =  $("#numberInputQuantity").val()
        quantity = (!q || q==0) ? 1 : q;
        
        input.val(quantity);

        updateUI();
        
        $(document).trigger('update_quantity', {'container':container, 'quantity':quantity});
    })
  
    $(document).on("modal_open", function(event, data){
      if(data!=='#numberPadQuantityModal')
        return;
        
      $("#numberInputQuantity").val(null);
      
    });
    
    $(document).on("modal_close", function(event, data){
      if(data!=='#numberPadQuantityModal')
        return;
      $(document).trigger('picker_close')
    });
  }

  // 商品毎ノート対応
  function addHandleItemNoteEvent(){
    var container;
    var input;
    var focused = false;
    $(document).delegate(".product__note" ,"click", function(event){
      focused = true;
      container = $(event.target).parents("li");
      input = $(event.target);
    });

    $(document).delegate("#note-open", "click", function(event){
      focused = true;
      input = $('#maintenance_log_remarks');
    });

    $(document).delegate("#inputNoteModal .confirm-note","click", function(event, data){
      if(!focused)
        return;

      var content = $("#inputNoteModal textarea").val();

      $(input).val(content).change();

      $("#inputNoteModal textarea").val(null);
      focused = false;

      if (input.attr('id') === 'maintenance_log_remarks') {
        if (content !== '') {
          $('#maintenance_log_remarks_badge').show();
        } else {
          $('#maintenance_log_remarks_badge').hide();
        }
      }
    });

    $(document).on("modal_open", function(event, data){
      if(data!=='#inputNoteModal'&& focused)
        return;

        $("#inputNoteModal textarea").val($(input).val());

    });
  }

  // 計算機
  function addCalculatorModalEvent(){
    var locale = "id-ID";
    var value;
    var total_price = 0;
    var rounding_direction = $("#maintenance_log_rounding_direction").val() || 'Down';
    var round_to = $("#maintenance_log_round_to").val() || '100';
    var $total = $('#order_total');
    var $adjusted = $('#order_adjusted');
    var $received = $("#order_received");
    var $change = $('#order_change');
    var $button = $("#calculator-button button");

    $("#calculator").numberPad({
      nodeHeight: 100,
      nodeWidth: 100,
      gridShapeY: 4,
      showQuickButtons: true,
      onInput:function(newValue){
        if(newValue == '.'|| newValue=='')
          value = 0;
        else
          value = newValue
          $received.val(value).toLocaleString(locale);
          updateUI();
          if($change.rpToNumber()>=0){
            $button.removeAttr("disabled")
          }else{
            $button.attr("disabled", "true")
          }
        },
    })
  
    $(document).on("modal_open", function(event, data){
      if(data!=='#calculatorModal')
        return;
      setUI();
    });
    
    $(document).on("modal_close", function(event, data){
      if(data!=='#calculatorModal')
        return;
      $(document).trigger("picker_close");
      $button.attr("disabled", "true")
    });

    $(document).on("click", "#calculatorModal button", function(event, data){
      updateUI();
    });

    function setUI(){
      $received.val(null);
      $change.text(0);
      getAdjustedValues()
    }

    function updateUI(){
      if(value===undefined){
        return
      }
      var result = parseInt($received.rpToNumber()-$total.rpToNumber());
      $change.text(result).toLocaleString(locale);

    }

    function getAdjustedValues(){
      //get rounding logic and apply or default to 'down' and '100'
      total_price = $('#maintenance_log_total_price').val()

      //check if rounding is unnecessary
      if(total_price%parseInt(round_to)==0){
        $total.text(parseInt(total_price)).toLocaleString(locale);
        $adjusted.text(0)
        return;
      }

      var temp = total_price;
      var sub = temp.substring((temp.length+1)-round_to.toString().length);

      //if(parseInt(total_price)>parseInt(round_to) && rounding_direction.toUpperCase()==='UP'){
      if(parseInt(total_price)>parseInt(round_to) && rounding_direction.toUpperCase()==='UP'){
        var adj = parseInt(round_to)-parseInt(sub)
        $adjusted.text(adj).toLocaleString(locale);
        $total.text(parseInt(temp)+adj).toLocaleString(locale);
      }else{
        sub = parseInt(`-${sub}`);
        $adjusted.text(sub).toLocaleString(locale);
        $total.text(parseInt(temp)+sub).toLocaleString(locale)
      }
    }
  }

  // プレービュー
  function addOrderPreviewModalEvent(){
    var locale = "id-ID";
    var value;
    var $items = $("#main-order-list");
    var $container = $("#order-preview-list");
  
    $(document).on("modal_open", function(event, data){
      if(data!=='#orderPreviewModal')
        return;
      setUI();
      $("#close-calculator-modal-button").click();
    });
    
    $(document).on("modal_close", function(event, data){
      if(data!=='#orderPreviewModal')
        return;
        
    });

    $(document).on("click", "#orderPreviewModal button", function(event, data){
      updateUI();
    });

    function setUI(){
      $("#order-preview-list").html(null);

      var itemTotal = 0;
      var orderItemTotal = 0;
      var discountTotal = 0;
      //price displayed at bottom of the app
      var subTotal = parseInt($("#maintenance_log_total_price").val())||0;
      var paid = $("#order_received").rpToNumber()||0;
      var change = $("#order_change").rpToNumber()||0;
      var $adjustmentField = $("#order-preview-adjustment-toggle");
      var $discountField = $("#order-preview-discount-toggle");
      $discountField.removeClass("d-flex")
      $discountField.hide();
      $adjustmentField.removeClass("d-flex")
      $adjustmentField.hide();

      $items.find("li").each(function(index, item){
        if($(this).css('display') === 'none'){
          return true;
        }
        var $item = $(item);
        var name = $item.find(".hidden_name").val();
        var unitprice = $item.find(".hidden_unit_price").val();
        var subtotal = $item.find(".hidden_sub_total_price").val();
        var discount = $item.find(".hidden_discount_amount").val();
        var quantity = $item.find(".hidden_quantity").val();

        $container.append(`<tr><td>${name}</td><td>${parseInt(quantity).toLocaleString(locale)}</td><td>${parseInt(unitprice).toLocaleString(locale)}</td><td>${(unitprice*quantity).toLocaleString(locale)}</td></tr>`);
        $item.find('.related-product').each((index, record) => {
          var $elem = $(".related-product.clone").clone();
          var $record = $(record);
          $elem.removeClass("clone");
          $elem.find(".related-product-name").append($record.find('.hidden_item_name').val());
          $container.append($elem);
        });
        if(discount!=0){
          var $elem = $(".discount-item.clone").clone();
          $elem.removeClass("clone")
          $elem.find(".discount-value").append(`-${parseInt(discount).toLocaleString(locale)}`);
          $container.append($elem);
          $discountField.addClass("d-flex")
          $discountField.show();
        }
        itemTotal += parseInt(subtotal);
        orderItemTotal += parseInt(unitprice*quantity);
        discountTotal += parseInt(discount);
      });

      $container.append(`<tr class="order-preview-divider"><td colspan='4'></td></tr>`)
      
      var orderDiscount = (orderItemTotal-discountTotal) - subTotal;
      if(orderDiscount&&orderDiscount>0){
        var $disc = $(".order-preview-group.discount.clone").clone();
        $disc.removeClass("clone")
        $disc.find(".discount-value").append(`-${orderDiscount.toLocaleString(locale)}`)
        $container.append($disc);
        $discountField.addClass("d-flex")
        $discountField.show();
      }
      var adjustedAmount = parseInt($("#order_adjusted").text())||0;

      if(adjustedAmount!=0){
        var $adjs = $(".order-preview-group.adjusted.clone").clone();
        $adjs.removeClass("clone")
        $adjs.find("#adjusted-value").append(`${adjustedAmount.toLocaleString(locale)}`)

        var $adjustedTotal = $("#order-preview-adjustment");

        var $adjustedText = $adjs.find("#adjusted-value");
        
        if(adjustedAmount<0){
          $adjustedText.addClass("discount-value");
          $adjustedTotal.addClass("discount-value");
        }else{
          $adjustedText.removeClass("discount-value");
          $adjustedTotal.removeClass("discount-value");
        }
        $adjustmentField.addClass("d-flex")
        $adjustmentField.show();
        $container.append($adjs);
      }else{
        var $adjustedTotal = $("#order-preview-adjustment");
      }

      var orderTotalDiscount = (discountTotal+orderDiscount)-(adjustedAmount);
      var discountTotalText = discountTotal+orderDiscount

      $("#order-preview-sub-total").text(orderItemTotal).toLocaleString(locale);
      //add adjusted
      $adjustedTotal.text(`${adjustedAmount}`).toLocaleString(locale);
      $("#order-preview-discount").text(`${discountTotalText>0?'-':''}${discountTotalText}`).toLocaleString(locale);
      $("#order-preview-total").text(orderItemTotal-orderTotalDiscount).toLocaleString(locale);
      $("#order-preview-paid").text(paid).toLocaleString(locale);
      $("#order-preview-change").text(change).toLocaleString(locale);
    }

    function updateUI(){
      if(value===undefined){
        return
      }
    }
  }

  // 合計計算
  function updateTotal(){
    var total = 0;
    var count = 0;
    $(".order-box .order-list-item").each(function(index,item){
      if($(this).css('display') === 'none'){
        return true;
      }
      var itemTotal = parseFloat($(item).find(".hidden_sub_total_price").val()||0);
      total += itemTotal;
      count++;
    });

    $("#totalPrice").text(total).toLocaleString("id-ID")
    $('#maintenance_log_total_price').val(total);
    $("#priceDifference").text(`(Rp.0)`);

    //商品が１つも選択されていない場合は、チェックアウトボタンを非活性にする。
    if(count === 0){
      $('#btn-checkout').prop('disabled',true);
    } else {
      $('#btn-checkout').prop('disabled',false);
    }
  }

  // 顧客情報詳細入力モーダル表示
  function openCustomerInfoModal() {
    let confirm_tel = $('#c-suggest-confirm_tel').val();
    let confirm_phone_country_code = $('#c-suggest-confirm_phone_country_code').val();
    let confirm_phone_national = $('#c-suggest-confirm_phone_national').val();
    let customer_name = $('#c-suggest-customer_name').val();
    let number_plate_area = $('#c-suggest-number_plate_area').val();
    let number_plate_number = $('#c-suggest-number_plate_number').val();
    let number_plate_pref = $('#c-suggest-number_plate_pref').val();

    $('#c-info-customer_name').val(customer_name);
    if(confirm_tel) {
      $('#c-info-phone_country_code').val(confirm_phone_country_code);
      $('#c-info-phone_national').val(confirm_phone_national);
    }
    if(number_plate_area && number_plate_number && number_plate_pref) {
      $('#c-info-number_plate_area').val(number_plate_area);
      $('#c-info-number_plate_number').val(number_plate_number);
      $('#c-info-number_plate_pref').val(number_plate_pref);
    }
  
    $('#customerSuggestModal').hide();
    $('#termsModal').hide();

    $('#completed_customer_suggest').val(true);

    $('#open-customer-info-modal').click();
  }

  // 電話番号形式チェック
  function validPhoneNumber() {
    showLoading();
    $.ajax({
      url: '/api/customers/valid_phone_number.json',
      method: 'POST',
      dataType: "json",
      data: {
        phone_country_code: $('#c-suggest-phone_country_code').val(),
        phone_national: $('#c-suggest-phone_national').val(),
      }
    }).done(function (data) {
      if(data.valid) {
        $('#c-suggest-phone_valid_err_msg').text('');

        findCustomer(
          $('#c-suggest-phone_country_code').val(),
          $('#c-suggest-phone_national').val(),
          $('#c-suggest-number_plate_area').val(),
          $('#c-suggest-number_plate_number').val(),
          $('#c-suggest-number_plate_pref').val(),
          function() {
            if(find_customer_data) {
              if(find_customer_data.to_agree) {
                openTermsModalFromCustomer();
                return;
              }
        
              reflectCustomerInfo(find_customer_info);
        
              showCustomerInfoButtons();
              $('#customer-suggest-modal-close').click();
              $('#completed_customer_suggest').val(true);
              openCustomerInfoModal();
            }
            else {
              if($('#customer_terms_agreed_at').val()) {  // 規約同意済みの場合
                sendConfirmMessage($('#c-suggest-phone_country_code').val(), $('#c-suggest-phone_national').val(),
                function(){
                  showSmsConfirm();
                });
              } else {
                openTermsModalFromCustomer();
              }
            }
          }
        );
      } else {
        $('#c-suggest-phone_valid_err_msg').text(data.err_msg);
      }
    }).fail(function() {
      $('#c-suggest-phone_valid_err_msg').text('Communication error');
    }).always(function() {
      hideLoading();
    });;
  }

  function findCustomer(phone_country_code, phone_national, number_plate_area, number_plate_number, number_plate_pref, callback) {
    showLoading();
    find_customer_data = null;
    find_customer_info = null;

    $.ajax({
      url: '/api/customers/find.json',
      dataType: 'json',
      data: {
        phone_country_code: phone_country_code,
        phone_national: phone_national,
        number_plate_area: number_plate_area,
        number_plate_number: number_plate_number,
        number_plate_pref: number_plate_pref
      }
    }).done(function (data) {
      let item = data.customer;

      if(item.id) {
        find_customer_data = item;
        find_customer_info = {
          'id': item.id,
          'tel': item.tel, 
          'tel_national': item.tel_national,
          'tel_national_hyphen': item.tel_national_hyphen,
          'tel_country_code': item.tel_country_code,
          'customer_name': $('#c-suggest-customer_name').val() || item.name,
          'send_dm': item.send_dm,
          'terms_agreed_at': item.terms_agreed_at,
          'number_plate_area': item.number_plate_area || number_plate_area,
          'number_plate_number': item.number_plate_number || number_plate_number,
          'number_plate_pref': item.number_plate_pref || number_plate_pref,
          'expiration_year': item.expiration_year,
          'expiration_month': item.expiration_month,
          'maker': item.maker,
          'model': item.model,
          'color': item.color,
          'owned_bikes_count': item.bikes_info.length,
          'send_type':item.send_type,
          'receipt_type':item.receipt_type,
          'wa_tel':item.wa_tel
        }
      }

      callback();
    }).fail(function() {
    }).always(function() {
      hideLoading();
    });
  }

  // 規約モーダル表示
  function openTermsModalFromCustomer() {
    // 会計ボタンか顧客情報ボタンどちらから開くかによって、同意ボタンの表示を切り替える
    $('#terms-agree-button').prop('disabled', true);
    $('#terms-agree-button').hide();
    $('#c-suggest-terms-agree-button').prop('disabled', false);
    $('#c-suggest-terms-agree-button').show();

    $('#open-terms-modal').click();
  }

  // 電話番号登録確認用メッセージ送信
  function sendConfirmMessage(phone_country_code, phone_national, callback) {
    showLoading();
    $.ajax({
      url: '/maintenance_log/send_confirm_sms.json',
      method: 'POST',
      dataType: "json",
      data: {
        phone_country_code: phone_country_code,
        phone_national: phone_national
      }
    }).done(function (data) {
      if(data.valid) {
        $('#c-suggest-confirm_tel').val(data.tel);
        $('#c-suggest-confirm_tel_national_hyphen').val(data.tel_national_hyphen);
        $('#c-suggest-confirm_phone_country_code').val(phone_country_code);
        $('#c-suggest-confirm_phone_national').val(phone_national);
      }
    }).always(() => {
      callback();
      hideLoading();
    });
  }

  // 顧客情報登録ボタンの活性非活性を判定
  function judgmentActivateResistration() {
    if($('#c-suggest-phone_national').val() || ($('#c-suggest-number_plate_number').val() && $('#c-suggest-number_plate_pref').val())) {
      $('#c-suggest-customer-registration-btn').prop('disabled', false);
    } else {
      $('#c-suggest-customer-registration-btn').prop('disabled', true);
    }
  }

  // 顧客情報登録ボタンの表示非表示を判定
  function judgmentDisplayResistration() {
    if($('#c-suggest-phone_national').val() || $('#c-suggest-customer_name').val() || $('#c-suggest-number_plate_number').val() || $('#c-suggest-number_plate_pref').val()) {
      $('#c-suggest-customer-registration-btn').show();
    } else {
      $('#c-suggest-customer-registration-btn').hide();
    }
  }

  // 顧客情報確定ボタンの活性判定
  function judgmentActivateCustomerInfoConfirm() {
    if($('#c-info-phone_national').val() || ($('#c-info-number_plate_number').val() && $('#c-info-number_plate_pref').val())) {
      $('#c-info-confirm').prop('disabled', false);
    } else {
      $('#c-info-confirm').prop('disabled', true);
    }
  }

  // 顧客検索
  function customeSuggest() {
    if(!allowSuggest) {
      return;
    }

    let word = `${$('#c-suggest-phone_national').val()} ${$('#c-suggest-customer_name').val()} ${$('#c-suggest-number_plate_number').val()} ${$('#c-suggest-number_plate_pref').val()}`;
    word = word.replace(/^\s+|\s+$/g,'');
    if (word.length < 3) {
      if (jqxhr) {
        jqxhr.abort();
        jqxhr = null;
      } else {
        // judgmentDisplayResistration();
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

    let tel_query = $('#c-suggest-phone_national').val();
    let name_query = $('#c-suggest-customer_name').val();
    let number_plate_query = `${$('#c-suggest-number_plate_number').val()} ${$('#c-suggest-number_plate_pref').val()}`.trim();
    jqxhr = $.ajax({
      url: "/api/customers/suggest_byfield.json",
      dataType: "json",
      data: {
        name: name_query,
        tel: tel_query,
        number_plate: number_plate_query,
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
      let suggest_list = $.map(data, function(item) {
        return item;
      })

      if (suggest_list.length == 0) {
        // judgmentDisplayResistration();
        return;
      }

      $('#c-suggest-customer_list .search_result').html($.map(suggest_list, function(item) {
        let number_plates = $.map(item.number_plate, function(num) {
          return $('<p>', {html: highlight(num, word)});
        });
        let bikes_maker_model = $.map(item.bikes_info, function(num) {
          return $('<p>', {html: highlight(num, word)});
        });
        return $('<tr>', {class: 'suggest_record', 'data-value': JSON.stringify(item)})
        .append($('<td>', {class: 'name_tel_col'}).append($('<p>', {html: highlight(item.name, word)})).append($('<p>', {html: highlight(item.tel_national_hyphen, word)})))
        .append($('<td>', {class: 'vehicle_col'}).append(number_plates))
        .append($('<td>', {class: 'vehicle_info_col'}).append(bikes_maker_model))
        .append($('<td>', {html: '<i class="fas fa-chevron-right"></i>', class: 'search_result_add add_col'}));
      }));

      $('#c-suggest-customer_list .search_result').show();
      $('#c-suggest-customer_list .search_header').show();
      $('#customerSuggestModal .suggest-customer-list-wrapper').show();
      // $('#c-suggest-customer-registration-btn').hide();
      $('#c-suggest-phone_valid_err_msg').text('');

      $('#c-suggest-customer_list .suggest_record').click(function() {
        let item = JSON.parse($(this).attr('data-value'));
        let last_maintenance_log = item.last_maintenance_log !== null ? JSON.parse(item.last_maintenance_log) : {};

        let customer_info = {
          'id': item.id,
          'tel': item.tel, 
          'tel_national': item.tel_national,
          'tel_national_hyphen': item.tel_national_hyphen,
          'tel_country_code': item.tel_country_code,
          'customer_name': item.name,
          'send_dm': item.send_dm,
          'terms_agreed_at': item.terms_agreed_at,
          'number_plate_area': last_maintenance_log.number_plate_area,
          'number_plate_number': last_maintenance_log.number_plate_number,
          'number_plate_pref': last_maintenance_log.number_plate_pref,
          'expiration_year': last_maintenance_log.expiration_year,
          'expiration_month': last_maintenance_log.expiration_month,
          'maker': last_maintenance_log.maker,
          'model': last_maintenance_log.model,
          'color': last_maintenance_log.color,
          'owned_bikes_count': item.bikes_info.length,
          'send_type':item.send_type,
          'receipt_type':item.receipt_type,
          'wa_tel':item.wa_tel
        }

        reflectCustomerInfo(customer_info);

        showCustomerInfoButtons();
        $('#customer-suggest-modal-close').click();
        $('#completed_customer_suggest').val(true);
      });
    }).fail(function() {
      resetSearchResult();
      // judgmentDisplayResistration();
      unsearching();
    });
  }

  function confirmCustomerInfo() {
    let customer_info = {
      'tel': $('#c-suggest-confirm_tel').val(), 
      'tel_national': $('#c-info-phone_national').val(),
      'tel_national_hyphen': $('#c-suggest-confirm_tel_national_hyphen').val(),
      'tel_country_code': $('#c-info-phone_country_code').val(),
      'customer_name': $('#c-info-customer_name').val(),
      'number_plate_area': $('#c-info-number_plate_area').val(),
      'number_plate_number': $('#c-info-number_plate_number').val(),
      'number_plate_pref': $('#c-info-number_plate_pref').val(),
      'expiration_year': $('#c-info-expiration-year').val(),
      'expiration_month': $('#c-info-expiration-month').val(),
      'maker': $('#c-info-bike-maker').val(),
      'model': $('#c-info-model').val(),
      'color': $('#c-info-bike-color').val()
    }

    reflectCustomerInfo(customer_info);
    showCustomerInfoButtons();
    $('#close-customer-info-modal').click();
  }

  // 顧客情報反映
  function reflectCustomerInfo(info) {
    let blank_str = ''
    let number_plate = `${info.number_plate_area}-${info.number_plate_number}-${info.number_plate_pref}`

    $('#customer_name').val(info.customer_name);
    $('#maintenance_log_maker').val(info.maker);
    $('#maintenance_log_model').val(info.model);
    $('#maintenance_log_color').val(info.color);
    $('#maintenance_log_name').val(info.customer_name);

    if(info.id) {
      $('#customer_id').val(info.id);
    }

    if(info.tel) {
      $('#display-customer-tel').text(info.tel_national_hyphen);
      $('#display-customer-tel').removeClass('-text-blank');

      $('#customer_tel').val(info.tel);
      $('#c-suggest-confirm_tel').val(info.tel);
      $('#c-suggest-confirm_tel_national_hyphen').val(info.tel_national_hyphen);

      $('#c-info-phone_national').val(info.tel_national);
      $('#c-info-phone_country_code').val(info.tel_country_code);

      $('#temp_tel_national').val(info.tel_national);
      $('#temp_tel_country_code').val(info.tel_country_code);
    } else {
      $('#display-customer-tel').text(blank_str);
      $('#display-customer-tel').addClass('-text-blank');

      $('#c-info-phone_national').val('');
      $('#c-info-phone_country_code').val('62');
    }

    if(info.customer_name) {
      $('#display-customer-name').text(info.customer_name);
      $('#display-customer-name').removeClass('-text-blank');
    } else {
      $('#display-customer-name').text(blank_str);
      $('#display-customer-name').addClass('-text-blank');
    }
    $('#c-info-customer_name').val(info.customer_name);

    if(info.number_plate_area && info.number_plate_number && info.number_plate_pref) {
      $('#customer-infoNumberPlate').text(number_plate);
      $('#customer-infoNumberPlate').removeClass('-text-blank');

      $('#maintenance_log_number_plate_area').val(info.number_plate_area);
      $('#maintenance_log_number_plate_number').val(info.number_plate_number);
      $('#maintenance_log_number_plate_pref').val(info.number_plate_pref);

      $('#c-info-number_plate_area').val(info.number_plate_area);
      $('#c-info-number_plate_number').val(info.number_plate_number);
      $('#c-info-number_plate_pref').val(info.number_plate_pref);
    } else {
      $('#customer-infoNumberPlate').text(blank_str);
      $('#customer-infoNumberPlate').addClass('-text-blank');

      $('#maintenance_log_number_plate_area').val('B');
      $('#maintenance_log_number_plate_number').val('');
      $('#maintenance_log_number_plate_pref').val('');

      $('#c-info-number_plate_area').val('B');
      $('#c-info-number_plate_number').val('');
      $('#c-info-number_plate_pref').val('');
    }

    if(info.expiration_year && info.expiration_month) {
      $('#customer-infoExpiration').text(`${info.expiration_month} / ${info.expiration_year}`);
      $('#customer-infoExpiration').removeClass('-text-blank');

      $('#maintenance_log_expiration_month').val(info.expiration_month);
      $('#maintenance_log_expiration_year').val(info.expiration_year);

      setExpiration(info.expiration_month, info.expiration_year);
    } else {
      $('#customer-infoExpiration').text(blank_str);
      $('#customer-infoExpiration').addClass('-text-blank');

      $('#maintenance_log_expiration_month').val('');
      $('#maintenance_log_expiration_year').val('');

      resetExpiration();
    }

    if(info.maker || info.model) {
      var str = `${info.maker}`
      if(info.maker && info.model) {
        str += ` / ${info.model}`
      } else {
        str += `${info.model}`
      }
      $('#customer-infoMakeModel').text(str);
    } else {
      $('#customer-infoMakeModel').text(blank_str);
    }
    $('#c-info-model').val(info.model);

    if(info.maker) {
      setMaker(info.maker);
    } else {
      resetMaker();
    }

    if(info.color) {
      let target = $('#customer-infoColor')
      let artifact = `<span class='artifact ml-1'><span>`
      artifact = $(artifact).css({'background':`var(--bike-${info.color})`})
      target.html(`${info.color.toUpperCase()}&nbsp;`).prepend(artifact)
      
      setColor(info.color)
    } else {
      $('#customer-infoColor').html(blank_str);

      resetColor();
    }

    if (info.color || info.maker || info.model) {
      $('#customer-infoMakeModelColor').removeClass('-text-blank');
    } else {
      $('#customer-infoMakeModelColor').addClass('-text-blank');
    }

    if(info.send_dm) {
      $('#customer_send_dm').val(info.send_dm);
    }

    if(info.terms_agreed_at) {
      $('#customer_terms_agreed_at').val(info.terms_agreed_at);
    }
  
    if(info.receipt_type) {
      $('#customer_receipt_type').val(info.receipt_type);
    }

    if(info.send_type) {
      $('#customer_send_type').val(info.send_type);
    }

    if(info.wa_tel) {
      $('#customer_wa_tel').val(info.wa_tel);
    }
  
    if ($('#customer_id').val()) {
      $('#select-bike-button').show();

      if(info.owned_bikes_count >= 2) {
        $('#select-bike-icon').addClass('count-badge');
        $('#select-bike-icon').attr('data-badge', info.owned_bikes_count); 
      }
    } else {
      $('#select-bike-button').hide();
    }

    $('#c-info-phone_valid_err_msg').text('');
  }

  function setExpiration(month, year) {
    let target = $('#c-info-expiration-select');
    target.html(`<span>${month} / ${year}&ensp;<i class="icon icon-Arrow-down"></i></span>`);
    $('#c-info-expiration-year').val(year);
    $('#c-info-expiration-month').val(month);
    $('#c-info-clear-expiration').show();
    $('#c-info-expiration-select').show();
    $('#c-info-expiration-blank').hide();
  }

  function resetExpiration() {
    $('#c-info-expiration-year').val('');
    $('#c-info-expiration-month').val('');
    $('#c-info-clear-expiration').hide();
    $('#c-info-expiration-select').hide();
    $('#c-info-expiration-blank').show();
  }

  function setMaker(maker) {
    let target = $("#c-info-maker-select");
    target.html(`<span>${maker}&ensp;<i class="icon icon-Arrow-down"></i></span>`);
    $('#c-info-bike-maker').val(maker);
    $('#c-info-clear-maker').show();
    $("#c-info-maker-select").show();
    $("#c-info-maker-blank").hide();
  }

  function resetMaker() {
    $('#c-info-bike-maker').val('');
    $('#c-info-clear-maker').hide();
    $("#c-info-maker-select").hide();
    $("#c-info-maker-blank").show();
  }

  function setColor(color) {
    let target = $("#c-info-color-select");
    let cache = target.find("i");
    let artifact = `<span class='artifact'><span>`
    artifact = $(artifact).css({'background':`var(--bike-${color})`})
    target.html(`${color}&nbsp;`).prepend(artifact).append(cache);
    $('#c-info-bike-color').val(color);
    $('#c-info-clear-color').show();
    $("#c-info-color-select").show();
    $("#c-info-color-blank").hide();
  }

  function resetColor() {
    $('#c-info-bike-color').val('');
    $('#c-info-clear-color').hide();
    $("#c-info-color-select").hide();
    $("#c-info-color-blank").show();
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
    $('#c-suggest-customer_list .search_result').hide();
    $('#c-suggest-customer_list .search_header').hide();
    $('#customerSuggestModal .suggest-customer-list-wrapper').hide();
    $('#c-suggest-customer_list .search_result').html('');
  }

  function showSmsConfirm() {
    $('#c-suggest-sms-confirm-block').show();
    $('#c-suggest-customer-regist-block').hide();
  }

  function showCustomerInfoButtons() {
    $('#refrect_customer_info').val(true);
    $('#customer-info-buttons').show();
    $('#add-customer-button').hide();
  }

  function isMobileDevice() {
    return (
      typeof window.orientation !== "undefined" ||
      navigator.userAgent.indexOf("IEMobile") !== -1
    );
  }

  function highlight(str, search_word) {
    if (str == null) return str;
    var word_re = new RegExp('(' + search_word.split(' ').join('|') + ')', 'gi');
    return str.replace(word_re, '<span class="highlight">$&</span>');
  }

  function addEvents() {
    addCustomerSuggestModalEvent();
    addCustomerInfoModalEvent();
    addYearPickerEvent();
    addBikePickerEvent();
    addColorPickerEvent();
    addCalendarEvent();
    addTotalNumberPickerEvent();
    addManualNumberPickerEvent();
    addPriceNumberPickerEvent();
    addDiscountNumberPickerEvent();
    addQuantityNumberPickerEvent();
    addSelectItemMechanicEvent();
    addHandleItemQuantityEvent();
    addHandleItemAddedEvent();
    addHandleItemNoteEvent();
    addCalculatorModalEvent();
    addOrderPreviewModalEvent();
    addChargeModalEvent();
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
    addHandleItemNoteEvent();
  });
}.call(this));
  