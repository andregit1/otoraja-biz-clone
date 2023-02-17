(function() {
  let options = {
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
    endDate: moment().add(1, "days"),
    locale: {
      "customRangeLabel": "Pilih rentang",
    },
    maxSpan: {
      "days": 30
    },
  };
  let labelDates = function(start, end) {
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
    return date_range_text
  }
  
  let paymentCallback = function(start, end, label) {
    let date_range_text = labelDates(start, end)

    $("#payment-btn span").html(date_range_text);
    $("#q_payment_date_gteq").val(start.format("YYYY-MM-DD 00:00:00"));
    $("#q_payment_date_lteq").val(end.format("YYYY-MM-DD 23:59:59"));
    $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
  }

  let expiredCallback = function(start, end, label) {
    let date_range_text = labelDates(start, end)

    $("#expired-btn span").html(date_range_text);
    $("#q_payment_expired_gteq").val(start.format("YYYY-MM-DD 00:00:00"));
    $("#q_payment_expired_lteq").val(end.format("YYYY-MM-DD 23:59:59"));
    $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
  }

  let invoiceCallback = function(start, end, label) {
    let date_range_text = labelDates(start, end)

    $("#invoice-btn span").html(date_range_text);
    $("#q_created_at_gteq").val(start.format("YYYY-MM-DD 00:00:00"));
    $("#q_created_at_lteq").val(end.format("YYYY-MM-DD 23:59:59"));
    $(".date-range-readonly").text(`${start.format("DD MMM YYYY")} - ${end.format("DD MMM YYYY")}`)
  }

  let selectorCheck = function(selector) {
    let start = $(selector + '_gteq').val()
    let end = $(selector + '_lteq').val()
    if (start.length != 0 && end.length != 0) return true
    else return false
  }

  let getMomentDate = function(selector) {
    let dateString = $(selector).val()
    if (dateString !== "") {
      return moment(dateString);
    } else return moment()
  }

  let checkDatesPickerLable = function() {
    let paymentLabel = invoiceLabel = dueDateLabel = '';
    if (selectorCheck("#q_payment_date")) paymentLabel = labelDates(getMomentDate("#q_payment_date_gteq"), getMomentDate("#q_payment_date_lteq"))
    if (selectorCheck("#q_created_at")) invoiceLabel = labelDates(getMomentDate("#q_created_at_gteq"), getMomentDate("#q_created_at_lteq"))
    if (selectorCheck("#q_payment_expired"))  dueDateLabel = labelDates(getMomentDate("#q_payment_expired_gteq"), getMomentDate("#q_payment_expired_lteq"))
    $("#payment-btn span").html(paymentLabel)
    $("#invoice-btn span").html(invoiceLabel)
    $("#expired-btn span").html(dueDateLabel)
  }

  let getIDs = function() {
    // q_checkbox_ids
    let array = []
    $('.select-subscription:checked').each(function(i, el){
      array.push($(el).data('id'))
    })
    $('#q_checkbox_ids').val(array)
  }

  let setParamsDownload = function() {
    let downloadLink = $('#download-invoice').attr('href')
    let params = $(':input').serialize()
    let download = $('#q_checkbox').val()
    if (download == '') {
      $('#confirmationModalDownload').modal('show')
      //alert('Pilih data yang akan didownload terlebih dahulu')
    } else window.location.href = downloadLink +'?'+ params
  }

  onPageLoad("subscriptions#index", function() {
    $("#shop_group_id_eq").select2();
  })

  onPageLoad("subscriptions#invoice", function() {
    checkDatesPickerLable()
    
    $("#payment-btn").daterangepicker(
      options,
      paymentCallback
    );

    $("#invoice-btn").daterangepicker(
      options,
      invoiceCallback
    );

    $("#expired-btn").daterangepicker(
      options,
      expiredCallback
    );

    $('#subscription_list_filter').each(function() {
      $(this).find('input').keypress(function(e) {
        // Enter pressed?
        if(e.which == 10 || e.which == 13) {
          this.form.submit();
        }
      });
    });
    $('#set-filter').click(function(){
      $('#console-subs-search').submit();
    })
    $("#select-all-subscription").click(function(){
      var checkedbox = $('.select-subscription:checked').length
      var checkbox = $('.select-subscription').length
      var state = $("#select-all-subscription").data('state')
    
      if (checkedbox < checkbox) {
        $('input:checkbox').not(this).prop('checked', true);
        $(this).prop("indeterminate", true);
        $(this).prop("checked", false);
        $(this).data('state', 1)
        $('#q_checkbox').val('page')
      } else if (state == 1 && checkedbox == checkbox) {
        $("#select-all-subscription").prop({
          indeterminate: false,
          checked: true
        })
        $('input:checkbox').not(this).prop('checked', true);
        $(this).data('state', 2)
        $('#q_checkbox').val('all')
      } else if ($('input:checkbox').length == (checkbox+1)) {
        $('input:checkbox').prop('checked', false);
        $(this).data('state', 0)
        $('#q_checkbox').val('')
      }

      countCheckbox()
    });
    $(".select-subscription").click(function(){
        $("#select-all-subscription").prop({
          indeterminate: true,
          checked: false
        })
        $("#select-all-subscription").data('state', 1)
        $('#q_checkbox').val('id')
        countCheckbox()
        getIDs()
    });
    $('#download-invoice').click(function(e){
      e.preventDefault()
      setParamsDownload()
    })
    function countCheckbox() {
        var checkbox = $('.select-subscription:checked').length;
        var state = $("#select-all-subscription").data('state')
        var total = $("#select-all-subscription").data('total')

        if (state == 2) {
          $('.selected-item span').html(total)
        } else {
          $('.selected-item span').html(checkbox)
        }        
    }
});
}.call(this));




