<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    UserDao userDao = (UserDao) renderRequest.getPortletSession().getAttribute("userDao");
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");

    List<UserImpl> users = userDao.getAll();
    int numberOfSurveys = users.size();
    int pageSize = 10;
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
<table>
    <tr>
        <th>#</th>
        <th>Display Name</th>
        <th>Joined</th>
        <th>Surveys</th>
        <th>Country</th>
        <th>View</th>
        <th>Edit</th>
    </tr>
    <%
        for (int i = lowerLimit; i < upperLimit; i++) {
            UserImpl aSurvey = users.get(i);
    %>
    <tr>
        <td><%=aSurvey.getId()%>
        </td>
        <td><%=aSurvey.getDisplayName()%>
        </td>
        <td><%=dateFormat.format(aSurvey.getRegistrationDate())%>
        </td>
        <td><%=userDao.getSurveyEntriesCreated(aSurvey).size()%>
        </td>
        <td><%=aSurvey.getCountry() == null ? "" : aSurvey.getCountry()%>
        </td>
        <td><input type="button" value="View"
                   onClick="self.location = '<portlet:renderURL ><portlet:param name="<%= Constants.CMD %>"
            value="<%= Constants.VIEW %>" /><portlet:param name="surveyId"
                                                           value="<%= String.valueOf(aSurvey.getId()) %>"/></portlet:renderURL>';"/>
        </td>
        <%
            if (currentUser != null && currentUser.equals(aSurvey)) {
        %>
        <td><input type="button" value="Edit"
                   onClick="self.location = '<liferay-portlet:renderURL portletName="registration-portlet" ><liferay-portlet:param name="<%= Constants.CMD %>"
            value="<%= Constants.EDIT %>" /><liferay-portlet:param name="surveyId"
                                                           value="<%= String.valueOf(aSurvey.getId()) %>"/></liferay-portlet:renderURL>';"/>
        </td>
        <td><input type="button" value="Delete"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>"
            value="<%= Constants.DELETE %>" /><portlet:param name="surveyId"
                                                             value="<%= String.valueOf(aSurvey.getId()) %>"/></portlet:renderURL>';"/>
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
       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>"
    value="<%= Constants.PREVIEW %>" /><portlet:param name="page"
                                                      value="<%= String.valueOf(i + 1) %>"/></portlet:renderURL>';"><%=i + 1%>
    </a>
    <%
            }
        }
    %>
</div>