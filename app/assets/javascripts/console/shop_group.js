(function() {
  onPageLoad("shop_groups", function() {
    let start = moment().subtract(7, "days")
    let end = moment().subtract(1, "days")

    $("#start_date_shop_groups").val(start);
    $("#end_date_shop_groups").val(end);

    var options = {
      ranges: {
        "Today": [moment(), moment()],
        "Last 7 Days": [moment().subtract(7, "days"), moment().subtract(1, "days")],
        "Month to Date": [moment().startOf("month"), moment()],
        "Last Month": [
          moment()
            .subtract(1, "month")
            .startOf("month"),
          moment()
            .subtract(1, "month")
            .endOf("month")
        ],
        "Last 3 Month": [
          moment()
            .subtract(3, "month")
            .startOf("month"),
          moment()
            .subtract(1, "month")
            .endOf("month")
        ],
        "Last 6 Month": [
          moment()
            .subtract(6, "month")
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
      startDate: start,
      endDate: end,
    };

    var callback = function(start, end){
      let date_range_text = start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY");
        
      if(start.isSame(moment(), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Today";
      }
      else if(start.isSame(moment().subtract(7, "days"), 'day') && end.isSame(moment().subtract(1, "days"), 'day')) {
        date_range_text = "Last 7 Days";
      }
      else if(start.isSame(moment().startOf("month"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Month to Date";
      }
      else if(start.isSame(moment().subtract(1, "month").startOf("month"), 'day') && end.isSame(moment().subtract(1, "month").endOf("month"), 'day')) {
        date_range_text = "Last Month";
      }
      else if(start.isSame(moment().subtract(3, "month").startOf("month"), 'day') && end.isSame(moment().subtract(1, "month").endOf("month"), 'day')) {
        date_range_text = "Last 3 Month";
      }
      else if(start.isSame(moment().subtract(6, "month").startOf("month"), 'day') && end.isSame(moment().subtract(1, "month").endOf("month"), 'day')) {
        date_range_text = "Last 6 Month";
      }

      $("#daterange-btn-shop-groups span").html(date_range_text);
      $("#start_date_shop_groups").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date_shop_groups").val(end.format("YYYY-MM-DD 23:59:59"));

      return date_range_text
    }

    $("#daterange-btn-shop-groups").daterangepicker(
      options,
      callback
    );
  });

}.call(this));
