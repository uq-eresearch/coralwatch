<#macro entry survey>
{
"start" : "${survey.date?string("EEE, dd MMM yyyy HH:mm:ss Z")}",
"point" : {
"lat" : ${survey.latitude?c},
"lon" : ${survey.longitude?c}
},
"title" : "${survey.reef.name}, ${survey.totalRatingValue?c} Stars (${survey.numberOfRatings?c} Ratings)",
"options" : {
tags: [${survey.totalRatingValue?c}]
}
}
</#macro>

<#if baseUrl?starts_with("http://localhost")>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<#else>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA-Y-sXcS7Cho7UUEWAL06lBQwtEFLLcTdtVnYJARPXeJhL0yKvxQD__Boj0suUIzkmUZHRHxL-cUVyw'></script>
</#if>

<script type="text/javascript" src="http://static.simile.mit.edu/timeline/api-2.2.0/timeline-api.js"></script>
<script language="javascript" type="text/javascript" src="${baseUrl}/javascript/timemap/timemap_full.pack.js"></script>
<script type="text/javascript">
    var tm;
    function init() {
        tm = TimeMap.init({
            mapId: "map",               // Id of map div element (required)
            timelineId: "timeline",     // Id of timeline div element (required)
            options: {
                eventIconPath: "${baseUrl}/icons/timemap/"
            },
            datasets: [
                {
                    id: "surveys",
                    title: "CoralWatch Surveys",
                    type: "basic",
                    options: {
                        items: [
                            <#list surveys as survey>
                            <@entry survey/>,
                            </#list>
                        ]
                    }
                }
            ],
            bandIntervals: [
                Timeline.DateTime.MONTH,
                Timeline.DateTime.YEAR
            ]
        });
        // add our new function to the map and timeline filters
        tm.addFilter("map", TimeMap.filters.hasSelectedTag); // hide map markers on fail
        tm.addFilter("timeline", TimeMap.filters.hasSelectedTag); // hide timeline events on fail
    }


    // filter function for tags
    TimeMap.filters.hasSelectedTag = function(item) {
        // if no tag was selected, every item should pass the filter
        if (!window.selectedTag) {
            return true;
        }
        if (item.opts.tags) {
            // look for selected tag
            var selectedStarValue = parseFloat(window.selectedTag);
            var tagValue = parseFloat(item.opts.tags[0]);
            if (item.opts.tags[0] > (selectedStarValue - 1) && item.opts.tags[0] <= selectedStarValue) {
                // tag found, item passes
                return true;
            }
            else {
                // indexOf() returned -1, so the tag wasn't found
                return false;
            }
        }
        else {
            // item didn't have any tags
            return false;
        }
    };

    // onChange handler for pulldown menu
    function setSelectedTag(select) {
        var idx = select.selectedIndex;
        window.selectedTag = select.options[idx].value;
        // run filters
        tm.filter('map');
        tm.filter('timeline');
        // you'll need this to make the timeline update
        tm.timeline.layout();
    }
</script>