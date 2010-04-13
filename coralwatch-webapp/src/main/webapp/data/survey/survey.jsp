<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>


<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    HashMap<String, String> params = (HashMap<String, String>) renderRequest.getPortletSession().getAttribute("params");
    long surveyId = ParamUtil.getLong(request, "surveyId");
    Survey survey = surveyDao.getById(surveyId);
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
%>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <table>
        <%
            if (cmd.equals(Constants.EDIT)) {
        %>
        <tr>
            <th>Creator:</th>
            <td><%= survey.getCreator().getDisplayName()%>
            </td>
        </tr>
        <%
            }
        %>
        <tr>
            <th><label for="organisation">Group Name:</label></th>
            <td><input type="text" id="organisation" name="organisation" value=""/></td>
        </tr>
        <tr>
            <th><label for="organisationType">Participating As:</label></th>
            <td><select name="organisationType" id="organisationType" value="">
                <option selected="selected" value="DiveCentre">Dive Centre</option>
                <option value="Scientist">Scientist</option>
                <option value="Eco">Ecological Manufacturing Group</option>
                <option value="Student">School/University</option>
                <option value="Tourist">Tourist</option>
                <option value="Other">Other</option>
            </select>
            </td>
        </tr>
        <tr>
            <th><label for="country">Country:</label></th>
            <td>
                <select name="country" id="country" value="">
                    <option selected="selected" value=""></option>
                    <jsp:include page="/include/countrylist.jsp"/>
                </select>
            </td>
        </tr>
        <tr>
            <th><label for="reefName">Reef Name:</label></th>
            <td><select name="reefName" id="reefName" value="">
                <option selected="selected" value=""></option>
            </select>
            </td>
        </tr>
        <tr>
            <th><label for="latitude">Latitude:</label></th>
            <td><input type="text" id="latitude" name="latitude" value=""/></td>
        </tr>
        <tr>
            <th><label for="longitude">Longitude:</label></th>
            <td><input type="text" id="longitude" name="longitude" value=""/></td>
        </tr>
        <tr>
            <th><label for="date">Date:</label></th>
            <td><input type="text" id="date" name="date" value=""/></td>
        </tr>
        <tr>
            <th><label for="time">Time:</label></th>
            <td><input id="time" name="time" type="text" value=""/></td>
        </tr>
        <tr>
            <th><label for="weather">Light Condition:</label></th>
            <td><select name="weather" id="weather" value="">
                <option value="Full Sunshine">Full Sunshine</option>
                <option value="Broken Cloud">Broken Cloud</option>
                <option value="Cloudy">Cloudy</option>
            </select>
            </td>
        </tr>
        <tr>
            <th><label for="temperature">Temperature (&deg;C):</label></th>
            <td><input type="text" id="temperature" value=""/></td>
        </tr>
        <tr>
            <th><label for="activity">Activity:</label></th>
            <td><select name="activity" id="activity" value="">
                <option value="Reef_walking">Reef walking</option>
                <option value="Snorkeling">Snorkeling</option>
                <option value="Diving">Diving</option>
            </select>
            </td>
        </tr>
        <tr>
            <th><label for="comments">Comments:</label></th>
            <td><input type="text" id="comments" name="comments"
                       style="width:300px"
                       value=""/>
            </td>
        </tr>
    </table>
</form>
<%
} else if (cmd.equals(Constants.VIEW)) {
%>
<div class="coralwatch-portlet-header"><span>Survey</span></div>
<%
    if (survey.getCreator().getGravatarUrl() != null) {

%>
<div style="float:right;"><a href=""><img src="<%=survey.getCreator().getGravatarUrl()%>"
                                          alt="<%=survey.getCreator().getDisplayName()%>"/></a><br/></div>
<%
    }
%>
<br/>
<table>
    <tr>
        <th>Creator</th>
        <td><%= survey.getCreator().getDisplayName() == null ? "" : survey.getCreator().getDisplayName()%>
        </td>
    </tr>
    <tr>
        <th>Group Name:</th>
        <td><%=survey.getOrganisation() == null ? "" : survey.getOrganisation()%>
        </td>
    </tr>
    <tr>
        <th>Participating As:</th>
        <td><%= survey.getOrganisationType() == null ? "" : survey.getOrganisationType()%>
        </td>
    </tr>
    <tr>
        <th>Country:</th>
        <td><%= survey.getReef().getCountry() == null ? "" : survey.getReef().getCountry()%>
        </td>
    </tr>
    <tr>
        <th>Reef:</th>
        <td><%= survey.getReef().getName() == null ? "" : survey.getReef().getName()%>
        </td>
    </tr>
    <tr>
        <th>Latitude:</th>
        <td><%=survey.getLatitude()%>
        </td>
    </tr>
    <tr>
        <th>Longitude:</th>
        <td><%=survey.getLongitude()%>
        </td>
    </tr>
    <tr>
        <th>Observation Date:</th>
        <td><%=survey.getDate() == null ? "" : survey.getDate()%>
        </td>
    </tr>
    <tr>
        <th>Time:</th>
        <td><%=survey.getTime() == null ? "" : survey.getTime()%>
        </td>
    </tr>
    <tr>
        <th>Weather Condition:</th>
        <td><%=survey.getWeather() == null ? "" : survey.getWeather()%>
        </td>
    </tr>
    <tr>
        <th>Temperature:</th>
        <td><%=survey.getTemperature()%>
        </td>
    </tr>
    <tr>
        <th>Activity:</th>
        <td><%=survey.getActivity() == null ? "" : survey.getActivity()%>
        </td>
    </tr>
    <tr>
        <th>Comments:</th>
        <td><%=survey.getComments() == null ? "" : survey.getComments()%>
        </td>
    </tr>
    <tr>
        <th>Submitted:</th>
        <td><%=survey.getDateSubmitted() == null ? "" : survey.getDateSubmitted()%>
        </td>
    </tr>
    <tr>
        <th>Last Edited:</th>
        <td><%=survey.getDateModified() == null ? "" : survey.getDateModified()%>
        </td>
    </tr>

    <tr>
        <th>Community Rating:</th>
        <td></td>
    </tr>
    <%
        if (currentUser != null && currentUser.equals(survey.getCreator())) {
    %>
    <tr>
        <td colspan="2"><input type="button" value="Edit"
                               onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:renderURL>';"/>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%

} else {
    List<Survey> surveys = surveyDao.getAll();
    int numberOfSurveys = surveys.size();
    int pageSize = 10;
    int numberOfPages = numberOfSurveys / pageSize + 1;
    int pageNumber = ParamUtil.getInteger(request, "page");
    if (pageNumber <= 0) {
        pageNumber = 1;
    }
    int lowerLimit = (pageNumber - 1) * pageSize;
    int upperLimit = (pageNumber) * pageSize;
%>
<div class="coralwatch-portlet-header"><span>View Survey</span></div>
<br/>
<table>
    <tr>
        <th align="center">#</th>
        <th>Creator</th>
        <th>Date</th>
        <th>Reef</th>
        <th>Country</th>
        <th>View</th>
        <th>Edit</th>
    </tr>
    <%
        for (int i = lowerLimit; i < upperLimit; i++) {
            Survey aSurvey = surveys.get(i);
    %>
    <tr>
        <td><%=aSurvey.getId()%>
        </td>
        <td><%=aSurvey.getCreator().getDisplayName()%>
        </td>
        <td><%=aSurvey.getDate()%>
        </td>
        <td><%=aSurvey.getReef().getName()%>
        </td>
        <td><%=aSurvey.getReef().getCountry()%>
        </td>
        <td><input type="button" value="View"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';"/>
        </td>
        <%
            if (currentUser != null && currentUser.equals(aSurvey.getCreator())) {
        %>
        <td><input type="button" value="Edit"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';"/>
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
    %>
    <a href="#"
       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.PREVIEW %>" /><portlet:param name="page" value="<%= String.valueOf(i + 1) %>" /></portlet:renderURL>';"><%=i + 1%>
    </a>
    <%
        }
    %>
</div>
<%

    }
%>