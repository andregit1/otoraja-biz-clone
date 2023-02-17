(function () {
  onPageLoad(["product_categories#new", "product_categories#edit"], function () {
    var use_reminder_element = $('#product_category_use_reminder');
    var remind_grouping_element = $('#product_category_remind_grouping');

    use_reminder_element.bootstrapToggle();
    remind_grouping_element.bootstrapToggle();

    productClassCheck();
    $('#product_category_product_class_id').change(function() {
      productClassCheck();
    });

    // 商品クラスがPARTS以外のとき、リマインダ設定不可 & OFF
    function productClassCheck() {
      if( $('#product_category_product_class_id option:selected').text() == 'PARTS' ) {
        use_reminder_element.parent().removeClass('disabled');
        remind_grouping_element.parent().removeClass('disabled');

        use_reminder_element.prop("disabled", false);
        remind_grouping_element.prop("disabled", false);
      } else {
        use_reminder_element.parent().addClass('off');
        remind_grouping_element.parent().addClass('off');

        use_reminder_element.parent().addClass('disabled');
        remind_grouping_element.parent().addClass('disabled');

        use_reminder_element.prop("disabled", true);
        remind_grouping_element.prop("disabled", true);
      }
    }
  });
}.call(this));
