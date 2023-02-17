(function () {
  'use strict';
  var modal = modal || {};
  modal.init = function(){
    $(document).on('click','.js-modal-open',function(){
      let target = $(this).data('target');
      let modal = $(target);
      $(modal).fadeIn();
      $(modal).find('.modal_content').addClass('slide').trigger('modal_open',`#${$(modal).attr('id')}`);

      scrollLock();
      return false;
    });
    $(document).on('click','.js-modal-close',function(){
      let target = $(this).data('target');
      let modal = $(target);
      $(modal).fadeOut();
      $(modal).find('.modal_content').removeClass('slide');
      $(modal).trigger('modal_close', `#${$(modal).attr('id')}`)

      if($('.slide').length == 0) {
        scrollLockCancel();
      }
      return false;
    });

    var current_scrollY = null;
    function scrollLock() {
      // 2つ目のモーダルを開いた時の位置を取得すると0のため、取得しないようにする
      if(current_scrollY == null) {
        current_scrollY = $(window).scrollTop();
      }
      $('body').css({
        position: 'fixed',
        top: -1 * current_scrollY
      });
    }

    function scrollLockCancel() {
      $('body').attr('style', '');
      $('html, body').prop({scrollTop: current_scrollY});
      current_scrollY = null;
    }
  }

  $(document).ready(function() {
    modal.init();
  });
}.call(this));
  