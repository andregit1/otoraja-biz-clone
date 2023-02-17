var notifications = function(){};

(function(notifications) {

  notifications.cache = []

  notifications.getCache = function(){
    return this.cache
  };

  notifications.setCache = function(objs){
    this.cache = objs;
  };
  
  onPageLoad("notifications", 
  function() {

    $('#notification_published_from').daterangepicker({
      "singleDatePicker": true,
      "timePicker": true,
      "timePicker24Hour": true,
      "autoUpdateInput": false,
      "locale": {"format": "DD/MM/YYYY HH:mm"}
    },function (date) {
      $('#notification_published_from').val(date.format('DD/MM/YYYY HH:mm'));
    });

    $('#notification_published_to').daterangepicker({
      "singleDatePicker": true,
      "timePicker": true,
      "timePicker24Hour": true,
      "autoUpdateInput": false,
      "locale": {"format": "DD/MM/YYYY HH:mm"}
    },function (date) {
      $('#notification_published_to').val(date.format('DD/MM/YYYY HH:mm'));
    });
  });

  onPageLoad("notifications#new", 
  function() {
    $('#notification_published_from').val(moment().format("DD/MM/YYYY HH:mm"));
  })
  
})(notifications || (notifications = {}));
