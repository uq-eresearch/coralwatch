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
%>

<script>
function submitCheck() {
  var isLoggedIn = <%=Boolean.valueOf(currentUser != null).toString()%>;
  if(!isLoggedIn) {
    return false;
  }
  var newSurveyForm = dijit.byId('newSurveyForm');
  if(newSurveyForm && !newSurveyForm.validate()){
    alert('Form contains invalid data. Please correct errors first.');
    return false;
  }
  return true;
}

function submitNewSurveyForm() {
  var newSurveyForm = dijit.byId('newSurveyForm');
  if(newSurveyForm) {
    newSurveyForm.submit();
  }
}

dojo.addOnLoad(function() {
  dojo.connect(dijit.byId("confirmLocationDialog"), 'onShow', function(e) {
    initConfirmLocationMap(
        dijit.byId("latitudeDeg1").getValue(), dijit.byId("longitudeDeg1").getValue());
  });
  dojo.connect(dojo.byId('btnSubmit'), "onclick", function(e) {
    if(submitCheck()) {
      var confirmLocationDialog = dijit.byId("confirmLocationDialog");
      if(confirmLocationDialog) {
        confirmLocationDialog.show();
      } else {
        submitNewSurveyForm();
      }
    }
  });
});
</script>

<div style="display:none;" dojoType="dijit.Dialog" id="confirmLocationDialog" 
    title="Please zoom in and confirm that this was the location of your survey">
  <div class="dijitDialogPaneContentArea">
    <script type="text/javascript">
      function initConfirmLocationMap(lat, lng) {
        var surveyLocation = new google.maps.LatLng(lat, lng);
        var mapOptions = {
          center: surveyLocation,
          zoom: 6, 
          mapTypeId: google.maps.MapTypeId.HYBRID
        };
        var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
        var marker = new google.maps.Marker({
          position: surveyLocation,
          map: map
        })
      }
    </script>
    <div id="map-canvas" style="height: 400px; width: 400px; margin: 0; padding: 0;"></div>
  </div>
  <div style="margin-top:6px;" class="dijitDialogPaneActionBar">
    <button dojoType="dijit.form.Button" type="button"
        onClick="submitNewSurveyForm()">Confirm and submit</button>
    <button dojoType="dijit.form.Button" type="button"
        onClick="dijit.byId('confirmLocationDialog').hide();">Go back and change location</button>
  </div>
</div>

<script>
var marker;
function googleMap(eId) {
    var mapDiv = dojo.byId(eId);
    var mapProp = {
        center: new google.maps.LatLng(0, 0),
        zoom: 1,
        mapTypeId: google.maps.MapTypeId.HYBRID,
        // Since the map is always draggable, this effectively sets the cursor.
        // The intention of the crosshair is to indicate the map is clickable
        // rather than draggable, but this achieves the same result.
        draggableCursor: 'crosshair'
    };
    map=new google.maps.Map(mapDiv,mapProp);
    marker=new google.maps.Marker({
      position:new google.maps.LatLng(0,0),
      map: map,
      visible: false
    });
    google.maps.event.addListener(map, "click", function(event) {
        dijit.byId("latitudeDeg1").setValue(event.latLng.lat().toFixed(6));
        dijit.byId("longitudeDeg1").setValue(event.latLng.lng().toFixed(6));
        dijit.byId('mainTabContainer').selectChild('tabDeg');
        onChangePositionDeg("latitudeDeg1");
        onChangePositionDeg("longitudeDeg1");
    });
}
function positionMarker() {
    var lat = dijit.byId("latitude").getValue();
    var lng = dijit.byId("longitude").getValue();
    if (isNaN(lat) || isNaN(lng)) {
        marker.setVisible(false);
    }
    else {
        var latLng = new google.maps.LatLng(lat, lng);
        map.setCenter(latLng);
        if (map.getZoom() < 10) {
            map.setZoom(10);
        }
        marker.setPosition(latLng);
        marker.setTitle(latLng.toString());
        marker.setVisible(true);
    }
}
</script>

<% List<String> errors = (List<String>) renderRequest.getAttribute("errors"); %>
<% if (errors != null && errors.size() > 0) { %>
<%     for (String error : errors) { %>
<div>
    <span class="portlet-msg-error"><%= error %></span>
</div>
<%     } %>
<% } %>

<%
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
//        if (currentUser != null) {
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

<% if (currentUser != null && currentUser.isSuperUser()) { %>
<div style="float: right;">
    <portlet:renderURL var="bulkUploadURL">
        <portlet:param name="<%= Constants.CMD %>" value="bulk_add" />
    </portlet:renderURL>
    <a href="<%= bulkUploadURL %>">Bulk survey upload</a>
</div>
<% } %>

<h2 style="margin-top:0;">Add New Survey</h2>
<br/>

<%
    }
%>
<%
    if (currentUser == null) {
%>
<div><span class="portlet-msg-error">You must sign in to submit a survey.</span></div>
<%
    }
%>

<form id="newSurveyForm" dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">

<jsp:include page="/map/google-map-key.jsp"/>

<script type="text/javascript">
    dojo.addOnLoad(
        function() {
            dojo.byId("groupName").focus();
            dojo.byId("latitudeDeg1").style.display = 'inline';
            var now = new Date();
            dijit.byId('date').constraints.max = now;
            //dijit.byId('time').constraints.max = 'T' + now.getHours() + ':' + now.getMinutes()+ ':00';
        }
    );
</script>

<script type="dojo/method" event="onSubmit">
  return true;
</script>

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
    <td>
        <table>
        <tr>
        <td style="padding: 0; vertical-align: middle;">
        <input type="text"
            id="groupName"
            name="groupName"
            required="true"
            dojoType="dijit.form.ValidationTextBox"
            regExp="...*"
            invalidMessage="Enter the name of the group you are participating with"
            value="<%=groupName == null ? "" : groupName%>" />
        </td>
        <td style="width: 320px; padding: 0; vertical-align: middle;">
            e.g. EarthCheck, ReefCheck, OceansWatch.<br />
            Enter your own name if you do not belong to a group.
        </td>
        </tr>
        </table>
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
        <table>
        <tr>
        <td style="padding: 0; vertical-align: middle;">

            <script type="text/javascript">
                dojo.addOnLoad(function() {
                    dojo.connect(dijit.byId("country"), "onChange", function() {
                        var country = dijit.byId("country").getValue();

                        dijit.byId("reefName").setValue("");
                        dijit.byId("reefName").attr("disabled", typeof country === "undefined" || country.length <3);
                        document.getElementById("reef_name_not_in_menu").style.visibility = "hidden";

                        reefStore.url = "<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/reefs?format=json&country=" + country;
                        reefStore.close();
                    });
                });
            </script>

            <select name="country" id="country"
                    dojoType="dijit.form.ComboBox"
                    required="true"
                    hasDownArrow="true"
                    value="<%=country == null ? "" : country%>">
                <option selected="selected" value=""></option>
                <jsp:include page="/include/countrylist.jsp"/>
            </select>
        </td>
        <td style="width: 320px; padding: 0; vertical-align: middle;">
            Please note: this is the country in which you collected the data, not the country you live in.
        </td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <th style="vertical-align: top; padding: 0.5em;">
        <label for="reefName">Reef Name:</label>
    </th>
    <td>
        <script type="text/javascript">
            dojo.addOnLoad(function() {
                dojo.connect(dijit.byId("reefName"), "onChange", function() {
                    var reef = dijit.byId("reefName").getValue();

                    console.log("reefStore = ", reefStore);
                    var match = false;
                    for (var i=0; i<reefStore.length; i++) {
                        if (reefStore[i].name == reef) {
                            match = true;
                            break;
                        }
                    }
                    dijit.byId("confirmReefName").attr("checked", match);
                    dijit.byId("confirmReefName").attr("required", !match);
                    document.getElementById("reef_name_not_in_menu").style.visibility = match ? "hidden" : "visible";

                    dijit.byId("latitudeDeg1").setValue("");
                    dijit.byId("longitudeDeg1").setValue("");

                    dojo.xhrGet({
                        url: '<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/api/reeflocation',
                        handleAs: "json",
                        content: {
                            reef: reef
                        },
                        load: function(latlng) {
                            function isNumber(obj) {
                                return (obj - parseFloat( obj ) + 1) >= 0;
                            }
                            if (latlng && isNumber(latlng.lat) && isNumber(latlng.lng)) {
                                dijit.byId("latitudeDeg1").setValue(latlng.lat);
                                dijit.byId("longitudeDeg1").setValue(latlng.lng);
                            }
                        },
                        error: function() {
                            console.log('reeflocation call failed')
                        }
                    });
                });
            });
        </script>
        
        <%
            String reefServletUrl = "/reefs?format=json&country=all";
        %>   
        
        <div id="reefStore" jsId="reefStore"
             dojoType="dojo.data.ItemFileReadStore"
             urlPreventCache="true" clearOnClose="true"
             url="<%=renderResponse.encodeURL(renderRequest.getContextPath() + reefServletUrl)%>">
        </div>
        <input name="reefName" id="reefName" style="width: 360px;"
               dojoType="dijit.form.ComboBox"
               value="<%=reefName == null ? "" : reefName%>"
               store="reefStore"
               required
               disabled
               searchAttr="name" />

        <div id="reef_name_not_in_menu" style="visibility: hidden;">
            <br/>
            <p style="width: 480px;">
                Before entering your reef and dive site details, check if they are already listed on the drop down menu.
                If not, record the location (such as island or bay) followed by the reef or dive site.
                Example: Heron Island - Pam's Point.
            </p>
            <input name="confirmReefName" id="confirmReefName"
                   dojoType="dijit.form.CheckBox"
                   checked
                   required />
            <label for="confirmReefName">&nbsp;I confirm that I can't find my reef name in the drop down menu.</label>
        </div>

    </td>
</tr>
<tr>
<th style="vertical-align: top; padding: 0.5em;">
    <label>Position:</label>
</th>
<td>
<p style="width: 480px;">
    If you used a GPS device, you can enter your survey's coordinates directly.
    Otherwise, click on the map below to select your survey's location.
    Please make sure you zoom in to confirm the exact location.
</p>
<input type="text"
       id="latitude"
       name="latitude"
       style="display: none;"
       required="false"
       dojoType="dijit.form.NumberTextBox"
       constraints="{places:'0,6',round:-1,min:-90,max:90}"
       trim="true"
       value="<%=cmd.equals(Constants.EDIT) ? survey.getLatitude() : ""%>"/>
<input type="text"
       id="longitude"
       name="longitude"
       style="display: none;"
       required="false"
       dojoType="dijit.form.NumberTextBox"
       constraints="{places:'0,6',round:-1,min:-180,max:360}"
       trim="true"
       value="<%=cmd.equals(Constants.EDIT) ? survey.getLongitude() : ""%>"/>
<div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:480px;height:115px">
<div id="tabDeg" dojoType="dijit.layout.ContentPane" title="Degrees" style="width:480px;height:115px;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg1">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg1"
                       name="latitudeDeg1"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,6',round:-1,min:-90,max:90}"
                       trim="true"
                       onChange="onChangePositionDeg('latitudeDeg1');"
                       invalidMessage="Enter a valid latitude value rounded to six decimal places."
                       value="<%=cmd.equals(Constants.EDIT) ? survey.getLatitude() : ""%>"/>
            </td>
        </tr>
        <tr>
            <th>
                <label for="longitude">Longitude:</label>
            </th>
            <td>
                <input type="text"
                       id="longitudeDeg1"
                       name="longitudeDeg1"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,6',round:-1,min:-180,max:360}"
                       trim="true"
                       onChange="onChangePositionDeg('longitudeDeg1');"
                       invalidMessage="Enter a valid longitude value rounded to six decimal places."
                       value="<%=cmd.equals(Constants.EDIT) ? survey.getLongitude() : ""%>"/>
                <input id="isGpsDevice" name="isGpsDevice"
                       <%if(isGpsDevice) {%>checked="checked"<%}%> dojoType="dijit.form.CheckBox"
                       value="">
                <label for="isGpsDevice">I used a GPS Device</label>
            </td>
        </tr>
    </table>
</div>
<div id="tabDegMin" dojoType="dijit.layout.ContentPane" title="Degrees/Minutes" style="width:480px;height:115px;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg2">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg2"
                       name="latitudeDeg2"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:90}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMin('latitudeDeg2');"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="latitudeMin2"
                       name="latitudeMin2"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,3',round:-1,min:0,max:59.999}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMin('latitudeMin2');"
                       invalidMessage="Enter a valid minute value rounded to three decimal places."/>
                '
                <select name="latitudeDir2"
                        id="latitudeDir2"
                        required="false"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onChange="onChangePositionDegMin('latitudeDir2');"
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
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:180}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMin('longitudeDeg2');"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="longitudeMin2"
                       name="longitudeMin2"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,3',round:-1,min:0,max:59.999}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMin('longitudeMin2');"
                       invalidMessage="Enter a valid minute value rounded to three decimal places."/>
                '
                <select name="longitudeDir2"
                        id="longitudeDir2"
                        required="false"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onChange="onChangePositionDegMin('longitudeDir2');"
                        style="width:4.5em;">
                    <option value="east">E</option>
                    <option value="west">W</option>
                </select>
            </td>
        </tr>
    </table>
</div>
<div id="tabDegMinSec" dojoType="dijit.layout.ContentPane" title="Degrees/Minutes/Seconds" style="width:480px;height:115px;">
    <table>
        <tr>
            <th style="width: 72px;">
                <label for="latitudeDeg3">Latitude:</label>
            </th>
            <td>
                <input type="text"
                       id="latitudeDeg3"
                       name="latitudeDeg3"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:90}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('latitudeDeg3');"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="latitudeMin3"
                       name="latitudeMin3"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('latitudeMin3');"
                       invalidMessage="Enter a valid minute value."/>
                '
                <input type="text"
                       id="latitudeSec3"
                       name="latitudeSec3"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,2',round:-1,min:0,max:59.99}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('latitudeSec3');"
                       invalidMessage="Enter a valid second value rounded to two decimal places."/>
                &quot;
                <select name="latitudeDir3"
                        id="latitudeDir3"
                        required="false"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onChange="onChangePositionDegMinSec('latitudeDir3');"
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
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:180}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('longitudeDeg3');"
                       invalidMessage="Enter a valid degree value."/>
                &deg;
                <input type="text"
                       id="longitudeMin3"
                       name="longitudeMin3"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:0,round:-1,min:0,max:59}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('longitudeMin3');"
                       invalidMessage="Enter a valid minute value."/>
                '
                <input type="text"
                       id="longitudeSec3"
                       name="longitudeSec3"
                       required="false"
                       dojoType="dijit.form.NumberTextBox"
                       constraints="{places:'0,2',round:-1,min:0,max:59.99}"
                       trim="true"
                       style="width:6em;"
                       onChange="onChangePositionDegMinSec('longitudeSec3');"
                       invalidMessage="Enter a valid second value rounded to two decimal places."/>
                &quot;
                <select name="longitudeDir3"
                        id="longitudeDir3"
                        required="false"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        onChange="onChangePositionDegMinSec('longitudeDir3');"
                        style="width:4.5em;">
                    <option value="east">E</option>
                    <option value="west">W</option>
                </select>
            </td>
        </tr>
    </table>
</div>
</div>
<div id="locatorMap" style="margin: 1em 0; width: 480px; height: 320px;">
</div>
<script type="text/javascript">
    google.maps.event.addDomListener(window, 'load', googleMap('locatorMap'));
</script>
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
               value="<%=(cmd.equals(Constants.EDIT) && (survey.getDate() != null)) ? dateFormat.format(survey.getDate()) : ""%>"
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
               value="<%=(cmd.equals(Constants.EDIT) && (survey.getTime() != null)) ? timeFormat.format(survey.getTime()) : ""%>"
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
    <th><label for="depthMetres">Depth (metres):</label></th>
    <td>
        <div style="display: none;">
        <input type="hidden"
               id="depth"
               name="depth"
               style="display: none; width:6em;"
               required="false"
               trim="true"
               dojoType="dijit.form.NumberTextBox"
               value="<%= cmd.equals(Constants.EDIT) ? survey.getDepth() : "" %>"/>
        </div>
        <input type="text"
               id="depthMetres"
               style="width:6em;"
               required="false"
               trim="true"
               dojoType="dijit.form.NumberTextBox"
               constraints="{places:'0,2',round:-1,min:0}"
               onChange="onChangeDepthMetres()"
               <% if (cmd.equals(Constants.EDIT) && (survey.getDepth() == null)) { %>
               disabled="disabled"
               <% } %>
               invalidMessage="Enter a valid depth value rounded to two decimal places."
               value="<%= (cmd.equals(Constants.EDIT) && (survey.getDepth() != null)) ? survey.getDepth() : "" %>"/>
        <label for="depthFeet" style="font-weight: bold;">or (feet):</label>
        <input type="text"
               id="depthFeet"
               style="width:6em;"
               required="false"
               trim="true"
               dojoType="dijit.form.NumberTextBox"
               constraints="{places:'0,2',round:-1,min:0}"
               onChange="onChangeDepthFeet()"
               <% if (cmd.equals(Constants.EDIT) && (survey.getDepth() == null)) { %>
               disabled="disabled"
               <% } %>
               invalidMessage="Enter a valid depth value rounded to two decimal places."/>
        <input type="checkbox"
               id="depthDisabled"
               name="depthDisabled"
               dojoType="dijit.form.CheckBox"
               <% if (cmd.equals(Constants.EDIT) && (survey.getDepth() == null)) { %>
               checked="checked"
               <% } %>
               value="true"
               onChange="onChangeDepthDisabled()" />
        <label for="depthDisabled">Not available</label>
    </td>
</tr>
<tr>
    <th><label for="waterTemperatureC">Water Temperature (&deg;C):</label></th>
    <td>
        <div style="display: none;">
        <input type="hidden"
               id="waterTemperature"
               name="waterTemperature"
               style="display: none; width:6em;"
               required="false"
               trim="true"
               dojoType="dijit.form.NumberTextBox"
               value="<%=cmd.equals(Constants.EDIT) ? survey.getWaterTemperature() : ""%>"/>
        </div>
        <input type="text"
               id="waterTemperatureC"
               style="width: 6em;"
               required="false"
               dojoType="dijit.form.NumberTextBox"
               constraints="{places:'0,2',round:-1}"
               trim="true"
               onChange="onChangeWaterTemperatureC()"
               invalidMessage="Enter a valid temperature value rounded to two decimal places."
               <% if (cmd.equals(Constants.EDIT) && (survey.getWaterTemperature() == null)) { %>
               disabled="disabled"
               <% } %>
               value="<%=cmd.equals(Constants.EDIT) ? survey.getWaterTemperature() : ""%>"/>
        <label for="waterTemperatureF" style="font-weight: bold;">or (&deg;F):</label>
        <input type="text"
               id="waterTemperatureF"
               style="width: 6em;"
               required="false"
               dojoType="dijit.form.NumberTextBox"
               constraints="{places:'0,2',round:-1}"
               onChange="onChangeWaterTemperatureF()"
               trim="true"
               <% if (cmd.equals(Constants.EDIT) && (survey.getWaterTemperature() == null)) { %>
               disabled="disabled"
               <% } %>
               invalidMessage="Enter a valid temperature value rounded to two decimal places."/>
        <input type="checkbox"
               id="waterTemperatureDisabled"
               name="waterTemperatureDisabled"
               dojoType="dijit.form.CheckBox"
               <% if (cmd.equals(Constants.EDIT) && (survey.getWaterTemperature() == null)) { %>
               checked="checked"
               <% } %>
               value="true"
               onChange="onChangeWaterTemperatureDisabled()" />
        <label for="waterTemperatureDisabled">Not available</label>
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
<% if ((currentUser != null) && currentUser.isSuperUser() && cmd.equals(Constants.EDIT)) { %>
<tr>
    <th><label for="reviewState">Review:</label></th>
    <td>
        <% for (Survey.ReviewState reviewState : Survey.ReviewState.values()) { %>
        <label style="padding-right: 5px;">
            <input type="radio" name="reviewState" value="<%= reviewState.name() %>" <% if (survey.getReviewState() == reviewState) { %>checked="checked"<% } %> />
            <%= reviewState.getText() %>
        </label>
        <% } %>
    </td>
</tr>
<% } %>
<tr>
    <td colspan="2"><input id="btnSubmit" type="button" value="<%=cmd.equals(Constants.ADD) ? "Submit" : "Save"%>" />
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
                    //alert("Response: " + response)
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
<!--<div align="right"><a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>">Add New Survey</a></div>-->
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
                <div style="float:right;"><a href=""><img src="<%=survey.getCreator().getGravatarUrl()%>" alt="<%=survey.getCreator().getDisplayName()%>"/></a><br/>
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
            <th>Depth:</th>
            <td>
                <%if (survey.getDepth() != null) {%>
                <% double depthFeet = survey.getDepth() / 0.3048; %>
                <%=survey.getDepth()%> m (<%=Math.round(depthFeet)%> feet)
                <%} else {%>
                Not available
                <%}%>
            </td>
        </tr>
        <tr>
            <th>Water Temperature:</th>
            <td>
                <%if (survey.getWaterTemperature() != null) {%>
                <%=survey.getWaterTemperature()%> &deg;C (<%=((survey.getWaterTemperature() * 9 / 5) + 32)%> &deg;F)
                <%} else {%>
                Not available
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
            <td><%=survey.getComments() == null ? "" : survey.getComments().replaceAll("\n", "<br />")%>
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
        <% if ((currentUser != null) && currentUser.isSuperUser()) { %>
        <tr>
            <th>Review:</th>
            <td>
                <img src="<%= renderRequest.getContextPath() %>/icon/timemap/<%= survey.getReviewState().getColour() %>-circle.png" />
                <%= survey.getReviewState().getText() %>
            </td>
        </tr>
        <% } %>
        <%
            if (currentUser != null && (currentUser.equals(survey.getCreator()) || currentUser.isSuperUser())) {
        %>
        <tr>
            <td colspan="2">
                <input type="button" value="Edit" onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:renderURL>';"/>
                <input type="button" value="Delete" onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DELETE %>" /><portlet:param name="surveyId" value="<%= String.valueOf(survey.getId()) %>" /></portlet:actionURL>';"/>
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
        if (Number(lightNumber) > Number(darkNumber)) {
            alert('Lightest colour number (' + lightNumber + ') must be smaller than (or equal to) darkest colour number (' + darkNumber + ').');
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
                if (tbody.childNodes.length > 1) {
                    tbody.insertBefore(row, tbody.childNodes[1]);
                }
                else {
                    tbody.appendChild(row);
                }
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

                <div id="light_color_slate" dojoType="dijit.form.DropDownButton" label="Select..." style="width: 30px;">
                    <div dojoType="dijit.TooltipDialog">
                        <jsp:include page="lightcolorslate.jsp"/>
                    </div>
                </div>
            </td>
            <td nowrap="nowrap">
                <input dojoType="dijit.form.TextBox" name="dark_color_input" id="dark_color_input" type="hidden"
                       value=""/>

                <div id="dark_color_slate" dojoType="dijit.form.DropDownButton" label="Select..." style="width: 30px;">
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
                        //alert('Cannot get number of records: ' + response);
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
    <div id="mDiv" style="width: 640px; height: 53ex">
        <script type="text/javascript">
            var mapDiv = dojo.byId("mDiv");
            var center = new google.maps.LatLng(<%=survey.getLatitude()%>, <%=survey.getLongitude()%>);
            var mapProp = {
                center:center,
                zoom:5,
                mapTypeId:google.maps.MapTypeId.HYBRID
            };
            map=new google.maps.Map(mapDiv,mapProp);
            var marker=new google.maps.Marker({
                position:center,
                map: map
            });
            dojo.addOnLoad(function() {
              var tabs = dijit.byId('surveyDetailsContainer');
              dojo.connect(tabs, '_transition', function(np, op) {
                if(np.id === 'mapTab') {
                  google.maps.event.trigger(map, 'resize');
                }
              });
            });
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
} else if (cmd.equals("bulk_add")) {
%>
<% if ((currentUser != null) && currentUser.isSuperUser()) { %>
<h2 style="margin-top:0;">Bulk Survey Upload</h2>

<div dojoType="dijit.layout.TabContainer" style="width:680px; height:60ex;">
<div id="standardPane" dojoType="dijit.layout.ContentPane" title="Standard">
<form dojoType="dijit.form.Form" action="<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= cmd %>" /></portlet:actionURL>" method="post" name="<portlet:namespace />fm" enctype="multipart/form-data">
<script type="dojo/method" event="onSubmit">
    if (!this.validate()) {
        alert('Form contains invalid data. Please correct errors first.');
        return false;
    }
    return true;
</script>
<script type="text/javascript">
    dojo.addOnLoad(function() {
        dojo.byId("groupName").focus();
    });
</script>
<input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
<input name="type" type="hidden" value="standard"/>
<table>
<tr>
    <th style="width: 120px;"><label for="file">Spreadsheet:</label></th>
    <td>
        <input
            type="file"
            id="file"
            name="file"
            required="true" />
    </td>
</tr>
<tr>
    <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
</tr>
</table>
</form>
</div>
<div id="surgPane" dojoType="dijit.layout.ContentPane" title="SURG">
<form dojoType="dijit.form.Form" action="<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= cmd %>" /></portlet:actionURL>" method="post" name="<portlet:namespace />fm" enctype="multipart/form-data">
<script type="dojo/method" event="onSubmit">
    if (!this.validate()) {
        alert('Form contains invalid data. Please correct errors first.');
        return false;
    }
    return true;
</script>
<input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
<input name="type" type="hidden" value="surg"/>
<table>
<tr>
    <th style="width: 120px;"><label for="file">Spreadsheet:</label></th>
    <td>
        <input
            type="file"
            id="file"
            name="file"
            required="true" />
    </td>
</tr>
<tr>
    <th><label for="groupName">Group Name:</label></th>
    <td>
        <table>
        <tr>
        <td style="padding: 0; vertical-align: middle;">
            <input type="text"
                id="groupName"
                name="groupName"
                required="true"
                dojoType="dijit.form.ValidationTextBox"
                regExp="...*"
                invalidMessage="Enter the name of the group you are participating with"
                value="" />
            </td>
        <td style="padding: 0; vertical-align: middle;">
            e.g. EarthCheck, ReefCheck, OceansWatch.<br />
            Enter your own name if you do not belong to a group.
        </td>
        </tr>
        </table>
    </td>
</tr>
<tr>
    <th><label for="participatingAs">Participating As:</label></th>
    <td><select name="participatingAs"
                id="participatingAs"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="">
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
        <table>
        <tr>
        <td style="padding: 0; vertical-align: middle;">
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
                    value="">
                <option selected="selected" value=""></option>
                <jsp:include page="/include/countrylist.jsp"/>
            </select>
        </td>
        <td style="padding: 0; vertical-align: middle;">
            Please note: this is the country in which you collected the data, not the country you live in.
        </td>
        </tr>
        </table>
    </td>
</tr>

<tr>
    <th><label for="activity">GPS Device:</label></th>
    <td>
        <input id="isGpsDevice" name="isGpsDevice"
               dojoType="dijit.form.CheckBox"
               value="">
        <label for="isGpsDevice">I used a GPS Device</label>
    </td>
</tr>

<tr>
    <th><label for="activity">Activity:</label></th>
    <td><select name="activity"
                id="activity"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="">
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
               value=""/>
    </td>
</tr>
<tr>
    <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
</tr>
</table>
</form>
</div>
</div>

<% } %>
<%
    //If no cmd is given then display list of surveys
} else {
    long userId = ParamUtil.getLong(request, "userId");
    Long createdByUserId = null;
    if (userId > 0) {
        createdByUserId = userId;
    }
    if (currentUser != null) {
%>
<div style="float: right;">
    <a href="<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>">New survey</a>
    <% if (currentUser != null && currentUser.isSuperUser()) { %>
        <portlet:resourceURL var="exportURL" id="export">
            <portlet:param name="singleSheet" value="true" />
            <portlet:param name="format" value="csv" />
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

    var datamodule = getCookie('datamodule');
    
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
                    var url = window.location.origin + '/web/guest/<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=' + item.toString();
                    if (datamodule) return '<a target="popup" href="' + url + '" onclick="window.open(\'' + url + '\',\'popup\',\'width=682,height=644\'); return false;">More Info</a>';
                    else return '<a target="_blank" href="' + url + '">More Info</a>';

                    //var viewURL = "<a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + item.toString() + "\">More info</a>";
                    //return viewURL;
                }
            }
            <% if ((currentUser != null) && currentUser.isSuperUser()) { %>
            , {
                field: "reviewState",
                name: "Review",
                width: 5,
                formatter: function(item) {
                    var reviewStateColour = null;
                    var reviewStateText = null;
                    <% for (Survey.ReviewState reviewState : Survey.ReviewState.values()) { %>
                    if (item == '<%= reviewState.name() %>') {
                        reviewStateColour = '<%= reviewState.getColour() %>';
                        reviewStateText = '<%= reviewState.getText() %>';
                    }
                    <% } %>
                    if (reviewStateColour && reviewStateText) {
                        return '<img src="<%= renderRequest.getContextPath() %>/icon/timemap/' + reviewStateColour + '-circle.png" title="' + reviewStateText + '" />';
                    }
                    else {
                        return '';
                    }
                }
            }
            <% } %>
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
            grid.queryOptions = {ignoreCase: true};
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
                                                                                                  value="Search"/>search is case sensitive
    </form>
</div>
<br/>

<portlet:resourceURL var="listURL" id="list">
    <portlet:param name="format" value="xml" />
    <% if (createdByUserId != null) { %>
    <portlet:param name="createdByUserId" value="<%= String.valueOf(createdByUserId) %>" />
    <% } %>
</portlet:resourceURL>
<div dojoType="dojox.data.XmlStore"
     url="<%= listURL %>"
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
