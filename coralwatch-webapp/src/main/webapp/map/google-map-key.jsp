<%
    String domainUrl = HttpUtils.getRequestURL(request).toString();
    if (domainUrl.startsWith("http://localhost")) {
%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<% } else if (domainUrl.startsWith("http://coralwatch-uat.metadata.net")) {%>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BQBDfbYjKWh6s09x5iuKv0ZU2QAdBQAZkbafRsp-FfYRV_11IIBzwbCcw"
        type="text/javascript"></script>
<% } else if (domainUrl.startsWith("http://coralwatch.metadata.net")) {%>
<%--TODO Remove this. This key is for coralwatch.metadata.net--%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BRQUGumEEA5VNOyRfA6H2JcRBcMpRSGKOPhfWtwYIQIEFoWKsymkjiraw'></script>
<% } else if (domainUrl.startsWith("http://coralwatch.org")) {%>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BTwU3hJOiuyCVtA4hso86Bt6jZRnxTarlfiE8U59jBHJiMibo2_r9vWng" type="text/javascript"></script>
<% } else if (domainUrl.startsWith("http://www.coralwatch.org")) {%>
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=false&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BSJgx2WEPLBIyjeoD2_MrZlirJZvhSdJKLrQZfrYS8Yulg6Wpil92f-ug" type="text/javascript"></script>
<%}%>