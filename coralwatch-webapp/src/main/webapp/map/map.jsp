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
                    var map = new GMap2(document.getElementById("map"));
                    map.setCenter(new GLatLng(25.799891, 15.468750), 2);
                    map.setMapType(G_MAPMAKER_HYBRID_MAP);
                    map.setUIToDefault();
                }
            });
</script>
<div id="map" style="height: 650px;"></div>