<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>

<portlet:defineObjects/>

<jsp:include page="map-head.jsp"/>
<script type="text/javascript">

    var styles = [
        [
            {
                url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv30.png',
                height: 27,
                width: 30,
                anchor: [3, 0],
                textColor: '#FF00FF'
            },
            {
                url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv40.png',
                height: 36,
                width: 40,
                opt_anchor: [6, 0],
                opt_textColor: '#FF0000'
            },
            {
                url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv50.png',
                width: 50,
                height: 45,
                opt_anchor: [8, 0]
            }
        ]
    ];

    var map = null;
    var markers = [];
    var markerClusterer = null;
    var surveyList = null;
    dojo.addOnLoad(
            function() {
                if (GBrowserIsCompatible()) {
                    map = new GMap2(document.getElementById("map_canvas"));
                    map.setCenter(new GLatLng(25.799891, 15.468750), 2);
                    map.setMapType(G_HYBRID_MAP);
                    map.setUIToDefault();

                    var xhrArgs = {
                        url: "<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/json-surveys")%>",
                        handleAs: "json",
                        load: function(data) {
                            surveyList = data;
                            //Call the asynchronous xhrGet


                            var icon = new GIcon(G_DEFAULT_ICON);
                            icon.image = "http://chart.apis.google.com/chart?cht=mm&chs=24x32&chco=FFFFFF,008CFF,000000&ext=.png";
                            for (var i = 0; i < parseInt(surveyList.count); ++i) {
                                var latlng = new GLatLng(surveyList.surveys[i].latitude, surveyList.surveys[i].longitude);
                                var marker = createMarker(latlng, icon, surveyList.surveys[i]);
                                markers.push(marker);
                            }
                            refreshMap();

                        },
                        error: function(error) {
                            targetNode.innerHTML = "An unexpected error occurred: " + error;
                        }
                    }
                    var deferred = dojo.xhrGet(xhrArgs);
                }
            });
    function createMarker(point, icon, survey) {
        var marker = new GMarker(point, {icon: icon});
        GEvent.addListener(marker, "click", function() {
            var baseUrl = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>";
            var piechartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=shapePie&width=128&height=128&labels=false&legend=true&titleSize=11";
            var coralcountchartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=coralCount&width=128&height=128&legend=false&titleSize=11";
            var numberOfRecs = parseInt(survey.records);
            var graphs = numberOfRecs <= 0 ? "" : "<br /><img src=\"" + piechartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/><img src=\"" + coralcountchartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/>";
            marker.openInfoWindowHtml("<b>" + survey.reef + "</b><br />- " + numberOfRecs + " Record(s) <br />- " + survey.date + graphs + "<br />- <a href=\"#\">More info</a>");
        });
        return marker;
    }
    function refreshMap() {
        if (markerClusterer != null) {
            markerClusterer.clearMarkers();
        }
        var zoom = null;
        var size = null;
        var style = null;
        markerClusterer = new MarkerClusterer(map, markers, {maxZoom: zoom, gridSize: size, styles:styles[style]});
    }

</script>
<div id="map_canvas" style="height: 650px;"></div>
