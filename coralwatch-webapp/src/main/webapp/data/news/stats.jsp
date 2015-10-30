<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.app.CoralwatchApplication" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    int users = Integer.parseInt(renderRequest.getAttribute("users").toString());
    int reefs = Integer.parseInt(renderRequest.getAttribute("reefs").toString());
    int surveys = Integer.parseInt(renderRequest.getAttribute("surveys").toString());
    int records = Integer.parseInt(renderRequest.getAttribute("records").toString());
    UserImpl highestContributor = (UserImpl) renderRequest.getAttribute("highestContributor");
    String baseUrl = CoralwatchApplication.getConfiguration().getBaseUrl();
%>
<div>
    <h3 style="text-align: left;">
      <span style="font-size: large;">
        <span style="color: rgb(0, 128, 128);">&nbsp;Coralwatch up-to-date</span>
      </span>
    </h3>
    <ul>
        <li>
            <a href="<%=baseUrl+"/"+renderRequest.getAttribute("userUrl")%>?p_p_id=reefportlet_WAR_coralwatch"><%=users%>
                Member<%=users > 1 ? "s" : ""%>
            </a></li>
        <li>
            <a href="<%=baseUrl+"/"+renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch"><%=reefs%>
                Reef<%=reefs > 1 ? "s" : ""%>
            </a></li>
        <li>
            <a href="<%=baseUrl+"/"+renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch"><%=surveys%>
                Survey<%=surveys > 1 ? "s" : ""%>
            </a></li>
        <li><%=records%> Coral<%=records > 1 ? "s" : ""%> Surveyed</li>
        <li>Highest Contributor: <a
                href="<%=baseUrl+"/"+renderRequest.getAttribute("userUrl")%>?p_p_id=userportlet_WAR_coralwatch&_userportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_userportlet_WAR_coralwatch_userId=<%=highestContributor.getId()%>"><%= highestContributor.getDisplayName()%>
        </a></li>
    </ul>
</div>
