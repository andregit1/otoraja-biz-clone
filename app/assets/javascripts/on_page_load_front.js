(function() {
  var isOnPage, regularize;

  this.onPageLoad = function(controller_and_actions, callback) {
    return $(document).ready(function() {
      var conditions;
      conditions = regularize(controller_and_actions);
      if (!conditions) {
        console.error('[onPageLoad] Unexpected arguments!');
        return;
      }
      return conditions.forEach(function(a_controller_and_action) {
        var action, controller, ref;
        ref = a_controller_and_action.split('#'), controller = ref[0], action = ref[1];
        if (isOnPage(controller, action)) {
          return callback();
        }
      });
    });
  };

  regularize = function(controller_and_actions) {
    if (typeof controller_and_actions === 'string') {
      return [controller_and_actions];
    } else if (Object.prototype.toString.call(controller_and_actions).includes('Array')) {
      return controller_and_actions;
    } else {
      return null;
    }
  };

  isOnPage = function(controller, action) {
    var selector;
    selector = "body[data-controller='" + controller + "']";
    if (action) {
      selector += "[data-action='" + action + "']";
    }
    return $(selector).length > 0;
  };

}).call(this);
