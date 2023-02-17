var adminProduct = function() {
};
(function(adminProduct) {
  'use strict';

  adminProduct.hot;
  adminProduct.cache_product_category = {};
  adminProduct.cache_brand = {};
  adminProduct.cache_variant = {};
  adminProduct.cache_tech_spec = {};
  adminProduct.cache_admin_product = {};

  adminProduct.getHot = function() {
    return this.hot;
  }
  adminProduct.setHot = function(obj) {
    this.hot = obj;
  }
  adminProduct.errorRows = [];

  adminProduct.getCacheProductCategory = function() {
    return this.cache_product_category;
  }
  adminProduct.setCacheProductCategory = function(obj) {
    this.cache_product_category = obj;
  }

  adminProduct.getCacheBrand = function() {
    return this.cache_brand;
  }
  adminProduct.setCacheBrand = function(obj) {
    this.cache_brand = obj;
  }

  adminProduct.getCacheVariant = function() {
    return this.cache_variant;
  }
  adminProduct.setCacheVariant = function(obj) {
    this.cache_variant = obj;
  }

  adminProduct.getCacheTechSpec = function() {
    return this.cache_tech_spec;
  }
  adminProduct.setCacheTechSpec = function(obj) {
    this.cache_tech_spec = obj;
  }
  

  adminProduct.getCacheAdminProduct = function(category) {
    if (category === undefined) {
      return this.cache_admin_product;
    } else {
      var list = this.cache_admin_product[category];
      if (list === undefined) {
        list = {};
      }
      return list;
    }
  }

  adminProduct.setCacheAdminProduct = function(category, obj) {
    this.cache_admin_product[category] = obj;
  }

  adminProduct.buildHot = function() {
    var element =  document.getElementById("product_list");
    var columns = [
      {
        title: " ",
        data: "selected",
        readOnly: false,
        type: 'checkbox',
        columnSorting: false,
      }, {
        title: $('#label-imported').val(),
        data: "exist_shop_product",
        readOnly: true,
        type: 'text',
        renderer: adminProduct.keyValueRender,
        editor: 'select'
      }, {
        title: $('#label-category').val(),
        data: "product_category_id",
        readOnly: true,
        type: 'text',
        renderer: adminProduct.keyValueRender,
        editor: 'select'
      }, {
        title: $('#label-product_no').val(),
        data: "product_no",
        readOnly: false,
        required: false,
        type: 'text',
      }, {
        title: $('#label-name').val(),
        data: "name",
        readOnly: true,
        required: true,
        type: 'text',
      }, {
        title: $('#label-item_detail').val(),
        data: "item_detail",
        readOnly: true,
        required: false,
        type: 'text',
      }, {
        title: $('#label-brand').val(),
        data: "brand_id",
        readOnly: true,
        renderer: adminProduct.keyValueRender,
        type: 'text',
      }, {
        title: $('#label-variant').val(),
        data: "variant_id",
        readOnly: true,
        renderer: adminProduct.keyValueRender,
        type: 'text',
      }, {
        title: $('#label-tech_spec').val(),
        data: "tech_spec_id",
        readOnly: true,
        renderer: adminProduct.keyValueRender,
        type: 'text',
      }, {
        title: $('#label-remind_interval_day').val(),
        data: "remind_interval_day",
        readOnly: true,
        type: 'numeric',
      }, {
        title: $('#label-created_at').val(),
        data: "created_at",
        readOnly: true,
        type: 'date',
        dateFormat: 'MM/DD/YYYY',
        correctFormat: true,
      }
    ];
    var settings = {
      data: {},
      dataSchema: {
        selected: null,
        product_category_id: null,
        name: null,
        item_detail: null,
        remind_interval_day: null,
      },
      columns: columns,
      colHeaders: true,
      rowHeaders: true,
      columnSorting: true,
      sortIndicator: true,
      outsideClickDeselects: true,
      enterMoves: {
        row: 0,
        col: 1
      },
      cells: function (row, col, prop) {
        var cellProperties = {}
        if (col === 0) {
          if(this.instance.getDataAtCell(row,1)){
            cellProperties.readOnly = true;
          }
        }
    
        return cellProperties;
      },
      width: '100%',
      height: 500,
      fillHandle: false
    };
    this.hot = new Handsontable(element, settings);
    Handsontable.hooks.add('afterRenderer', adminProduct.afterRenderer, this.hot);
  }

  adminProduct.loadData = function() {
    $('#product_list').LoadingOverlay('show');
    getAjax(
      'list.json',
      {
        shop_id: $('#select_shop').val(),
        product_category_id: $('#select_category').val(),
        shortage: $('#shortage:checked').val(),
        search: $('#shop-product-search').val()
      },
      function(data) {
        adminProduct.getHot().loadData(data);
        $('#product_list').LoadingOverlay('hide');
      }
    );
  }

  adminProduct.addRow = function() {
    this.hot.alter('insert_row', this.hot.countRows());
    this.hot.setDataAtRowProp(this.hot.countRows() - 1, 'shop_id', $('#select_shop').val());
    this.hot.setDataAtRowProp(this.hot.countRows() - 1, 'product_category_id', $('#select_category').val());
    this.hot.selectCell(this.hot.countRows() - 1, this.hot.propToCol('shop_alias_name'));
  }

  adminProduct.import = function() {
    $('#product_list').LoadingOverlay('show');
    $('#import').prop('disabled', true);
    var sourceData = adminProduct.getHot().getSourceData();
    var import_product_ids = [];
    for(var i=0, length=sourceData.length; i < length; i++){
      if(typeof sourceData[i].selected !== 'undefined' && sourceData[i].selected && !sourceData[i].exist_shop_product){
        import_product_ids.push(sourceData[i].id)
      }
    }

    if(import_product_ids.length < 1){
      $('#product_list').LoadingOverlay('hide');
      $('#import').prop('disabled', false);
      return;
    }

    var params = {
      shop_id: $('#select_shop').val(),
      import_product_ids: import_product_ids,
    };
    putAjax(
      'import.json',
      params,
      function(data) {
        $('#product_list').LoadingOverlay('hide');
        $('#import').prop('disabled', false);
        if (data.msg === 'success') {
          adminProduct.loadData();
        } else {
          alert(data.msg);
          adminProduct.loadData();
        }
      },
      true
    );
  }

  adminProduct.emptyValidator = function(value, callback) {
    if (value === undefined || value === null || value === "") {
      callback(false);
    } else {
      callback(true);
    }
  }

  adminProduct.keyValueRender = function (instance, td, row, col, prop, value, cellProperties) {
    var label = value;
    if (value === undefined || value === null || value === '') {
      td.innerHTML = Handsontable.helper.stringify(label);
      return;
    }
    switch (prop) {
      case 'product_category_id':
        label = adminProduct.getCategory()[value];
        break;
      case 'brand_id':
        label = adminProduct.getBrand()[value];
        break;
      case 'variant_id':
        label = adminProduct.getVariant()[value];
        break;
      case 'tech_spec_id':
        label = adminProduct.getTechSpec()[value];
        break;
      case 'admin_product_id':
        var category = instance.getDataAtRowProp(row, 'product_category_id');
        label = adminProduct.getAdminProduct(category)[value];
        break;
      case 'exist_shop_product':
        var bool = instance.getDataAtRowProp(row, 'exist_shop_product');
        label = bool ? 'Yes' : 'No';
        break;
      default:
        break;
    }
    td.innerHTML = Handsontable.helper.stringify(label);
    return td;
  }

  adminProduct.getCategory = function() {
    if (Object.keys(adminProduct.getCacheProductCategory()).length === 0) {
      var list = {};
      getAjax(
        'product_categories.json',
        null,
        function(data) {
          list = data;
        },
        false
      );
      adminProduct.setCacheProductCategory(list);
    }
    return adminProduct.getCacheProductCategory();
  }

  adminProduct.getBrand = function() {
    if (Object.keys(adminProduct.getCacheBrand()).length === 0) {
      var list = {};
      getAjax(
        'brands.json',
        null,
        function(data) {
          list = data;
        },
        false
      );
      adminProduct.setCacheBrand(list);
    }
    return adminProduct.getCacheBrand();
  }

  adminProduct.getVariant = function() {
    if (Object.keys(adminProduct.getCacheVariant()).length === 0) {
      var list = {};
      getAjax(
        'variants.json',
        null,
        function(data) {
          list = data;
        },
        false
      );
      adminProduct.setCacheVariant(list);
    }
    return adminProduct.getCacheVariant();
  }

  adminProduct.getTechSpec = function() {
    if (Object.keys(adminProduct.getCacheTechSpec()).length === 0) {
      var list = {};
      getAjax(
        'tech_specs.json',
        null,
        function(data) {
          list = data;
        },
        false
      );
      adminProduct.setCacheTechSpec(list);
    }
    return adminProduct.getCacheTechSpec();
  }

  // adminProduct.getAdminProducts = function(row, col, prop) {
  //   var category = adminProduct.getHot().getDataAtRowProp(row, 'product_category_id');
  //   return adminProduct.getAdminProduct(category);
  // }

  adminProduct.afterRenderer = function(td, row, col, prop, value, cellProperties) {
    var isUse = adminProduct.getHot().getDataAtRowProp(row, 'is_use');
    if (!isUse) {
      td.className += ' deactive';
    }
    return td;
  }

  adminProduct.getAdminProduct = function(category) {
    if (
      Object.keys(adminProduct.getCacheAdminProduct(category)).length === 0
    ) {
      var list = {};
      var params = {};
      if (category != undefined || category != "") {
        params = {
          product_category_id: category
        };
      }
      getAjax(
        'admin_products.json',
        params,
        function(data) {
          list = data;
        },
        false
      );
      adminProduct.setCacheAdminProduct(category, list);
    }
    return adminProduct.getCacheAdminProduct(category);
  }

  adminProduct.selectAll = function(){
    var sourceData = adminProduct.getHot().getSourceData();
    for(var i=0, length=sourceData.length; i < length; i++){
      if(!sourceData[i].exist_shop_product){
        sourceData[i].selected = true
      }
    }
    adminProduct.getHot().loadData(sourceData);
  }

  adminProduct.deselectAll = function(){
    var sourceData = adminProduct.getHot().getSourceData();
    for(var i=0, length=sourceData.length; i < length; i++){
      sourceData[i].selected = false
    }
    adminProduct.getHot().loadData(sourceData);
  }

  function getAjax(url, data, callback, async) {
    coreAjax('GET', url, data, callback, async);
  }

  function postAjax(url, data, callback, async) {
    coreAjax('POST', url, data, callback, async);
  }

  function putAjax(url, data, callback, async) {
    coreAjax('PUT', url, data, callback, async);
  }

  function coreAjax(method, url, data, callback, async) {
    if (async == null) {
      async = true;
    }
    url = '/api/admin/admin_products/' + url
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

  onPageLoad("admin_products#index", function() {
    adminProduct.buildHot();
    adminProduct.loadData();

    $("#reload").on("click", function(){
      adminProduct.loadData();
    });
    $("#select_shop").on("change", function(){
      adminProduct.loadData();
    });
    $("#select_category").on("change", function(){
      adminProduct.loadData();
    });
    $("#shortage").on("change", function(){
      adminProduct.loadData();
    });
    $('select[name="select_shop"]').select2();
    $('#select_category').select2();
    $("#add_row").on("click", function(){
      adminProduct.addRow();
    });
    $("#import").on("click", function(){
      setTimeout(function(){adminProduct.import();}, 0);
    });
    $('#print').on("click", function(){
      adminProduct.print();
      return false;
    });
    $('#shop-product-search-btn').on("click", function(){
      adminProduct.loadData();
    });
    $('#selectAll').on("click",function(){
      adminProduct.selectAll();
      // $(this).hide();
      // $('#deselectAll').show();
      return false;
    });
    $('#deselectAll').on("click",function(){
      adminProduct.deselectAll();
      // $(this).hide();
      // $('#selectAll').show();
      return false;
    });

    // suggest debug
    // $('#search').on('click',function(){
    //   var data = {
    //     shop_id: $('#select_shop').val(),
    //     product_category_id: $('#select_category').val(),
    //     search_word: $('#search_word').val()
    //   }
    //   $.ajax({
    //     url: '/api/shop_products/suggest.json',
    //     type: 'GET',
    //     dataType: 'json',
    //     data: data,
    //   }).fail(function (xhr, status, error) {
    //     console.error(error);
    //   }).done(function (data) {
    //     console.log(data);
    //   });
    // });
  });

})(adminProduct || (adminProduct = {}));
