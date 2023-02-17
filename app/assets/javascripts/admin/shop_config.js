(function() {
    'use strict'

    var shop = shop || {};

    shop.init = function()
    {
      var $modal = $("#editTagModal");
      var $selected = {}
      var $edit_input = $("#edit-tag-input");
      var $submit = $("#shop-update-btn");
      var $btn_edit = $('#shop_multiselect_edit');
      var isSubmitted = false;

      $('#shop_multiselect').multiselect({
        keepRenderingSort: true
      });

      $("#shop_multiselect_edit").on("click", function(){
        $selected = $("#shop_multiselect_to option:selected");
        if($selected.length>0){
          $modal.modal("show");
          $edit_input.val($selected.text());
        }
      });

      $modal.on('hidden.bs.modal', function(event){
        $selected.text($edit_input.val());
      });

      $submit.on("click", function(event){
        if(!isSubmitted){
          event.preventDefault();
          var data = []
          var $select = $("#shop_multiselect_to option");

          $select.each(function(index,item){
            item = $(item);
            data.push({
                id: item.val(),
                name: item.text(),
                order: index+1,
                is_using: true
            })
          })

          if(data.length==0)
          {
            isSubmitted = true
            $submit.trigger("click");
            return;
          }
          
          $.ajax({
            url: '/console/shop_configs/search_tags',
            type: 'POST',
            dataType: 'json',
            data: {
              data : JSON.stringify(data),
              id : $select.eq(0).data("shop")
            },
            success : function(e){
              isSubmitted = true
              $submit.trigger("click")
            }
          });
        }
      });

      $('#shop_multiselect_to').change(function(){
        var $selected = $("option:selected",this);

        if($selected.length > 1){
          $btn_edit.prop('disabled',true);
        } else {
          $btn_edit.prop('disabled',false)
        }
      });
    };

    onPageLoad("shop_configs", 
    function() {
      shop.init();
    });
  }.call(this));
  