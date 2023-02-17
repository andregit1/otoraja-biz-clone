var checkin = function() {
};
(function(checkin) {
  'use strict';

  checkin.voidDateRange = function () {
    var start = null;
    var end = null;
    $('#void_daterangepicker').change(function (){
      start = $(this).val();
      end = $(this).val();
      if (start != undefined && end != undefined){
        $('#checkin-search').submit();
      }
    });
  }

  checkin.getUrlParams = function() {
    var params = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        params.push(hash[0]);
        params[hash[0]] = hash[1];
    }
    return params;
  }

  checkin.dateRangePicker = function() {
    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(29, "days"), moment()],
        "Semua": ['', '']
      },
      showDropdowns: true,
      showWeekNumbers: true,
      showISOWeekNumbers: true,
      autoApply: true,
      startDate: moment(),
      endDate: moment().subtract(1, "days"),
      locale: {
        "customRangeLabel": "Pilih rentang",
      },
      dateLimit: {
        'months': 1,
        'days': -1
      }
    };

    var callback = function(start, end, label){
      let date_range_text = isNaN(start) && isNaN(end) || start.length == 0 && end.length == 0 ? 'Semua' : start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY");

      if(isNaN(start) && isNaN(end) || start.length == 0 && end.length == 0) {
        date_range_text = "Semua";
      }
      else if(start.isSame(moment(), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Hari ini";
      }
      else if(start.isSame(moment().subtract(6, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "7 Hari terakhir";
      }
      else if(start.isSame(moment().startOf("month"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Bulan ini";
      }
      else if(start.isSame(moment().subtract(29, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "30 Hari terakhir";
      }
      
      $("#daterange-btn  span").html(date_range_text);  
      if (isNaN(start) && isNaN(end) || start.length == 0 && end.length == 0) {
        $("#start_date").val("");
        $("#end_date").val("");
      } else {
        $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
        $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
        $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
      }
    }

    $("#daterange-btn").daterangepicker(
      options,
      callback
    );
    
    let start = $("#start_date").val().length != 0 ? moment($("#start_date").val()) : '';
    let end = $("#end_date").val().length !=0 ? moment($("#end_date").val()) : '';
    callback(start, end);
  }

  checkin.dateRangePickerCustom = function() {
    var separator = ' - ', dateFormat = 'DD/MM/YYYY';
    var options = {
        autoUpdateInput: false,
        autoApply: true,
        locale: {
            format: dateFormat,
            separator: separator,
        },
        dateLimit: {
          'months': 1,
          'days': -1
        },
        opens: "right"
    };
  
    $('[data-datepicker=separateRange]')
      .daterangepicker(options)
      .on('apply.daterangepicker' ,function(ev, picker) {
        var default_date = picker.startDate.format(dateFormat) + separator + picker.endDate.format(dateFormat);
        $(this).closest('form').find('[name=value_start_end_date]').blur();
        $(this).closest('form').find('[name=value_start_end_date]').val(default_date);
        $("#start_date").val(picker.startDate.format("YYYY-MM-DD 00:00:00"));
        $("#end_date").val(picker.endDate.format("YYYY-MM-DD 23:59:59"));
        $(this).trigger('change').trigger('keyup');
      });
  }

  onPageLoad(["checkins#list", "checkins#index"], function() {
        
    checkin.dateRangePicker();
    checkin.dateRangePickerCustom();
    
    let params = checkin.getUrlParams();

    $('#no-trx-search').val(params["no_trx"]);
    if (params["base_date"] != null) {
      $('#select-checkin-base-date').val(params["base_date"]);
    }

    $('#search-clear-btn').on('click', function(){
      $('#no-trx-search').val('');
      $('#customer-search').submit();
    });

    if ($('#mode').val() === 'deleted') {
      checkin.voidDateRange();
    }

    $('#daterange-btn').on('apply.daterangepicker', function() {
      $('#checkin-search').submit();
    });

    $('#search-btn').on('click', function() {
      $('#checkin-search').submit();
    });

    $('#select-checkin-base-date').on('change', function() {
      $('#checkin-search').submit();
    });

    $('#select-checkin-sort, #select_shop').on('change', function() {
      $('#checkin-search').submit();
    });

    $("input").on("keydown", function(e) {
      if ((e.which && e.which === 13) || (e.keyCode && e.keyCode === 13)) {
        $('#checkin-search').submit();
      }
    });
  });
  
})(checkin || (checkin = {}));