<#-- @ftlvariable name="reefRecs" type="java.util.List<org.coralwatch.model.Reef>" -->
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<script type="text/javascript">

    function showMap(elementId) {
        var id = document.getElementById(elementId);
        id.style.display = (id.style.display == 'none') ? '' : 'none';
    }
    $(document).ready(function() {
        if (GBrowserIsCompatible()) {
            var mapDiv = document.getElementById("locatorMap");
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
                document.getElementById("latitude").value = Lat5;
                updateLatFromDecimal();
                document.getElementById("longitude").value = Lng5;
                updateLonFromDecimal();
            });
            mapDiv.style.display = 'none';
        }
        else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
        }
        //        jQuery("#map").dialog({ autoOpen: false, width: 470, height: 330 });
        jQuery("#locatorMap").dialog({ autoOpen: false, width: 470, height: 320 });
    });
</script>

<#assign newObject=!(survey??)/>
<#if newObject>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/surveys">Surveys</a>&ensp;&raquo;&ensp;New
    Survey
</div>
<h3>Create New Survey</h3>
<#else>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/surveys">Surveys</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/surveys/${(survey.id)!}">${(survey.id)!}</a>&ensp;&raquo;&ensp;Edit Survey
</div>
<h3>Editing Survey</h3>
</#if>
<p>Thanks for participating in this survey, please complete the following information before you enter your data for
    each sample.</p>

<div dojoType="dijit.form.Form" method="post">
<script type="dojo/method" event="onSubmit">
    if(!this.validate()){
    alert('Form contains invalid data. Please correct first');
    return false;
    }
    return true;
</script>
<script type="text/javascript">
    dojo.addOnLoad(function() {
        dijit.byId("organisation").focus();
        updateLonFromDecimal();
        updateLatFromDecimal();
    });

    function updateLonFromDecimal() {
        var dec = dijit.byId("longitude").getValue();
        if (dec > 180) {
            dec = dec - 360;
        }
        var sign = (dec >= 0) ? 1 : -1;
        dec = dec * sign;
        var deg = Math.floor(dec);
        dec = (dec - deg) * 60;
        var min = Math.floor(dec);
        dec = (dec - min) * 60;
        var sec = Math.round(dec);
        dijit.byId("longitudeDeg").setValue(deg);
        dijit.byId("longitudeMin").setValue(min);
        dijit.byId("longitudeSec").setValue(sec);
        if (sign == 1) {
            dijit.byId("longitudeDir").setValue("E");
        } else {
            dijit.byId("longitudeDir").setValue("W");
        }
    }
    function updateLatFromDecimal() {
        var dec = dijit.byId("latitude").getValue();
        var sign = (dec >= 0) ? 1 : -1;
        dec = dec * sign;
        var deg = Math.floor(dec);
        dec = (dec - deg) * 60;
        var min = Math.floor(dec);
        dec = (dec - min) * 60;
        var sec = Math.round(dec);
        dijit.byId("latitudeDeg").setValue(deg);
        dijit.byId("latitudeMin").setValue(min);
        dijit.byId("latitudeSec").setValue(sec);
        if (sign == 1) {
            dijit.byId("latitudeDir").setValue("N");
        } else {
            dijit.byId("latitudeDir").setValue("S");
        }
    }
    function updateLonFromDegrees() {
        var deg = parseInt(dijit.byId("longitudeDeg").getValue());
        var min = parseInt(dijit.byId("longitudeMin").getValue());
        var sec = parseInt(dijit.byId("longitudeSec").getValue());
        var dec = deg + min / 60 + sec / 3600;
        if (dijit.byId("longitudeDir").getValue() == "W") {
            dec = -dec;
        }
        dijit.byId("longitude").setValue(dec);
    }
    function updateFTemperature() {
        dijit.byId("temperatureF").setValue((212 - 32) / 100 * dijit.byId("temperature").getValue() + 32);
    }
    function updateCTemperature() {
        dijit.byId("temperature").setValue(100 / (212 - 32) * (dijit.byId("temperatureF").getValue() - 32 ));
    }
    function updateLatFromDegrees() {
        var deg = parseInt(dijit.byId("latitudeDeg").getValue());
        var min = parseInt(dijit.byId("latitudeMin").getValue());
        var sec = parseInt(dijit.byId("latitudeSec").getValue());
        var dec = deg + min / 60 + sec / 3600;
        if (dijit.byId("latitudeDir").getValue() == "S") {
            dec = -dec;
        }
        dijit.byId("latitude").setValue(dec);
    }

</script>

<div id="locatorMap" style="width: 470px; height: 320px;"></div>

<table>
<#if !newObject>
<tr>
    <td class="headercell">Creator:</td>
    <td>${(survey.creator.username)!}</td>
</tr>
</#if>
<tr>
    <td class="headercell">
        <label for="organisation">Group Name:</label>
    </td>
    <td>
        <input type="text"
               id="organisation"
               name="organisation"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp="...*"
               invalidMessage="Enter the name of the group you are participating with"
               value="${(survey.organisation)!}"/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="organisationType">Participating As:</label></td>
    <td>
        <select name="organisationType"
                id="organisationType"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="${(survey.organisationType)!}">
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
    <td class="headercell">
        <label for="country">Country:</label>
    </td>
    <td>
        <select name="country"
                id="country"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="${(survey.reef.country)!}">
            <option selected="selected" value=""></option>
            <#include "macros/countrylist.html.ftl"/>
        </select>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="reefName">Reef Name:</label></td>
    <td>
        <select name="reefName"
                id="reefName"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="${(survey.reef.name)!}">
            <option selected="selected" value=""></option>
            <#if (reefRecs?size > 0)>
            <#list reefRecs as item>
            <option country="${item.country!}" value="${item.name!}">${item.name!}</option>
            </#list>
            <#else>
            <option value=""></option>
            </#if>
        </select>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label>Position:</label>
    </td>
    <td>
        <div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:40em;height:15ex">
            <div id="tabDecimal" dojoType="dijit.layout.ContentPane" title="Decimal">
                <table>
                    <tr>
                        <td class="headercell">
                            <label for="latitude">Latitude:</label>
                        </td>
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
                                   value="${(survey.latitude)!}"/> <a
                                onClick="jQuery('#locatorMap').dialog('open');return false;" id="locateMapLink"
                                href="#">Locate on map</a>
                        </td>
                    </tr>
                    <tr>
                        <td class="headercell">
                            <label for="longitude">Longitude:</label>
                        </td>
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
                                   value="${(survey.longitude)!}"/>
                        </td>
                    </tr>
                </table>

            </div>
            <div id="tabDegrees" dojoType="dijit.layout.ContentPane" title="Degrees">
                <table>
                    <tr>
                        <td class="headercell">
                            <label for="latitudeDeg">Latitude:</label>
                        </td>
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
                        <td class="headercell">
                            <label for="longitudeDeg">Longitude:</label>
                        </td>
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
    <td class="headercell">
        <label for="date">Date:</label>
    </td>
    <td>
        <input type="text"
               id="date"
               name="date"
               required="true"
               isDate="true"
                <#if !newObject>
               value="${(survey.date)?string("yyyy-MM-dd")!}"
                </#if>
               dojoType="dijit.form.DateTextBox"
               constraints="{datePattern: 'dd/MM/yyyy', min:'2000-01-01'}"
               lang="en-au"
               promptMessage="dd/mm/yyyy"
               invalidMessage="Invalid date. Use dd/mm/yyyy format."/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="time">Time:</label></td>
    <td>
        <input id="time"
               name="time"
               type="text"
                <#if !newObject>
               value="${(survey.time)?string("'T'HH:mm:ss")!}"
                </#if>
               required="true"
               dojoType="dijit.form.TimeTextBox"/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="weather">Light Condition:</label></td>
    <td>
        <select name="weather"
                id="weather"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="${(survey.weather)!}">
            <option value="Full Sunshine">Full Sunshine</option>
            <option value="Broken Cloud">Broken Cloud</option>
            <option value="Cloudy">Cloudy</option>
        </select>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="temperature">Temperature (&deg;C):</label>
    </td>
    <td>
        <input type="text"
               id="temperature"
               name="temperature"
               required="true"
               dojoType="dijit.form.NumberTextBox"
               trim="true"
               onBlur="updateFTemperature()"
               invalidMessage="Enter a valid temperature value."
               value="${(survey.temperature)!}"/>
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
    <td class="headercell">
        <label for="activity">Activity:</label></td>
    <td>
        <select name="activity"
                id="activity"
                required="true"
                dojoType="dijit.form.ComboBox"
                hasDownArrow="true"
                value="${(survey.activity)!}">
            <option value="Reef_walking">Reef walking</option>
            <option value="Snorkeling">Snorkeling</option>
            <option value="Diving">Diving</option>
        </select>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="comments">Comments:</label>
    </td>
    <td>
        <input type="text"
               id="comments"
               name="comments"
               style="width:300px"
               dojoType="dijit.form.Textarea"
               trim="true"
               value="${(survey.comments)!}"/>
    </td>
</tr>
</table>
<button dojoType="dijit.form.Button" type="submit" name="submit">${newObject?string("Create","Update")}</button>
<#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
<button dojoType="dijit.form.Button"
        onClick="window.location='${plainUrl}'">Cancel
</button>
</div>
