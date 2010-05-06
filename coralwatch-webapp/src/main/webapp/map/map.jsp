<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="java.util.List" %>

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

<script type="text/javascript">
    dojo.addOnLoad(
            function() {
                if (GBrowserIsCompatible()) {
                    var map = new GMap2(document.getElementById("map_canvas"));
                    map.setCenter(new GLatLng(25.799891, 15.468750), 2);
                    map.setMapType(G_HYBRID_MAP);
                    map.setUIToDefault();

                <%
                SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
                List<Survey> surveys=surveyDao.getAll();
                for(Survey survey: surveys){
                %>
                    var point = new GLatLng(<%=survey.getLatitude()%>, <%=survey.getLongitude()%>);
                    var marker = new GMarker(point);
                    GEvent.addListener(marker, "click", function() {
                        marker.openInfoWindowHtml("<table><tr><td>Reef</td><td><%=survey.getReef().getName()%></td></tr></table><br /><br /><a href=\"#\">More info</a>");
                    });
                    map.addOverlay(marker);
                <%
                }
                %>
                }
            });            
</script>
<div id="map_canvas" style="height: 650px;"></div>