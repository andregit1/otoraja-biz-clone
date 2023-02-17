var shopProductImport = function() {
};
(function(shopProductImport) {
  'use strict';
  shopProductImport.changeUploadButton = function(){
    if ($('#shop_product_upload_shop_id').val() === '' || $('#productInputFile').val() === '') {
      $('#import-file-upload').prop('disabled', true);
    } else {
      $('#import-file-upload').prop('disabled', false);
    }
  }
  onPageLoad(
    ["shop_products#import","shop_products#import_confirm"]
  , function() {
    bsCustomFileInput.init();
    $('#shop_product_upload_shop_id').select2();
    $('#shop_product_upload_shop_id').change(shopProductImport.changeUploadButton);
    $('#productInputFile').change(shopProductImport.changeUploadButton);
    shopProductImport.changeUploadButton();

    $("#execute_import").submit(function(e){
      var import_btn = $(this)
      e.preventDefault(e);
  
      $("#import_button").addClass("buttonload")
      $(".fa-spinner").removeClass("d-none");
      $( "#import_button" ).prop( "disabled", true );
  
      $.ajax({
        url: $(this).attr("action"),
        type: "POST",
        data: $(this).serialize(),
        dataType: "json",
        success: function(response){
          import_btn.fadeOut(500);

          import_btn.fadeIn(500,function(){
            import_btn.html(
            '<div class="alert alert-info alert-dismissible mb-4 d-flex align-items-center">'+
            '<a class="btn btn-default mr-3 bg-info" href="/console/shop_products/import">Back</a>'+
            '<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>'+
          response.message+'</div>');

            if(response.success){
              if($("#products_with_error").length == 0){
                window.history.replaceState( null, null, "import" );
              }
            }else{
              $(".alert").removeClass("alert-success")
              $(".alert").addClass("alert-danger")
              $(".btn-default").addClass("bg-red")
            }
          });
        }
      })
    });
  });
})(shopProductImport || (shopProductImport = {}));

function convertToCSV(objArray) {
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';

    for (var i = 0; i < array.length; i++) {
        var line = '';
        for (var index in array[i]) {
            if (line != '') line += ','

            line += array[i][index];
        }

        
        str += line.replace(/null/g,'') + '\r\n';
    }

    return str;
}
function blankForNull(s) {
  return s === null ? null : s.toString().replace(/,/g, '');
}

function exportCSVFile() {
  var itemsNotFormatted = JSON.parse($("#products_with_error").html())
  var items = []

  itemsNotFormatted.forEach((item) => {
    items.push({
      product_no: blankForNull(item.product_no),
      product_class_name: blankForNull(item.product_class_name),
      product_category_id: blankForNull(item.product_category_id),
      product_category_name: blankForNull(item.product_category_name),
      admin_product_id: blankForNull(item.admin_product_id),
      shop_alias_name: blankForNull(item.shop_alias_name),
      item_detail: blankForNull(item.item_detail),
      stock_minimum: blankForNull(item.stock_minimum),
      sales_unit_price: blankForNull(item.sales_unit_price),
      remind_interval_day: blankForNull(item.remind_interval_day),
      purchase_unit_price: blankForNull(item.purchase_unit_price),
      stock: blankForNull(item.stock),
      in_store: blankForNull(item.in_store),
      error: blankForNull(item.error)
    });
  });

items.unshift({
    product_no: "product_no",
    product_class_name: "product_class_name",
    product_category_id: "product_category_id",
    product_category_name: "product_category_name",
    admin_product_id: "admin_product_id",
    shop_alias_name: "shop_alias_name",
    item_detail: "item_detail",
    stock_minimum: "stock_minimum",
    sales_unit_price: "sales_unit_price",
    remind_interval_day: "remind_interval_day",
    purchase_unit_price: "purchase_unit_price",
    stock: "stock",
    in_store: "in_store",
    error: "error"
  });

  // Convert Object to JSON
  var jsonObject = JSON.stringify(items);

  var csv = this.convertToCSV(jsonObject);

  var blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  if (navigator.msSaveBlob) { // IE 10+
      navigator.msSaveBlob(blob, exportedFilenmae);
  } else {
    var link = document.createElement("a");
    if (link.download !== undefined) { // feature detection
        // Browsers that support HTML5 download attribute
        var url = URL.createObjectURL(blob);
        link.setAttribute("href", url);
        var shop_name = $("#shop_name").html();
        link.setAttribute("download", "shop_products_with_error_on_"+shop_name+".csv");
        link.style.visibility = 'hidden';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
  }
}
 // call the exportCSVFile() function to process the JSON and trigger the download