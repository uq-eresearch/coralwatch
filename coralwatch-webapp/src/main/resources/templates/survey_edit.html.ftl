<#assign newObject=!(survey??)/>
<#if newObject>
<h3>Create New Survey</h3>
<#else>
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
<table>
<#if !newObject>
<tr>
    <td class="headercell">Creator:</td>
    <td>${(survey.creator.username)!}</td>
</tr>
</#if>
<tr>
    <td class="headercell">
        <label for="organisation">Organisation:</label>
    </td>
    <td>
        <input type="text"
               id="organisation"
               name="organisation"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp="...*"
               invalidMessage="Enter your organisation name"
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
        <label for="reefName">Reef Name:</label></td>
    <td>
        <select name="reefName"
                id="reefName"
                dojoType="dijit.form.ComboBox"
                required="true"
                hasDownArrow="true"
                value="${(survey.reef.name)!}">
            <#if (reefRecs?size > 0)>
            <#list reefRecs as item>
            <option value="${item.name!}">${item.name!}</option>
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
        <div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:33em;height:12ex">
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
                                   constraints="{places:6}"
                                   trim="true"
                                   onBlur="updateLatFromDecimal()"
                                   invalidMessage="Enter a valid latitude value."
                                   value="${(survey.latitude)!}"/>
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
                                   constraints="{places:6}"
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
                                   constraints="{places:0,min:0,max:180}"
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
               required="true"
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
        <label for="weather">Weather:</label></td>
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
        <label for="temperature">Temperature:</label>
    </td>
    <td>
        <input type="text"
               id="temperature"
               name="temperature"
               required="true"
               dojoType="dijit.form.NumberTextBox"
               trim="true"
               invalidMessage="Enter a valid temperature value."
               value="${(survey.temperature)!}"/>
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