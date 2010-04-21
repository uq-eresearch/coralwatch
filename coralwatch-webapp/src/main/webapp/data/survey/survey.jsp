<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.SurveyRecord" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery("#tabs2").tabs();
        jQuery("#tabs1").tabs();
        jQuery("#tabs").tabs();
    });
</script>
<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    String qtip = (String) renderRequest.getPortletSession().getAttribute("qtip");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    DateFormat timeFormat = new SimpleDateFormat("HH:mm");

    long surveyId = 0;
    Survey survey = null;
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
        if (currentUser == null) {
%>
<div><span class="portlet-msg-error">You need to sign in to <%=cmd%> a survey.</span></div>
<%
} else {
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    ReefDao reefDao = (ReefDao) renderRequest.getPortletSession().getAttribute("reefDao");

    String groupName = "";
    String organisationType = "";
    String country = "";
    String reefName = "";
    String weatherCondition = "";
    String activity = "";
    String comments = "";
%>

<%--<jsp:include page="/include/dojo.jsp"/>--%>
<script type="text/javascript">
    function validate()
    {
        var myform = dojo.query(".surveyform");
        myform.validate();
        if (!myform.isValid()) {
            alert('Form contains invalid data. Please correct first');
            return false;
        }
        return true;
    }
</script>
<%
    if (cmd.equals(Constants.EDIT)) {
        surveyId = ParamUtil.getLong(request, "surveyId");
        survey = surveyDao.getById(surveyId);
        groupName = survey.getOrganisation();
        organisationType = survey.getOrganisationType();
        country = survey.getReef().getCountry();
        reefName = survey.getReef().getName();
        weatherCondition = survey.getWeather();
        activity = survey.getActivity();
        comments = survey.getComments();
%>

<div class="coralwatch-portlet-header"><span>Edit Survey</span></div>
<br/>
<%
} else if (cmd.equals(Constants.ADD)) {
%>
<div class="coralwatch-portlet-header"><span>Add New Survey</span></div>
<br/>

<div id="tabs1">
<ul>
    <li><a href="#fragment-1"><span>Survey</span></a></li>
</ul>
<div id="fragment-1">
<%
    }
    if (!errors.isEmpty()) {
        for (SubmissionError error : errors) {
%>
<div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
<%
        }
    }
%>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm" class="surveyform"
      onsubmit="return validate();">
<input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
<table>
<%
    if (cmd.equals(Constants.EDIT)) {
%>
<input name="surveyId" type="hidden" value="<%= surveyId %>"/>
<tr>
    <th>Creator:</th>
    <td><%= survey.getCreator().getDisplayName()%>
    </td>
</tr>
<%
    }
%>
<tr>
    <th><label for="organisation">Organisation:</label></th>
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
    <th><label for="organisationType">Organisation Type:</label></th>
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
        <div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:40em;height:18ex">
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
                                   value="<%=cmd.equals(Constants.EDIT) ? survey.getLatitude() : ""%>"/> <a
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
                                   value="<%=cmd.equals(Constants.EDIT) ? survey.getLongitude() : ""%>"/>
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
    <th><label for="date">Observation Date:</label></th>
    <td>
        <input type="text"
               id="date"
               name="date"
               required="true"
               isDate="true"
               value="<%=cmd.equals(Constants.EDIT) ? survey.getDate() : ""%>"
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
               value="<%=cmd.equals(Constants.EDIT) ? (survey.getTime().getHours() + ":" + survey.getTime().getMinutes()) : ""%>"
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
               value="<%=cmd.equals(Constants.EDIT) ? survey.getTemperature() : ""%>"/>
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
</div>
</div>
<%
    }
} else if (cmd.equals(Constants.VIEW)) {
    surveyId = ParamUtil.getLong(request, "surveyId");
    survey = surveyDao.getById(surveyId);
%>

<div class="coralwatch-portlet-header"><span>Survey</span></div>
<br/>

<div id="tabs">
    <ul>
        <li><a href="#fragment-2"><span>Survey</span></a></li>
        <li><a href="#fragment-3"><span>Data</span></a></li>
    </ul>
    <div id="fragment-2">
        <table>
            <%
                if (survey.getCreator().equals(currentUser)) {
            %>

            <%
                }
            %>
            <tr>
                <th>Creator</th>
                <td><%= survey.getCreator().getDisplayName() == null ? "" : survey.getCreator().getDisplayName()%>
                </td>
                <td rowspan="4">
                    <%
                        if (survey.getCreator().getGravatarUrl() != null) {
                    %>
                    <div style="float:right;"><a href=""><img src="<%=survey.getCreator().getGravatarUrl()%>"
                                                              alt="<%=survey.getCreator().getDisplayName()%>"/></a><br/>
                    </div>
                    <%
                        }
                    %></td>
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
                <td><%=survey.getDate() == null ? "" : dateFormat.format(survey.getDate())%>
                </td>
            </tr>
            <tr>
                <th>Time:</th>
                <td><%=survey.getTime() == null ? "" : timeFormat.format(survey.getTime())%>
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
    </div>
    <div id="fragment-3">
        <table>
            <tr>
                <th nowrap="nowrap">Coral Type</th>
                <th nowrap="nowrap">Lightest</th>
                <th nowrap="nowrap">Darkest</th>
                <th nowrap="nowrap">Delete</th>
            </tr>
            <%
                List<SurveyRecord> surveyRecords = surveyDao.getSurveyRecords(survey);
                for (SurveyRecord record : surveyRecords) {
            %>
            <tr>
                <td><%=record.getCoralType()%>
                </td>
                <td><%=record.getLightestLetter() + "" + record.getLightestNumber()%>
                </td>
                <td><%=record.getDarkestLetter() + "" + record.getDarkestNumber()%>
                </td>
                <td>
                    <input type="button" value="Delete"/>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        <form method="post">
            <input type="hidden" name="surveyId" value="<%=survey.getId()%>"/>
            <table width="100%">
                <tr>
                    <th nowrap="nowrap">Coral Type</th>
                    <th nowrap="nowrap">Lightest</th>
                    <th nowrap="nowrap">Darkest</th>
                    <th nowrap="nowrap"></th>
                </tr>
                <tr>
                    <td nowrap="nowrap">
                        <input dojoType="dijit.form.RadioButton" id="coralType_0" name="coralType" value="Branching"
                               type="radio"/>
                        <label for="coralType_0"> Branching </label>
                        <input dojoType="dijit.form.RadioButton" id="coralType_1" name="coralType" value="Boulder"
                               type="radio"/>
                        <label for="coralType_1"> Boulder </label>
                        <input dojoType="dijit.form.RadioButton" id="coralType_2" name="coralType" value="Plate"
                               type="radio"/>
                        <label for="coralType_2"> Plate </label>
                        <input dojoType="dijit.form.RadioButton" id="coralType_3" name="coralType" value="Soft"
                               type="radio"/>
                        <label for="coralType_3"> Soft </label>
                    </td>
                    <td nowrap="nowrap">
                        <jsp:include page="light-color-field.jsp"/>
                    </td>
                    <td nowrap="nowrap">
                        <jsp:include page="dark-color-field.jsp"/>
                    </td>
                    <td>
                        <button dojoType="dijit.form.Button" type="submit" name="submit">Add</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>
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
<div id="tabs2">
    <ul>
        <li><a href="#fragment-4"><span>Surveys</span></a></li>
    </ul>
    <div id="fragment-4">
        <%
            if (currentUser != null) {
        %>
        <a href="#"
           onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>';">New
            Survey</a>
        <br/><br/>
        <%
            }
        %>
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
                <td><%=dateFormat.format(aSurvey.getDate())%>
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
                <td><input type="button" value="Delete"
                           onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';"/>
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
    </div>
</div>
<%

    }
%>