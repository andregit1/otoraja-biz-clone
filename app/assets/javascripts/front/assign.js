(function () {
  var is_assign_first = true;
  var $select2 = '';
  onPageLoad("assign", function () {

    $('#checkin-datepicker').datepicker({
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayBtn: 'linked',
      todayHighlight: true,
      language: 'id',
      maxViewMode: 0,
      endDate: $('#today').val(),
    }).on('changeDate', function(e) {
      if (e.dates.length === 0) return;
      date = new Date(e.date);
      location = '/assign/' + date.getFullYear() + '-' + (date.getMonth() + 1) + '-' + date.getDate();
    });
    

    $(document).on('change','.input-main-mechanic-id',function(){
      var val = $(this).val();
      var $branch = $(this).parent().parent();
      $branch.find('.list-group .list-group-item').each(function(){
        var select = $(this).find('select');
        if(select.val().length == 0){
          select.val(val).trigger('change');
        }
      });
    });

    $select2 = $('.select2').select2();
  });
}.call(this));
  