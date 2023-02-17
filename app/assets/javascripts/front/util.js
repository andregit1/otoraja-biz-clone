(function () {
  'use strict';

  window.app = window.app || {}
  var util = window.app.util = {};

  util.formatRupiah = function(price){
    return price.toString().replace(/(\d)(?=(\d{3})+$)/g , '$1.');
  }

}.call(this));