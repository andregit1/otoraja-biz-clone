(function() {
  'use strict';
  window.app = window.app || {}
  var dashboard = window.app.dashboard = {};

  onPageLoad("dashboard", function() {
    $('#dashboard_shop_id').select2({containerCssClass: "text-normal", dropdownCssClass: "text-normal"});
    $('#sales_aggregation_unit_type, #checkins_aggregation_unit_type, #revenue_aggregation_unit_type, #profit_aggregation_unit_type, #expenses_aggregation_unit_type, #sales_details_category').select2({containerCssClass: "text-normal", dropdownCssClass: "text-normal", minimumResultsForSearch: -1});
    $('#daterange-btn').daterangepicker({
      locale: {
        "custom Range": "Pilih rentang",
      },
    },);
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

    let start = moment();
    let end = moment();

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

      $("#daterange-btn span").html(date_range_text);

      $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
      localStorage.setItem("date_range",JSON.stringify({
        start: start,
        end : end
      }));
      $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
      dashboard.refresh();
    }

    $("#daterange-btn").daterangepicker(
      options,
      callback
    );

    callback(start, end);

    $(document).on("click", ".date-range-readonly", function(event){
      $(document).scrollTop(0)
    })

    $(document).on("change", "#dashboard_shop_id", function(){
      dashboard.refresh();
    });

    $(document).on("change", "#sales_aggregation_unit_type", function(){
      dashboard.refresh();
    });

    $(document).on("change", "#checkins_aggregation_unit_type", function(){
      dashboard.refresh();
    });

    $(document).on("change", "#revenue_aggregation_unit_type", function(){
      dashboard.refresh();
    });

    $(document).on("change", "#profit_aggregation_unit_type", function(){
      dashboard.refresh();
    });

    $(document).on("change", "#expenses_aggregation_unit_type", function(){
      dashboard.refresh();
    });

    $(document).on('click', ".btn-group", function(){
      $(this).find('.btn').toggleClass('active');
    });

  });

  dashboard.refresh = function() {
    // コンテナごとにリサイズするため、１つずつ呼び出す
    $('.loading-wrapper').each(function(i, e){
      $(e).LoadingOverlay('show');
    })
    $("#dashboard-commit").click();
  }

  dashboard.hideLoading = function() {
    $('.loading-wrapper').LoadingOverlay('hide');
  }
}.call(this));

