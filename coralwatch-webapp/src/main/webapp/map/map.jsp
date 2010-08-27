<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>

<portlet:defineObjects/>
<%
    List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
%>
<jsp:include page="map-head.jsp"/>
<%--<script type="text/javascript">--%>
<%--var styles = [--%>
<%--[--%>
<%--{--%>
<%--url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv30.png',--%>
<%--height: 27,--%>
<%--width: 30,--%>
<%--anchor: [3, 0],--%>
<%--textColor: '#FF00FF'--%>
<%--},--%>
<%--{--%>
<%--url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv40.png',--%>
<%--height: 36,--%>
<%--width: 40,--%>
<%--opt_anchor: [6, 0],--%>
<%--opt_textColor: '#FF0000'--%>
<%--},--%>
<%--{--%>
<%--url: 'http://gmaps-utility-library.googlecode.com/svn/trunk/markerclusterer/1.0/images/conv50.png',--%>
<%--width: 50,--%>
<%--height: 45,--%>
<%--opt_anchor: [8, 0]--%>
<%--}--%>
<%--]--%>
<%--];--%>

<%--var map = null;--%>
<%--var markers = [];--%>
<%--var markerClusterer = null;--%>
<%--var surveyList = null;--%>
<%--dojo.addOnLoad(--%>
<%--function() {--%>
<%--var dialog = dijit.byId("dialog");--%>
<%--dialog.titleBar.style.display = 'none';--%>
<%--dialog.show();--%>
<%--if (GBrowserIsCompatible()) {--%>
<%--map = new GMap2(document.getElementById("map_canvas"));--%>
<%--map.setCenter(new GLatLng(25.799891, 15.468750), 2);--%>
<%--map.setMapType(G_HYBRID_MAP);--%>
<%--map.setUIToDefault();--%>
<%--map.addControl(new GOverviewMapControl());--%>
<%--var xhrArgs = {--%>
<%--url: "<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/surveys?format=json")%>",--%>
<%--handleAs: "json",--%>
<%--load: function(data) {--%>
<%--surveyList = data;--%>
<%--//Call the asynchronous xhrGet--%>


<%--var icon = new GIcon(G_DEFAULT_ICON);--%>
<%--icon.image = "http://chart.apis.google.com/chart?cht=mm&chs=24x32&chco=FFFFFF,008CFF,000000&ext=.png";--%>
<%--for (var i = 0; i < parseInt(surveyList.count); ++i) {--%>
<%--var latlng = new GLatLng(surveyList.surveys[i].latitude, surveyList.surveys[i].longitude);--%>
<%--var marker = createMarker(latlng, icon, surveyList.surveys[i]);--%>
<%--markers.push(marker);--%>
<%--}--%>
<%--refreshMap();--%>
<%--dialog.hide();--%>

<%--},--%>
<%--error: function(error) {--%>
<%--targetNode.innerHTML = "An unexpected error occurred: " + error;--%>
<%--}--%>
<%--}--%>
<%--var deferred = dojo.xhrGet(xhrArgs);--%>
<%--}--%>
<%--});--%>
<%--function createMarker(point, icon, survey) {--%>
<%--var marker = new GMarker(point, {icon: icon});--%>
<%--GEvent.addListener(marker, "click", function() {--%>
<%--var baseUrl = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>";--%>
<%--var piechartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=shapePie&width=128&height=128&labels=false&legend=true&titleSize=11";--%>
<%--var coralcountchartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=coralCount&width=128&height=128&legend=false&titleSize=11";--%>
<%--var numberOfRecs = parseInt(survey.records);--%>
<%--var graphs = numberOfRecs <= 0 ? "" : "<br /><img src=\"" + piechartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/><img src=\"" + coralcountchartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/>";--%>
<%--marker.openInfoWindowHtml("<b>" + survey.reef + " (" + survey.country + ")</b><br />- " + numberOfRecs + " Record(s) <br />- " + survey.date + graphs + "<br/><div dojoType='dojox.form.Rating' numStars='5' value='1'></div><br />- <a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + survey.id + "\">More info</a>");--%>
<%--});--%>
<%--return marker;--%>
<%--}--%>
<%--function refreshMap() {--%>
<%--if (markerClusterer != null) {--%>
<%--markerClusterer.clearMarkers();--%>
<%--}--%>
<%--var zoom = 5;--%>
<%--var size = 50;--%>
<%--var style = null;--%>
<%--markerClusterer = new MarkerClusterer(map, markers, {maxZoom: zoom, gridSize: size, styles:styles[style]});--%>
<%--}--%>

<%--</script>--%>
<%--<div style="border: 1px solid #333333; padding: 5px;">--%>
<%--&lt;%&ndash;<fieldset dojotype="app.Fieldset" legend="Search Coralwatch Data" open="false">&ndash;%&gt;--%>
<%--<table width="100%">--%>
<%--<tr>--%>
<%--<td><strong>Search:</strong>--%>
<%--</td>--%>
<%--</tr>--%>
<%--<tr>--%>
<%--<td><input type="text" name="occupation" id="occupation" width="50%" dojoType="dijit.form.TextBox"/>--%>
<%--<input type="button" value="Search"/>--%>
<%--</td>--%>
<%--</tr>--%>
<%--<tr>--%>
<%--<td><strong>Filters:</strong></td>--%>
<%--</tr>--%>
<%--<tr>--%>
<%--<td>--%>
<%--<label for="reefName">Reef Name</label> <select name="reefName"--%>
<%--id="reefName"--%>
<%--dojoType="dijit.form.ComboBox"--%>
<%--required="true"--%>
<%--hasDownArrow="true">--%>
<%--<option selected="selected" value="All">All</option>--%>
<%--<%--%>
<%--for (Reef reef : reefs) {--%>
<%--%>--%>
<%--<option value="<%=reef.getName()%>"><%=reef.getName()%>--%>
<%--</option>--%>
<%--<%--%>
<%--}--%>
<%--%>--%>
<%--</select></td>--%>
<%--</tr>--%>
<%--<tr>--%>
<%--<td>--%>
<%--<label for="rating">Rating</label> <select name="rating"--%>
<%--id="rating"--%>
<%--dojoType="dijit.form.ComboBox"--%>
<%--required="true"--%>
<%--hasDownArrow="true">--%>
<%--<option selected="selected" value="All">All</option>--%>
<%--<option value="1">1 Star</option>--%>
<%--<option value="2">2 Stars</option>--%>
<%--<option value="3">3 Stars</option>--%>
<%--<option value="4">4 Stars</option>--%>
<%--<option value="5">5 Stars</option>--%>
<%--</select>--%>
<%--</td>--%>
<%--</tr>--%>
<%--<tr>--%>
<%--<td>--%>
<%--Criteria:--%>
<%--<input type="checkbox" dojoType="dijit.form.CheckBox" id="cb0"/>--%>
<%--<label for="cb0">Direct Rating</label>--%>
<%--<input type="checkbox" dojoType="dijit.form.CheckBox" id="cb1"/>--%>
<%--<label for="cb1">Role</label>--%>
<%--<input type="checkbox" dojoType="dijit.form.CheckBox" id="cb2"/>--%>
<%--<label for="cb2">Frequency of Contribution</label>--%>
<%--<input type="checkbox" dojoType="dijit.form.CheckBox" id="cb3"/>--%>
<%--<label for="cb3">Amount of Data</label>--%>
<%--<input type="button" value="Apply Filter"/>--%>
<%--</td>--%>
<%--</tr>--%>
<%--</table>--%>
<%--&lt;%&ndash;</fieldset>&ndash;%&gt;--%>
<%--</div>--%>
<%--<br/>--%>


<%--<div id="map_canvas" style="height: 650px; border: 2px solid #333333"></div>--%>

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

    var map, cluster, eventListeners = [], markersArray = [], icon;
    var dialog;
    dojo.addOnLoad(function() {
        dialog = dijit.byId("dialog");
        dialog.titleBar.style.display = 'none';
        dialog.show();
        //        myOnload();
    });

    function myOnload() {


        if (GBrowserIsCompatible()) {

            map = new GMap2(document.getElementById('map'));
            map.setCenter(new GLatLng(25.799891, 15.468750), 2);
            map.setMapType(G_HYBRID_MAP);
            map.setUIToDefault();
            map.addControl(new GOverviewMapControl());
            GEvent.addListener(map, 'zoomend', function() {
                map.closeInfoWindow();
            });

            function myClusterClick(args) {
                cluster.defaultClickAction = function() {
                    map.setCenter(args.clusterMarker.getLatLng(), map.getBoundsZoomLevel(args.clusterMarker.clusterGroupBounds))
                    delete cluster.defaultClickAction;
                }
                var html = '<div style="height:8em; overflow:auto; width:24em"><h4>' + args.clusteredMarkers.length + ' Surveys:</h4>';
                for (var i = 0; i < args.clusteredMarkers.length; i++) {
                    html += '<br/>' + args.clusteredMarkers[i].getTitle() + '<br />' + '<a href="javascript:cluster.triggerClick(' + args.clusteredMarkers[i].index + ')">Zoom to survey</a><hr/>';
                }
                html += '<br /><a href="javascript:void(0)" onclick="cluster.defaultClickAction()">Fit map</a> to show these locations</div>';
                map.openInfoWindowHtml(args.clusterMarker.getLatLng(), html);
            }

            //	create a ClusterMarker
            cluster = new ClusterMarker(map, {clusterMarkerTitle:'Click to see info about %count locations' , clusterMarkerClick:myClusterClick });

            icon = new GIcon();
            icon.shadow = 'http://googlemapsapi.martinpearman.co.uk/maps/clustermarker/images/icon_shadow.png';
            icon.shadowSize = new GSize(37, 34);
            icon.iconSize = new GSize(20, 34);
            icon.iconAnchor = new GPoint(10, 30);
            icon.infoWindowAnchor = new GPoint(10, 8);

            selectExample();
        }
    }

    function newMarker(markerLocation, title, markerIcon) {
        var marker = new GMarker(markerLocation, {title:title, icon:markerIcon});
        eventListeners.push(GEvent.addListener(marker, 'click', function() {
            marker.openInfoWindowHtml(title);
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
                icon.image = "http://chart.apis.google.com/chart?cht=mm&chs=24x32&chco=FFFFFF,008CFF,000000&ext=.png";

                var marker, newIcon, j = 1;
                for (var i = 0; i < surveyList.surveys.length; i++) {
                    newIcon = new GIcon(icon, 'http://googlemapsapi.martinpearman.co.uk/maps/clustermarker/images/icon_' + j + '.png');
                    var survey = surveyList.surveys[i];
                    var baseUrl = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>";
                    var piechartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=shapePie&width=128&height=128&labels=false&legend=true&titleSize=11";
                    var coralcountchartUrl = baseUrl + "/graph?type=survey&id=" + survey.id + "&chart=coralCount&width=128&height=128&legend=false&titleSize=11";
                    var numberOfRecs = parseInt(survey.records);
                    var graphs = numberOfRecs <= 0 ? "" : "<br /><img src=\"" + piechartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/><img src=\"" + coralcountchartUrl + "\" alt=\"Shape Distribution\" width=\"128\" height=\"128\"/>";
                    var title = "<b>" + survey.reef + " (" + survey.country + ")</b><br />- <a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + survey.id + "\">" + numberOfRecs + " Record(s)</a><br />- " + survey.date + graphs + "<br/><div dojoType='dojox.form.Rating' numStars='5' value='1'></div>";

                    marker = newMarker(new GLatLng(survey.latitude, survey.longitude), title, newIcon);
                    markersArray.push(marker);
                    j++;
                    if (j > 26) {
                        j = 1;
                    }
                }
                cluster.removeMarkers();
                cluster.addMarkers(markersArray);
                //                    cluster.fitMapToMarkers();
                cluster.refresh(true);
                map.savePosition();
                json = [];
                //                            refreshMap();
                //                            dialog.hide();
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