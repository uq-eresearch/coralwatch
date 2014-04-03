<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="liferay-portlet" uri="http://liferay.com/tld/portlet" %>

<portlet:defineObjects/>
<%
    List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
%>
<jsp:include page="map-head.jsp"/>
<script src="/coralwatch/js/markerclusterer_compiled.js"></script>
<!--[if IE]><script type="text/javascript">window['isIE'] = true;</script><![endif]-->
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
        <liferay-portlet:resourceURL var="resourceURL" portletName="surveyportlet_WAR_coralwatch">
            <liferay-portlet:param name="format" value="json" />
        </liferay-portlet:resourceURL>
        url: "<%= resourceURL %>&p_p_resource_id=list",
        handleAs: "json",
        load: function(surveys) {
            var markers = [];
            for (var i = 0; i < surveys.length; i++) {
                var survey = surveys[i];
                var marker=new google.maps.Marker({
                    position:new google.maps.LatLng(survey.lat,survey.lng),
                    map: map,
                    id: survey.id,
                    title: survey.date
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
              zoomOnClick: false
            });
            google.maps.event.addListener(markerCluster, 'clusterclick', function(cluster) {
              var html = '<div style="height:300px; overflow:auto;"><h4>' + cluster.getMarkers().length + ' Surveys:</h4>';
              for (var i = 0; i < cluster.getMarkers().length; i++) {
                html += '<a href="javascript:void(0)" onclick="triggerMarkerClick('+cluster.getMarkers()[i].id+')">' + cluster.getMarkers()[i].title.replace(/\s/g, '&nbsp;') + '</a><br/>';
              }
              html += '</div>';
              infowindow.setContent(html);
              infowindow.open(map, cluster.getMarkers()[0]);
            });
            if(!window.isIE) {
              dialog.hide();
            }
        },
        error: function(error) {
            targetNode.innerHTML = "An unexpected error occurred: " + error;
        }
  }
  var deferred = dojo.xhrGet(xhrArgs);
  if(!window.isIE) {
    dojo.addOnLoad(function() {
      dialog = dijit.byId("dialogDiv");
      dialog.titleBar.style.display = 'none';
      dialog.show();
    });
  }
}
google.maps.event.addDomListener(window, 'load', initialize);
</script>

<div id="mapDiv" style="height: 650px; border: 2px solid #333333"></div>
<div id="dialogDiv" dojoType="dijit.Dialog" title="loading..." style="display:none;" align="center">
    <h3 style="text-align:center;">Loading surveys...</h3>
</div>
