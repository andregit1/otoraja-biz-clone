(function () {
  onPageLoad("shop_staffs", function () {
    $('#staff-select-shop').select2();
    $('.use-select2').select2({containerCssClass: "text-normal", dropdownCssClass: "text-normal"});
    $('.custom-checkbox').bootstrapToggle({
      width: '15%'
    });
    var is_mechanic = $('#shop_staff_is_mechanic').prop('checked');
    if(!is_mechanic) {
      $('#shop_staff_mechanic_grade').prop('disabled',true);
    }
    
    $(document).on('change','#shop_staff_is_mechanic',function(){
      if($(this).prop('checked')){
        $('#shop_staff_mechanic_grade').prop('disabled',false);
      } else {
        $('#shop_staff_mechanic_grade').prop('disabled',true);
      }
    });
  });
}.call(this));
  