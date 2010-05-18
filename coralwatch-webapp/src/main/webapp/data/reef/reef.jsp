<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    ReefDao reefDao = (ReefDao) renderRequest.getPortletSession().getAttribute("reefDao");
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
        <th>Download</th>
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
        <td>
        </td>
        <td>
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