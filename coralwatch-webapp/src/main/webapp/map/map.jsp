<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>

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

    function newMarker(markerLocation, title, content, markerIcon) {
        var marker = new GMarker(markerLocation, {title:title, icon:markerIcon});
        eventListeners.push(GEvent.addListener(marker, 'click', function() {
            marker.openInfoWindowHtml(content);
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
            url: "<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/surveys?format=json")%>",
            handleAs: "json",
            load: function(data) {
                surveyList = data;
                //Call the asynchronous xhrGet

                var json = [];
                var icon = new GIcon(G_DEFAULT_ICON);

                var marker;
                for (var i = 0; i < surveyList.surveys.length; i++) {
                    var survey = surveyList.surveys[i];
                    var baseUrl = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>";
                    var piechartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=shapePie&width=256&height=256&labels=false&legend=true&titleSize=11";
                    var coralcountchartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=coralCount&width=256&height=256&legend=false&titleSize=11";
                    var numberOfRecs = parseInt(survey.records);
                    var graphs = numberOfRecs <= 0 ? "" : "<br /><img src=\"" + piechartUrl + "\" alt=\"Shape Distribution\" width=\"256\" height=\"256\"/><img src=\"" + coralcountchartUrl + "\" alt=\"Shape Distribution\" width=\"256\" height=\"256\"/>";
                    var content = "<b>" + survey.reef + " (" + survey.country + ")</b><br />- <a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + survey.id + "\">" + numberOfRecs + " Record(s)</a><br />- " + survey.date + graphs + "<br/><div dojoType='dojox.form.Rating' numStars='5' value='1'></div>";
                    var title = "- " + survey.date;
                    marker = newMarker(new GLatLng(survey.latitude, survey.longitude), title, content, icon);
                    markersArray.push(marker);
                }
                cluster.removeMarkers();
                cluster.addMarkers(markersArray);
                cluster.refresh(true);
                map.savePosition();
                json = [];
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
