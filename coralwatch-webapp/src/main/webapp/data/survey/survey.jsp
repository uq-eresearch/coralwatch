<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.app.CoralwatchApplication" %>
<%@ page import="org.coralwatch.dataaccess.SurveyDao" %>
<%@ page import="org.coralwatch.dataaccess.SurveyRatingDao" %>
<%@ page import="org.coralwatch.model.*" %>
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
    dojo.require("dojo.data.ItemFileReadStore");
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
//        if (currentUser != null) {
        List<String> errors = (List<String>) renderRequest.getAttribute("errors");
//    ReefDao reefDao = (ReefDao) renderRequest.getAttribute("reefDao");
        List<Reef> reefs = (List<Reef>) renderRequest.getAttribute("reefs");
        String groupName = "";
        String participatingAs = "";
        String country = "";
        String reefName = "";
        String lightCondition = "";
        String activity = "";
        String comments = "";
        boolean isGpsDevice = false;
        if (cmd.equals(Constants.EDIT)) {
            surveyId = ParamUtil.getLong(request, "surveyId");
            survey = surveyDao.getById(surveyId);
            groupName = survey.getGroupName();
            participatingAs = survey.getParticipatingAs();
            country = survey.getReef().getCountry();
            reefName = survey.getReef().getName();
            lightCondition = survey.getLightCondition();
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
    if (errors != null && errors.size() > 0) {
        for (String error : errors) {
%>
<div><span class="portlet-msg-error"><%=error%></span></div>
<%
        }
    }
    if (currentUser == null) {
%>
<div><span class="portlet-msg-error">You must sign in to submit a survey.</span></div>
<%
    }
%>

<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">

<jsp:include page="/map/google-map-key.jsp"/>

<script type="text/javascript">
    dojo.addOnLoad(
            function() {
                dojo.byId("groupName").focus();
                dojo.byId("latitudeDeg1").style.display = 'inline';
                var now = new Date();
                dijit.byId('date').constraints.max = now;
                //                dijit.byId('time').constraints.max = 'T' + now.getHours() + ':' + now.getMinutes()+ ':00';
                updateLonFromDeg();
                updateLatFromDeg();
                updateFTemperature();
                updateCTemperature();
            }
            );
</script>
<script type="dojo/method" event="onSubmit">
    <%
        if (currentUser != null) {
    %>
    var isLoggedIn = true;
    <%
    } else {
    %>
    var isLoggedIn = false;
    <%
        }
    %>
    if(!isLoggedIn) {
    alert('You must sign in before you can add or edit a survey.');
    return false;
    }
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
    <th><label for="groupName">Group Name:</label></th>
    <td><input type="text"
               id="groupName"
               name="groupName"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp="...*"
               invalidMessage="Enter the name of the group you are participating with"
               value="<%=groupName == null ? "" : groupName%>"/> Enter your own name if you do not belong to a group.
    </td>
</tr>
<tr>
    <th><label for="participatingAs">Participating As:</label></th>
    <td><select name="participatingAs"
                id="participatingAs"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="<%=participatingAs == null ? "" : participatingAs%>">
        <option selected="selected" value=""></option>
        <option value="Dive Centre">Dive Centre</option>
        <option value="Scientist">Scientist</option>
        <option value="Conservation Group">Conservation Group</option>
        <option value="School/University">School/University</option>
        <option value="Tourist">Tourist</option>
        <option value="Other">Other</option>
    </select>
    </td>
</tr>
<tr>
    <th><label for="country">Country of Survey:</label></th>
    <td>
        <script type="text/javascript">
            dojo.addOnLoad(function() {
                dojo.connect(dijit.byId("country"), "onChange", function() {
                    var country = dijit.byId("country").getValue();
                    reefStore.url = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/reefs?format=json&country=" + country;
                    reefStore.close();
                });
            });
        </script>
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
    <td>
        <%
            String reefServletUrl = "/reefs?format=json&country=all";
        %>
        <div dojoType="dojo.data.ItemFileReadStore" id="reefStore" jsId="reefStore" urlPreventCache="true"
             clearOnClose="true"
             url="<%=renderResponse.encodeURL(renderRequest.getContextPath() + reefServletUrl)%>">
        </div>
        <input dojoType="dijit.form.ComboBox" value="<%=reefName == null ? "" : reefName%>" store="reefStore"
               searchAttr="name" name="reefName" id="reefName">
    </td>
</tr>
<tr>
<th>
    <label>Position:</label>
</th>
<td>
<div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:40em;height:30ex">
<div id="tabDeg" dojoType="dijit.layout.ContentPane" title="Degrees" style="width:40em;height:30ex;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg1">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg1"
                       name="latitudeDeg1"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:6,min:-90,max:90}"
                       trim="true"
                       onBlur="updateLatFromDeg()"
                       onChange="updateLatFromDeg()"
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
                                document.getElementById("latitudeDeg1").value = Lat5.toFixed(6);
                                updateLatFromDeg();
                                document.getElementById("longitudeDeg1").value = Lng5.toFixed(6);
                                updateLonFromDeg();
                            });
                        } else {
                            alert("Sorry, the Google Maps API is not compatible with this browser");
                        }
                    }
                </script>
                <a href="#" onclick="showMap(); return false;">Without GPS Device</a>
                <%
                } else {
                %>
                <div id="locator" dojoType="dijit.form.DropDownButton" label="Without GPS Device">
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
                                        document.getElementById("latitudeDeg1").value = Lat5.toFixed(6);
                                        updateLatFromDeg();
                                        document.getElementById("longitudeDeg1").value = Lng5.toFixed(6);
                                        updateLonFromDeg();
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
                <label for="longitudeDeg1">Longitude:</label>
            </th>
            <td>
                <input type="text"
                       id="longitudeDeg1"
                       name="longitudeDeg1"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:6,min:-180,max:360}"
                       trim="true"
                       onBlur="updateLonFromDeg()"
                       onChange="updateLonFromDeg()"
                       invalidMessage="Enter a valid longitude value rounded to six decimal places. Append 0s if required."
                       value="<%=cmd.equals(Constants.EDIT) ? survey.getLongitude() : ""%>"/>
                <input id="isGpsDevice" name="isGpsDevice"
                       <%if(isGpsDevice) {%>checked="checked"<%}%> dojoType="dijit.form.CheckBox"
                       value="">
                <label for="isGpsDevice">I used a GPS Device</label>
            </td>
        </tr>
        <tr>
            <td></td>
            <td>If no GPS device used, click on "Without GPS Device" to use a map locator to estimate
                your survey location by double clicking on the map to zoom in one level at a time to find your location.
                Then close the map.
            </td>
        </tr>
    </table>

</div>
<div id="tabDegMin" dojoType="dijit.layout.ContentPane" title="Degrees/Minutes" style="width:40em;height:20ex;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg2">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg2"
                       name="latitudeDeg2"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:90}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLatFromDegMin()"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="latitudeMin2"
                       name="latitudeMin2"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:4,min:0,max:60}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLatFromDegMin()"
                       invalidMessage="Enter a valid minute value rounded to four decimal places. Append 0s if required."/>
                '
                <select name="latitudeDir2"
                        id="latitudeDir2"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onBlur="updateLatFromDegMin()"
                        style="width:4.5em;">
                    <option value="north">N</option>
                    <option value="south">S</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <label for="longitudeDeg2">Longitude:</label>
            </th>
            <td>
                <input type="text"
                       id="longitudeDeg2"
                       name="longitudeDeg2"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:180}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLonFromDegMin()"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="longitudeMin2"
                       name="longitudeMin2"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:4,min:0,max:60}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLonFromDegMin()"
                       invalidMessage="Enter a valid minute value rounded to four decimal places. Append 0s if required."/>
                '
                <select name="longitudeDir2"
                        id="longitudeDir2"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onBlur="updateLonFromDegMin()"
                        style="width:4.5em;">
                    <option value="east">E</option>
                    <option value="west">W</option>
                </select>
            </td>
        </tr>
    </table>
</div>
<div id="tabDegMinSec" dojoType="dijit.layout.ContentPane" title="Degrees/Minutes/Seconds" style="width:40em;height:20ex;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg3">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg3"
                       name="latitudeDeg3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:90}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLatFromDegMinSec()"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="latitudeMin3"
                       name="latitudeMin3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLatFromDegMinSec()"
                       invalidMessage="Enter a valid minute value."/>
                '
                <input type="text"
                       id="latitudeSec3"
                       name="latitudeSec3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLatFromDegMinSec()"
                       invalidMessage="Enter a valid second value."/>
                &quot;
                <select name="latitudeDir3"
                        id="latitudeDir3"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onBlur="updateLatFromDegMinSec()"
                        style="width:4.5em;">
                    <option value="north">N</option>
                    <option value="south">S</option>
                </select>
            </td>
        </tr>
        <tr>
            <th>
                <label for="longitudeDeg3">Longitude:</label>
            </th>
            <td>
                <input type="text"
                       id="longitudeDeg3"
                       name="longitudeDeg3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:180}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLonFromDegMinSec()"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="longitudeMin3"
                       name="longitudeMin3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLonFromDegMinSec()"
                       invalidMessage="Enter a valid minute value."/>
                '
                <input type="text"
                       id="longitudeSec3"
                       name="longitudeSec3"
                       required="true"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onBlur="updateLonFromDegMinSec()"
                       invalidMessage="Enter a valid second value."/>
                &quot;
                <select name="longitudeDir3"
                        id="longitudeDir3"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onBlur="updateLonFromDegMinSec()"
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
    <th><label for="lightCondition">Light Condition:</label></th>
    <td><select name="lightCondition"
                id="lightCondition"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="<%=lightCondition == null ? "" : lightCondition%>">
        <option selected="selected" value=""></option>
        <option value="Full Sunshine">Full Sunshine</option>
        <option value="Broken Cloud">Broken Cloud</option>
        <option value="Cloudy">Cloudy</option>
    </select>
    </td>
</tr>
<tr>
    <th><label for="watertemperature">Water Temperature (&deg;C):</label></th>
    <td>
        <input type="text"
               id="watertemperature"
               name="watertemperature"
               required="true"
               dojoType="dijit.form.NumberTextBox"
               trim="true"
               onBlur="updateFTemperature()"
               onChange="updateFTemperature()"
               invalidMessage="Enter a valid temperature value."
               value="<%=cmd.equals(Constants.EDIT) ? survey.getWaterTemperature() : ""%>"/>
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
               maxLength="2000"
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
    //}
} else if (cmd.equals(Constants.VIEW)) {
    SurveyRatingDao surveyRatingDao = (SurveyRatingDao) renderRequest.getAttribute("surveyRatingDao");
    surveyId = ParamUtil.getLong(request, "surveyId");
    survey = surveyDao.getById(surveyId);
%>
<script type="text/javascript">
    dojo.require("dojox.form.Rating");
</script>
<%
    if (currentUser != null) {
%>
<script type="text/javascript">
    dojo.addOnLoad(function() {
        var widget = dijit.byId("connectRating");
        dojo.connect(widget, "onClick", function() {
            dojo.xhrPost({
                url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/rating?cmd=ratesurvey&raterId=<%=currentUser.getId()%>&surveyId=<%=survey.getId()%>&value=' + widget.value,
                timeout: 5000,
                load: function(response, ioArgs) {
                    //                    alert("Response: " + response)
                    return response;
                },
                error: function(response, ioArgs) {
                    alert('Cannot add rating: ' + response);
                    return response;
                }
            });
        });
    });

</script>
<%
    }
%>
<div align="right">
    <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>">Add
        New
        Survey</a>
</div>
<h2 style="margin-top:0;">Survey Details</h2>
<br/>

<div id="surveyDetailsContainer" dojoType="dijit.layout.TabContainer" style="width:650px;height:60ex">
<div id="metadataTab" dojoType="dijit.layout.ContentPane" title="Metadata" style="width:650px; height:60ex">
    <table>
        <tr>
            <th>Surveyor</th>
            <td>
                <a href="<%=renderRequest.getAttribute("userUrl")%>?p_p_id=userportlet_WAR_coralwatch&_userportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_userportlet_WAR_coralwatch_userId=<%=survey.getCreator().getId()%>"><%= survey.getCreator().getDisplayName() == null ? "" : survey.getCreator().getDisplayName()%>
                </a>
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
            <td><%=survey.getGroupName() == null ? "" : survey.getGroupName()%>
            </td>
        </tr>
        <tr>
            <th>Participating As:</th>
            <td><%= survey.getParticipatingAs() == null ? "" : survey.getParticipatingAs()%>
            </td>
        </tr>
        <tr>
            <th>Country of Survey:</th>
            <td><%= survey.getReef().getCountry() == null ? "" : survey.getReef().getCountry()%>
            </td>
        </tr>
        <tr>
            <th>Reef:</th>
            <td>
                <%
                    if (survey.getReef() != null) {
                %>
                <a href="<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch&_reefportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_reefportlet_WAR_coralwatch_reefId=<%=survey.getReef().getId()%>"><%= survey.getReef().getName() == null ? "" : survey.getReef().getName()%>
                </a>
                <%
                    }
                %>
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
            <th>Light Condition:</th>
            <td><%=survey.getLightCondition() == null ? "" : survey.getLightCondition()%>
            </td>
        </tr>
        <tr>
            <th>Water Temperature:</th>
            <td>
                <%if (survey.getWaterTemperature() != null) {%>
                <%=survey.getWaterTemperature()%> &deg;C (<%=((survey.getWaterTemperature() * 9 / 5) + 32)%> &deg;F)
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
            <th>Quality Status:</th>
            <td><span
                    style="color:#ff0000;"><%=survey.getQaState().equalsIgnoreCase("Post Migration") ? "Data submitted on the new CoralWatch website" : "Data migrated from the old CoralWatch website"%></span>
            </td>
        </tr>


        <%
            if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
                if (currentUser != null) {
                    SurveyRating userSurveyRating = surveyRatingDao.getSurveyRating(currentUser, survey);
                    double userSurveyRatingValue = 0;
                    if (userSurveyRating != null) {
                        userSurveyRatingValue = userSurveyRating.getRatingValue();
                    }
        %>
        <tr>
            <th>Your Rating:</th>
            <td>
                <%--<%--%>
                <%--UserRating userRating = userRatingDao.getRating(currentUser, user);--%>
                <%--double userRatingValue = 0;--%>
                <%--if (userRating != null) {--%>
                <%--userRatingValue = userRating.getRatingValue();--%>
                <%--}--%>
                <%--%>--%>
                <span id="connectRating" dojoType="dojox.form.Rating" numStars="5"
                      value="<%=userSurveyRatingValue%>"></span>
            </td>
        </tr>
        <%
            }
        %>
        <tr>
            <th>Overall Rating:</th>
            <td>
            <span id="overAllRating" dojoType="dojox.form.Rating" numStars="5" disabled="disabled"
                  value="<%=surveyRatingDao.getCommunityRatingValue(survey)%>"></span>
            </td>
        </tr>

        <%
            }
        %>

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

        //Validate colour here
        var lightNumber = light.substring(1);
        var darkNumber = dark.substring(1);
        if (Number(lightNumber) >= Number(darkNumber)) {
            alert('Lightest colour number (' + lightNumber + ') must be smaller than darkest colour number (' + darkNumber + ').');
            return false;
        }
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
<div id="mapTab" dojoType="dijit.layout.ContentPane" title="Map" style="width:650px; height:60ex">
    <%
        if (survey.getLatitude() != null && survey.getLongitude() != null) {
    %>
    <jsp:include page="../../map/google-map-key.jsp"/>
    <div id="map" style="width: 640px; height: 53ex">
        <script type="text/javascript">
            if (GBrowserIsCompatible()) {
                var mavDiv = dojo.byId("map");
                var map = new GMap2(mavDiv);
                map.setMapType(G_HYBRID_MAP);
                map.addControl(new GSmallMapControl());
                map.addControl(new GMapTypeControl());
                map.addControl(new GOverviewMapControl());
                var center = new GLatLng(<%=survey.getLatitude()%>, <%=survey.getLongitude()%>);
                var marker = new GMarker(center);
                map.setCenter(center, 5);
                map.addOverlay(marker);
            }
        </script>
    </div>
    <%
    } else {
    %>
    <p>No GPS data available for this survey.</p>
    <%}%>
</div>
</div>
<%
    //If no cmd is given then display list of surveys
} else {
    //If a user is given then display only surveys created by this user and pass it is id to servlet
    long userId = ParamUtil.getLong(request, "userId");
    long createdByUserId = -1;
    if (userId > 0) {
        createdByUserId = userId;
    }
    if (currentUser != null) {
%>
<div align="right">
    <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>">New Survey</a>
    <% if (currentUser != null && currentUser.isSuperUser()) { %>
        <portlet:resourceURL var="exportURL" id="export">
            <portlet:param name="singleSheet" value="true" />
        </portlet:resourceURL>
        | <a href="<%= exportURL %>">Export survey data</a>
    <% } %>
</div>
<%
    }
%>
<h2 style="margin-top:0;">All Surveys</h2>
<script>
    dojo.require("dojox.grid.DataGrid");
    dojo.require("dojox.data.XmlStore");
    dojo.require("dojox.form.Rating");
    dojo.require("dojo.date.locale");
    dojo.require("dojo.parser");

    dojo.addOnLoad(function() {
        //        grid.setSortIndex(1, true);
        surveyStore.comparatorMap = {};
        surveyStore.comparatorMap["records"] = function(a, b) {
            var ret = 0;
            if (Number(a) > Number(b)) {
                ret = 1;
            }
            if (Number(a) < Number(b)) {
                ret = -1;
            }
            return ret;
        }
    });
    var dateFormatter = function(data) {
        return dojo.date.locale.format(new Date(Number(data)), {
            datePattern: "dd MMM yyyy",
            selector: "date",
            locale: "en"
        });
    };

    var layoutSurveys = [
        [

            {
                field: "country",
                name: "Country",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "reef",
                name: "Reef",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "surveyor",
                name: "Surveyor",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "date",
                name: "Date",
                width: 10,
                formatter: dateFormatter

            },
            {
                field: "records",
                name: "Records",
                width: 5,
                formatter: function(item) {
                    return Number(item.toString());
                }
            },
            <%--<%--%>
            <%--if (CoralwatchApplication.getConfiguration().isRatingSetup()) {--%>
            <%--%>--%>
            <%--{--%>
            <%--field: "rating",--%>
            <%--name: "Overall Rating",--%>
            <%--width: 10,--%>
            <%--formatter: function(item) {--%>
            <%--return new dojox.form.Rating({value: item.toString(), numStars:5, disabled: true});--%>
            <%--}--%>
            <%--},--%>
            <%--<%--%>
            <%--}--%>
            <%--%>--%>
            {
                field: "view",
                name: "View",
                width: 10,
                formatter: function(item) {
                    var viewURL = "<a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + item.toString() + "\">More info</a>";
                    return viewURL;
                }
            }
        ]
    ];
</script>

<div>
    <form dojoType="dijit.form.Form" jsId="filterForm" id="filterForm">
        <script type="dojo/method" event="onSubmit">
            if(!this.validate()){
            alert('Enter a search key word.');
            return false;
            } else {
            grid.filter({
            surveyor: "*" + dijit.byId("surveyorFilterField").getValue() + "*",
            reef: "*" + dijit.byId("reefFilterField").getValue() + "*",
            country: "*" + dijit.byId("countryFilterField").getValue() + "*"
            });
            return false;
            }
        </script>
        Country: <input type="text"
                        id="countryFilterField"
                        name="countryFilterField"
                        style="width:100px;"
                        dojoType="dijit.form.TextBox"
                        trim="true"
                        value=""/> Reef Name: <input type="text"
                                                     id="reefFilterField"
                                                     name="reefFilterField"
                                                     style="width:100px;"
                                                     dojoType="dijit.form.TextBox"
                                                     trim="true"
                                                     value=""/> Surveyor: <input type="text"
                                                                                 id="surveyorFilterField"
                                                                                 name="surveyorFilterField"
                                                                                 style="width:100px;"
                                                                                 dojoType="dijit.form.TextBox"
                                                                                 trim="true"
                                                                                 value=""/><input type="submit"
                                                                                                  name="submit"
                                                                                                  value="Filter"/>
        Filter is case sensitive
    </form>
</div>
<br/>

<div dojoType="dojox.data.XmlStore"
     url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/surveys?format=xml&createdByUserId=<%=createdByUserId%>"
     jsId="surveyStore" label="title">
    <script type="dojo/method" event="onLoad">
        grid.setSortIndex(1, true);
    </script>
</div>
<div id="grid" jsId="grid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
     store="surveyStore" structure="layoutSurveys" query="{}" rowsPerPage="40">
</div>
<%
    }
%>
<div id="mapDialog" dojoType="dijit.Dialog" title="Without GPS Dvice"
     style="width: 470px; height: 320px; display:none;">
    <div id="ieMap" style="height: 275px;"></div>
</div>