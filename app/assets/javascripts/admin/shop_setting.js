var shopSetting = function() {
};

(function() {
  'use strict';
  let time = [];
  let provinces = '';
  let regencies = '';
  let previous_province_select = '';
  let previous_regency_select = '';

  var validateOption = {
    messages: {
      'shop[name]' : 'Tidak boleh kosong',
      'shop[tel]' : 'Tidak boleh kosong',
      'shop[tel3]' : 'Tidak boleh kosong', 
      'shop[address]' : 'Tidak boleh kosong',
      'shop[region_id]' : 'Tidak boleh kosong',
      'shop[province_id]' : 'Tidak boleh kosong',
      'shop[regency_id]' : 'Tidak boleh kosong',
    },
    highlight: function(element, errorClass) {
      $(element).removeClass(errorClass);
    },
    errorPlacement: function (err, element) {
      err.addClass('text-small');
      element.after(err);
    }
  }

  shopSetting.generateTime = function () {
    let index = 0;
    for (let hours = 0; hours <= 23; hours++) {
      let hours_formated = hours.toLocaleString('en-US', { minimumIntegerDigits: 2 });
      for (let minutes = 0; minutes < 60; minutes += 30) {
        let minutes_formated = minutes.toLocaleString('en-US', { minimumIntegerDigits: 2 });
        time[index] = new Array();
        time[index].push([hours_formated,minutes_formated])
        index++;
      }
    }
  }

  shopSetting.generateSelectTime = function () {
    shopSetting.generateTime();

    let open_hour = parseInt($('.open-time-hour').val()).toLocaleString('en-US', { minimumIntegerDigits: 2 });
    let open_minute = parseInt($('.open-time-minute').val()).toLocaleString('en-US', { minimumIntegerDigits: 2 });
    let close_hour = parseInt($('.close-time-hour').val()).toLocaleString('en-US', { minimumIntegerDigits: 2 });
    let close_minute = parseInt($('.close-time-minute').val()).toLocaleString('en-US', { minimumIntegerDigits: 2 });

    time.forEach(function (item, index) {
      if(item[0][0] == open_hour && item[0][1] == open_minute ){
        $('#open-time').append(
          `<option value="${index}" selected>
            ${item[0][0] +' : '+item[0][1]}
          </option>`
        );
      }
      else{
        $('#open-time').append(
          `<option value="${index}">
            ${item[0][0] +' : '+item[0][1]}
          </option>`
        );
      }


      if(item[0][0] == close_hour && item[0][1] == close_minute ){
        $('#close-time').append(
          `<option value="${index}" selected>
            ${item[0][0] +' : '+item[0][1]}
          </option>`
        );
      }
      else{
        $('#close-time').append(
          `<option value="${index}">
            ${item[0][0] +' : '+item[0][1]}
          </option>`
        );
      }
    });
  }

  shopSetting.provinceHandler = function () {
    let provinces_tmp = provinces
    let region_selected = $('#shop_region_id :selected').text();
    let options = $(provinces_tmp).filter(`optgroup[label='${region_selected}']`).html();
    $('#shop_regency_id').empty();
    if(options){
      $('#shop_province_id').html(options).val('');
    }else{
      $('#shop_province_id').empty();
    }
  }

  shopSetting.regencyHandler = function () {
    let regencies_tmp = regencies
    let province_selected = $('#shop_province_id :selected').text();
    let options = $(regencies_tmp).filter(`optgroup[label='${province_selected}']`).html();
    if(options){
      $('#shop_regency_id').html(options).val('');
    }else{
      $('#shop_regency_id').empty();``
    }
  }

  onPageLoad("shop_setting", function() {
    $('#form-branch').validate(validateOption);
    $('.select2').select2();
    
    previous_province_select = $('#shop_province_id :selected').val();
    previous_regency_select = $('#shop_regency_id :selected').val();

    $('#shop_province_id :selected').removeAttr('data-select2-id').removeAttr('selected')
    $('#shop_regency_id :selected').removeAttr('data-select2-id').removeAttr('selected')

    provinces = $('#shop_province_id').html();
    regencies = $('#shop_regency_id').html();

    shopSetting.provinceHandler();
    if(previous_province_select){
      $("#shop_province_id").val(previous_province_select);
      $('#shop_province_id').attr('disabled', false);
    }else{
      $('#shop_province_id').attr('disabled', true);
    }
    
    shopSetting.regencyHandler();
    if(previous_regency_select){
      $("#shop_regency_id").val(previous_regency_select);
      $('#shop_regency_id').attr('disabled', false);
    }else{
      $('#shop_regency_id').attr('disabled', true);
    }

    $('.btn-up').on('click', function () {
      let current_position = $('.tag_list').find('.tag-name').index($(this).parents('.tag-content').find('.tag-name'));
      let current_tag_name = $('.tag_list').find('.tag-name').eq(current_position);
      let previous_tag_name = $('.tag_list').find('.tag-name').eq(current_position-1);
      let temp = null;

      if(previous_tag_name.val() && current_position != 0){
        temp = current_tag_name.val();
        current_tag_name.val(previous_tag_name.val());
        previous_tag_name.val(temp);
      }
    });

    $('.btn-down').on('click', function () {
      let current_position = $('.tag_list').find('.tag-name').index($(this).parents('.tag-content').find('.tag-name'));
      let current_tag_name = $('.tag_list').find('.tag-name').eq(current_position);
      let next_tag_name = $('.tag_list').find('.tag-name').eq(current_position+1);
      let temp = null;

      if(next_tag_name.val()){
        temp = current_tag_name.val();
        current_tag_name.val(next_tag_name.val());
        next_tag_name.val(temp);
      }
    });

    $('#open-time').on('change',function () {
      let index_time = $(this).find('option').filter(':selected').val();
      let hour = time[index_time][0][0];
      let minute = time[index_time][0][1];

      $('.open-time-hour').val(hour);
      $('.open-time-minute').val(minute);
    });

    $('#close-time').on('change',function () {
      let index_time = $(this).find('option').filter(':selected').val();
      let hour = time[index_time][0][0];
      let minute = time[index_time][0][1];
      
      $('.close-time-hour').val(hour);
      $('.close-time-minute').val(minute);
    });

    $('.show_password').on('mousedown touchstart',function () {
      $(this).closest('.form-group').find('.form-control').attr('type','text');
    }).bind('mouseup mouseleave touchend',function () {
      $(this).closest('.form-group').find('.form-control').attr('type','password');
    })

    $('#shop_region_id').on('change', function () {
      $('#shop_province_id').attr('disabled', false);
      $('#shop_regency_id').attr('disabled', true);
      shopSetting.provinceHandler();
    });
    
    $('#shop_province_id').on('change', function () {
      $('#shop_regency_id').attr('disabled', false);
      shopSetting.regencyHandler();
    });

    shopSetting.generateSelectTime();
  });
}.call(this));
