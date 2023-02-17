(function () {
  var customer = customer || {};
  var suggest_load_count = 0;
  customer.changeRegistrationMonth = function() {
    var select_month = $('.select-month label input:checked').val();
    if(select_month <= moment().month()){
      $('.select-year label').eq(0).addClass('disabled').find('input').prop('disabled', true);
    } else {
      $('.select-year label').removeClass('disabled').find('input').prop('disabled', false);
    }
  }
  customer.changeCheckedout = function() {
    disable = !$('#checkedout').prop('checked');
    if (disable) {
      $('#checkedout_day_disp').addClass('text-muted');
      $('#checkedout_day_btn').addClass('disabled');
    } else {
      $('#checkedout_day_disp').removeClass('text-muted');
      $('#checkedout_day_btn').removeClass('disabled');
    }
    $('#checkedout_day_btn').prop('disabled', disable);
    $('#checkedout_hour').prop('disabled', disable);
    $('#checkedout_min').prop('disabled', disable);
  }

  customer.suggest = function(e) {
    var word = $('#search_word').val();
    if (word.length < 3) {
      customer.resetSearchResult();
      $('#customer_list .checkin').removeClass('hide');
      return;
    }
    suggest_load_count++;
    customer.searching();
    $.ajax({
      url: "/api/customers/suggest.json",
      dataType: "json",
      data: {
        search_word: word
      },
      success: function(data) {
        customer.resetSearchResult();
        if (data.length == 0) {
          $('#customer_list .checkin').removeClass('hide');
          $('#no_hit').removeClass('hide');
          suggest_load_count--;
          customer.unsearching();
          return;
        }
        $('#customer_list .search_result').html($.map(data, function(item) {
          var number_plate = $.map(item.number_plate, function(num) {
            return $('<p>', {class: 'h6 mb-0', html: customer.highlight(num, word)});
          });
          return $('<tr>', {class: 'suggest_record', 'data-value': item.id})
          .append($('<td>', {class: 'h6', html: customer.highlight(item.name, word)}))
          .append($('<td>', {class: 'h6', html: customer.highlight(item.tel, word)}))
          .append($('<td>').append(number_plate))
          .append($('<td>', {class: 'h6', html: item.last_checkin_datetime}));
        }));
        $('#customer_list .search_result').removeClass('hide');
        $('#customer_list .search_header').removeClass('hide');
        $('.suggest_record').click(function() {
          var id = $(this).attr('data-value');
          $('#customer_id').val(id);
          $('#suggest_checkin_btn').click();
        });
        suggest_load_count--;
        customer.unsearching();
      }
    });
  }

  customer.resetSearchResult = function() {
    $('#customer_list .search_result').addClass('hide');
    $('#customer_list .search_header').addClass('hide');
    $('#customer_list .checkin').addClass('hide');
    $('#no_hit').addClass('hide');
  }

  customer.searching = function() {
    $('#searching').removeClass('hide');
    $('#unsearching').addClass('hide');
  }

  customer.unsearching = function() {
    if (suggest_load_count <= 0) {
      $('#unsearching').removeClass('hide');
      $('#searching').addClass('hide');
    }
  }

  customer.highlight = function(str, search_word) {
    if (str == null) return str;
    var word_re = new RegExp('(' + search_word.split(' ').join('|') + ')', 'gi');
    return str.replace(word_re, '<span class="highlight">$&</span>')
  }

  customer.autocompleteModel = function() {
    /* auto complete */
    $('#model').autocomplete({
      source: function(request, response) {
        $.ajax({
          url: "/api/bike_model/model_auto_complete.json",
          dataType: "json",
          data: {
            term: request.term,
            maker: $('input[name="maintenance_log[maker]"]:checked').val()
          },
          success: function(data) {
              response($.map(data, function(item) {
                return {
                  id: item.id,
                  name: item.name
                }
              }))
          }
        })
      },
      delay: 500,
      minLength: 2,
      focus: function(event, ui) {
        $(this).val(ui.item.name);
        return false;
      },
      select: function(event, ui) {
        $(this).val(ui.item.name);
        return false;
      }
    }).data("ui-autocomplete")._renderItem = function(ul, item) {
      return $("<li>").attr("data-value", item.name).data("ui-autocomplete-item", item).append("<a>" + item.name + "</a>").appendTo(ul);
    };
  }
  customer.changeSelectMaker = function(){
    $('.select-maker label').removeClass('active');
    if ($(this).closest(".dropdown-menu").length > 0) {
        if (!$('#btnGroupDropMaker').hasClass('active')) {
            $('#btnGroupDropMaker').addClass('active');
        }
        $('#btnGroupDropMaker').text($(this).parent().text());
    } else {
        $('#btnGroupDropMaker').removeClass('active');
    }
  }

  onPageLoad("customers#past_checkin", function () {
    props = {
      format: 'dd-M-yyyy',
      autoclose: true,
      todayBtn: true,
      todayHighlight: true,
      language: 'id',
      maxViewMode: 0,
      endDate: $('#today').val(),
    };
    $('#checkedin_day_btn').datepicker(props).on('changeDate', function(e){
      if (e.dates.length === 0) return;
      $('#checkedin_day_disp').text(e.format());
      $('#checkedin_day').val(e.format());
    });
    $('#checkedout_day_btn').datepicker(props).on('changeDate', function(e){
      if (e.dates.length === 0) return;
      $('#checkedout_day_disp').text(e.format());
      $('#checkedout_day').val(e.format());
    });
    $('#checkedout').bootstrapToggle();
    $('#checkedout').change(customer.changeCheckedout);
    $('input[name="expiration_month"]').on('change', customer.changeRegistrationMonth);

    customer.changeCheckedout();
    customer.changeRegistrationMonth();
    customer.autocompleteModel();
    $('.select-maker input').on('change', customer.changeSelectMaker);

    $(':input:checked').parent('.btn').addClass('active');
  });

  onPageLoad("customers#checkin", function () {
    $('#search_word').keyup(function(e) {
      clearTimeout($.data(this, 'timer'));
      var wait = setTimeout(customer.suggest(e), 500);
      $(this).data('timer', wait);
    });
    
    $('#phone_national').on('input', function() {
      if($(this).val()) {
        $('#phone_num_checkin_btn').prop("disabled", false);
      } else {
        $('#phone_num_checkin_btn').prop("disabled", true);
      }
    });

    function number_plate_blank_check() {
      if($('#number_plate_number').val() && $('#number_plate_pref').val()) {
        $('#num_plate_checkin_btn').prop("disabled", false);
      } else {
        $('#num_plate_checkin_btn').prop("disabled", true);
      }
    }

    $('#number_plate_number').on('input', function() {
      number_plate_blank_check()
    });

    $('#number_plate_pref').on('input', function() {
      number_plate_blank_check()
    });

    $('#phone_num_checkin_btn').click(function() {
      var self = this;
      $(self).prop("disabled", true);
      $('#phone_national').prop("readOnly", true);
      $.ajax({
        url: '/api/customers/valid_phone_number.json',
        method: 'POST',
        dataType: "json",
        data: {
          phone_country_code: $('#phone_country_code').val(),
          phone_national: $('#phone_national').val()
        },
        success: function(data) {
          if(data.valid) {
            $('#phone_checkin_submit').click();
          } else {
            $(self).prop("disabled", false);
            $('#phone_national').prop("readOnly", false);
            $('#phone_valid_err_msg').text(data.err_msg);
          }
        }
      })
    });

    $('#num_plate_checkin_btn').click(function() {
      var self = this;
      $(self).prop("disabled", true);
      $('#number_plate_number').prop("readOnly", true);
      $('#number_plate_pref').prop("readOnly", true);
      $.ajax({
        url: '/api/customers/valid_numberplate.json',
        method: 'POST',
        dataType: "json",
        data: {
          number_plate_area: $('#number_plate_area').val(),
          number_plate_number: $('#number_plate_number').val(),
          number_plate_pref: $('#number_plate_pref').val()
        },
        success: function(data) {
          if(data.valid) {
            $('#plate_checkin_submit').click();
          } else {
            $(self).prop("disabled", false);
            $('#number_plate_number').prop("readOnly", false);
            $('#number_plate_pref').prop("readOnly", false);
            $('#numberplate_valid_err_msg').text(data.err_msg);
          }
        }
      })
    });

    $('#modalRegisterByNumberplate').on('hidden.bs.modal', function (e) {
      $('#num_plate_checkin_btn').prop("disabled", true);
      $('#number_plate_number').val('');
      $('#number_plate_pref').val('');
      $('#numberplate_valid_err_msg').text('');
    });

    $('#modalRegisterByNumberplate').on('shown.bs.modal', function () {
      $('#number_plate_number').focus();
    });

    $('#modalRegisterByTel').on('hidden.bs.modal', function (e) {
      $('#phone_num_checkin_btn').prop("disabled", true);
      $('#phone_national').val('');
      $('#phone_valid_err_msg').text('');
    });

    $('#modalRegisterByTel').on('shown.bs.modal', function () {
      $('#phone_national').focus();
    });

    $("input").on("keydown", function(e) {
      // エンターキー押下時のsubmit対策
      if ((e.which && e.which === 13) || (e.keyCode && e.keyCode === 13)) {
        return false;
      } else {
        return true;
      }
    });

  });

  onPageLoad("customers#edit", function () {
    $('#customer_send_dm').bootstrapToggle();
  });
}.call(this));
