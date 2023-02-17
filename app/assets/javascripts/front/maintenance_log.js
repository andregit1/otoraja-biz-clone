(function () {

  'use strict';
  
  var maintenanceLog = maintenanceLog || {};
  var blank_str = '';
  var loaded_new = false;
  var loaded_edit = false;

  maintenanceLog.submit = function() {
    maintenanceLog.showLoading();
    $('#maintenance-log-form').submit();
  }

  maintenanceLog.showLoading = function() {
    $('.wrapper').LoadingOverlay('show', {size: 20});
  }

  maintenanceLog.hideLoading = function (){
    $('.wrapper').LoadingOverlay('hide');
  }

  maintenanceLog.save = function() {
    $('#is_form_save').val('true');
    maintenanceLog.submit();
  }

  maintenanceLog.getOwnedBikes = function() {
    maintenanceLog.showLoading();
    $("#table-select-bike-body").empty();
    var customer_id = $("#customer_id").val();
    if (customer_id == '') {
      maintenanceLog.hideLoading();
      return;
    }

    $.ajax({
      url: `/api/customers/${customer_id}/owned_bikes.json`,
      method: 'GET',
      dataType: "json",
    }).done(function (data) {
      var record_template = $("#table-select-bike-body-template tr:first");
      $.each(data, function(index, value) {
        var record = record_template.clone();
        var id = value.id;
        var formated_number_plate = '';
        if (value.number_plate_area !== '' || value.number_plate_number !== '' || value.number_plate_pref !== '') {
          formated_number_plate = `${value.number_plate_area}-${value.number_plate_number}-${value.number_plate_pref}`;
        }
        var formated_expiration = '';
        if (value.expiration_month !== '' && value.expiration_year !== '') {
          formated_expiration = `${value.expiration_month} / ${value.expiration_year}`;
        }
        var maker = `${value.maker || ''}`;
        var model = `${value.model || ''}`;
        var color = `${value.color || ''}`;
        record.attr('data-number_plate_area', value.number_plate_area);
        record.attr('data-number_plate_number', value.number_plate_number);
        record.attr('data-number_plate_pref', value.number_plate_pref);
        record.attr('data-expiration_month', value.expiration_month);
        record.attr('data-expiration_year', value.expiration_year);
        record.attr('data-maker', value.maker);
        record.attr('data-model', value.model);
        record.attr('data-color', value.color);

        record.find('.radio-circle input[type="radio"]').attr('id', `select_bike_${id}`).attr('name', 'select_bike').val(id);
        if (
          value.number_plate_area == $('#maintenance_log_number_plate_area').val() &&
          value.number_plate_number == $('#maintenance_log_number_plate_number').val() &&
          value.number_plate_pref == $('#maintenance_log_number_plate_pref').val()
        ) {
          record.find('.radio-circle input[type="radio"]').attr('checked', true);
          $('#selected-bike-target-id').val(`select_bike_${id}`);
        }
        record.find('.radio-circle label').attr('for', `select_bike_${id}`);
        record.find('.bike-plate').html(formated_number_plate);
        record.find('.bike-expiration').html(formated_expiration);
        record.find('.bike-maker').html(maker);
        record.find('.bike-model').html(model);
        record.find('.bike-color').html(color);
        $("#table-select-bike-body").append(record);
      });

      // style adjust
      $("#table-select-bike-body .bike-color").each(function(index, item){
        if($(item).text()) {
          var artifact = `<span class='artifact'><span>`;
          artifact = $(artifact).css({'background':`var(--bike-${$(item).text()})`});
          $(item).prepend(artifact);
        }
      });

      $(document).off('click', '#bikeSelectModal .radio-circle');

      $(document).delegate("#bikeSelectModal .radio-circle","click", function(event){
        let target_id = $(event.target)[0].id;
        $('#selected-bike-target-id').val(target_id);
      });
    }).fail(function() {
    }).always(function() {
      maintenanceLog.hideLoading();
    });
  }

  maintenanceLog.setOwnedBikes = function() {
    let target_id = $('#selected-bike-target-id').val();
    let target = $(`#${target_id}`).parents("tr");

    // hidden value update
    $('#maintenance_log_number_plate_area').val(target.attr('data-number_plate_area'));
    $('#maintenance_log_number_plate_number').val(target.attr('data-number_plate_number'));
    $('#maintenance_log_number_plate_pref').val(target.attr('data-number_plate_pref'));
    $('#maintenance_log_expiration_month').val(target.attr('data-expiration_month'));
    $('#maintenance_log_expiration_year').val(target.attr('data-expiration_year'));
    $('#maintenance_log_maker').val(target.attr('data-maker'));
    $('#maintenance_log_model').val(target.attr('data-model'));
    $('#maintenance_log_color').val(target.attr('data-color'));
    // display info
    var number_plate = target.find(".bike-plate").text();
    var expiration = target.find(".bike-expiration").text();
    var maker_model = "";
    let maker = target.find(".bike-maker").text();
    let model = target.find(".bike-model").text();
    if (maker !== '' || model !== '') {
      maker_model = `${maker}${maker && model ? ' / ' : ''}${model}`;
    }
    var color = target.find(".bike-color").text();
    if (number_plate) {
      $("#customer-infoNumberPlate").text(number_plate);
      $('#customer-infoNumberPlate').removeClass('-text-blank');
    } else {
      $('#customer-infoNumberPlate').html(blank_str);
      $('#customer-infoNumberPlate').addClass('-text-blank');
    }
    if (expiration) {
      $("#customer-infoExpiration").text(expiration);
      $('#customer-infoExpiration').removeClass('-text-blank');
    } else {
      $("#customer-infoExpiration").text(expiration);
      $('#customer-infoExpiration').addClass('-text-blank');
    }
    if (maker_model) {
      $("#customer-infoMakeModel").text(maker_model);
    } else {
      $("#customer-infoMakeModel").text(maker_model);
    }

    if (color) {
      let target = $('#customer-infoColor')
      let artifact = `<span class='artifact ml-1'><span>`
      artifact = $(artifact).css({'background':`var(--bike-${color})`})
      target.html(`${color.toUpperCase()}&nbsp;`).prepend(artifact)
    } else {
      $('#customer-infoColor').html(blank_str);
    }

    if (maker || model || color) {
      $('#customer-infoMakeModelColor').removeClass('-text-blank');
    } else {
      $('#customer-infoMakeModelColor').addClass('-text-blank');
    }
  }

  maintenanceLog.setSelectMainMechanicStyle = function() {
    $("#selectMainMechanicModal .badge").pill({
      onClick : function(value, index){
        let staff_id = $("#selectMainMechanicModal .badge").eq(index - 1).attr('data-shop-staff-id');

        $('#selected-main-mechanic-name').val(value);
        $('#selected-main-mechanic-id').val(staff_id);
        $('#confirm-main-mechanic').prop('disabled', false);
      }
    });

    $('#confirm-main-mechanic').on('click',function(){
      let target = $("#selectMainMechanic");
      let cache = target.children();
      let main_mechanic_name = $('#selected-main-mechanic-name').val();
      let main_mechanic_id = $('#selected-main-mechanic-id').val();

      target.text(`${main_mechanic_name}`).append(cache);
      $('#maintenance_log_maintained_staff_id').val(main_mechanic_id);
      $(document).trigger("selected_main_mechanic", main_mechanic_id);
    });
  }
  maintenanceLog.clickSelectMainMechanic = function() {
    $("#selectMainMechanicModal .badge").removeClass('-selected');
    var main_mechanic_id = $('#maintenance_log_maintained_staff_id').val();
    var main_mechanic_name = $("#selectMainMechanic").text();
 
    if(main_mechanic_id) {
      $(`#main_mechanic_${main_mechanic_id}`).addClass('-selected');
      $('#confirm-main-mechanic').prop('disabled', false);
    } else {
      $('#confirm-main-mechanic').prop('disabled', true);
    }

    $('#selected-main-mechanic-id').val(main_mechanic_id);
    $('#selected-main-mechanic-name').val(main_mechanic_name);
  }

  maintenanceLog.init = function() {
    maintenanceLog.setSelectMainMechanicStyle();
    $('#selectMainMechanic').on('click', maintenanceLog.clickSelectMainMechanic);
    $('#saveForm').on('click', maintenanceLog.save);
    $('#select-bike-button').on('click', maintenanceLog.getOwnedBikes);
    $('#add_new_bike').on('click', function(event) {
      // hidden value update
      $('#maintenance_log_number_plate_area').val('');
      $('#maintenance_log_number_plate_number').val('');
      $('#maintenance_log_number_plate_pref').val('');
      $('#maintenance_log_expiration_month').val('');
      $('#maintenance_log_expiration_year').val('');
      $('#maintenance_log_maker').val('');
      $('#maintenance_log_model').val('');
      $('#maintenance_log_color').val('');
      // display info
      $('input[name="select_bike"]').prop('checked', false);
      $("#customer-infoNumberPlate").text(blank_str);
      $('#customer-infoNumberPlate').addClass('-text-blank');
      $("#customer-infoExpiration").text(blank_str);
      $('#customer-infoExpiration').addClass('-text-blank');
      $("#customer-infoMakeModel").text(blank_str);
      $('#customer-infoColor').html(blank_str);
      $('#customer-infoMakeModelColor').addClass('-text-blank');
      // bike select modal close
      $('#bikeSelectModal').hide();
      // customer info input modal open
      $('#open-customer-info-modal').click();
    });

    $('#confirm-bike-button').on('click', maintenanceLog.setOwnedBikes);
  }

  onPageLoad([
    "maintenance_log#new",
    "maintenance_log#create",
    "maintenance_log#edit",
    "maintenance_log#update"
  ], function () {
    maintenanceLog.init();
  });

}.call(this));
