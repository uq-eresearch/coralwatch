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

<script type="text/javascript"
        src="http://googlemapsapi.martinpearman.co.uk/maps/clustermarker/HtmlControl/HtmlControl.js"></script>
<script type="text/javascript"
        src="http://googlemapsapi.martinpearman.co.uk/maps/clustermarker/ClusterMarker/ClusterMarker.js"></script>


<script type="text/javascript">
    if (window.addEventListener) {
        window.addEventListener("load", myOnload, false);
    } else {
        window.attachEvent("onload", myOnload);
    }

    if (window.addEventListener) {
        window.addEventListener("unload", GUnload, false);
    } else {
        window.attachEvent("onunload", GUnload);
    }

    var cssNode = document.createElement('link');
    cssNode.type = 'text/css';
    cssNode.rel = 'stylesheet';
    cssNode.href = 'http://googlemapsapi.martinpearman.co.uk/maps/clustermarker/HtmlControl/HtmlControl.css';
    document.getElementsByTagName("head")[0].appendChild(cssNode);

    var map, cluster, eventListeners = [], markersArray = [];
    var dialog;
    dojo.addOnLoad(function() {
        dialog = dijit.byId("dialog");
        dialog.titleBar.style.display = 'none';
        dialog.show();
    });

    function myOnload() {
        if (GBrowserIsCompatible()) {

            map = new GMap2(document.getElementById('map'));

            var minZoom = 2; 
            var maxZoom = 12; 
            var mapTypes = map.getMapTypes(); 
            for (var i = 0; i < mapTypes.length; i++) { 
                mapTypes[i].getMinimumResolution = function() {return minZoom;} 
                mapTypes[i].getMaximumResolution = function() {return maxZoom;} 
            }

            map.setCenter(new GLatLng(25.799891, 15.468750), minZoom);
            map.setMapType(G_HYBRID_MAP);
            map.setUIToDefault();
            map.addControl(new GOverviewMapControl());
            GEvent.addListener(map, 'zoomend', function() {
                map.closeInfoWindow();
            });

            function onClusterClick(args) {
                cluster.defaultClickAction = function() {
                    map.setCenter(args.clusterMarker.getLatLng(), map.getBoundsZoomLevel(args.clusterMarker.clusterGroupBounds));
                };
                var html = '<div style="height:300px; overflow:auto;"><h4>' + args.clusteredMarkers.length + ' Surveys:</h4>';
                for (var i = 0; i < args.clusteredMarkers.length; i++) {
                    html += '<a href="javascript:void(0)" onclick="cluster.triggerClick(' + args.clusteredMarkers[i].index + ');">' + args.clusteredMarkers[i].getTitle() + '</a><br/>';
                }
                html += '<br /><a href="javascript:void(0)" onclick="cluster.defaultClickAction()">Fit map</a> to show these locations</div>';
                map.openInfoWindowHtml(args.clusterMarker.getLatLng(), html);
            }

            //	create a ClusterMarker
            cluster = new ClusterMarker(map, {
                clusterMarkerTitle: 'Click to see list of %count surveys',
                clusterMarkerClick: onClusterClick
            });

            selectExample();
        }
    }

    function newMarker(markerLocation, title, surveyId, markerIcon) {
        var marker = new GMarker(markerLocation, {title:title, icon:markerIcon});
        eventListeners.push(GEvent.addListener(marker, 'click', function() {
            dojo.xhrGet({
                url: '<portlet:resourceURL id="survey"/>',
                content: {
                    <portlet:namespace/>format: 'html',
                    <portlet:namespace/>id: surveyId
                },
                handleAs: "text",
                load: function(content) {
                    marker.openInfoWindowHtml(content);
                },
                error: function(error) {
                    marker.openInfoWindowHtml("Error opening survey details.");
                }
            });
        }));
        return marker;
    }

    function toggleClustering() {
        cluster.clusteringEnabled = !cluster.clusteringEnabled;
        cluster.refresh(true);
    }

    function selectExample() {
        markersArray = [];
        for (var z = eventListeners.length - 1; z >= 0; z--) {
            GEvent.removeListener(eventListeners[z]);
        }
        eventListeners = [];
        var xhrArgs = {
            <liferay-portlet:resourceURL var="resourceURL" portletName="surveyportlet_WAR_coralwatch">
                <liferay-portlet:param name="format" value="json" />
            </liferay-portlet:resourceURL>
            url: "<%= resourceURL %>&p_p_resource_id=list",
            handleAs: "json",
            load: function(surveys) {
                var icon = new GIcon(G_DEFAULT_ICON);

                for (var i = 0; i < surveys.length; i++) {
                    var survey = surveys[i];
                    var marker = newMarker(new GLatLng(survey.lat, survey.lng), survey.date, survey.id, icon);
                    markersArray.push(marker);
                }
                cluster.removeMarkers();
                cluster.addMarkers(markersArray);
                cluster.refresh(true);
                map.savePosition();
                dialog.hide();
            },
            error: function(error) {
                targetNode.innerHTML = "An unexpected error occurred: " + error;
            }
        }
        var deferred = dojo.xhrGet(xhrArgs);
    }
</script>

<div id="map" style="height: 650px; border: 2px solid #333333"></div>
<div id="dialog" dojoType="dijit.Dialog" title="loading..." style="display:none;" align="center">
    <h3 style="text-align:center;">Loading surveys...</h3>
</div>
