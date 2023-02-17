(function() {
  "use strict";

  window.app = window.app || {}
  var stockBookReport = window.app.stockBookReport = {};

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/shop_products/' + url
    $.ajax({
      url: url,
      type: method,
      dataType: 'json',
      data: data,
      async: async,
    }).fail(function (xhr, status, error) {
      console.error(error);
    }).done(function (data) {
      callback(data);
    });
  }

  function getAjax(url, data, callback, async) {
    coreAjax('GET', url, data, callback, async);
  }

  stockBookReport.addPurchaseHistory = function(item) {
    var item_exist = item.difference || item.quantity
    var op = item_exist > 0 ? '+' : ''
    var notes = item.reason
    var stock = item.stock_at_close == 0 || item.difference == 0 ? item_exist : parseInt(item.stock_at_close + item_exist).toLocaleString("id-ID")
    var quantity = item.difference == 0 ? 0 : op + item_exist

    switch (item.reason) {
      case "1":
        notes = "Beli"
        break;
      case "2":
        notes = "Opname"
        break;
      case "3":
        notes = "Jual"
        break;
      case "4":
        notes = "Opname"
        break; 
      default:
        notes = ""
    }

    $("#purchase_history").append(`
      <tr class="text-normal">
        <td>${item.formated_date}</td>
        <td class="text-right">${quantity}</td>
        <td class="text-right">${stock}</td>
        <td class="text-center">${notes}</td>
      </tr>
    `)
  }

  stockBookReport.getStockHistory = function(id){
    var params = {
      shop_product_id: id,
      start_date: $('#start_date_history').val(),
      end_date: $('#end_date_history').val(),
    };

    $('#loading_purchase_history').removeClass('hide');
    $('#empty_data_info').addClass('hide');
    $('#purchase_history').empty();
    
    getAjax(
      'stock_controls.json',
      params,
      function(data) {
        $('#loading_purchase_history').addClass('hide');
        if(data.length){
          data.forEach(function(item){
            stockBookReport.addPurchaseHistory(item);
          })
        }else{
          $('#empty_data_info').removeClass('hide');
        }
      },
      true
    );
  }

  stockBookReport.findStockHistory = function (id) {
    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(29, "days"), moment()],
      },
      showDropdowns: true,
      showWeekNumbers: true,
      showISOWeekNumbers: true,
      showCustomRangeLabel: false,
      autoApply: true,
      startDate: moment(),
      endDate: moment(),
      parentEl: '#detailProductModal',
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
      else if(start.isSame(moment().subtract(29, "days"), 'day') && end.isSame(moment(), 'day')) {
        date_range_text = "30 hari terakhir";
      }

      $("#daterange-btn-history span").html(date_range_text);

      $("#start_date_history").val(start.format("YYYY-MM-DD 00:00:00"));
      $("#end_date_history").val(end.format("YYYY-MM-DD 23:59:59"));

      stockBookReport.getStockHistory(id);
    }

    $("#daterange-btn-history").daterangepicker(
      options,
      callback
    );

    callback(start, end);
  }

  onPageLoad("stock_book_reports", function() {
    $("#select_category").select2({width: '100%'});
    $("#select_category, #last_stock_zero, #no_stock_movement, #not_available").on("change", function() {
      $("#report-filter").trigger("click");
    });
    $("#search-btn").on("click", function() {
      $("#report-filter").trigger("click");
    });
    $("#show-detail").on("click", function() {
      $("#detailProductModal").show();
    });

    var options = {
      ranges: {
        "Hari ini": [moment(), moment()],
        "7 hari terakhir": [moment().subtract(6, "days"), moment()],
        "Bulan ini": [moment().startOf("month"), moment()],
        "30 hari terakhir": [moment().subtract(29, "days"), moment()],
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
      else if(start.isSame(moment().subtract(29, "days"), 'day') && end.isSame(moment(), 'day')) {
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
      $("#report-filter").trigger("click");
    });

    $(".item-detail").off().on("click", function() {
      var $form = $("#detailProductModal");
      var shop_product_id = $(this).data("shop-product-id");
  
      $form.find("[name='shop_alias_name']").val($(this).data("shop-alias-name"));
      $form.find("[name='product_category']").val($(this).data("category"));
      $form.find("[name='product_no']").val($(this).data("product-no"));
      $form.find("[name='availability']").prop("checked", $(this).data("availability")).trigger("change").attr("disabled", true);
      $form.find("[name='admin_product_name']").val($(this).data("admin-product-name"));
      $form.find("[name='sales_unit_price']").val($(this).data("price"));
      $form.find("[name='item_detail']").val($(this).data("item-detail"));
      $form.find("[name='is_stock_control']").prop("checked", $(this).data("is-stock-control")).trigger("change").attr("disabled", true);
      $form.find("[name='stock_minimum']").val($(this).data("stock-minimum"));

      $("#purchase_history").empty();
      stockBookReport.findStockHistory(shop_product_id);
    });
  });
}.call(this));
