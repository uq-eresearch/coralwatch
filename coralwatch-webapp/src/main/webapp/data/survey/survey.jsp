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
    dojo.locale = "en";
    dojo.require("dojo.fx");
    dojo.require("dojo.parser");
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.Button");
    dojo.require("dijit.form.RadioButton");
    dojo.require("dijit.form.ComboBox");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.NumberTextBox");
    dojo.require("dijit.form.ValidationTextBox");
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
    dojo.require("dijit.TooltipDialog");
    dojo.require("dijit.form.DropDownButton");

</script>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    SurveyDao surveyDao = (SurveyDao) renderRequest.getPortletSession().getAttribute("surveyDao");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    DateFormat timeFormat = new SimpleDateFormat("'T'HH:mm");
    DateFormat timeFormatDisplay = new SimpleDateFormat("HH:mm");

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

<h2>Edit Survey</h2>
<br/>
<%
} else if (cmd.equals(Constants.ADD)) {
%>
<h2>Add New Survey</h2>
<br/>
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

<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">

<% if (HttpUtils.getRequestURL(request).toString().startsWith("http://localhost")) {
%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<% } else {%>
<%--TODO Remove this. This key is for coralwatch.metadata.net--%>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAYJ0-yjhies4aZVt60XiE1BRQUGumEEA5VNOyRfA6H2JcRBcMpRSGKOPhfWtwYIQIEFoWKsymkjiraw'></script>
<%}%>

<script type="text/javascript">
    dojo.addOnLoad(
            function() {
                dojo.byId("organisation").focus();
                dojo.byId("latitude").style.display = 'inline';
                updateLonFromDecimal();
                updateLatFromDecimal();
                updateFTemperature();
                updateCTemperature();
            }
            );
</script>
<script type="dojo/method" event="onSubmit">
    if(!this.validate()){
    alert('Form contains invalid data. Please correct errors first.');
    return false;
    }
    return true;
</script>
<%--<div id="locatorMap" style="width: 470px; height: 320px;"></div>--%>
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
                                   onChange="updateLatFromDecimal"
                                   invalidMessage="Enter a valid latitude value."
                                   value="<%=cmd.equals(Constants.EDIT) ? survey.getLatitude() : ""%>"/>

                            <div id="locator" dojoType="dijit.form.DropDownButton" label="Locate On Map">
                                <div dojoType="dijit.TooltipDialog">
                                    <div id="locatorMap" style="width: 470px; height: 320px;">
                                        <script type="text/javascript">
                                            if (GBrowserIsCompatible()) {
                                                var mapDiv = dojo.byId("locatorMap");
                                                var map = new GMap2(mapDiv);
                                                map.setCenter(new GLatLng(0, 0), 1);
                                                map.enableScrollWheelZoom();
                                                map.enableContinuousZoom();
                                                map.addControl(new GLargeMapControl3D());
                                                map.addControl(new GMapTypeControl());
                                                map.addMapType(G_PHYSICAL_MAP);
                                                map.setMapType(G_HYBRID_MAP);
                                                map.removeMapType(G_SATELLITE_MAP);
                                                map.getContainer().style.overflow = "hidden";
                                                GEvent.addListener(map, 'click', function(overlay, latlng) {
                                                    var Lat5 = latlng.lat();
                                                    var Lng5 = latlng.lng();
                                                    document.getElementById("latitude").value = Lat5.toFixed(6);
                                                    updateLatFromDecimal();
                                                    document.getElementById("longitude").value = Lng5.toFixed(6);
                                                    updateLonFromDecimal();
                                                });
                                            } else {
                                                alert("Sorry, the Google Maps API is not compatible with this browser");
                                            }
                                        </script>
                                    </div>
                                </div>
                            </div>
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
                                   onChange="updateLonFromDecimal()"
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
               value="<%=cmd.equals(Constants.EDIT) ? dateFormat.format(survey.getDate()) : ""%>"
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
               timePattern="HH:mm"
               clickableIncrement="T00:15:00"
               visibleIncrement="T00:15:00"
               visibleRange="T03:00:00"
               value="<%=cmd.equals(Constants.EDIT) ? timeFormat.format(survey.getTime()) : ""%>"
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
               onChange="updateFTemperature()"
               invalidMessage="Enter a valid temperature value."
               value="<%=cmd.equals(Constants.EDIT) ? survey.getTemperature() : ""%>"/>
        (&deg;F): <input type="text"
                         id="temperatureF"
                         name="temperatureF"
                         required="true"
                         dojoType="dijit.form.NumberTextBox"
                         onBlur="updateCTemperature()"
                         onChange="updateCTemperature()"
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
    }
} else if (cmd.equals(Constants.VIEW)) {
    surveyId = ParamUtil.getLong(request, "surveyId");
    survey = surveyDao.getById(surveyId);
%>
<script type="text/javascript">
    dojo.addOnLoad(function() {
        dijit.byId('<%=ParamUtil.getString(request, "selectedTab")%>').setAttribute('selected', true);
    });
</script>
<h2>Survey Details</h2>
<br/>

<div id="surveyDetailsContainer" dojoType="dijit.layout.TabContainer" style="width:650px;height:60ex">
<div id="metadataTab" dojoType="dijit.layout.ContentPane" title="Metadata" style="width:650px; height:60ex">
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
            <td><%=survey.getTime() == null ? "" : timeFormatDisplay.format(survey.getTime())%>
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

<div id="dataTab" dojoType="dijit.layout.ContentPane" title="Data" style="width:650px; height:60ex">
<%
    List<SurveyRecord> surveyRecords = surveyDao.getSurveyRecords(survey);
    if (!surveyRecords.isEmpty()) {
%>
<table>
    <tr>
        <th nowrap="nowrap">Coral Type</th>
        <th nowrap="nowrap">Lightest</th>
        <th nowrap="nowrap">Darkest</th>
        <%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
        <th nowrap="nowrap">Delete</th>
        <%}%>
    </tr>
    <%

        for (SurveyRecord record : surveyRecords) {
    %>
    <tr>
        <td><%=record.getCoralType()%>
        </td>
        <td><%=record.getLightestLetter() + "" + record.getLightestNumber()%>
        </td>
        <td><%=record.getDarkestLetter() + "" + record.getDarkestNumber()%>
        </td>
        <%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
        <td>
            <input type="button" value="Delete"
                   onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="deleterecord" /><portlet:param name="recordId" value="<%= String.valueOf(record.getId()) %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:actionURL>';"/>
        </td>
        <%}%>
    </tr>
    <%
        }
    %>
</table>
<%
} else {
%>
<span style="text-align:center;">No Data Recorded</span>
<%
    }
%>
<%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm"
      jsId="recordForm" id="recordForm">

<script type="text/javascript">

    function setColor(colorCode, slate, inputField) {
        dijit.byId(slate).setAttribute('label', colorCode);
        dojo.byId(inputField).setAttribute('value', colorCode);
    }
</script>
<script type="dojo/method" event="onSubmit">
    var isValid = dojo.query('INPUT[name=coralType]', 'recordForm').
    filter(function(n) { return n.checked }).length > 0;
    var selectedLightColor = dojo.query('INPUT[name=light_color_input]', 'recordForm').
    filter(function(n) { return n.getAttribute('value') != ""; }).length > 0;
    var selectedDarkColor = dojo.query('INPUT[name=dark_color_input]', 'recordForm').
    filter(function(n) { return n.getAttribute('value') != ""; }).length > 0;
    if (!isValid) {
    alert('You must select coral type to submit a record.');
    return false;
    }
    if (!selectedLightColor) {
    alert('You must select lightest colour.');
    return false;
    }
    if (!selectedDarkColor) {
    alert('You must select darkest colour.');
    return false;
    }
    return true;
</script>

<input type="hidden" name="surveyId" value="<%= String.valueOf(survey.getId()) %>"/>
<input type="hidden" name="<%= Constants.CMD %>" value="saverecord"/>
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
    <input dojoType="dijit.form.TextBox" name="light_color_input" id="light_color_input" type="hidden" value=""/>

    <div id="light_color_slate" dojoType="dijit.form.DropDownButton" label="" style="width:30px">
        <div dojoType="dijit.TooltipDialog">
            <table style="cursor:pointer;">
                <tr>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('B1', 'light_color_slate', 'light_color_input')">B1
                    </td>
                    <td style="background-color:#ccffcc;"
                        onClick="setColor('B2', 'light_color_slate', 'light_color_input')">B2
                    </td>
                    <td style="background-color:#99ff99;"
                        onClick="setColor('B3', 'light_color_slate', 'light_color_input')">B3
                    </td>
                    <td style="background-color:#66cc00;"
                        onClick="setColor('B4', 'light_color_slate', 'light_color_input')">B4
                    </td>
                    <td style="background-color:#339900;"
                        onClick="setColor('B5', 'light_color_slate', 'light_color_input')">B5
                    </td>
                    <td style="background-color:#006600;"
                        onClick="setColor('B6', 'light_color_slate', 'light_color_input')">B6
                    </td>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('C1', 'light_color_slate', 'light_color_input')">C1
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#333300;"
                        onClick="setColor('E6', 'light_color_slate', 'light_color_input')">E6
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#ffcccc;"
                        onClick="setColor('C2', 'light_color_slate', 'light_color_input')">C2
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#666600;"
                        onClick="setColor('E5', 'light_color_slate', 'light_color_input')">E5
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#ff6666;"
                        onClick="setColor('C3', 'light_color_slate', 'light_color_input')">C3
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#666600;"
                        onClick="setColor('E4', 'light_color_slate', 'light_color_input')">E4
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#cc3300;"
                        onClick="setColor('C4', 'light_color_slate', 'light_color_input')">C4
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#999900;"
                        onClick="setColor('E3', 'light_color_slate', 'light_color_input')">E3
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#993300;"
                        onClick="setColor('C5', 'light_color_slate', 'light_color_input')">C5
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#cccc00;"
                        onClick="setColor('E2', 'light_color_slate', 'light_color_input')">E2
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#330000;"
                        onClick="setColor('C6', 'light_color_slate', 'light_color_input')">C6
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('E1', 'light_color_slate', 'light_color_input')">E1
                    </td>
                    <td style="background-color:#330000;"
                        onClick="setColor('D6', 'light_color_slate', 'light_color_input')">D6
                    </td>
                    <td style="background-color:#663300;"
                        onClick="setColor('D5', 'light_color_slate', 'light_color_input')">D5
                    </td>
                    <td style="background-color:#993300;"
                        onClick="setColor('D4', 'light_color_slate', 'light_color_input')">D4
                    </td>
                    <td style="background-color:#ff9933;"
                        onClick="setColor('D3', 'light_color_slate', 'light_color_input')">D3
                    </td>
                    <td style="background-color:#ffcc99;"
                        onClick="setColor('D2', 'light_color_slate', 'light_color_input')">D2
                    </td>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('D1', 'light_color_slate', 'light_color_input')">D1
                    </td>
                </tr>
            </table>
        </div>
    </div>
</td>
<td nowrap="nowrap">
    <input dojoType="dijit.form.TextBox" name="dark_color_input" id="dark_color_input" type="hidden" value=""/>

    <div id="dark_color_slate" dojoType="dijit.form.DropDownButton" label="" style="width:30px">
        <div dojoType="dijit.TooltipDialog">
            <table style="cursor:pointer;">
                <tr>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('B1', 'dark_color_slate', 'dark_color_input')">B1
                    </td>
                    <td style="background-color:#ccffcc;"
                        onClick="setColor('B2', 'dark_color_slate', 'dark_color_input')">B2
                    </td>
                    <td style="background-color:#99ff99;"
                        onClick="setColor('B3', 'dark_color_slate', 'dark_color_input')">B3
                    </td>
                    <td style="background-color:#66cc00;"
                        onClick="setColor('B4', 'dark_color_slate', 'dark_color_input')">B4
                    </td>
                    <td style="background-color:#339900;"
                        onClick="setColor('B5', 'dark_color_slate', 'dark_color_input')">B5
                    </td>
                    <td style="background-color:#006600;"
                        onClick="setColor('B6', 'dark_color_slate', 'dark_color_input')">B6
                    </td>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('C1', 'dark_color_slate', 'dark_color_input')">C1
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#333300;"
                        onClick="setColor('E6', 'dark_color_slate', 'dark_color_input')">E6
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#ffcccc;"
                        onClick="setColor('C2', 'dark_color_slate', 'dark_color_input')">C2
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#666600;"
                        onClick="setColor('E5', 'dark_color_slate', 'dark_color_input')">E5
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#ff6666;"
                        onClick="setColor('C3', 'dark_color_slate', 'dark_color_input')">C3
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#666600;"
                        onClick="setColor('E4', 'dark_color_slate', 'dark_color_input')">E4
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#cc3300;"
                        onClick="setColor('C4', 'dark_color_slate', 'dark_color_input')">C4
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#999900;"
                        onClick="setColor('E3', 'dark_color_slate', 'dark_color_input')">E3
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#993300;"
                        onClick="setColor('C5', 'dark_color_slate', 'dark_color_input')">C5
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#cccc00;"
                        onClick="setColor('E2', 'dark_color_slate', 'dark_color_input')">E2
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td style="background-color:#330000;"
                        onClick="setColor('C6', 'dark_color_slate', 'dark_color_input')">C6
                    </td>
                </tr>
                <tr>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('E1', 'dark_color_slate', 'dark_color_input')">E1
                    </td>
                    <td style="background-color:#330000;"
                        onClick="setColor('D6', 'dark_color_slate', 'dark_color_input')">D6
                    </td>
                    <td style="background-color:#663300;"
                        onClick="setColor('D5', 'dark_color_slate', 'dark_color_input')">D5
                    </td>
                    <td style="background-color:#993300;"
                        onClick="setColor('D4', 'dark_color_slate', 'dark_color_input')">D4
                    </td>
                    <td style="background-color:#ff9933;"
                        onClick="setColor('D3', 'dark_color_slate', 'dark_color_input')">D3
                    </td>
                    <td style="background-color:#ffcc99;"
                        onClick="setColor('D2', 'dark_color_slate', 'dark_color_input')">D2
                    </td>
                    <td style="background-color:#ffffff;"
                        onClick="setColor('D1', 'dark_color_slate', 'dark_color_input')">D1
                    </td>
                </tr>
            </table>
        </div>
    </div>
</td>
<td>
    <input type="submit" name="submit" value="Add"/>
</td>
</tr>
</table>
</form>
<%}%>
</div>
<div id="graphTab" dojoType="dijit.layout.ContentPane" title="Graphs" style="width:650px; height:60ex">
    <%
    String url = "/graph?surveyId=" + survey.getId() + "&format=png&chart=shapePie";
    %>
     <table>
         <tr>
             <td><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + url)%>" alt="Shape Distribution"/></td>
         </tr>
     </table>
</div>
</div>
<%

} else {
    List<Survey> surveys = surveyDao.getAll();
    int numberOfSurveys = surveys.size();
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
        <th>Creator</th>
        <th>Date</th>
        <th>Reef</th>
        <th>Country</th>
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
            Survey aSurvey = surveys.get(i);
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
        <td><input type="button" value="View"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>';"/>
        </td>
        <%
            if (currentUser != null && currentUser.equals(aSurvey.getCreator()) || (currentUser != null && currentUser.isSuperUser())) {
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

<%

    }
%>