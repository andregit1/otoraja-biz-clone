var notifications = function(){};

(function(notifications) {
 
  onPageLoad("notifications", 
  function() {
    $('#sort').select2();
    $('#tag').select2();

    $('.show-detail').on('click', function(e){
      e.preventDefault()
      var requested_to = $(this).attr("href")
      $('#notif-detail-dialog').modal('show')
      $('#notif-detail-dialog .modal-body').hide();
      $('.loading-wrapper').each(function(i, e){
        $(e).LoadingOverlay("show", {
          background  : "unset",
          size: "50px"
        });
        $('.loading-txt').show();
        $('.loading-margin').show();
      })
      $('#notif-detail-dialog .modal-body').load(requested_to + ' div.show-detail_notif', function(){
        $('.loading-wrapper').LoadingOverlay('hide');
        $('.loading-txt').hide();
        $('.loading-margin').hide();
        $('#notif-detail-dialog .modal-body').show();
      });
    });

  });

})(notifications || (notifications = {}));
