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
//= require on_page_load_console
//= require popper
//= require jquery/dist/jquery.min
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/position
//= require jquery-ui/widgets/autocomplete
//= require bootstrap/dist/js/bootstrap.min
//= require jquery-validation/dist/jquery.validate.min
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
//= require ./front/modal
//= require_tree ./admin
//= stub ./admin/notification
//= require_tree ./console

$.validator.addMethod('pattern', function(value, element, regexp) {
  var re = new RegExp(regexp);
  return this.optional(element) || re.test(value);
}, 'Gunakan karakter umum saja.');

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
  
  $('.single-date-picker').daterangepicker({
    "singleDatePicker": true,
    "autoApply": true,
    "drops": "up",
    "minDate": moment(),
    locale: {
      format: 'DD-MM-YYYY'
    }
  });

  $('.single-date-picker-no-minDate').daterangepicker({
    "singleDatePicker": true,
    "autoApply": true,
    "drops": "down",
    locale: {
      format: 'DD-MM-YYYY'
    }
  });

  $('.use_select2').select2({width: '100%'});
  $('.use_select2_no_search').select2({width: '100%', minimumResultsForSearch: -1});
});
