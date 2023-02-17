var subscription = function() {
};
(function(subscription) {
  "use strict";

  subscription.getTimeRemaining = function (endtime) {
    const total = Date.parse(endtime) - Date.parse(new Date());
    const seconds = Math.floor( (total/1000) % 60 );
    const minutes = Math.floor( (total/1000/60) % 60 );
    const hours = Math.floor( (total/(1000*60*60)) % 24 );
  
    return {
      total,
      hours,
      minutes,
      seconds
    }; 
  }

  subscription.initializeClock = function (endtime) {
    const hoursSpan = $('.hours');
    const minutesSpan = $('.minutes');
    const secondsSpan = $('.seconds');
  
    function updateClock() {
      const t = subscription.getTimeRemaining(endtime);
      hoursSpan.html(t.hours.toLocaleString('en-US', { minimumIntegerDigits: 2 }));
      minutesSpan.html(t.minutes.toLocaleString('en-US', { minimumIntegerDigits: 2 }));
      secondsSpan.html(t.seconds.toLocaleString('en-US', { minimumIntegerDigits: 2 }));
  
      if (t.total <= 0) {
        clearInterval(timeinterval);
        location.reload();
      }
    }
  
    updateClock();
    const timeinterval = setInterval(updateClock, 1000);
  }

  onPageLoad("subscriptions", function() {
    $('[data-toggle="popover"]').popover({
      trigger: "focus"
    })

    $("#va-copy").on("click", function() {
      let va_number = $("#va-number").text()
      navigator.clipboard.writeText(va_number)
      setTimeout(() => { 
        $('[data-toggle="popover"]').popover("dispose")
      }, 1500);
    });

    $("#instruction-btn-1, #instruction-btn-2, #instruction-btn-3").on("click", function() {
      $(this).find(".fas").toggleClass("fa-angle-up fa-angle-down")
    })

    subscription.initializeClock($('#countdown-expired').data('expired'))
  });
})(subscription || (subscription = {}));
