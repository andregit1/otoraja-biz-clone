(function () {
  'use strict';

  var checkins = checkins || {};
  var suggest_load_count = 0;

  checkins.showLoading = function() {
    $('.wrapper').LoadingOverlay('show', {size: 20});
  }

  checkins.hideLoading = function (){
    $('.wrapper').LoadingOverlay('hide');
  }

  checkins.addCalendarEvent = function() {
    $("#open_checkin_calender").on('click', function(event){
      $("#calendar").html("");
      $("#calendar").calendar({
        locale:"id-ID",
        selectedDate: moment($('#selected_date').val(), 'YYYY-MM-DD').toDate(),
        onSelect: function(date, self){
          $('#selected_date').val(moment(date, 'DD.MM.YYYY').format('YYYY-MM-DD'));
        }
      });
      $(document).trigger('calendar_open', event);
    });
    $('#calendar-button button').on('click', function() {
      // checkins.showLoading();
      // location.href = `/checkin/${$('#selected_date').val()}`;
      checkins.searchByDate();
    });
  }

  checkins.searchPrevCheckins = function(e) {
    var prevDate = moment($('#selected_date').val(), 'YYYY-MM-DD').subtract(1, 'days');
    $('#selected_date').val(prevDate.format('YYYY-MM-DD'));
    checkins.searchByDate();
  }

  checkins.searchNextCheckins = function(e) {
    var nextDate = moment($('#selected_date').val(), 'YYYY-MM-DD').add(1, 'days');
    $('#selected_date').val(nextDate.format('YYYY-MM-DD'));
    checkins.searchByDate();
  }

  checkins.restyleObject = function() {
    var selectedDate = $('#selected_date').val();
    var today = $('#today').val();
    if (selectedDate === today) {
      $('#next_checkins').addClass('disabled');
    } else {
      $('#next_checkins').removeClass('disabled');
    }
    $('#displaySelectedDate').html(moment(selectedDate, 'YYYY-MM-DD').format('DD.MM.YYYY'));
  }

  checkins.searchByDate = function() {
    checkins.restyleObject();
    var selectedDate = $('#selected_date').val();
    var today = $('#today').val();
    var url = '/api/customers/checkin';
    if (selectedDate !== today) {
      url = url + '/' + selectedDate;
    }
    checkins.showLoading();
    $.ajax({
      url: url,
      dataType: "html"
    }).done(function(data) {
      var result = $(data);
      var unchecked_out = result.find('#search_unchecked_out');
      var checked_out = result.find('#search_checked_out');
      var all = result.find('#search_all');
      $('#unchecked_out').html(unchecked_out.html());
      $('#checked_out').html(checked_out.html());
      $('#all').html(all.html());
    }).always(function(data) {
      checkins.hideLoading();
    });
  }

  checkins.suggest = function(e) {
    var word = $('#search_word').val();
    if (word.length < 3) {
      return;
    }
    suggest_load_count++;
    checkins.searching();
    checkins.activeSuggest();
    $.ajax({
      url: "/api/customers/search_checkin",
      dataType: "html",
      data: {
        search_word: word
      }
    }).done(function(data) {
      var result = $(data);
      var unchecked_out = result.find('#search_unchecked_out');
      var checked_out = result.find('#search_unchecked_out');
      var all = result.find('#search_all');
      $('#search_unchecked_out').html(unchecked_out.html());
      $('#search_checked_out').html(checked_out.html());
      $('#search_all').html(all.html());
    }).always(function(data) {
      suggest_load_count--;
      checkins.unsearching();
    });
  }

  checkins.activeSuggest = function() {
    $('#search_result').show();
    $('#calendar_result').hide();
  }

  checkins.deactiveSuggest = function() {
    $('#search_result').hide();
    $('#calendar_result').show();
    checkins.unsearching();
  }

  checkins.searching = function() {
    $('#searching').removeClass('hide');
    $('#unsearching').addClass('hide');
  }

  checkins.unsearching = function() {
    if (suggest_load_count <= 0) {
      $('#unsearching').removeClass('hide');
      $('#searching').addClass('hide');
    }
  }

  checkins.adjustHeight = function() {
    var ot1 = $('#main .tab-content').offset().top;
    var ot2 = $('#footer-bar').offset().top;
    $('#main .tab-content').outerHeight(ot2 - ot1);
  }

  checkins.init = function() {
    checkins.searchByDate();
    checkins.addCalendarEvent();
    checkins.adjustHeight();
    $('#prev_checkins').on('click', checkins.searchPrevCheckins);
    $('#next_checkins').on('click', checkins.searchNextCheckins);
    $('#search_word').keyup(function(e) {
      clearTimeout($.data(this, 'timer'));
      var wait = setTimeout(checkins.suggest(e), 500);
      $(this).data('timer', wait);
    });
    $('#close_search_result').on('click', function() {
      checkins.deactiveSuggest();
    });
  }

  onPageLoad("checkin", function () {
    checkins.init();
  });
}.call(this));
  