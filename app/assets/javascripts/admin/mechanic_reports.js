(function() {
  "use strict";

  window.app = window.app || {}
  var mechanicReports = window.app.mechanicReports = {};

  onPageLoad("mechanic_reports", function() {
    $("#select_mechanic").select2({width: '100%'});
    $("#select_mechanic").on("change", function() {
      $("#report-filter").trigger("click");
    });

    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(30, "days"), moment()],
        "3 bulan kebelakang": [
          moment()
            .subtract(3, "month")
            .startOf("month"),
          moment()
            .subtract(1, "month")
            .endOf("month")
        ],
      },
      showDropdowns: true,
      showWeekNumbers: true,
      showISOWeekNumbers: true,
      autoApply: true,
      startDate: moment(),
      endDate: moment(),
      locale: {
        "customRangeLabel": "Pilih rentang",
      },
      maxSpan: {
        "days": 30
      },
    };

    var callback = function(start, end, label){
      let date_range_text = start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY");

      if(start.isSame(moment(), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Hari ini";
      }
      else if(start.isSame(moment().subtract(6, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "7 hari terakhir";
      }
      else if(start.isSame(moment().startOf("month"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Bulan ini";
      }
      else if(start.isSame(moment().subtract(30, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "30 hari terakhir";
      }
      else if(start.isSame(moment().subtract(3, "month").startOf("month"), 'day') && end.isSame(moment().subtract(1, "month").endOf("month"), 'day')) {
        date_range_text = "3 bulan kebelakang";
      }

      $("#daterange-btn-report span").html(date_range_text);

      $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
    }

    $("#daterange-btn-report").daterangepicker(
      options,
      callback
    );

    let start = moment($("#start_date").val());
    let end = moment($("#end_date").val());

    callback(start, end);

    $("#daterange-btn-report").data('daterangepicker').setStartDate(start);
    $("#daterange-btn-report").data('daterangepicker').setEndDate(end);

    $('#daterange-btn-report').on('apply.daterangepicker', function() {
      $("#report-filter").trigger("click");
    });
  });
}.call(this));
