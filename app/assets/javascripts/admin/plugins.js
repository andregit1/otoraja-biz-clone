(function ($) {
    const paginationDataSet = []
    function getDataCache(){

    }
    function setDataCache(){

    }
    $.fn.sortBy = function( options ) {
        var settings = $.extend({
            //defaults
            property : "",
            data : [],
            desc : false
        }, options );

        let sortedData = settings.data.sort(function(a,b){
            if(!settings.desc && a[settings.property] < b[settings.property]){
              return -1;
            }
            if(!settings.desc && a[settings.property] > b[settings.property]){
              return 1;
            }
            if(settings.desc && a[settings.property] > b[settings.property]){
              return -1;
            }
            if(settings.desc && a[settings.property] < b[settings.property]){
              return 1;
            }
            return 0;
        });

        return sortedData;
    }

    $.fn.paginate = function(options){
        
        var settings = $.extend({
            //defaults
            dataSet: null,
            itemsPerPage : 10,
        }, options);
        var self = this;
        var $target = $(this);
        var skip = 0;
        var take = settings.itemsPerPage;
        var dataCount = settings.dataSet.length;
        var pageCount = dataCount/settings.itemsPerPage
        var displayData = [];
        var controlContainer = "";
        var initalized = false

        if(settings.dataSet==null){
            console.error("please include the following options. Options include (dataSet:array(html elements), itemsPerPage:int-default=10)")
            return;
        }
        if(dataCount==0){
            return;
        }

        //clean dom of any drawn controls for this element
        $target.find(".pagination-controlls").remove();

        function init(element){
            if(!initalized){
                setDom();
                createControlls();
            }
            
            getDisplayData();
            drawTargetList();
            drawPaginationIndicator();
            initalized = true;
        }

        function setDom(){
            let wrapper = "<div class='pagination-container'></div>";
            if($target.find('.pagination-container').length>0){
                var content = $target.find('.pagination-container').clone();
            }else{
                var content = $target.clone();
            }
            
            $target.empty();
            $target.append(wrapper);
            $target.find(".pagination-container").append(content.html());
            controlContainer = $target.find(".pagination-container");
        }

        function getDisplayData(){
            displayData = [];
            for(var i = skip; i<skip+take; i++){
                if(settings.dataSet[i]!=null){
                    displayData.push(settings.dataSet[i])
                }
            }
        }

        function drawTargetList(){
            let $tbody = $target.find("tbody");
            $tbody.empty()
            displayData.forEach(function(html, index){
                $tbody.append(html);
            })
        }

        function drawPaginationIndicator(){
            let text = `${skip+1}-${skip+displayData.length<=dataCount?skip+displayData.length:dataCount} of ${dataCount}`
            $target.find(".pagination-indicator").text(text)
        }

        function createControlls(){
            //create items per select
            let itemsPerPageDropdown = `<select class='pagination-item-count form-control' style="width:75px">
            <option value='${settings.itemsPerPage}'>${settings.itemsPerPage}</option>
            <option value='${settings.itemsPerPage*2}'>${settings.itemsPerPage*2}</option>
            <option value='${settings.itemsPerPage*5}'>${settings.itemsPerPage*5}</option>
            <option value='${settings.itemsPerPage*10}'>${settings.itemsPerPage*10}</option>
            </select>`
            //create paging indicator
            let pagingIndicator = `<span class="pagination-indicator mr-2 ml-2 mt-2"></span>`
            //create next / prev buttons
            let prevButton = `<button class="btn btn-outline-primary pagination-button pagination-prev mr-2"><</button>`
            let nextButton = `<button class="btn btn-outline-primary pagination-button pagination-next mr-2">></button>`
            controlContainer.after(`<div class="pagination-controlls d-flex justify-content-end mt-2 mb-2"></div>`)
            $target.find(".pagination-controlls").append(itemsPerPageDropdown+pagingIndicator+prevButton+nextButton);
            //handle it
            $target.find(".pagination-item-count").off().on("change", handleItemsPerPageDropdownChange)
            $target.find(".pagination-prev").off().on("click", handlePrevButtonClick)
            $target.find(".pagination-next").off().on("click", handleNextButtonClick)
            
        }

        //handlers
        function handleItemsPerPageDropdownChange(event){
            settings.itemsPerPage = take = parseInt($(this).val());
            skip = 0;
            getDisplayData();
            drawTargetList();
            drawPaginationIndicator();
        }

        function handlePrevButtonClick(){
            if(skip<=0){
                return;
            }
            skip = skip - settings.itemsPerPage;
            getDisplayData();
            drawTargetList();
            drawPaginationIndicator();
        }

        function handleNextButtonClick(){
            if(skip + settings.itemsPerPage>=dataCount){
                return;
            }
            skip = skip + settings.itemsPerPage;
            getDisplayData();
            drawTargetList();
            drawPaginationIndicator();
        }

        //events
        function addEventListeners(){
            //$target.off().on("data.sorted", updatePaginationDataEvent)
            document.querySelector(`#${$target.attr("id")}`).removeEventListener("data.sorted", updatePaginationDataEvent, true);
            document.querySelector(`#${$target.attr("id")}`).addEventListener("data.sorted", updatePaginationDataEvent)
        }

        function updatePaginationDataEvent(event){
            settings.dataSet = event.data.dataSet;
            dataCount = settings.dataSet.length;
            init(self);
            drawPaginationIndicator();
        }

        addEventListeners();

        //initialize
        init(this);
    }
}(jQuery));