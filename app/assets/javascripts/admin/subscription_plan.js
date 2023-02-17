var subscriptionPlan = function() {
};
(function(subscriptionPlan) {
  'use strict';

  var is_change_plan = false;
  var is_continue_payment = false;

  function coreAjax(method, url, data, callback, timeout = 30000) {
    return $.ajax({
      url: url,
      type: method,
      data: data,
      dataType: 'json',
      async: true,
      timeout: timeout
    }).fail(function (xhr, status) {
      callback(xhr)
      console.error(status);
    }).done(function (data, textStatus, xhr) {
      callback(xhr, data);
    });
  }

  subscriptionPlan.preCheckSubscriptionStatus =  function () {
    is_change_plan = $('#is_change_plan').val();
  is_continue_payment = $('#continue_payment').val();

    if(is_change_plan == 'true' || is_continue_payment == 'true' ){
      $('.payment_method').attr('disabled', false);
      subscriptionPlan.buttonSubmitToggle(true);
    }else{
      subscriptionPlan.inProcessingSubscriptionCheck(function (xhr, data) {
        if(data.in_processing) {
          $('#processingSubsModal').modal('show');
        }else{
          $('.payment_method').attr('disabled', false);
          subscriptionPlan.buttonSubmitToggle(true);
        }
      });
    }
  }

  subscriptionPlan.inProcessingSubscriptionCheck =  function (callback) {
    let params = $('#form-request-subs').serialize();
    let url = 'status_subscription_check';
    let method = 'POST';

    coreAjax(method, url, params, callback);
  }

  subscriptionPlan.paymentMethodCheck = function (id, callback) {
    let payment_type_id = id;
    let params = {payment_type_id: payment_type_id};
    let url = 'payment_method_check'
    let method = 'GET';

    coreAjax(method, url, params, callback);
  }

  subscriptionPlan.sendRequestSubscription = function () {
    let params = $('#form-request-subs').serialize();
    let url = $('#form-request-subs').attr('action');
    let method = 'POST';

    coreAjax(method, url, params,
      function(xhr, data){
        if(xhr.status == 200){
          let redirect_link = typeof data == "undefined" ? '/admin/subscriptions' : data.redirect_link;
          window.location.replace(redirect_link);
        }else{
          subscriptionPlan.loadingViewToggle(false);
          subscriptionPlan.buttonSubmitToggle(true);
        }
      }
    );
  }

  subscriptionPlan.loadingViewToggle = function (status) {
    if(status){
      $('#retry-request-content').addClass('hide');
      $('#request-content').removeClass('hide');
    }else{
      $('#retry-request-content').removeClass('hide');
      $('#request-content').addClass('hide');
    }
  }

  subscriptionPlan.buttonPaymenGatewayToggle = function (status) {
    if(status){
      $('#alert-payment-method').removeClass('show').addClass('hide');
      $('#btn-buy').prop('disabled',false);
    }else{
      $('#alert-payment-method').removeClass('hide').addClass('show');
      $('#btn-buy').prop('disabled',true);
    }
  }

  subscriptionPlan.buttonSubmitToggle = function (status) {
    if(status){
      $('.request_subs').removeClass('hide');
      $('#btn-loading').addClass('hide');
    }else{
      $('.request_subs').addClass('hide');
      $('#btn-loading').removeClass('hide');
    }
  }

  subscriptionPlan.showSubscriptionProcessedModal = function () {
    $('#requestSubsModal').modal('hide');
    $('#processingSubsModal').modal('show');
  }

  onPageLoad("subscription_plan", function() {
    if ($("button").hasClass("request_subs")) subscriptionPlan.preCheckSubscriptionStatus();

    $('.payment_method').on('click', function () {
      let payment_method_id = $(this).data('id');
      
      $('#btn-buy').prop('disabled',true);
      $('#btn-buy').html('<i class="fas fa-spinner fa-spin"></i>');
      
      subscriptionPlan.paymentMethodCheck(payment_method_id, function (xhr, data) {
        if (data.payment_gateway['is_active'] && data.payment_method_smc['is_active']) {          
          let is_payment_method_active = data.payment_method_service['code'] == '200' && data.payment_method_service['data']['is_active'];
          subscriptionPlan.buttonPaymenGatewayToggle(is_payment_method_active);
          $('#btn-buy').html('Bayar');
        }else{
          location.reload();
        }
      });
    });
      
    $('.request_subs').on('click', function () {
      subscriptionPlan.loadingViewToggle(true);
      subscriptionPlan.sendRequestSubscription();
    });

    $('#retry-request-subs').on('click', function () {
      subscriptionPlan.loadingViewToggle(true);
      if(is_change_plan == 'true' || is_continue_payment == 'true' ){
        subscriptionPlan.sendRequestSubscription();
      }else{
        subscriptionPlan.inProcessingSubscriptionCheck(function (xhr, data) {
          if(xhr.status == 200){
            data.in_processing ? subscriptionPlan.showSubscriptionProcessedModal() : subscriptionPlan.sendRequestSubscription();
          }else{
            subscriptionPlan.loadingViewToggle(false);
          }
        });
      }
    });

  });

})(subscriptionPlan || (subscriptionPlan = {}));
