(function() {

  function setWeekDays(date) {
    if(date.getDay() == 0){
      return date.setDate(date.getDate() + 1);
    }
    else if(date.getDay() == 6){
      return date.setDate(date.getDate() + 2);
    }
    else{
      return date;
    }
  }

  function formatedDateUseDash(date) {
    let year = new Intl.DateTimeFormat('id', { year: 'numeric' }).format(date);
    let month = new Intl.DateTimeFormat('id', { month: 'short' }).format(date);
    let day = new Intl.DateTimeFormat('id', { day: '2-digit' }).format(date);
    return `${day}-${month}-${year}`;
  }

  onPageLoad("shop_configs", 
  function() {
    $('#id_check_box').click(function() {
      if(this.checked){
        $('#extension_days').removeAttr('disabled');
        $('#extension_days').attr('required',true);
      }else{
        $('#extension_days').removeAttr('required');
        $('#extension_days').attr('disabled', 'disabled');
        $('#extension_days').val('');
        $('#extension_date').empty()
      }
    });

    $('#extension_days').on('change',function () {
      if($(this).val()){
        let grace_period_date = new Date($('#extension_date').data('grace-period'));
        let expiration_date = new Date($('#extension_date').data('expiration-date'));
        let interval_days = parseInt($(this).val());
        let extension_date = '';
        let date_today = new Date();
        
        if(date_today > expiration_date){
          extension_date = grace_period_date > date_today ? grace_period_date : date_today;
        }else{
          extension_date = grace_period_date > expiration_date ? grace_period_date : expiration_date;
        }

        extension_date.setDate(extension_date.getDate() + interval_days);
        $('#extension_date').html(formatedDateUseDash(setWeekDays(extension_date)));
      }else{
        $('#extension_date').empty()
      }
    });
  });
}.call(this));
  