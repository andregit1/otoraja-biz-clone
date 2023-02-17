(function() {
  onPageLoad("customers", function() {
    let url = window.location.href
    let decodeUrl = decodeURI(url);
    if (!decodeUrl.includes('commit')) {
      $('#q_name').attr('checked', 'checked')
      $('#q_tel').attr('checked', 'checked')
      $('#q_owned_bikes_number_plate_number').attr('checked', 'checked')
    } else {
      decodeUrl.includes('customer_name') ? $('#q_name').attr('checked', 'checked') : $('#q_name').removeAttr('checked');
      decodeUrl.includes('customer_tel') ? $('#q_tel').attr('checked', 'checked') : $('#q_tel').removeAttr('checked');
      decodeUrl.includes('customer_plat') ? $('#q_owned_bikes_number_plate_number').attr('checked', "checked") : $('#q_owned_bikes_number_plate_number').removeAttr('checked'); 
    }

    $('#select-search-field').on('change', function() {
      $('.text-field').hide().attr('disabled', true);
      $('#' + $(this).val()).show().attr('disabled', false);
    })
    .trigger('change')
    .select2({ minimumResultsForSearch: -1 });

    $('#search-clear-btn').on('click', function(){
      $('.text-field').val('');
      $('#customer-search').submit();
    });

    $('#search-btn').on('click', function() {
      $('#customer-search').submit();
    });

    $("input").on("keydown", function(e) {
      if ((e.which && e.which === 13) || (e.keyCode && e.keyCode === 13)) {
        $('#customer-search').submit();
      }
    });

    if ($('.text-field:visible').val()) {
      $('#search-clear-btn').show();
    } else {
      $('#search-clear-btn').hide();
    }

    var typingTimer;
    $("#tmp_tel").on("keyup", function(){
      clearTimeout(typingTimer);
      typingTimer = setTimeout(check_phone_number, 1000);
    })

    $("#remove_tmp_tel").on("click", function(e){
      e.preventDefault();
      $.get($(this).attr("href"), {id: $("#id").val()},function(){
        $("#tmp_tel").fadeOut(300, function(){ $("#max_request_alert").remove();});
      });
    })

    $("#request_token").on("click", function(e){
      e.preventDefault();
      $(".fa-spinner").removeClass("d-none");
      $.ajax({
        method: "GET",
        url: $(this).attr("href"),
        data: {id: $("#id").val()},
        dataType: "json",
        success: function(response){
          if(response.hasOwnProperty("locked_until")){
            $("#alert_message").html(response.message);
            $("#max_request_alert").removeClass("d-none");
            $(".request_token").remove()
          }
          else{
            $("#request_token").addClass("d-none")
            $("#token_request_count").html(response.token_request_count)
            countDown(response.countdown);
          }
        }
      })
    })

    function check_phone_number(){
      let tmp_tel = $("#tmp_tel");
      let customer_id = $("#customer_id").val();

      let tmp_tel_sanitized = tmp_tel.val().replace(/[^0-9]+/g, '')
    
      $(".error").addClass("d-none");
      tmp_tel.removeClass("is-invalid");
      $("#registered_phone_alert").addClass("d-none")
      $("#error-message").empty()

      if(tmp_tel_sanitized.length == 0){ 
        $("#save").prop("disabled", false) 
        return 
      }

      if(tmp_tel_sanitized.length <= 9 && tmp_tel_sanitized.length >= 1){
        $("#save").prop("disabled", true)
        return
      }

      if(tmp_tel_sanitized.indexOf('0') == 0) tmp_tel_sanitized = tmp_tel_sanitized.replace("0", "62")

      tmp_tel.val(tmp_tel_sanitized)

      $.ajax({
        method: "GET",
        url: "/admin/customers/check_phone_number",
        data: {tmp_tel: tmp_tel_sanitized, id: customer_id},
        dataType: "json",
        beforeSend: function () { // Before we send the request, remove the .hidden class from the spinner and default to inline-block.
          $(".fa-spinner").removeClass("d-none");
        }, 
        success: function(response){
          $(".fa-spinner").addClass("d-none");

          if(response.success){
            $("#save").prop("disabled", false)
          }
          else{
            tmp_tel.addClass("is-invalid");
            $(".error").removeClass("d-none");
            $(".fa-spinner").addClass("d-none");
            $("#save").prop("disabled", true);
            if (response.error == 1)
              $("#error-message").html(response.message)
            else if(response.error == 2)
              $("#registered_phone_alert").removeClass("d-none")
          }
        },
        error: function(response){
          tmp_tel.addClass("is-invalid");
          $(".error").removeClass("d-none");
          $(".fa-spinner").addClass("d-none");
          $("#save").prop("disabled", true);
          $("#error-message").html("Internal server error")
        }
      });
      
    }

    function countDown(dro = 0){
        var es = $('#countdown');
        if(dro > 0){
          dro--;
          es.html("Tunggu " + dro);
          let t = setTimeout(function(){
            countDown(dro);
          }, 1000);
        }
        else{
          es.html('');
          $("#request_token").removeClass("d-none")
          $(".fa-spinner").addClass("d-none");
        }
    }

    check_phone_number()
  });
}.call(this));