<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>


<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<jsp:include page="/include/dojo.jsp"/>
<script type="text/javascript">
    function setValueOfComboBox(combobox, value)
    {
        var e = document.getElementById(combobox);
        if (e) e.value = value;
    }
</script>
<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    ReefDao reefDao = (ReefDao) renderRequest.getPortletSession().getAttribute("reefDao");

    HashMap<String, String> params = (HashMap<String, String>) renderRequest.getPortletSession().getAttribute("params");

    long surveyId = ParamUtil.getLong(request, "surveyId");
    Survey survey = surveyDao.getById(surveyId);
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
        String groupName = survey.getOrganisation();
        String organisationType = survey.getOrganisationType();
        String country = survey.getReef().getCountry();
        String reefName = survey.getReef().getName();
        String weatherCondition = survey.getWeather();
        String activity = survey.getActivity();
        String comments = survey.getComments();
        if (cmd.equals(Constants.EDIT)) {
%>
<div class="coralwatch-portlet-header"><span>Edit Survey</span></div>
<br/>
<%
} else if (cmd.equals(Constants.ADD)) {
%>
<div class="coralwatch-portlet-header"><span>Add New Survey</span></div>
<br/>
<%
    }
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
    <td><input type="text"
               id="organisation"
               name="organisation"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp="...*"
               invalidMessage="Enter the name of the group you are participating with"
               value="<%=groupName == null ? "" : groupName%>"/></td>
</tr>
<tr>
    <th><label for="organisationType">Participating As:</label></th>
    <td><select name="organisationType"
                id="organisationType"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="<%=organisationType == null ? "" : organisationType%>">
        <option selected="selected" value=""></option>
        <option value="Dive Centre">Dive Centre</option>
        <option value="Scientist">Scientist</option>
        <option value="Ecological Manufacturing Group">Ecological Manufacturing Group</option>
        <option value="School/University">School/University</option>
        <option value="Tourist">Tourist</option>
        <option value="Other">Other</option>
    </select>
    </td>
</tr>
<tr>
    <th><label for="country">Country:</label></th>
    <td>
        <select name="country"
                id="country"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="<%=country == null ? "" : country%>">
            <option selected="selected" value=""></option>
            <jsp:include page="/include/countrylist.jsp"/>
        </select>
    </td>
</tr>
<tr>
    <th><label for="reefName">Reef Name:</label></th>
    <td><select name="reefName"
                id="reefName"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="<%=reefName == null ? "" : reefName%>">
        <option selected="selected" value=""></option>
            <%
                    List<Reef> reefs = reefDao.getAll();
                    for (Reef reef : reefs) {
                %>
        <option value="<%=reef.getName()%>"><%=reef.getName()%>
        </option>
            <%
                    }
                %>
    </td>
</tr>
<tr>
    <th>
        <label>Position:</label>
    </th>
    <td>
        <div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:40em;height:20ex">
            <div id="tabDecimal" dojoType="dijit.layout.ContentPane" title="Decimal">
                <table>
                    <tr>
                        <th>
                            <label for="latitude">Latitude:</label>
                        </th>
                        <td>
                            <input type="text"
                                   id="latitude"
                                   name="latitude"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:6,min:-90,max:90}"
                                   trim="true"
                                   onBlur="updateLatFromDecimal()"
                                   invalidMessage="Enter a valid latitude value."
                                   value=""/> <a
                                onClick="jQuery('#locatorMap').dialog('open');return false;" id="locateMapLink"
                                href="#">Locate on map</a>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label for="longitude">Longitude:</label>
                        </th>
                        <td>
                            <input type="text"
                                   id="longitude"
                                   name="longitude"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:6,min:-180,max:360}"
                                   trim="true"
                                   onBlur="updateLonFromDecimal()"
                                   invalidMessage="Enter a valid longitude value."
                                   value=""/>
                        </td>
                    </tr>
                </table>

            </div>
            <div id="tabDegrees" dojoType="dijit.layout.ContentPane" title="Degrees">
                <table>
                    <tr>
                        <th>
                            <label for="latitudeDeg">Latitude:</label>
                        </th>
                        <td>
                            <input type="text"
                                   id="latitudeDeg"
                                   name="latitudeDeg"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:90}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLatFromDegrees()"
                                   invalidMessage="Enter a valid degree value."/>
                            &deg;
                            <input type="text"
                                   id="latitudeMin"
                                   name="latitudeMin"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:59}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLatFromDegrees()"
                                   invalidMessage="Enter a valid minute value."/>
                            &apos;
                            <input type="text"
                                   id="latitudeSec"
                                   name="latitudeSec"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:59}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLatFromDegrees()"
                                   invalidMessage="Enter a valid second value."/>
                            &quot;
                            <select name="latitudeDir"
                                    id="latitudeDir"
                                    required="true"
                                    dojoType="dijit.form.ComboBox"
                                    hasDownArrow="true"
                                    onBlur="updateLatFromDegrees()"
                                    style="width:4.5em;">
                                <option value="north">N</option>
                                <option value="south">S</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <label for="longitudeDeg">Longitude:</label>
                        </th>
                        <td>
                            <input type="text"
                                   id="longitudeDeg"
                                   name="longitudeDeg"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:180}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLonFromDegrees()"
                                   invalidMessage="Enter a valid degree value."/>
                            &deg;
                            <input type="text"
                                   id="longitudeMin"
                                   name="longitudeMin"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:59}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLonFromDegrees()"
                                   invalidMessage="Enter a valid minute value."/>
                            &apos;
                            <input type="text"
                                   id="longitudeSec"
                                   name="longitudeSec"
                                   required="true"
                                   dojoType="dijit.form.NumberTextBox"
                                   constraints="{places:0,min:0,max:59}"
                                   trim="true"
                                   style="width:6em;"
                                   onBlur="updateLonFromDegrees()"
                                   invalidMessage="Enter a valid second value."/>
                            &quot;
                            <select name="longitudeDir"
                                    id="longitudeDir"
                                    required="true"
                                    dojoType="dijit.form.ComboBox"
                                    hasDownArrow="true"
                                    onBlur="updateLonFromDegrees()"
                                    style="width:4.5em;">
                                <option value="east">E</option>
                                <option value="west">W</option>
                            </select>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </td>
</tr>
<tr>
    <th><label for="date">Date:</label></th>
    <td>
        <input type="text"
               id="date"
               name="date"
               required="true"
               isDate="true"
               value=""
               dojoType="dijit.form.DateTextBox"
               constraints="{datePattern: 'dd/MM/yyyy', min:'2000-01-01'}"
               lang="en-au"
               promptMessage="dd/mm/yyyy"
               invalidMessage="Invalid date. Use dd/mm/yyyy format."/>
    </td>
</tr>
<tr>
    <th><label for="time">Time:</label></th>
    <td><input id="time"
               name="time"
               type="text"
               value=""
               required="true"
               dojoType="dijit.form.TimeTextBox"/>
    </td>
</tr>
<tr>
    <th><label for="weather">Light Condition:</label></th>
    <td><select name="weather"
                id="weather"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="<%=weatherCondition == null ? "" : weatherCondition%>">
        <option selected="selected" value=""></option>
        <option value="Full Sunshine">Full Sunshine</option>
        <option value="Broken Cloud">Broken Cloud</option>
        <option value="Cloudy">Cloudy</option>
    </select>
    </td>
</tr>
<tr>
    <th><label for="temperature">Temperature (&deg;C):</label></th>
    <td>
        <input type="text"
               id="temperature"
               name="temperature"
               required="true"
               dojoType="dijit.form.NumberTextBox"
               trim="true"
               onBlur="updateFTemperature()"
               invalidMessage="Enter a valid temperature value."
               value="<%=survey.getTemperature()%>"/>
        (&deg;F):<input type="text"
                        id="temperatureF"
                        name="temperatureF"
                        required="true"
                        dojoType="dijit.form.NumberTextBox"
                        onBlur="updateCTemperature()"
                        trim="true"
                        invalidMessage="Enter a valid temperature value."/>
    </td>
</tr>
<tr>
    <th><label for="activity">Activity:</label></th>
    <td><select name="activity"
                id="activity"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="<%=activity == null ? "" : activity%>">
        <option selected="selected" value=""></option>
        <option value="Reef walking">Reef walking</option>
        <option value="Snorkeling">Snorkeling</option>
        <option value="Diving">Diving</option>
    </select>
    </td>
    </td>
</tr>
<tr>
    <th><label for="comments">Comments:</label></th>
    <td><input type="text"
               id="comments"
               name="comments"
               style="width:300px"
               dojoType="dijit.form.Textarea"
               trim="true"
               value="<%=comments == null ? "" : comments%>"/>
    </td>
</tr>
<tr>
    <td colspan="2"><input type="submit" name="submit"
                           value="<%=cmd.equals(Constants.ADD) ? "Submit" : "Save"%>"/>
        <%
            if (cmd.equals(Constants.EDIT)) {
        %>
        <input type="button" value="Cancel"
               onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="surveyId" value="<%= String.valueOf(surveyId) %>" /></portlet:renderURL>';"/>
        <%
            }
        %>
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
<div class="coralwatch-portlet-header"><span>View Survey</span></div>
<br/>
<table>
    <tr>
        <th>#</th>
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