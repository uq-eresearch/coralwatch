<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    int users = Integer.parseInt(renderRequest.getAttribute("users").toString());
    int reefs = Integer.parseInt(renderRequest.getAttribute("reefs").toString());
    int surveys = Integer.parseInt(renderRequest.getAttribute("surveys").toString());
    UserImpl highestContributor = (UserImpl) renderRequest.getAttribute("highestContributor");
%>
<div>
    <h3 style="margin-top:0;">Updates</h3>
    <ul>
        <li><a href="<%=renderRequest.getAttribute("userUrl")%>?p_p_id=reefportlet_WAR_coralwatch"><%=users%>
            Member<%=users > 1 ? "s" : ""%>
        </a></li>
        <li><a href="<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch"><%=reefs%>
            Reef<%=reefs > 1 ? "s" : ""%>
        </a></li>
        <li><a href="<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch"><%=surveys%>
            Survey<%=surveys > 1 ? "s" : ""%>
        </a></li>
        <li>Highest Contribution: <a
                href="<%=renderRequest.getAttribute("userUrl")%>?p_p_id=surveyportlet_WAR_coralwatch"><%=highestContributor.getDisplayName()%>
        </a></li>
    </ul>
    <div align="center">
        <img alt="Coralwatch Updates"
             src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/image/stats_updates.png")%>"/>
    </div>
</div>