<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>

<portlet:defineObjects/>

<% if (HttpUtils.getRequestURL(request).toString().startsWith("http://localhost")) {
%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<% } else {%>
<%--TODO Remove this. This key is for coralwatch.metadata.net--%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BRQUGumEEA5VNOyRfA6H2JcRBcMpRSGKOPhfWtwYIQIEFoWKsymkjiraw'></script>
<%}%>
<script type="text/javascript"
        src="http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/src/markerclusterer_packed.js"></script>

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
            marker.openInfoWindowHtml(survey.reef);
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