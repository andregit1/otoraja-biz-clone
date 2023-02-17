(function() {
  onPageLoad("makers#index", function() {
    $('.rowup').click(function() {
      let $row = $(this).closest("tr");
      if($row[0].rowIndex != 1) {
        let $row_prev = $row.prev("tr");
        if($row.prev.length) {
          $row.insertBefore($row_prev);
          $(order_change).attr("disabled", false);
        }
      }
    });

    $('.rowdown').click(function() {
      let $row = $(this).closest("tr");
      let $row_next = $row.next("tr");
      if($row_next.length) {
        $row.insertAfter($row_next);
        $(order_change).attr("disabled", false);
      }
    });

    $('#order_change').click(function() {
      var tblTbody = document.getElementById('maker_table');
      var list = [];
      for(var i=0, rowLen = tblTbody.rows.length; i < rowLen; i++) {
        if(i+1 != $('tr')[i+1].dataset.order) {
          var data = {
            id: $('tr')[i+1].dataset.makerId,
            order: i + 1
          }
          list.push(data);
        }
      }
      if(list.length > 0) {
        url = '/console/makers'
        $.ajax({
          url: url + '/order_update',
          method: 'PATCH',
          dataType: "json",
          data: {
            data: JSON.stringify(list)
          }
        }).fail(function (error) {
          console.error(error);
        }).done(function () {
          location = url;
        });
      } else {
        $(order_change).attr("disabled", true);
      }
    });
  });
}.call(this));
