(function() {
  'use strict';
  window.app = window.app || {}
  var salesDetails = window.app.sales_details = {};

  function getDateRange(){
    let range = {};
    if(localStorage.getItem("date_range")){
      let obj = JSON.parse(localStorage.getItem("date_range"))
      range = {
        start : moment(obj.start),
        end : moment(obj.end)
      }
    }
    else{
      range = {
        start : moment(),
        end : moment()
      }
    };
    localStorage.removeItem("date_range")
    return range;
  }
  onPageLoad("sales_details", function() {
    $('#dashboard_shop_id').select2();
    
    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(30, "days"), moment()],
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

      $("#daterange-btn span").html(date_range_text);

      $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
      $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
      $("#dashboard-commit").click();
      salesDetails.refresh();
    }

    $("#daterange-btn").daterangepicker(
      options,
      callback
    );
    let range = getDateRange();
    callback(range.start, range.end);

    $(document).on("click", ".date-range-readonly", function(event){
      $(document).scrollTop(0)
    })

    $(document).on("change", "#dashboard_shop_id", function(){
      $("#dashboard-commit").click();
    });
  
    $(document).on("change", "#sales_aggregation_unit_type", function(){
      $('#dashboard-commit').click();
    });
  
    $(document).on("change", "#checkins_aggregation_unit_type", function(){
      $('#dashboard-commit').click();
    });

    $(document).on("change", "#revenue_aggregation_unit_type", function(){
      $('#dashboard-commit').click();
    });

    $(document).on("change", "#profit_aggregation_unit_type", function(){
      $('#dashboard-commit').click();
    });

    $("#dashboard-commit").click();

  });

  salesDetails.refresh = function() {
    // コンテナごとにリサイズするため、１つずつ呼び出す
    $('.loading-wrapper').each(function(i, e){
      $(e).LoadingOverlay('show');
    })
    $("#dashboard-commit").click();
  }

  salesDetails.hideLoading = function() {
    $('.loading-wrapper').LoadingOverlay('hide');
  }

}.call(this));
