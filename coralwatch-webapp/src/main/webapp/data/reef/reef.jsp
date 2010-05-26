<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="liferay-portlet" uri="http://liferay.com/tld/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    ReefDao reefDao = (ReefDao) renderRequest.getAttribute("reefDao");
    SurveyDao surveyDao = (SurveyDao) renderRequest.getAttribute("surveyDao");
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
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
            if (reefDao.getSurveysByReef(reef).size() > 0) {
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
        <%
        } else {
        %>
        <span style="text-align:center;">No surveys conducted in this reef yet.</span>
        <%
            }
        %>
    </div>
    <div id="surveys" dojoType="dijit.layout.ContentPane" title="Data" style="width:680px; height:60ex">
        <% List<Survey> surveysOnReef = reefDao.getSurveysByReef(reef);
            int numberOfSurveys = surveysOnReef.size();
            if (numberOfSurveys > 0) {
            String downloadUrl = "/data-download?id=" + reefId;
        %>
        <div align="right">
        <a href="<%=renderResponse.encodeURL(renderRequest.getContextPath() + downloadUrl)%>">Dowload Data</a>
        </div>
        <%

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
        <table class="coralwatch_list_table">
            <tr>
                <th>Creator</th>
                <th>Date</th>
                <th>Reef</th>
                <th>Country</th>
                <th>Records</th>
                <th>View</th>
                <%
                    if (currentUser != null) {
                %>
                <th>Edit</th>
                <th>Delete</th>
                <%
                    }
                %>
            </tr>
            <%
                for (int i = lowerLimit; i < upperLimit; i++) {
                    Survey aSurvey = surveysOnReef.get(i);
            %>
            <tr>
                <td><%=aSurvey.getCreator().getDisplayName()%>
                </td>
                <td><%=dateFormat.format(aSurvey.getDate())%>
                </td>
                <td><%=aSurvey.getReef().getName()%>
                </td>
                <td><%=aSurvey.getReef().getCountry()%>
                </td>
                <td><%=surveyDao.getSurveyRecords(aSurvey).size()%>
                </td>
                <td><a href="<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=<%= String.valueOf(aSurvey.getId()) %>">View</a>
                </td>
                <%
                    if (currentUser != null && currentUser.equals(aSurvey.getCreator()) || (currentUser != null && currentUser.isSuperUser())) {
                %>
                <td><a href="#" onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';">Edit</a>
                </td>
                <td><a href="#" onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';">Delete</a>
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

            <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.PREVIEW %>" /><portlet:param name="page" value="<%= String.valueOf(i + 1) %>" /></portlet:renderURL>"><%=i + 1%>
            </a>
            <%
                    }
                }
            %>
        </div>

        <%
        } else {
        %>
        <span style="text-align:center;">No surveys conducted in this reef yet.</span>
        <%
            }
        %>
    </div>
</div>
<%

} else {
    List<Reef> reefs = reefDao.getAll();
    int numberOfSurveys = reefs.size();
    if (numberOfSurveys < 1) {
        %>
        <span style="text-align:center;">No reefs recorded yet.</span>
        <%
    } else {
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
<table class="coralwatch_list_table">
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
        <td><a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>">View</a>
        </td>
        <%
            if (currentUser != null && currentUser.isSuperUser()) {
        %>
        <td><a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>">Edit</a>
        </td>
        <td><a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="reefId" value="<%= String.valueOf(aReef.getId()) %>" /></portlet:renderURL>">Delete</a>
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

    <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.PREVIEW %>" /><portlet:param name="page" value="<%= String.valueOf(i + 1) %>" /></portlet:renderURL>"><%=i + 1%>
    </a>
    <%
            }
        }
    %>
</div>
<%
        }
    }
%>