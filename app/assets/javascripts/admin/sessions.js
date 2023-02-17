var sessions = function() {
};
(function(sessions) {
  'use strict';

  sessions.validateFormMandatory = function() {
    var isValid = false;
    if($("#user_id_field").val().length>4 && $("#password_field").val().length>4){
      isValid = true;
    }
    return isValid;
  }

  onPageLoad(["sessions#new", "session#create"], function() {
    $("#new_user").on("keyup change", function(){
      $("#button_login").attr("disabled", !sessions.validateFormMandatory());
    });
  });

  
})(sessions || (sessions = {}));
