var expanse_report = function() {
};
(function(expanse_report) {
  'use strict';

  function checkValue() {
    $("input#input-expenses-val").on("keyup change", function(){
      var $this = $(this);
      var input = $this.val();
      if(input.length > 0) {
          $('input#shop_expense_value').val($this.val().replace(/\./g,''))

          var $this = $(this);
          var input = $this.val();
          input = input.replace(/[\D\s\._\-]+/g, "");
          input = input && parseInt( input, 10 );
          $this.val( function() {
            return ( input < 0 ) ? "" : input.toLocaleString( "id-ID" );
          });
          $('input#save-expenses-btn').prop('disabled', false)

          if (input == ''){
            $('input#save-expenses-btn').prop('disabled', true)
          }
      } else if (input.length == 0) {
          $('input#save-expenses-btn').prop('disabled', true)
      }
    });
  }

  function resetModalsupplier() {
    $("input#name").val('');
    $("input#tel").val('');
    $("input#address").val('');
  }

  function countDesc() {
    // edit mode
    if ($('#countDesc').val()) {
      $('#countDesc').val($("input#shop_expense_description").val().length)
      if($("input#shop_expense_description").val().length < 10) {
        $("#countDesc").css({"width": "14px"});
      } else {
        $("#countDesc").css({"width": "23px"});
      }
    }
    // create new mode
    $("input#shop_expense_description").on("keyup change", function(){
      if($(this).val().length < 10) {
        $("#countDesc").css({"width": "14px"});
      } else {
        $("#countDesc").css({"width": "23px"});
      }
      $('#countDesc').val($(this).val().length)
    });
  }

  onPageLoad('shop_expenses#index', function(){
    // dateRangePicker //
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
      showCustomRangeLabel: false,
      autoApply: true,
      startDate: moment(),
      endDate: moment(),
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
      $("#expense-report-filter").trigger("click");
    });
    // EndDateRangePicker //
    $('#search-btn').on('click', function(e){
      $("#expense-report-filter").trigger("click");
    })
  });

  onPageLoad(["shop_expenses#new", "shop_expenses#show", "shop_expenses#edit"], function() {
    $('input#save-expenses-btn').prop('disabled', true)

    if ($("input#shop_expense_value").val()) {
      var valTemp = $("input#shop_expense_value").val().replace(/[\D\s\._\-]+/g, "");
      valTemp = valTemp && parseInt( valTemp, 10 );
      var x = valTemp.toLocaleString( "id-ID" );
      $('input#input-expenses-val').val(x)
      $('input#save-expenses-btn').prop('disabled', false);
      checkValue();
    } else {
      checkValue();
    }

    $('#deleteExpenseBtn').on('click', function(e){
      $('#confirmDeleteExpense').modal('show');
    })

    // date picker basic //
    $('.single-date-picker-no-minDate').daterangepicker({
      "singleDatePicker": true,
      "autoApply": true,
      "drops": "down",
      locale: {
        format: 'DD-MM-YYYY'
      }
    });

    // supplier add new //
    $('#expense-new-modal').on('click', function(e){
      resetModalsupplier();
      $('input#add-supplier-save-btn').prop('disabled', true);
      $('#addNewExpenseModal').modal('show');
    })

    $("input#name").on("keyup change", function(){
      if($(this).val().length > 0) {
        $('input#add-supplier-save-btn').prop('disabled', false)
        } else if ($(this).val().length == 0) {
        $('input#add-supplier-save-btn').prop('disabled', true)
      }
    });

    countDesc();

  });

})(expanse_report || (expanse_report = {}));