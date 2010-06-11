<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.SurveyRecord" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="org.coralwatch.util.GpsUtil" %>
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
    //    dojo.require("dijit.form.RadioButton");
    dojo.require("dijit.form.ComboBox");
    dojo.require("dijit.form.CheckBox");
    dojo.require("dijit.form.DateTextBox");
    dojo.require("dijit.form.TimeTextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.NumberTextBox");
    dojo.require("dijit.form.ValidationTextBox");
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.Dialog");
    dojo.require("dijit.layout.TabContainer");
    dojo.require("dijit.TooltipDialog");
    dojo.require("dijit.form.DropDownButton");

</script>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    SurveyDao surveyDao = (SurveyDao) renderRequest.getAttribute("surveyDao");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    DateFormat dateFormatDisplay = new SimpleDateFormat("dd/MM/yyyy");
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
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
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getAttribute("errors");
//    ReefDao reefDao = (ReefDao) renderRequest.getAttribute("reefDao");
    List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
    String groupName = "";
    String organisationType = "";
    String country = "";
    String reefName = "";
    String weatherCondition = "";
    String activity = "";
    String comments = "";
    boolean isGpsDevice = false;
    if (cmd.equals(Constants.EDIT)) {
        surveyId = ParamUtil.getLong(request, "surveyId");
        survey = surveyDao.getById(surveyId);
        groupName = survey.getOrganisation();
        organisationType = survey.getOrganisationType();
        country = survey.getReef().getCountry();
        reefName = survey.getReef().getName();
        weatherCondition = survey.getWeather();
        isGpsDevice = survey.isGPSDevice();
        activity = survey.getActivity();
        comments = survey.getComments();
%>

<h2 style="margin-top:0;">Edit Survey</h2>
<br/>
<%
} else if (cmd.equals(Constants.ADD)) {
%>
<h2 style="margin-top:0;">Add New Survey</h2>
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

<jsp:include page="/map/google-map-key.jsp"/>

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
    <th>Surveyor:</th>
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
//                    List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
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
<div id="tabDecimal" dojoType="dijit.layout.ContentPane" title="Decimal" style="width:40em;height:20ex;">
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
                       invalidMessage="Enter a valid latitude value rounded to six decimal places. Append 0s if required."
                       value="<%=cmd.equals(Constants.EDIT) ? survey.getLatitude() : ""%>"/>
                <%
                    String userAgent = request.getHeader("user-agent");
                    if (userAgent.indexOf("MSIE") > -1) {
                %>
                <script type="text/javascript">
                    function showMap() {
                        var dialog = dijit.byId("mapDialog");
                        dialog.show();
                        if (GBrowserIsCompatible()) {
                            var mapDiv = dojo.byId("ieMap");
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
                    }
                </script>
                <a href="#" onclick="showMap(); return false;">Locate On Map</a>
                <%
                } else {
                %>
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
                <%}%>
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
                       invalidMessage="Enter a valid longitude value rounded to six decimal places. Append 0s if required."
                       value="<%=cmd.equals(Constants.EDIT) ? survey.getLongitude() : ""%>"/>
                <input id="isGpsDevice" name="isGpsDevice"
                       <%if(isGpsDevice) {%>checked="checked"<%}%> dojoType="dijit.form.CheckBox"
                       value="">
                <label for="isGpsDevice">I used a GPS Device</label>
            </td>
        </tr>
    </table>

</div>
<div id="tabDegrees" dojoType="dijit.layout.ContentPane" title="Degrees" style="width:40em;height:20ex;">
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
                       invalidMessage="Enter a valid minute value."/>'
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
                       invalidMessage="Enter a valid minute value."/>'
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
<h2 style="margin-top:0;">Survey Details</h2>
<br/>

<div id="surveyDetailsContainer" dojoType="dijit.layout.TabContainer" style="width:650px;height:60ex">
<div id="metadataTab" dojoType="dijit.layout.ContentPane" title="Metadata" style="width:650px; height:60ex">
    <table>
        <tr>
            <th>Surveyor</th>
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
            <td><%if (survey.getLatitude() != null) {%>
                <%=GpsUtil.formatGpsValue(survey.getLatitude(), GpsUtil.LAT) + " (" + survey.getLatitude() + ")"%>
                <%}%>
            </td>
        </tr>
        <tr>
            <th>Longitude:</th>
            <td><%if (survey.getLongitude() != null) {%>
                <%=GpsUtil.formatGpsValue(survey.getLongitude(), GpsUtil.LONG) + " (" + survey.getLongitude() + ")"%>
                <%}%>
            </td>
        </tr>
        <tr>
            <th>Observation Date:</th>
            <td><%=survey.getDate() == null ? "" : dateFormatDisplay.format(survey.getDate())%>
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
            <td>
                <%if (survey.getTemperature() != null) {%>
                <%=survey.getTemperature()%> &deg;C (<%=((survey.getTemperature() * 9 / 5) + 32)%> &deg;F)
                <%}%>
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
            <th>QA Status:</th>
            <td><span
                    style="color:#ff0000;"><%=survey.getQaState().equalsIgnoreCase("Post Migration") ? "New" : "Migrated"%></span>
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

        <%--<tr>--%>
        <%--<th>Community Rating:</th>--%>
        <%--<td></td>--%>
        <%--</tr>--%>
        <%
            if (currentUser != null && (currentUser.equals(survey.getCreator()) || currentUser.isSuperUser())) {
        %>
        <tr>
            <td colspan="2"><input type="button" value="Edit"
                                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:renderURL>';"/>
                <input type="button" value="Delete"
                       onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:actionURL>';"/>
            </td>


        </tr>
        <%
            }
        %>
    </table>
</div>

<div id="dataTab" dojoType="dijit.layout.ContentPane" title="Data" style="width:650px; height:60ex">
    <%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
    <script type="text/javascript">
        function validate() {
            var form = dijit.byId("recordForm");
            if (!form.validate()) {
                alert('You must select coral type to submit a record.');
                return false;
            }
            var selectedLightColor = dojo.query('INPUT[name=light_color_input]', 'recordForm').filter(function(n) {
                return n.getAttribute('value') != '';
            }).length > 0;
            var selectedDarkColor = dojo.query('INPUT[name=dark_color_input]', 'recordForm').filter(function(n) {
                return n.getAttribute('value') != '';
            }).length > 0;
            if (!selectedLightColor) {
                alert('You must select lightest colour.');
                return false;
            }
            if (!selectedDarkColor) {
                alert('You must select darkest colour.');
                return false;
            }
            var type = dijit.byId('coralType').getValue();
            var light = dijit.byId('light_color_input').getValue();
            var dark = dijit.byId('dark_color_input').getValue();
            saveRecord(type, light, dark);
            return true;
        }

        function saveRecord(coralType, lightColor, darkColor) {
            dojo.xhrPost({
                url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/record?cmd=add&surveyId=<%=survey.getId()%>&coralType=' + coralType + '&light_color=' + lightColor + '&dark_color=' + darkColor,
                timeout: 5000,
                load: function(response, ioArgs) {
                    var table = dojo.byId('survey_records');
                    if (table == null) {
                        var table = dojo.create('table');
                        table.setAttribute('id', 'survey_records');
                        if (dojo.isIE) {
                            table.setAttribute('className', 'coralwatch_list_table');
                        }
                        table.setAttribute('class', 'coralwatch_list_table');

                        var tbody = dojo.create('tbody');
                        var row = dojo.create('tr');
                        row.appendChild(dojo.create('th', { innerHTML: 'No', nowrap:'nowrap' }));
                        row.appendChild(dojo.create('th', { innerHTML: 'Coral Type', nowrap:'nowrap' }));
                        row.appendChild(dojo.create('th', { innerHTML: 'Lightest', nowrap:'nowrap' }));
                        row.appendChild(dojo.create('th', { innerHTML: 'Darkest', nowrap:'nowrap' }));
                        row.appendChild(dojo.create('th', { innerHTML: 'Delete', nowrap:'nowrap' }));
                        tbody.appendChild(row);
                        table.appendChild(tbody);
                        dojo.destroy('nodata');
                        dojo.byId('dataTab').appendChild(table);

                    }
                    var tbody = table.getElementsByTagName('tbody')[0];
                    var numberOfRaws = tbody.children.length;
                    var row = dojo.create('tr');
                    row.setAttribute('id', 'record' + numberOfRaws);
                    row.appendChild(dojo.create('td', { innerHTML: numberOfRaws }));
                    row.appendChild(dojo.create('td', { innerHTML: coralType }));
                    row.appendChild(dojo.create('td', { innerHTML: lightColor }));
                    row.appendChild(dojo.create('td', { innerHTML: darkColor }));
                    row.appendChild(dojo.create('td', { innerHTML: '<a href="#" onClick="deleteRecord(' + Number(response) + ', ' + Number(numberOfRaws) + '); return false;">Delete</a>' }));
                    tbody.appendChild(row);
                    reloadImage();
                    return response;
                },
                error: function(response, ioArgs) {
                    alert('Cannot add record: ' + response);
                    return response;
                }
            });
        }
        function deleteRecord(recordId, pos) {
            dojo.xhrPost({
                url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/record?cmd=delete&recordId=' + recordId,
                timeout: 5000,
                load: function(response, ioArgs) {
                    dojo.destroy('record' + pos)
                    reloadImage();
                    return response;
                },
                error: function(response, ioArgs) {
                    alert('Cannot delete record: ' + response);
                    return response;
                }
            });
        }
    </script>

    <span>Add Records:</span><br/>

    <form dojoType="dijit.form.Form" jsId="recordForm" id="recordForm">

        <script type="text/javascript">
            function setColor(colorCode, slate, inputField) {
                dijit.byId(slate).setAttribute('label', colorCode);
                dojo.byId(inputField).setAttribute('value', colorCode);
            }
        </script>
        <table width="100%" class="coralwatch_list_table">
            <tr>
                <th nowrap="nowrap">Coral Type</th>
                <th nowrap="nowrap">Lightest</th>
                <th nowrap="nowrap">Darkest</th>
                <th nowrap="nowrap">Action</th>
            </tr>

            <tr>
                <td nowrap="nowrap">
                    <select name="coralType" id="coralType"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="">
                        <option selected="selected" value=""></option>
                        <option value="Boulder">Boulder</option>
                        <option value="Branching">Branching</option>
                        <option value="Plate">Plate</option>
                        <option value="Soft">Soft</option>
                    </select>
                </td>
                <td nowrap="nowrap">
                    <input dojoType="dijit.form.TextBox" name="light_color_input" id="light_color_input" type="hidden"
                           value=""/>

                    <div id="light_color_slate" dojoType="dijit.form.DropDownButton" label="" style="width:30px">
                        <div dojoType="dijit.TooltipDialog">
                            <jsp:include page="lightcolorslate.jsp"/>
                        </div>
                    </div>
                </td>
                <td nowrap="nowrap">
                    <input dojoType="dijit.form.TextBox" name="dark_color_input" id="dark_color_input" type="hidden"
                           value=""/>

                    <div id="dark_color_slate" dojoType="dijit.form.DropDownButton" label="" style="width:30px">
                        <div dojoType="dijit.TooltipDialog">
                            <jsp:include page="darkcolorslate.jsp"/>
                        </div>
                    </div>
                </td>
                <td>
                    <input type="button" onclick="validate();" value="Add"/>
                </td>
            </tr>
        </table>
    </form>
    <%}%>
    <%
        List<SurveyRecord> surveyRecords = surveyDao.getSurveyRecords(survey);
        if (!surveyRecords.isEmpty()) {
    %>
    <table id="survey_records" class="coralwatch_list_table">
        <tr>
            <th nowrap="nowrap">No</th>
            <th nowrap="nowrap">Coral Type</th>
            <th nowrap="nowrap">Lightest</th>
            <th nowrap="nowrap">Darkest</th>
            <%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
            <th nowrap="nowrap">Action</th>
            <%}%>
        </tr>
        <%

            for (int index = 0; index < surveyRecords.size(); index++) {
                SurveyRecord record = surveyRecords.get(index);
        %>
        <tr id="record<%=(index + 1)%>">
            <td><%=(index + 1) + "" %>
            </td>
            <td><%=record.getCoralType()%>
            </td>
            <td><%=record.getLightestLetter() + "" + record.getLightestNumber()%>
            </td>
            <td><%=record.getDarkestLetter() + "" + record.getDarkestNumber()%>
            </td>
            <%if (currentUser != null && currentUser.equals(survey.getCreator())) {%>
            <td>
                <a href="#" onClick="deleteRecord(<%=record.getId()%>, <%=(index + 1)%>); return false;">Delete</a>
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
    <div id="nodata" align="center">
        <br/>
        <span style="text-align:center;">No Data Recorded</span>
    </div>
    <%
        }
    %>
</div>
<div id="graphTab" dojoType="dijit.layout.ContentPane" title="Graphs" style="width:650px; height:60ex">
    <%
        String pieChartUrl = "/graph?type=survey&id=" + survey.getId() + "&chart=shapePie&width=256&height=256&labels=true&legend=true&titleSize=12";
        String barChartUrl = "/graph?type=survey&id=" + survey.getId() + "&chart=coralCount&width=256&height=256&legend=false&titleSize=12";
    %>
    <br/>
    <script type="text/javascript">
        function reloadImage() {
            var pieChart = dojo.byId('pie');
            var barChart = dojo.byId('bar');
            if (pieChart != null && barChart != null) {
                var graphDiv = dojo.byId('graphDiv');
                var noGraphDiv = dojo.byId('noGraphDiv');
                dojo.xhrGet({
                    url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/record?cmd=count&surveyId=<%=survey.getId()%>',
                    timeout: 5000,
                    load: function(response, ioArgs) {
                        //Do the query and update
                        if (Number(response) > 0) {
                            graphDiv.style.display = 'inline';
                            noGraphDiv.style.display = 'none';
                            pieChart.src = pieChart.src + '&time=' + (new Date()).getTime();
                            barChart.src = barChart.src + '&time=' + (new Date()).getTime();
                        } else {
                            graphDiv.style.display = 'none';
                            noGraphDiv.style.display = 'inline';
                        }
                        return response;
                    },
                    error: function(response, ioArgs) {
                        graphDiv.style.display = 'none';
                        noGraphDiv.style.display = 'inline';
                        //                    alert('Cannot get number of records: ' + response);
                        return response;
                    }
                });
            }
        }
    </script>
    <div align="right">
        <a href="#" onclick="reloadImage();">Refresh</a>
    </div>
    <div id="graphDiv" <%if (surveyDao.getSurveyRecords(survey).size() < 1) {%>style="display:none;"<%}%>>
        <img id="pie" src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + pieChartUrl)%>"
             alt="Shape Distribution" width="256" height="256"/>
        <img id="bar" src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + barChartUrl)%>"
             alt="Colour Distribution" width="256" height="256"/>
    </div>
    <div id="noGraphDiv" align="center" <%if (surveyDao.getSurveyRecords(survey).size() > 0) {%>
         style="display:none;"<%}%>>
        <span style="text-align:center;">No graphs available.</span>
    </div>
</div>
</div>
<%

} else {
    List<Survey> surveys = surveyDao.getAll();
    long userId = ParamUtil.getLong(request, "userId");
//    Long userId = Long.getLong(renderRequest.getAttribute("userId").toString());
    if (userId > 0) {
        UserDao userDao = (UserDao) renderRequest.getAttribute("userDao");
        UserImpl user = userDao.getById(userId);
        surveys = userDao.getSurveyEntriesCreated(user);
    }
    if (surveys.size() < 1) {
%>
<span style="text-align:center;">No surveys yet</span>
<%
} else {
    int numberOfSurveys = surveys.size();
    int pageSize = 40;
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
<div align="right">
    <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>">New
        Survey</a>
</div>
<%
    }
%>
<h2 style="margin-top:0;">All Surveys</h2>
<table class="coralwatch_list_table">
    <tr>
        <th>Surveyor</th>
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
            Survey aSurvey = surveys.get(i);
    %>
    <tr>
        <td><%=aSurvey.getCreator().getDisplayName()%>
        </td>
        <td><%=dateFormatDisplay.format(aSurvey.getDate())%>
        </td>
        <td><%=aSurvey.getReef().getName()%>
        </td>
        <td><%=aSurvey.getReef().getCountry()%>
        </td>
        <td><%=surveyDao.getSurveyRecords(aSurvey).size()%>
        </td>
        <td>
            <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>">View</a>
        </td>
        <%
            if (currentUser != null && currentUser.equals(aSurvey.getCreator()) || (currentUser != null && currentUser.isSuperUser())) {
        %>
        <td>
            <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:renderURL>">Edit</a>
        </td>
        <td>
            <a href="<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="surveyId" value="<%= String.valueOf(aSurvey.getId()) %>" /></portlet:actionURL>">Delete</a>
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
<div id="mapDialog" dojoType="dijit.Dialog" title="Locate On Map" style="width: 470px; height: 320px; display:none;">
    <div id="ieMap" style="height: 275px;"></div>
</div>