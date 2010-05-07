<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserDao userDao = (UserDao) renderRequest.getPortletSession().getAttribute("userDao");
    ReefDao reefDao = (ReefDao) renderRequest.getPortletSession().getAttribute("reefDao");
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
%>
<div>
    <h3>Updates</h3>
    <ul>
        <li><%=userDao.getAll().size()%> Member<%=userDao.getAll().size() > 1 ? "s" : ""%>
        </li>
        <li><a href="#"><%=reefDao.getAll().size()%> Reef<%=reefDao.getAll().size() > 1 ? "s" : ""%>
        </a></li>
        <li><a href="#"><%=surveyDao.getAll().size()%> Survey<%=surveyDao.getAll().size() > 1 ? "s" : ""%>
        </a></li>
    </ul>
    <div align="center">
    <img alt="Coralwatch Updates" src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/image/stats_updates.png")%>"/>
    </div>
</div>