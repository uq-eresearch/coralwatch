<#macro entry survey>
{
start : "${survey.date?string("EEE, dd MMM yyyy HH:mm:ss Z")}",
point : {
lat : ${survey.latitude?c},
lon : ${survey.longitude?c}
},
title : "${survey.reef.name}: #${survey.id?c}",
options : {
infoUrl: "surveys/${survey.id?c}?noframe=true",
tags: ['${survey.totalRatingValue?c}', '${survey.reef.country}', '${survey.reef.name}'],
theme: <#if (survey.totalRatingValue >= 0) && survey.totalRatingValue <= 1>'red'
    <#elseif (survey.totalRatingValue > 1) && survey.totalRatingValue <= 2>'yellow'
    <#elseif (survey.totalRatingValue > 2) && survey.totalRatingValue <= 3>'green'
    <#elseif (survey.totalRatingValue > 3) && survey.totalRatingValue <= 4>'blue'
    <#elseif (survey.totalRatingValue > 4) && survey.totalRatingValue <= 5>'purple'</#if>
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

<script src="http://simile.mit.edu/timeline/api/scripts/timeline-api.js" type="text/javascript"></script>
<#--<script type="text/javascript" src="http://static.simile.mit.edu/timeline/api/timeline-api.js"></script>-->

<script language="javascript" type="text/javascript" src="${baseUrl}/javascript/timemap/timemap_full.pack.js"></script>
<script type="text/javascript">
    var tm;
    function init() {
        tm = TimeMap.init({
            mapId: "map",               // Id of map div element (required)
            timelineId: "timeline",     // Id of timeline div element (required)
            options: {
                hidePastFuture: false,
                mapType: G_HYBRID_MAP,
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
        tm.addFilter("timeline", TimeMap.filters.countryFilter);
        tm.addFilter("timeline", TimeMap.filters.reefFilter);
        tm.addFilter("timeline", TimeMap.filters.ratingFilter);
        // add our new function to the map and timeline filters
        tm.addFilter("map", TimeMap.filters.countryFilter);
        tm.addFilter("map", TimeMap.filters.reefFilter);
        tm.addFilter("map", TimeMap.filters.ratingFilter);
        tm.map.setCenter(new GLatLng(-28.397, 135.644), 4);
        tm.timeline.getBand(1).setCenterVisibleDate(new Date(new Date().getYear() + 1900, new Date().getMonth(), 1));
    }


    // filter function for tags
    TimeMap.filters.countryFilter = function(item) {
        var selectedCountry = window.selectedCountryTag;
        if (!selectedCountry) {
            return true;
        }
        if (item.opts.tags) {
            return item.opts.tags.indexOf(selectedCountry) >= 0;
        }
        else {
            return false;
        }
    };

    TimeMap.filters.reefFilter = function(item) {
        var selectedReef = window.selectedReefTag;
        if (!selectedReef) {
            return true;
        }
        if (item.opts.tags) {
            return item.opts.tags.indexOf(selectedReef) >= 0;
        }
        else {
            return false;
        }
    };

    TimeMap.filters.ratingFilter = function(item) {
        // if no tag was selected, every item should pass the filter
        if (!window.selectedRatingTag) {
            return true;
        }
        if (item.opts.tags) {
            // look for selected tag
            var selectedStarValue = parseFloat(window.selectedRatingTag);
            var ratingValue = parseFloat(item.opts.tags[0]);
            return ratingValue > (selectedStarValue - 1) && ratingValue <= selectedStarValue;
        }
        else {
            return false;
        }
    };

    function setSelectedCountryTag(select) {
        var idx = select.selectedIndex;
        window.selectedCountryTag = select.options[idx].value;
        runFilters();
    }

    function setSelectedReefTag(select) {
        var idx = select.selectedIndex;
        window.selectedReefTag = select.options[idx].value;
        runFilters();
    }

    function setSelectedRatingTag(select) {
        var idx = select.selectedIndex;
        window.selectedRatingTag = select.options[idx].value;
        runFilters();
    }
    function runFilters() {
        tm.filter('timeline');
        tm.filter('map');
        // update the timeline
        tm.timeline.layout();
    }

    function findLocation() {
        var searchField = document.getElementById("search-text");
        var searchText = searchField.value;
        searchField.value = "";
        var geo = new GClientGeocoder();
        geo.getLocations(searchText, function (result)
        {
            var p = result.Placemark[0].Point.coordinates;
            tm.map.setCenter(new GLatLng(p[1], p[0]), 10);
        });
    }


</script>