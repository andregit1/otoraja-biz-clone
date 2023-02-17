// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require on_page_load_admin
//= require popper
//= require jquery/dist/jquery.min
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/position
//= require jquery-ui/widgets/autocomplete
//= require jquery-validation/dist/jquery.validate.min
//= require bootstrap/dist/js/bootstrap.min
//= require admin-lte/dist/js/adminlte
//= require bs-custom-file-input/dist/bs-custom-file-input.min
//= require icheck
//= require bootstrap4-toggle/js/bootstrap4-toggle.min
//= require chart.js/dist/Chart.min
//= require daterangepicker/moment.min
//= require daterangepicker/daterangepicker
//= require cocoon
//= require jquery_ujs
//= require raty-js
//= require select2/dist/js/select2.full.min
//= require data-confirm-modal
//= require chartjs-plugin-labels
//= require chartjs-plugin-annotation
//= require handsontable/dist/handsontable.full.min
//= require numbro/dist/languages/de-DE.min
//= require gasparesganga-jquery-loading-overlay/dist/loadingoverlay.min
//= require serviceworker-companion
//= require bootbox/dist/bootbox.min
//= require setup_overlay
//= require ./front/modal
//= require_tree ./admin

// Add regular expression check method for jQuery validation
$.validator.addMethod('pattern', function(value, element, regexp) {
  var re = new RegExp(regexp);
  return this.optional(element) || re.test(value);
}, 'Gunakan karakter umum saja.');

function validateRegisterForm() {
  var isValid = $('#register-form').valid();
  var $button = $("#confirm-registration-button");
  var captcha_checked = grecaptcha.getResponse().length != 0
  $("#new_contract_request_email").removeClass("border-danger");
  $(".email-invalid").remove();

  if (isValid && captcha_checked) {
    $button.removeClass("button-inactive");
    $button.addClass("button-active");
    $button.attr("disabled", false);
  } else {
    $button.addClass("button-inactive");
    $button.removeClass("button-active");
    $button.attr("disabled", true);
  }
};

function captchaResponse() {
  validateRegisterForm();
};

$(document).ready(function(){
  $("body").Layout("_init");
  $('[data-toggle="tooltip"]').tooltip({ boundary: 'window' });

  // 統計カラム用ソートリンク
  $('.table-sort-link').on('click',function(){
    $('#sort').val($(this).data('colmun') + ' ' + $(this).data('order'));
    $('.search-form').submit();
  });

  resize_content();
  var timer = false;
  $(window).resize(function(){
    if (timer !== false) {
      clearTimeout(timer);
    }
    timer = setTimeout(function() {
      resize_content();
    }, 200);
    
  });

  function resize_content(){
    var window_h = $(window).height();
    var footer_h = $('.main-footer').outerHeight();
    var $datatable = $('.content-datatable'); 
    if($datatable[0]){
      var content_h = $datatable.offset().top;
      var after_content_h = window_h - footer_h - content_h - 15;
      if(after_content_h > 0){
        $datatable.height(after_content_h);
      }
    }
  }

  bsCustomFileInput.init();
  $('.shop_select').select2({width: '100%'});
  $('.use_select2').select2({containerCssClass: "text-normal", dropdownCssClass: "text-normal"});
  
  $('.single-date-picker').daterangepicker({
    "singleDatePicker": true,
    "autoApply": true,
    "drops": "up",
    "minDate": moment(),
    locale: {
      format: 'DD-MM-YYYY'
    }
  });

  $('#select_current_shop').change(function () {
    $.ajax({
      type: "POST",
      url: "/admin/shops/default_session_shop",
      data: { shop_id : this.value}
    })
    .fail(function (xhr, status, error) {
      alert("Gagal mengubah bengkel");
    })
    .done(function (data) {
      location.reload();
    })
  })

  $.validator.addMethod( "pickProduct", function() {
    return $("#new_contract_request_is_otoraja_biz").is(":checked") || $("#new_contract_request_is_otoraja_bp").is(":checked")
  }, "" );

  var validateOption = {
    rules: {
      "new_contract_request[name]": "required",
      "new_contract_request[email]": {
        required: true,
        pattern: /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/,
        email: false
      },
      "new_contract_request[tel]": {
        required: true,
        number: true
      },
      "new_contract_request[shop_name]": "required",
      "new_contract_request[regency_id]": "required",
      "new_contract_request[distric_id]": "required",
      "new_contract_request[is_otoraja_biz]": "pickProduct",
      "new_contract_request[is_otoraja_bp]": "pickProduct",
      "terms": "required",
      "privacy": "required"
    },
    messages: {
      "new_contract_request[name]": {
        required: ''
      },
      "new_contract_request[email]": {
        required: '',
        pattern: 'Format penulisan email salah'
      },
      "new_contract_request[tel]": {
        required: '',
        number: ''
      },
      "new_contract_request[shop_name]": {
        required: ''
      },
      "terms": {
        required: ''
      },
      "privacy": {
        required: ''
      },
      "new_contract_request[regency_id]": {
        required: ''
      },

      "new_contract_request[distric_id]": {
        required: ''
      }
    },
    success: function(element) {
      $(element).parent().removeClass("invalid-field");
      $(element).remove();
    },
    highlight: function(element, errorClass) {
      $(element).addClass(errorClass);
      $(element).parent().addClass("invalid-field");
      $(element).parent().find(".select2-selection--single").addClass("invalid-field");
    },
    errorPlacement: function (error, element) {
      error.addClass('text-small');
      element.after(error);
    }
  }

  $('#register-form').validate(validateOption);

  $("#register-form input").on("keyup change", function(){
    validateRegisterForm();
  });

  $("#confirm-terms").on("click", function() {
    $("#termsModal").modal("hide");
    $("#terms-checkbox").trigger("click");
  });

  $("#confirm-privacy").on("click", function() {
    $("#privacyModal").modal("hide");
    $("#privacy-checkbox").trigger("click");
  });

  $('#new_contract_request_regency_id').select2({placeholder: $("#new_contract_request_regency_id").attr("placeholder")}).siblings('.select2-container').find('.select2-selection__placeholder, .select2-selection__rendered, li.select2-results__option').css('font-size', '20px');
  $('#new_contract_request_distric_id').select2({placeholder: $("#new_contract_request_distric_id").attr("placeholder")}).siblings('.select2-container').find('.select2-selection__placeholder, .select2-selection__rendered, li.select2-results__option').css('font-size', '20px');

  $('#new_contract_request_regency_id').on('change', function (e) {
    $(".select2-selection--single").removeClass("invalid-field");
  });

  $("#new_contract_request_regency_id").on("change", function(){
    $.ajax({
      url: "/administrative_areas/districs",
      type: "GET",
      dataType: 'json',
      data: {regency_id: $(this).val()},
    }).fail(function (xhr, status, error) {
      console.error(error);
    }).done(function (data) {
      $("#new_contract_request_distric_id").html('').select2({data: data}).siblings('.select2-container').find('.select2-selection__placeholder, .select2-selection__rendered, li.select2-results__option').css('font-size', '20px');  
    });
  })
});
