<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="liferay-portlet" uri="http://liferay.com/tld/portlet" %>

<portlet:defineObjects/>
<jsp:include page="map-head.jsp"/>
<script src="/coralwatch/js/markerclusterer/markerclusterer.js"></script>
<script>
markerById = {};
function triggerMarkerClick(markerId) {
  google.maps.event.trigger(markerById[markerId], 'click');
}
function initialize() {
  var mapProp = {
    center:new google.maps.LatLng(25.799891, 15.468750),
    zoom:2,
    mapTypeId:google.maps.MapTypeId.HYBRID
  };
  map=new google.maps.Map(document.getElementById("mapDiv"),mapProp);
  var infowindow = new google.maps.InfoWindow();
  google.maps.event.addListener(map, 'zoom_changed', function() {
    infowindow.close();
  });
  var xhrArgs = {
        url: "/coralwatch/api/survey-location",
        handleAs: "json",
        sync: false,
        load: function(surveys) {
            var markers = [];
            for (var i = 0; i < surveys.length; i++) {
                var survey = surveys[i];
                var marker=new google.maps.Marker({
                    position:new google.maps.LatLng(survey.lat,survey.lng),
                    map: map,
                    id: survey.id,
                    title: String(survey.date)
                });
                markerById[marker.id] = marker;
                google.maps.event.addListener(marker, 'click', (function(marker, i) {
                    return function() {
                        dojo.xhrGet({
                            url: '<portlet:resourceURL id="survey"/>',
                            content: {
                                <portlet:namespace/>format: 'html',
                                <portlet:namespace/>id: marker.id
                            },
                            handleAs: "text",
                            load: function(content) {
                                infowindow.setContent(content);
                                infowindow.open(map, marker);
                            },
                            error: function(error) {
                                infowindow.setContent("Error opening survey details.");
                                infowindow.open(map, marker);
                            }
                        });
                    }
                })(marker, i));
                markers.push(marker);
            }
            markerCluster = new MarkerClusterer(map, markers, {
              zoomOnClick: false,
              imagePath: '/coralwatch/js/markerclusterer/images/m'
            });
            google.maps.event.addListener(markerCluster, 'clusterclick', function(cluster) {
              var surveyUrlPrefix =
                '<%=renderRequest.getAttribute("surveyUrl")%>' +
                '?p_p_id=surveyportlet_WAR_coralwatch' +
                '&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>' +
                '&_surveyportlet_WAR_coralwatch_surveyId=';
              var html = '<div style="width: 240px; height:300px; overflow: auto;">';
              html += '<h4>' + cluster.getMarkers().length + ' Surveys:</h4>';
              html += '<ul>';
              for (var i = 0; i < cluster.getMarkers().length; i++) {
                html += '<li>';
                html += '<a href="javascript:void(0)" onclick="triggerMarkerClick('+cluster.getMarkers()[i].id+')">' + cluster.getMarkers()[i].title.replace(/\s/g, '&nbsp;') + '</a> ';
                html += '<a href="' + surveyUrlPrefix + cluster.getMarkers()[i].id + '">(link)</a>';
                html += '</li>';
              }
              html += '</ul>';
              html += '</div>';
              infowindow.setContent(html);
              infowindow.open(map, cluster.getMarkers()[0]);
            });
        },
        error: function(error) {
          console.error('error loading surveys %o', error);
        }
  }
  var deferred = dojo.xhrGet(xhrArgs);
}
google.maps.event.addDomListener(window, 'load', initialize);
</script>

<div id="mapDiv" style="height: 650px; border: 2px solid #333333"></div>
