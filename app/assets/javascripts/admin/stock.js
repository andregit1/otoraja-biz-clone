(function() {
  onPageLoad("stock#index", function() {

    $("#select_shop").select2();
    $("#select_category").select2();

    var isLoss = false;
    var shopId = 0;

    var options = {
      timePicker: false,
      singleDatePicker: true,
      showWeekNumbers: false,
      showISOWeekNumbers: false,
      autoApply: true,
      locale: {
        format: 'D/M/YYYY'
      },
      language: "id",
      todayBtn: 'linked',
      autoclose: true,
      "drops": "up"
    };

    var base_path = "admin";
    var paths = location.pathname.split('/');
    if(paths[1] !== "admin"){
      base_path = "console";
    }

    $("#stock-date-btn")
    .daterangepicker(options);

    $("#daily-history-date-btn")
    .daterangepicker({
      timePicker: false,
      singleDatePicker: true,
      showWeekNumbers: false,
      showISOWeekNumbers: false,
      autoApply: true,
      locale: {
        format: 'D/M/YYYY'
      },
      language: "id",
      todayBtn: 'linked',
      autoclose: true,
    }, function(date) {    
      $("#daily_history_date").val(date.format('YYYY-MM-DD'));
      $('#dailyHistoryModalBody').LoadingOverlay('show', {size: 50});
      $("#daily-history-commit").click();
    });

    shopId = $("#select_shop").val();

    dataRow = {}
  
    //hide the supplier and payment info when registering a loss action
    $(document).on("change", "#select_action", function(e){

        //reset previously inputted stock values
        $("[edited='edited']").find(".quantity-input").val(null).trigger("keyup");

        var target = $("#lbl_supplier, #select_supplier, #lbl_pay, #select_pay");
        var $editLink = $(".edit-stock-control");
        if($(e.target).val()==2){
            isLoss = true;
            $editLink.hide();
            return target.hide();
        }
        isLoss = false;
        target.show();
        $editLink.show();
    })

    //
    $(document).on("change", "#select_category", function(e){
        //get by category
        var id = $(e.target).val();

        $("[data-category-id]").show().hide();

        if($('#shortage:checked').length) {
          $(`[data-search-id=${shopId}-${id}-shortage]`).show();
        } else {
          $(`[data-search-id=${shopId}-${id}-shortage]`).show();
          $(`[data-search-id=${shopId}-${id}]`).show();
        }
    })

    $(document).on("change", "#select_shop", function(e){
      //get shop id
      var id = $(e.target).val();
      shopId = id;

      $("[data-shop-id]").show().hide();
      $(`[data-shop-id=${shopId}]`).show();

      $("#select_category").trigger("change");

      http(`/${base_path}/stock/shop/${shopId}/suppliers`,"GET",null,
        function(result){
          var html = "";
          $(result).each(function(index, item){
            html = html + `<option value='${item.id}'>${item.name}</option>`
          })
          
          $("#select_supplier").html(null).html(html).trigger("change")

        },
        function(error){
      })
    })

    $('#shortage').on('click', function(){
      $("#select_category").trigger("change");
    })

    //
    $(document).on("keydown", "#stock-table input", function(event){
      if(event.keyCode===189) {
        // マイナス入力不可
        return false;
      }
    })

    //
    $(document).on("keyup", ".quantity-input", function(event){
      var input = parseFloat($(event.target).val());
      var $inputField = $(event.target);
      var $row = $inputField.parents('tr');
      var orig = parseFloat($row.find("input.original-total").val()) || 0;
      var $stock = $row.find("span.new-total");
      var $purchasePriceInput = $row.find('.purchase-price-input');
      var $purchaseUnitPriceInput = $row.find('.purchase-unit-price-input');
      var $purchaseUnitPriceText = $row.find('.purchase-unit-price-text');

      $stock.removeClass("text-primary text-danger text-dark").addClass("text-dark");
      $inputField.removeClass("text-primary text-danger text-dark").addClass("text-dark");

      if(
        (isLoss && orig==0 && isNaN(input)) ||
        (isLoss && input>orig)
        )
      {
        $inputField.val(null);
        $stock.text(orig);
        return
      }

      $row.attr("edited", "edited")

      if(isNaN(input)){
        $inputField.val(null);
        $stock.text(orig);
        $row.removeAttr("edited");
        $purchasePriceInput.prop('disabled',true).val(null);
        $purchasePriceInput.prop('required',false);
        $purchaseUnitPriceInput.val(null);
        $purchaseUnitPriceText.text('');
      }
      else{
        var text = orig + " → ";
        if(isLoss){
          $stock.text(text + (orig - input).toFixed(1))
          $stock.removeClass("text-primary text-danger text-dark").addClass("text-danger");
          $inputField.removeClass("text-primary text-danger text-dark").addClass("text-danger");
        }else{
          $stock.text(text + (input + orig).toFixed(1))
          $stock.removeClass("text-primary text-danger text-dark").addClass("text-primary");
          $inputField.removeClass("text-primary text-danger text-dark").addClass("text-primary");
          $purchasePriceInput.prop('disabled',false).trigger('keyup');
          $purchasePriceInput.prop('required',true);
        }
      }
    });

    $(document).on("keyup", ".purchase-price-input", function(event){
      var input = $(event.target).val();
      var $inputField = $(event.target);
      var $row = $inputField.parents('tr');
      var quantity = parseFloat($row.find('.quantity-input').val());
      var $purchaseUnitPriceText = $row.find('.purchase-unit-price-text');
      var $purchaseUnitPriceInput = $row.find('.purchase-unit-price-input');
      $inputField.removeClass('bg-danger');

      if(isNaN(input) || input === ''){
        $inputField.val(null);
        $purchaseUnitPriceInput.val(null);
        $purchaseUnitPriceText.text('');
        return;
      }

      var unit_price = Math.floor(input / quantity);
      $purchaseUnitPriceText.text(unit_price.toLocaleString("id-ID"));
      $purchaseUnitPriceInput.val(unit_price);
    });

    $(document).on("click", "#register-btn", function(event){
      event.preventDefault();
      event.stopImmediatePropagation();

      if(!isFormValid())
        return;

      var btn = $(this)

      if(btn.attr("disabled"))
        return;

      $(this).attr("disabled", true);

      var list = [];
      $("[edited='edited']").each(function(index, item){
        item = $(item);
        var data = {
          id : item.find(".product-id").data("stock-id"),
          quantity: item.find(".quantity-input").val(),
          purchase_price: item.find('.purchase-price-input').val(),
          purchase_unit_price: item.find('.purchase-unit-price-input').val(),
          shop_product_id: item.find(".product-id").data("product-id"),
          supplier_id: $("#select_supplier").val(),
          reason: $("#select_action").val(),
          payment_method: $("#select_pay").val(),
          date: $("#stock-date-btn").val()
        }
        list.push(data);
      });

      http(`/${base_path}/stock/update`, "POST", { data : JSON.stringify(list), shop_id : $("#select_shop").val(), supplier_id : $("#select_supplier").val(), arrival_date: $("#stock-date-btn").val(), payment_method: $("#select_pay").val() }, function(response){
        btn.removeAttr("disabled");
        if(Array.isArray(response)){
          response.forEach(function(item, index){
              var row = $(`[data-product-id='${item.shop_product_id}']`).parent("tr");
              row.removeAttr("edited");
              row.find(".quantity-input").val(null);
              row.find(".purchase-price-input").val(null).prop("disabled",true);
              row.find(".purchase-unit-price-text").text('');
              row.find(".purchase-unit-price-input").val(null);
              row.find(".new-total").text(item.quantity.toFixed(1));
              row.find(".original-total").val(item.quantity.toFixed(1))
              row.find(".product-id").data("stock-id", item.id)
              row.find(".new-total").append(`<i class="fas fa-edit text-primary edit-stock-control pl-1" data-shop-product-id="${item.shop_product_id}" data-toggle="modal" data-target="#stockControlModal" data-backdrop="static"></i>`)
          });
        }else{
          $(".alert").show()
        }
        $(".quantity-input , .new-total").removeClass("text-primary text-danger text-dark").addClass("text-dark");

      });
    })

    $(document).on("click", "#edit-btn", function(event){
      var $form = $(event.target).parents("#edit-form");
      var $btn = $(event.target);
      var $modal = $("#stockControlModal")
      if($btn.attr("disabled"))
        return;

      $btn.attr("disabled", "disabled")

      dataRow.purchase_price = $form.find("#edit-purchase-price").val();
      dataRow.purchase_unit_price = $form.find("#edit-purchase-unit-price").val();

      http(`/${base_path}/stock/edit`, "POST", { data : JSON.stringify(dataRow) }, 
        function(response){
          $btn.removeAttr("disabled");
          $modal.find("input").val(null);
          $modal.modal("hide");
        }
      );
    })

    $(document).on("click", ".edit-stock-control", function(event){
      $('#stockControlModalBody').LoadingOverlay('show', {size: 50});

      var $row = $(event.target).parents("tr");
      var id = $row.find(".product-id").data("product-id")

      http(`/${base_path}/stock/${id}/stock_controll`, "GET", null, 
        function(response){
            $('#stockControlModalBody').LoadingOverlay('hide');
            var $form = $("#edit-form");
            var $purchasePrice = $form.find("#edit-purchase-price")
            var $unitPrice = $form.find("#edit-purchase-unit-price")
            var $btn = $form.find("button")
            var $modal = $("#stockControlModal");
            if(response){
              $modal.find(".modal-title span").text($row.find(".name").text());
              $purchasePrice.val(response.purchase_price || null)
              $unitPrice.val(response.purchase_unit_price || null)
              dataRow = {
                id : response.id,
                quantity: response.quantity.toString(),
                shop_product_id: response.shop_product_id,
              }
              $purchasePrice.removeAttr("disabled")
              $unitPrice.removeAttr("disabled")
              $btn.removeAttr("disabled")
            }else{
              //disable field
              $purchasePrice.attr("disabled", "disabled")
              $unitPrice.attr("disabled", "disabled")
              $btn.attr("disabled", "disabled")
            }
        });
    })

    var http =  function(url, verb, data, callback){
      $.ajax({
        url : url,
        method: verb,
        dataType: 'JSON',
        data : data
      })
      .done( function(result){
        if(typeof(callback)==="function")
          callback(result);
      }).
      fail ( function(){
        if(typeof(callback)==="function")
          callback("error");
      })
    }

    var isFormValid = function(){
        var inputs = $(".purchase-price-input");
        var result = true;
        inputs.each(function(index, item){
          $(item).removeClass("bg-danger");
          if(!$(item).attr("disabled")&&!$(item).val()){
            $(item).addClass("bg-danger");
            result = false;
          }
        })
        return result;
    }

    $("#select_shop").trigger("change");
    $("#select_category").trigger("change");

    var options = {
      ranges: {
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
        "Year to Date": [moment().startOf("year"), moment()]
      },
      showDropdowns: true,
      showWeekNumbers: true,
      showISOWeekNumbers: true,
      autoApply: true,
      startDate: moment().subtract(6, "days"),
      endDate: moment().subtract(1, "days"),
    };

    $("#stock-daterange-btn").daterangepicker(
      options,
      function(start, end) {
        $("#stock-daterange-btn span").html(
          start.format("D/M/YYYY") + " - " + end.format("D/M/YYYY")
        );
        $("#start_date").val(start.format("YYYY-MM-DD 00:00:00"));
        $("#end_date").val(end.format("YYYY-MM-DD 23:59:59"));
        $('#stockHistoryModalBody').LoadingOverlay('show', {size: 50});
        $("#stock-history-commit").click();
      }
    );

    $('#stockHistoryModal').on('shown.bs.modal', function (e) {
      var button = $(e.relatedTarget)
      var shopProductId = button.data('shop-product-id')
      $("#shop-product-id").val(shopProductId)

      $('#stockHistoryModalBody').LoadingOverlay('show', {size: 50});
      $("#stock-history-commit").click();
    });

    $('#stockHistoryModal').on('hidden.bs.modal', function (e) {
      $('#stockHistoryModalBody').LoadingOverlay('hide');
    });

    $('#dailyHistoryModal').on('shown.bs.modal', function (e) {
      let shopId = $("#select_shop").val();
      $("#daily-history-shop-id").val(shopId);

      $("#daily_history_date").val($("#daily-history-date-btn").val());

      $('#dailyHistoryModalBody').LoadingOverlay('show', {size: 50});
      $("#daily-history-commit").click();
    });

    $('#dailyHistoryModal').on('hidden.bs.modal', function (e) {
      $('#dailyHistoryModalBody').LoadingOverlay('hide');
    });

    $('#stockControlModal').on('shown.bs.modal', function (e) {
    });

    $('#stockControlModal').on('hidden.bs.modal', function (e) {
      var $form = $("#edit-form");
      var $purchasePrice = $form.find("#edit-purchase-price")
      var $unitPrice = $form.find("#edit-purchase-unit-price")
      $purchasePrice.val(null);
      $unitPrice.val(null);
      $('#stockControlModalBody').LoadingOverlay('hide');
    });

    $('#stockProfitModal').on('shown.bs.modal', function (e) {
      var button = $(e.relatedTarget)
      var stockProductId = button.data('stock-product-id')
      var stockControlId = button.data('stock-control-id')

      $("#stock-product-id").val(stockProductId)
      $("#stock-control-id").val(stockControlId)
      $('#stockProfitModalBody').LoadingOverlay('show', {size: 50});
      $("#stock-profit-commit").click();
    });

    $('#stockProfitModal').on('hidden.bs.modal', function (e) {
      $('#stockProfitModalBody').LoadingOverlay('hide');
    });
  });
}.call(this));
