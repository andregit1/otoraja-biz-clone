//UI Components
//number pad
(function ($) {
 
    $.fn.numberPad = function( options ) {
 
      var settings = $.extend({
        //defaults.
        minDigit : 0,
        maxDigit : 9,
        showBackspace : true,
        showDecimal : true,
        useDecimal : false,
        nodeClassName: "btn-pad",
        gridShapeY:　3,
        grigShapeX: 'auto',
        nodeWidth: 50,
        nodeHeight: 50,
        truncateDecimal: 2,
        onInput: null,
        locale: "id-ID",
        localeOptions: {style: 'currency', currency: 'IDR'},
        targetValue: null,
        targetTotal: null,
        discountType: '%',
        currentValue: "",
        showQuickButtons: false,
        quickButtons: ['10k','20k','50k','100k']
        
      }, options );
      
      settings.prevValue = "";
      settings.localeValue = "";

      createNumberPad(this, settings)
      addEventListeners(this, settings)

      return;
 
    };
  
  function createNumberPad(element, settings){
    var arr = new Array()
    for(var i = settings.minDigit;i < (settings.maxDigit+1);i++){
      arr.push(i);
      if(settings.showQuickButtons){
        if(i%(settings.gridShapeY-1)==0){
           switch(i){
             case 0:
               arr.push(settings.quickButtons[3])
              break;
              case 3:
               arr.push(settings.quickButtons[2])
              break;
              case 6:
               arr.push(settings.quickButtons[1])
              break;
              case 9:
               arr.push(settings.quickButtons[0])
              break;
           }
        }
      }
      
    }
    arr.reverse();
    var id = (new Date().getTime());
    var container = `<div id='${id}' class='number-pad'></div>`
    var order = 100;
    element.append(container);
    var size = `1 0 ${(100/settings.gridShapeY).toFixed(0)-2}%`;
    arr.forEach(function(item, index){
            
      var html = `<div class='${settings.nodeClassName} digit'>${item}</div>`
     
      html = $(html).css({
          flex:size,
          'height':`${settings.nodeHeight}px`,
          'width':`${settings.nodeWidth}px`,
          'order': order++ 
      })
      
      html = $(html).data("value", item)
      
      element.find(`#${id}`).append(html);
    });
    
    if(settings.showBackspace){

      var html = `<div class='${settings.nodeClassName} backspace fas fa-backspace'></div>`
      
      html = $(html).css({
          flex:size,
          'order': settings.showQuickButtons ? order-(settings.gridShapeY-2): order-(settings.gridShapeY-1)
      })
      
      element.find(`#${id}`).append(html);
      
    }
    
    if(settings.showDecimal){
      var html = `<div class='${settings.nodeClassName} decimal'>.</div>`
      
      html = $(html).css({
          flex:size,
          'order': order+1
        })
      
      element.find(`#${id}`).append(html);
      
    }

    if(settings.showQuickButtons){
      var html = `<div class='${settings.nodeClassName} exact-amount'>Exact Amount</div>`
      
      html = $(html).css({
          flex:size,
          'order': order+1
        })
      
      element.find(`#${id}`).append(html);
    }
  }

  function addEventListeners(element, settings){

    $(document).on('picker_close', function(event){
      settings.currentValue = '';
    })

    $(document).on('picker_open', function(event, data){
      settings.currentValue = data.toString();
    })

    $(document).on('number_pad_target_update', (event, data)=>{
      settings.targetValue = data.target;
      settings.currentValue = data.inputValue;
    })

    $(document).on("number_pad_keyboard_update", (event, data) => {
      event.stopImmediatePropagation();

      settings.targetValue = data.target;
      settings.currentValue = data.inputValue.replace(/\./g, "");

      updateInput(element, settings);
    });
 
    element.delegate(".btn-pad", "click", function(event) {
      updateInput(element, settings);
    });
  }

  function updateInput(element, settings) {
    var temp = settings.currentValue;
      settings.prevValue = temp;
      if($(event.target).hasClass("digit")){
        var input = Number.parseInt(String($(event.target).data('value')).replace(/k/,''))
        var mimQuicButton = Number.parseInt(settings.quickButtons[0].replace(/k/,''))
        if(temp.length==0&&input==0)
          return;
        if(input>=mimQuicButton){
          input = input*1000
          temp = isNaN(parseInt(temp)) ? "0" : temp
          temp = (parseInt(temp)+parseInt(input)).toString()
        }else{
          temp = `${temp}${input}`
        }
      }
      
      if($(event.target).hasClass("backspace")){
        if(temp)
        temp = temp.substring(0,temp.length-1);
        if(!$.isNumeric(temp))
          temp = '';
      }

      if($(event.target).hasClass("exact-amount")){
        temp = $("#order_total").rpToNumber().toString();
      }
      
      if(settings.useDecimal){
        if($(event.target).hasClass("decimal")){
          if(temp.toString().indexOf('.')===-1){
            temp = `${temp}.`
            settings.currentValue = temp
          }
        }
        if(settings.truncateDecimal>0){
          temp = truncateOutput(temp, settings)
        }
      }
      
      settings.currentValue = temp;
      if(temp=='')
        temp = "0";
      settings.localeValue = parseFloat(temp).toLocaleString(settings.locale, settings.localeOptions).substring("3")
      
      if(settings.onInput&&typeof(settings.onInput)==='function'){
        settings.onInput(settings.currentValue, settings.prevValue, settings);
        emitChangedEvent(element, settings);
      } 
  }

  function truncateOutput(value, settings){
    if(typeof(value)!=='string')
      value = '';
    if(value.indexOf('.')!=-1){
      var parts = value.split('.');
      var fraction = parts[1].substring(0,settings.truncateDecimal);
      return `${isNaN(parts[0]) ? "0" : parts[0]}.${fraction}`;
    }else
      return value;

  }

  function emitChangedEvent(element, settings){
    var data = {currentValue: settings.currentValue, prevValue: settings.prevValue}
    var name = "numberPad.changed";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    element[0].dispatchEvent(event);
    $(element).trigger(name, data)
  }
}( jQuery ));

//color pills
(function($){
  $.fn.colorPill = function(options){
    
    var settings = $.extend({
      items : null,
      style: "badge badge-pill badge-grey",
      callback: null,
    },options);
    
    if(!Array.isArray(settings.items))
      return;
    var self = this;
    settings.uniqueClass = `o-${new Date().getTime()}`;
    settings.items.forEach(function(item, index){
      var color = `var(--bike-${item})`;
      var element = `<div></div>`;

      element = $(element)
      .addClass(settings.style)
      .addClass(settings.uniqueClass);

      element = $(element).text(item);

      $(element)
      .prepend("<span></span>")
      .find("span")
      .css({"background": `${color}`})
      .addClass("artifact");

      self.append(element);
      addEventListener(element, item, settings);
    })

    return;
  }

  function addEventListener(element, item,  settings){
      $(element).on("click", function(event){
        $(`.${settings.uniqueClass}`).removeClass("-selected");
        $(element).addClass("-selected")
        if(settings.callback&&typeof(settings.callback)==='function')
          settings.callback(item);

        emitClickedEvent(element, item)
      })
  }

  function emitClickedEvent(element, item){
    var data = item
    var name = "colorPill.clicked";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    element[0].dispatchEvent(event);
    $(element).trigger(name, data)
  }
  
}(jQuery));
//pill
(function($){
  $.fn.pill = function(options){
    this.settings = $.extend({
      data: [],
      style: 'badge-grey',
      onClick: '',
    },options)
    this.settings.uniqueClass = `o-${new Date().getTime()}`;
    //creating new pills or calling on existing elements
    if(this.settings.data&&this.settings.data.length>0){
      this.settings.data.forEach((item, index)=>{
        var pill = `<span></span>`;
        pill = $(pill)
        .addClass(`badge`)
        .addClass(`badge-pill`)
        .addClass(this.settings.style)
        .addClass(this.settings.uniqueClass)
        .text(item);
        addEventListener(pill, index+1, this.settings);
        this.append(pill);
      })
    }else{
      this.each((index, item)=>{
        item = $(item)
        .addClass(this.settings.style)
        .addClass(this.settings.uniqueClass);
        addEventListener(item, index+1, this.settings);
      })
    }

    return this
  }
  function addEventListener(item, index, settings){
    item.on("click", (event)=>{
      $(`.${settings.uniqueClass}`).removeClass("-selected");
      item.addClass("-selected");
      if(settings.onClick&&typeof(settings.onClick)==='function')
        settings.onClick(item.text(), index, event);
      emitClickedEvent(item, index);
    })
  }

  function emitClickedEvent(element, i){
    var data = {name: element.text(), index: i}
    var name = "pill.clicked";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    element[0].dispatchEvent(event);
    $(element).trigger(name, data)
  }
}(jQuery));
//year picker
(function($){
  $.fn.yearPicker = function(options){
    var date = new Date();
    var settings = $.extend({
      testDate:null,
      callback: null
    },options);
    
    //
    var adjustedDate = getCutOffDate(settings);
    
    //var date = new Date(1547280926997);
    //console.log(new Date(1547280926997));
    var date = settings.testDate || new Date();
    this.currentYear = date.getFullYear();
    this.currentMonth = date.getMonth();
    this.cutOffYear = adjustedDate.getFullYear();
    this.cutOffMonth = adjustedDate.getMonth();
    
    this.selectedYear = this.currentYear;
    this.selectedMonth = this.currentMonth+1;
    
    var startYear = this.cutOffYear<this.currentYear ? this.cutOffYear : this.currentYear;
    
    var yearElements = `<div class="btn-group btn-group-toggle year-list group-button" data-toggle="buttons"></div>`;
    var monthElements = `<div class="month-list"></div>`;
    var length = this.cutOffYear<this.currentYear ? 5 : 4;
    //draw the year selector with consideration that the cutoff year could be in the previous year
    //however we still need to look ahead 4 years
    for(var i = 0; i< length; i++){
      var year = startYear+(i);

      var html = `<label class="year-picker btn btn-light -text-bold -text-14 ${year==this.currentYear?'active':''}"><input type="radio" name="years" id="${year}" autocomplete="off" ${year==this.currentYear?'checked':''}>${year}</label>`;
      
      yearElements = $(yearElements).append(html);

    }
    
    for(var i = 1; i<13; i++){
      
      var html = `<div class='badge badge-pill badge-grey ${i<this.currentMonth ? 'disabled' : ''} ${i==this.currentMonth+1 ? '-selected' : ''}'>${i}</div>`
      
      monthElements = $(monthElements).append(html);
    }
    
    this.append(yearElements);

    this.append(monthElements);
    
    //adjust the selector sizing
    this.find(".btn").css({width:`${(100/length).toFixed(3)}%`});
    
    addClickHandlers(this, settings);
    
    if(settings.callback&&typeof(settings.callback==='function'))
        settings.callback(this.selectedMonth, this.selectedYear);

    emitChangedEvent(this);

    return;
  }
  //private
  function getCutOffDate(settings){
    //var date = new Date(1547280926997);
    var date = settings.testDate || new Date();
    var offset = date.setMonth(date.getMonth()-1);
    return new Date(offset);
  }
  
  function addClickHandlers(element, settings){
    $(element).delegate(".badge", "click", function(event){
      if($(event.target).hasClass("disabled"))
        return;
      element.selectedMonth = $(event.target).text();
      element.find(".badge").removeClass("-selected");
      $(event.target).addClass("-selected");

      if(settings.callback&&typeof(settings.callback==='function'))
        settings.callback(element.selectedMonth, element.selectedYear);

      emitChangedEvent(element);
    });
    
    $(element).delegate(".year-picker", "click", function(event){      
      element.selectedYear = event.target.id;

      // labelとinputそれぞれのclickイベント発生現象対策
      if(!element.selectedYear) return;

      //handle previous year view
      if(element.selectedYear<element.currentYear){
        element.find(".badge").each(function(index,item){
          $(item).removeClass("disabled").removeClass("-selected");
          if($(item).text()!=element.cutOffMonth+1){
             $(item).addClass("disabled");
          }
        })
      //handle others
      }else if(element.selectedYear==element.currentYear){
        element.find(".badge").each(function(index,item){
          $(item).removeClass("disabled").removeClass("-selected");
          if($(item).text()<element.currentMonth){
             $(item).addClass("disabled");
          }
        })
      }else{
        element.find(".badge").each(function(index,item){
          $(item).removeClass("disabled").removeClass("-selected");
        })
      }
      
      emitChangedEvent(element);
    });
  }

  function emitChangedEvent(element){
    var data = {selectedMonth: element.selectedMonth, selectedYear: element.selectedYear}
    var name = "yearPicker.changed";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    element[0].dispatchEvent(event);
    $(element).trigger(name, data)
  }
}(jQuery));
//calendar
(function($){
  var date = new Date();
  $.fn.calendar = function(options){
    this.settings = $.extend({
      startDate : null,
      selectedDate: null,
      locale: "ja-JP",
      options: {year:'numeric', month:'2-digit'},
      seperator: ".",
      onSelect: null,
      updateTarget: null,
      limitFutureDays: 0,
      currentYear: date.getFullYear(),
      currentMonth: date.getMonth()+1,
      currentDate: date.getDate(),
    }, options);
    
    if(this.settings.selectedDate)
      this.d = this.settings.selectedDate;
    
    createSelector(this);
    
    drawCalendarMonth(this);

    createTodayButton(this)
    
    addEventListeners(this);

    //select the first date
    //selectUIDate(this)

    // イベント初期化
    $(document).off('calendar_open');

    $(document).on('calendar_open', (event, data)=>{
      this.settings.updateTarget = data.target;
      selectUIDate(this);
    })
    
    return;
  }

  function selectUIDate(element){
    element.find('.date.selectable > span').each((index,item)=> {
      if($(item).text() == (element.settings.startDate || element.d.getDate())){
        $(item).click();
      }
    });
  }
  
  function addEventListeners(element){
    // イベント初期化
    element.off('click', '.btn');
    element.off('click', '.date.selectable > span');

    element.delegate(".return-btn", "click", function(event){

        clearCalendar(element);
        element.selectedDate = new Date();
        element.date = new Date(element.selectedDate.getFullYear(),element.selectedDate.getMonth());
        setSelector(element);
        drawCalendarMonth(element);
    });

    element.find(`#date-selector-${element.id}`).delegate(".btn", "click", function(event){
      if($(event.target).hasClass("next")){
        element.date.setMonth(element.date.getMonth()+1)
      }
      if($(event.target).hasClass("prev")){
        element.date.setMonth(element.date.getMonth()-1)
      }
      setSelector(element);
      drawCalendarMonth(element);
    });
    
    element.delegate('.date.selectable > span', 'click', function(event){
  
      element.find('.date.selectable > span').removeClass("-selected");
      $(event.target).addClass("-selected");
      var date = $(event.target).text();
      setSelectedDate(element, date);
      if(element.settings.onSelect&&typeof(element.settings.onSelect)==='function')
        element.settings.onSelect(element.selectedFormattedDate, element);

      emitChangedEvent(element);
    })
  }
  
  function createSelector(element){
    element.id = new Date().getTime();
    if(!element.d)
      element.d = new Date();
    //get first day of current month
    element.date = new Date(element.d.getFullYear(), element.d.getMonth(), 1);
    element.selector = `<div class="btn-group btn-group-toggle group-button group-button-selector">`
    element.selector = $(element.selector)
      .attr('id', `date-selector-${element.id}`)
      .addClass('calendar-selector')
      .append('<label class="prev btn btn-light active fas fa-caret-left active"></label>')
      .append(`<label class="btn btn-light -text-bold -text-18 -text-black -full-width"><span class='year'>${getLocaleDate(element)}</span></label>`)
      .append('<label class="next btn btn-light fas fa-caret-right active"></label>')
    
    element.append(element.selector);
  }
  
  function setSelector(element){
    element.find(`#date-selector-${element.id} .year`).text(getLocaleDate(element));
  }
  
  function drawCalendarMonth(element){
    
    clearCalendar(element);
    //element.selectedDate = null;
    
    element.daysInMonth = new Date(element.date.getFullYear(), element.date.getMonth()+1, 0).getDate();
    
    element.firstDayOfWeek = new Date(element.date.getFullYear(), element.date.getMonth(), 1).getDay();

    var currentMonthDateTime = new Date(element.d.getFullYear(), element.d.getMonth(), 1);

    var drawingMonth = element.date.getMonth()+1;
    
    var row = 0;
    var day = 1;
    var calendar = `<div class="calendar"></div>`;
    var d = getFirstDayOfWeek(new Date())
    for(var i = 0;i < 6; i ++){
      var r = `<div class="row-${row}"></div>`
      for(var j = 0; j < 7; j++){
        var html;
        //draw localized weekday string
        if(row==0){
          var weekday = d.toLocaleString(element.settings.locale, { weekday: "narrow" });
          html = `<div class="weekday"><span>${weekday}</span></div>`
          d.setDate(d.getDate()+1)
        }
        else if((row==1&&j<element.firstDayOfWeek)||(day>element.daysInMonth)){
          html = `<div class="date empty"><span>&nbsp;</span></div>`
        }else{
          //if not last day of month
          //if last day of month and month = current month + 1 
          //is day > than day + future limit
          var isCurrentMonth = element.date.valueOf()==currentMonthDateTime.valueOf();
          var isPast = element.date<currentMonthDateTime
          
          if(isPast || isCurrentMonth && day<=element.settings.currentDate+element.settings.limitFutureDays && !isLastDayOfCurrentMonth() || isLastDayOfCurrentMonth() && drawingMonth==element.settings.currentMonth+1 && day<=element.settings.limitFutureDays){
            html = `<div class="date ${day} selectable"><span>${day}</span></div>`
          }else{
            html = `<div class="date ${day}"><span>${day}</span></div>`
          }
          
          day++
        }
        html = $(html).css({width:`${(100/7).toFixed(3)}%`});
        r = $(r).append(html);
      }
      calendar = $(calendar).append(r);
      row++
    }

    element.append(calendar);

    //select the date
    if(element.selectedDate&&element.selectedDate.getFullYear()==element.date.getFullYear()&&element.selectedDate.getMonth()==element.date.getMonth()){
      $(`.date.selectable.${element.selectedDate.getDate()} > span`).click()
    }
  }

  function createTodayButton(element, settings){
    var html = "<div class='d-flex justify-content-end pb-4'><i class='btn-circle-primary return-btn fas fa-calendar-day'></i></div>"

    //element.find(".calendar").append(html);
    $(html).insertBefore(element.find(".calendar"))
  }

  function getLocaleDate(element){
    return element.date.toLocaleDateString(element.settings.locale, element.settings.options).replace('/', element.settings.seperator)
  }

  function setSelectedDate(element, date){
    element.selectedDate = new Date(element.date.getFullYear(), element.date.getMonth(), date)
    element.selectedFormattedDate = element.selectedDate.toLocaleDateString(element.settings.locale).replace(/\//g, element.settings.seperator)
  }

  function getFirstDayOfWeek(date) {
    var d = new Date(date);
    d.setDate(d.getDate() - d.getDay());
    return d;
  }

  function isLastDayOfCurrentMonth(){
    var d = new Date();
    daysInMonth = new Date(d.getFullYear(), d.getMonth()+1, 0).getDate();
    var currentMonthDay = new Date().getDate();
    return daysInMonth == currentMonthDay;
  }
  
  function clearCalendar(element){
    element.find(`.calendar`).html(null);
  }

  function emitChangedEvent(element){
    var data = {selectedDate: element.selectedFormattedDate}
    var name = "calendar.changed";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    element[0].dispatchEvent(event);
    $(element).trigger(name, data)
  }
  
}(jQuery));
//counter
(function($){
  $.fn.counter = function(options){
    this.settings = $.extend({
      buttonStyle: 'btn-light',
      addClass : '-text-bold -text-14',
      startNumber : 0,
      allowNegative : true,
      onChange: null,
    },options);

    this.counters = [];

    this.each((index, item)=>{
      setTimeout(()=>{

        var counter = {}

        counter.currentValue = this.settings.startNumber;

        counter.prevValue = this.settings.startNumber;
        
        counter.id = new Date().getTime();

        counter.element = drawCounter(item, counter.id, this.settings);

        addEventListeners(counter, this.settings);

        this.counters.push(counter);
      },10)
    });
    
    return this;
  }

  function drawCounter(item, id, settings){
    var wrapper = `<div class="btn-group group-button"></div>`
    $(wrapper).attr("id", id);
    leftButton = `<label data-id="${id}" class="btn counter-${id} subtract active ${settings.buttonStyle} ${settings.addClass} fas fa-minus active"></label>`;
    centerButton = `<label id="value-${id}" class="btn ${settings.buttonStyle}">${settings.startNumber}</label>`;
    rightButton = `<label data-id="${id}"  class="btn counter-${id} add active ${settings.buttonStyle} ${settings.addClass} fas fa-plus active"></label>`;

    wrapper = $(wrapper)
    .append(leftButton)
    .append(centerButton)
    .append(rightButton)

    $(item).append(wrapper);

    return item;
  }

  function addEventListeners(item, settings){

    $(item.element).delegate(`.counter-${item.id}`, "click", function(event){

      item.prevValue = item.currentValue;

      isAdd = $(event.target).hasClass("add")
      
      item.currentValue = isAdd 
      ? item.currentValue + 1
      : item.currentValue - 1

      if(!settings.allowNegative&&item.currentValue<0)
        item.currentValue = 0;

      $(`#value-${item.id}`).text(item.currentValue)

      if(settings.onChange&&typeof(settings.onChange)==='function')
        settings.onChange(item.currentValue, item.prevValue, item)

      //emit changed event
      emitChangedEvent(item);
    })
  }

  function emitChangedEvent(item){
    var data = {currentValue: item.currentValue, prevValue: item.prevValue, element: item.element}
    var name = "counter.changed";
    var event = new Event(name, {bubbles: true});
    event.data = data;
    item.element.dispatchEvent(event);
    $(item.element).trigger(name, data)
  }

}(jQuery));
// END Components

// Helper functions
(function($){
  $.fn.toLocaleString = function(locale){
    
    var target = this.text() || this.val();

    if(!target || isNaN(target))
      return "1";
    if(this.text()){
      this.text(parseInt(target).toLocaleString(locale));
    }else if(this.val()){
      this.val(parseInt(target).toLocaleString(locale));
    }
    return this
  }
}(jQuery));

(function($){
  $.fn.rpToNumber = function(){
    var text;
    if(this.text())
      text=this.text()
    if(this.val())
      text=this.val();
    if(!text)
      return 
      
    return parseFloat(text.split('.').join('').split(',').join('.'));
  }
}(jQuery));

(function($){
  $.fn.setDiscountPrice = function(type, price, newValue){
    if(!newValue)
    {
      this.text(price)
      return this;
    }
    if(typeof(newValue)==="string")
      newValue = parseFloat(newValue);
    switch(type){
      case "percent" :
        if(newValue<=100)
          this.text(Math.floor(price-(price*(newValue/100))))
        else
          this.text("0");
      break;
      case "cash" :
        if(newValue<=price)
          this.text((price-newValue));
        else
          this.text("0");
      break;
      default:
        console.info("unsupported discount type")
      break;
    }
    return this;
  }
}(jQuery));

(function($){
  $.fn.getDiscountPrice = function(type, price, newValue){
    
    var result;
    if(typeof(newValue)==="string")
      newValue = parseFloat(newValue);
    switch(type){
      case "percent" :
      case "rate":
        if(newValue<=100)
          result = Math.floor(price-(price*(newValue/100)))
      break;
      case "cash" :
      case "value":
        if(newValue<=price)
          result = (price-newValue);
      break;
      default:
        
      break;
    }
    if(isNaN(result))
      result = price
    return result;
  }
}(jQuery));

//replaced with css variables
(function($){
  $.fn.findColor = function(value){
    
    this.colors = [
      {name:"White", hex: "#FFFFFF"},
      {name:"Black", hex: "#000033"},
      {name:"Blue", hex: "#1147C9"},
      {name:"Grey", hex: "#888888"},
      {name:"Red", hex: "#E83B33"},
      {name:"Green", hex: "#0A8254"},
      {name:"Yellow", hex: "#E8BE33"},
      {name:"Orange", hex: "#E88733"},
      {name:"Pink", hex: "#E650CF"},
      {name:"Purple", hex: "#A233E8"},
      {name:"Brown", hex: "#6E3300"},
      {name:"Silver", hex: "transparent linear-gradient(218deg, #ACACAC 0%, #565656 100%)"},
      {name:"Gold", hex: "transparent linear-gradient(218deg, #C9A71B 0%, #957800 100%)"},
      {name:"Other", hex: "transparent"},
    ];

    return this.colors.find(function(item, index){
      return item.name.toUpperCase() === value.toUpperCase();
    })
  }
}(jQuery))
//END Helper functions
