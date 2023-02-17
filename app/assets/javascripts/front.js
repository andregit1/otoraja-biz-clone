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
//= require popper
//= require jquery/dist/jquery.min
//= require bootstrap/dist/js/bootstrap.min
//= require jquery-ui-dist/jquery-ui.min
//= require vendors/jquery.ui.touch-punch.min
//= require moment/min/moment.min
//= require cocoon
//= require jquery_ujs
//= require raty-js
//= require data-confirm-modal
//= require serviceworker-companion
//= require on_page_load_front
//= require gasparesganga-jquery-loading-overlay/dist/loadingoverlay.min
//= require bootstrap4-toggle/js/bootstrap4-toggle.min
//= require bootbox/dist/bootbox.min
//= require front/util
//= require_tree ./front

$(document).ready(function() {
  $('[data-toggle="tooltip"]').tooltip({ boundary: 'window' });

  $(document).on('click', '.select-staff-form-group label', function () {
    location = '/maintenance_log/new?current_staff_id=' + $(this).find('input')[0].value;
  });
  if ($('#current_staff_id').val() == undefined || $('#current_staff_id').val() == "") {
    $('#select-staff').modal('show');
  }

  $('#btn-menu').on('click', function () {
    $wrapper = $('.wrapper');
    if($wrapper.hasClass('menu-open')){
      $wrapper.removeClass('menu-open');
    } else {
      $wrapper.addClass('menu-open');
    }
  });

  $('#side-bar').on('click', function(event){
      if($(event.target).attr("id")!="side-bar")
        return;
      $('.wrapper').removeClass('menu-open');
  })

  $(document).on('click','.menu-open #main',function(){
    $('.wrapper').removeClass('menu-open');
  });

  $('#release_note_open').on('click', function(event){
    $('.wrapper').removeClass('menu-open');
  });

  $('#customize_shop_product_list_open').on('click', function(event){
    $('.wrapper').removeClass('menu-open');
  });

  dataConfirmModal.setDefaults({
    focus: 'cancel',
    zIndex: 2050,
    modalClass: 'confirm-modal'
  });
});
