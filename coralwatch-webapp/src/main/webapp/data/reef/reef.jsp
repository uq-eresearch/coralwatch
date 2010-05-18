<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    ReefDao reefDao = (ReefDao) renderRequest.getPortletSession().getAttribute("reefDao");
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (cmd.equals(Constants.VIEW)) {
        long reefId = ParamUtil.getLong(request, "reefId");
        Reef reef = reefDao.getById(reefId);

%>
<script type="text/javascript">
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
</script>
<h2><%=reef.getName()%> (<%=reef.getCountry()%>)</h2>

<div id="reefContainer" dojoType="dijit.layout.TabContainer" style="width:680px;height:60ex">
    <div id="graphs" dojoType="dijit.layout.ContentPane" title="Graphs" style="width:680px; height:60ex">
        <%
            String pieChartUrl = "/graph?type=reef&id=" + reefId + "&chart=shapePie&width=512&height=512&labels=true&legend=true&titleSize=12";
            String barChartUrl = "/graph?type=reef&id=" + reefId + "&chart=coralCount&width=512&height=512&legend=false&titleSize=12";
            String timelineChartUrl = "/graph?type=reef&id=" + reefId + "&chart=timeline&width=512&height=512&legend=false&titleSize=12";
        %>
        <br/>
        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + timelineChartUrl)%>"
                    alt="Colour Distribution" width="512" height="512"/>
        </div>
        <br/>
        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + barChartUrl)%>"
                    alt="Colour Distribution" width="512" height="512"/>
        </div>
        <br/>
        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + pieChartUrl)%>"
                     alt="Shape Distribution" width="512" height="512"/>
        </div>
    </div>
    <div id="surveys" dojoType="dijit.layout.ContentPane" title="Data" style="width:680px; height:60ex">
        <%
            String downloadUrl  ="/data-download?id=" + reefId;
        %>
        <a href="<%=renderResponse.encodeURL(renderRequest.getContextPath() + downloadUrl)%>">Dowload Data</a>
    </div>
</div>
<%

} else {
    List<Reef> reefs = reefDao.getAll();
    int numberOfSurveys = reefs.size();
    int pageSize = 20;
    int pageNumber = ParamUtil.getInteger(request, "page");
    if (pageNumber <= 0) {
        pageNumber = 1;
    }
    int lowerLimit = (pageNumber - 1) * pageSize;
    int upperLimit = lowerLimit + pageSize;
    int numberOfPages = numberOfSurveys / pageSize;
    if (numberOfSurveys % pageSize > 0) {
        numberOfPages++;
        if (pageNumber == numberOfPages) {
            upperLimit = lowerLimit + (numberOfSurveys % pageSize);
        }
    }
%>

<h2 style="margin-top:0;">All Reefs</h2>
<table>
    <tr>
        <th>Name</th>
        <th>Country</th>
        <th>Surveys</th>
        <th>View</th>
        <%
            if (currentUser != null && currentUser.isSuperUser()) {
        %>
        <th>Edit</th>
        <th>Delete</th>
        <%
            }
        %>
    </tr>
    <%
        for (int i = lowerLimit; i < upperLimit; i++) {
            Reef aReef = reefs.get(i);
    %>
    <tr>
        <td><%=aReef.getName()%>
        </td>
        <td><%=aReef.getCountry()%>
        </td>
        <td><%=reefDao.getSurveysByReef(aReef).size()%>
        </td>
        <td><input type="button" value="View"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>';"/>
        </td>
        <%
            if (currentUser != null && currentUser.isSuperUser()) {
        %>
        <td><input type="button" value="Edit"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>';"/>
        </td>
        <td><input type="button" value="Delete"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>';"/>
        </td>
        <%
            }
        %>
    </tr>
    <%
        }
    %>
</table>
<div style="text-align:center;"><span>Page:</span>
    <%
        for (int i = 0; i < numberOfPages; i++) {
            if (i == pageNumber - 1) {
    %>
    <span style="text-decoration:underline;"><%=i + 1%></span>
    <%
    } else {
    %>

    <a href="#"
       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.PREVIEW %>" /><portlet:param name="page" value="<%= String.valueOf(i + 1) %>" /></portlet:renderURL>';"><%=i + 1%>
    </a>
    <%
            }
        }
    %>
</div>
<%
    }
%>