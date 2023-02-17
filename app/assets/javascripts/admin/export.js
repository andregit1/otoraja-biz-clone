(function() {
  onPageLoad("export", function() {
    let start = moment().subtract(6, "days")
    let end = moment().subtract(1, "days")

    $("#start_date_sales").val(start);
    $("#end_date_sales").val(end);
    $("#start_date_subscription").val(start);
    $("#end_date_subscription").val(end);

    const options = {
      ranges: {
        "Today": [moment(), moment()],
        "Last 7 Days": [moment().subtract(6, "days"), moment()],
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

    const get_range_text = (start, end) => {
      let date_range_text = start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY");
        
      if(start.isSame(moment(), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "Today";
      }
      else if(start.isSame(moment().subtract(6, "days"), 'day') && end.isSame(moment().subtract(1, "days"), 'day')) {
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

      return date_range_text
    }

    $("#daterange-btn-sales").daterangepicker(
      options,
      function(start, end) {
        let date_range_text = get_range_text(start, end)

        $("#daterange-btn-sales span").html(date_range_text);
        $("#start_date_sales").val(start.format("YYYY-MM-DD 00:00:00"));
        $("#end_date_sales").val(end.format("YYYY-MM-DD 23:59:59"));
      }
    );

    $("#daterange-btn-subscription").daterangepicker(
      options,
      function(start, end) {
        let date_range_text = get_range_text(start, end)

        $("#daterange-btn-subscription span").html(date_range_text);
        $("#start_date_subscription").val(start.format("YYYY-MM-DD 00:00:00"));
        $("#end_date_subscription").val(end.format("YYYY-MM-DD 23:59:59"));
      }
    );
  });

}.call(this));
