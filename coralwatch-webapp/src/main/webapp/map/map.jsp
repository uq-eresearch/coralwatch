<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>

<portlet:defineObjects/>
<%
    List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
%>
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
                var dialog = dijit.byId("dialog");
                dialog.titleBar.style.display = 'none';
                dialog.show();
                if (GBrowserIsCompatible()) {
                    map = new GMap2(document.getElementById("map_canvas"));
                    map.setCenter(new GLatLng(25.799891, 15.468750), 2);
                    map.setMapType(G_HYBRID_MAP);
                    map.setUIToDefault();
                    map.addControl(new GOverviewMapControl());
                    var xhrArgs = {
                        url: "<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/surveys?format=json")%>",
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
                            dialog.hide();

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
            marker.openInfoWindowHtml("<b>" + survey.reef + " (" + survey.country + ")</b><br />- " + numberOfRecs + " Record(s) <br />- " + survey.date + graphs + "<br />- <a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + survey.id + "\">More info</a>");
        });
        return marker;
    }
    function refreshMap() {
        if (markerClusterer != null) {
            markerClusterer.clearMarkers();
        }
        var zoom = 5;
        var size = 50;
        var style = null;
        markerClusterer = new MarkerClusterer(map, markers, {maxZoom: zoom, gridSize: size, styles:styles[style]});
    }

</script>
<div style="border: 1px solid #333333; padding: 5px;">
    Filter by <label for="reefName">Reef</label> <select name="reefName"
                                                         id="reefName"
                                                         dojoType="dijit.form.ComboBox"
                                                         required="true"
                                                         hasDownArrow="true">
    <option selected="selected" value="All">All</option>
    <%
        for (Reef reef : reefs) {
    %>
    <option value="<%=reef.getName()%>"><%=reef.getName()%>
    </option>
    <%
        }
    %>
</select>
    <label for="rating">Rating</label> <select name="rating"
                                               id="rating"
                                               dojoType="dijit.form.ComboBox"
                                               required="true"
                                               hasDownArrow="true">
    <option selected="selected" value="All">All</option>
    <option value="1">1 Star</option>
    <option value="2">2 Stars</option>
    <option value="3">3 Stars</option>
    <option value="4">4 Stars</option>
    <option value="5">5 Stars</option>
</select>
</div>
<br/>

<div id="dialog" dojoType="dijit.Dialog" title="loading..." style="display:none;" align="center">
    <h3 style="text-align:center;">Loading surveys...</h3>
</div>
<div id="map_canvas" style="height: 650px; border: 2px solid #333333"></div>
