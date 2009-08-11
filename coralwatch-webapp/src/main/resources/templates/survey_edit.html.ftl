<#-- @ftlvariable name="reefRecs" type="java.util.List<org.coralwatch.model.Reef>" -->
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
        if(dec > 180) {
            dec = dec-360;
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
<option value="Afghanistan">Afghanistan</option>
<option value="Albania">Albania</option>
<option value="Algeria">Algeria</option>
<option value="American Samoa">American Samoa</option>
<option value="Andorra">Andorra</option>
<option value="Angola">Angola</option>
<option value="Anguilla">Anguilla</option>
<option value="Antigua and Barbuda">Antigua and Barbuda</option>
<option value="Argentina">Argentina</option>
<option value="Armenia">Armenia</option>
<option value="Aruba">Aruba</option>
<option value="Australia">Australia</option>
<option value="Austria">Austria</option>
<option value="Azerbaijan">Azerbaijan</option>
<option value="Bahamas">Bahamas</option>
<option value="Bahrain">Bahrain</option>
<option value="Bangladesh">Bangladesh</option>
<option value="Barbados">Barbados</option>
<option value="Belarus">Belarus</option>
<option value="Belgium">Belgium</option>
<option value="Belize">Belize</option>
<option value="Benin">Benin</option>
<option value="Bermuda">Bermuda</option>
<option value="Bhutan">Bhutan</option>
<option value="Bolivia">Bolivia</option>
<option value="Bosnia and Herzegovina">Bosnia and Herzegovina</option>
<option value="Botswana">Botswana</option>
<option value="Brazil">Brazil</option>
<option value="Brunei Darussalam">Brunei Darussalam</option>
<option value="Bulgaria">Bulgaria</option>
<option value="Burkina Faso">Burkina Faso</option>
<option value="Burundi">Burundi</option>
<option value="Cambodia">Cambodia</option>
<option value="Cameroon">Cameroon</option>
<option value="Canada">Canada</option>
<option value="Cape Verde">Cape Verde</option>
<option value="Cayman Islands">Cayman Islands</option>
<option value="Central African Republic">Central African Republic</option>
<option value="Chad">Chad</option>
<option value="Chile">Chile</option>
<option value="China">China</option>
<option value="Colombia">Colombia</option>
<option value="Comoros">Comoros</option>
<option value="Congo, Republic of">Congo, Republic of</option>
<option value="Cook Islands">Cook Islands</option>
<option value="Costa Rica">Costa Rica</option>
<option value="Croatia">Croatia</option>
<option value="Cuba">Cuba</option>
<option value="Cyprus">Cyprus</option>
<option value="Czech Republic">Czech Republic</option>
<option value="Democratic Republic of the Congo">Democratic Republic of the Congo</option>
<option value="Denmark">Denmark</option>
<option value="Djibouti">Djibouti</option>
<option value="Dominica">Dominica</option>
<option value="Dominican Republic">Dominican Republic</option>
<option value="Ecuador">Ecuador</option>
<option value="Egypt">Egypt</option>
<option value="El Salvador">El Salvador</option>
<option value="Equatorial Guinea">Equatorial Guinea</option>
<option value="Eritrea">Eritrea</option>
<option value="Estonia">Estonia</option>
<option value="Ethiopia">Ethiopia</option>
<option value="Fiji">Fiji</option>
<option value="Finland">Finland</option>
<option value="France">France</option>
<option value="French Polynesia">French Polynesia</option>
<option value="Gabon">Gabon</option>
<option value="Georgia">Georgia</option>
<option value="Germany">Germany</option>
<option value="Ghana">Ghana</option>
<option value="Greece">Greece</option>
<option value="Grenada">Grenada</option>
<option value="Guadeloup">Guadeloupe</option>
<option value="Guam">Guam</option>
<option value="Guatemala">Guatemala</option>
<option value="Guinea">Guinea</option>
<option value="Guinea-Bissau">Guinea-Bissau</option>
<option value="Guyana">Guyana</option>
<option value="Haiti">Haiti</option>
<option value="Holy See">Holy See</option>
<option value="Honduras">Honduras</option>
<option value="Hong Kong SAR">Hong Kong SAR</option>
<option value="Hungary">Hungary</option>
<option value="Iceland">Iceland</option>
<option value="India">India</option>
<option value="Indonesia">Indonesia</option>
<option value="Iran">Iran</option>
<option value="Iraq">Iraq</option>
<option value="Ireland">Ireland</option>
<option value="Israel">Israel</option>
<option value="Italy">Italy</option>
<option value="Ivory Coast">Ivory Coast</option>
<option value="Jamaica">Jamaica</option>
<option value="Japan">Japan</option>
<option value="Jordan">Jordan</option>
<option value="Kazakhstan">Kazakhstan</option>
<option value="Kenya">Kenya</option>
<option value="Kiribati">Kiribati</option>
<option value="Korea, Democratic People's Republic Of">Korea, Democratic People's Republic Of</option>
<option value="Korea, Republic Of">Korea, Republic Of</option>
<option value="Kosovo">Kosovo</option>
<option value="Kuwait">Kuwait</option>
<option value="Kyrgyzstan">Kyrgyzstan</option>
<option value="Laos">Laos</option>
<option value="Latvia">Latvia</option>
<option value="Lebanon">Lebanon</option>
<option value="Lesotho">Lesotho</option>
<option value="Liberia">Liberia</option>
<option value="Libya">Libya</option>
<option value="Liechtenstein">Liechtenstein</option>
<option value="Lithuania">Lithuania</option>
<option value="Luxembourg">Luxembourg</option>
<option value="Macau">Macau</option>
<option value="Macedonia">Macedonia</option>
<option value="Madagascar">Madagascar</option>
<option value="Malawi">Malawi</option>
<option value="Malaysia">Malaysia</option>
<option value="Maldives">Maldives</option>
<option value="Mali">Mali</option>
<option value="Malta">Malta</option>
<option value="Marshall Islands">Marshall Islands</option>
<option value="Martinique">Martinique</option>
<option value="Mauritania">Mauritania</option>
<option value="Mauritius">Mauritius</option>
<option value="Mexico">Mexico</option>
<option value="Micronesia">Micronesia</option>
<option value="Moldova">Moldova</option>
<option value="Monaco">Monaco</option>
<option value="Mongolia">Mongolia</option>
<option value="Montenegro">Montenegro</option>
<option value="Montserrat">Montserrat</option>
<option value="Morocco">Morocco</option>
<option value="Mozambique">Mozambique</option>
<option value="Myanmar">Myanmar</option>
<option value="Namibia">Namibia</option>
<option value="Nauru">Nauru</option>
<option value="Nepal">Nepal</option>
<option value="Netherland">Netherlands</option>
<option value="Netherlands Antilles">Netherlands Antilles</option>
<option value="New Caledonia">New Caledonia</option>
<option value="New Zealand">New Zealand</option>
<option value="Nicaragua">Nicaragua</option>
<option value="Niger">Niger</option>
<option value="Nigeria">Nigeria</option>
<option value="Niue">Niue</option>
<option value="Northern Mariana Islands">Northern Mariana Islands</option>
<option value="Norway">Norway</option>
<option value="Oman">Oman</option>
<option value="Pakistan">Pakistan</option>
<option value="Palau">Palau</option>
<option value="Palestinian National Authority">Palestinian National Authority</option>
<option value="Panama">Panama</option>
<option value="Papua New Guinea">Papua New Guinea</option>
<option value="Paraguay">Paraguay</option>
<option value="Peru">Peru</option>
<option value="Philippines">Philippines</option>
<option value="Pitcairn">Pitcairn</option>
<option value="Poland">Poland</option>
<option value="Portugal">Portugal</option>
<option value="Qatar">Qatar</option>
<option value="Romania">Romania</option>
<option value="Russian Federation">Russian Federation</option>
<option value="Rwanda">Rwanda</option>
<option value="Saint Kitts and Nevis">Saint Kitts and Nevis</option>
<option value="Saint Lucia">Saint Lucia</option>
<option value="Saint Vincent and the Grenadines">Saint Vincent and the Grenadines</option>
<option value="Samoa">Samoa</option>
<option value="San Marino">San Marino</option>
<option value="Sao Tome and Principe">Sao Tome and Principe</option>
<option value="Saudi Arabia">Saudi Arabia</option>
<option value="Senegal">Senegal</option>
<option value="Serbia">Serbia</option>
<option value="Seychelles">Seychelles</option>
<option value="Sierra Leone">Sierra Leone</option>
<option value="Singapore">Singapore</option>
<option value="Slovakia">Slovakia</option>
<option value="Slovenia">Slovenia</option>
<option value="Solomon Islands">Solomon Islands</option>
<option value="Somalia">Somalia</option>
<option value="South Africa">South Africa</option>
<option value="Spain">Spain</option>
<option value="Sri Lanka">Sri Lanka</option>
<option value="Sudan">Sudan</option>
<option value="Suriname">Suriname</option>
<option value="Swaziland">Swaziland</option>
<option value="Sweden">Sweden</option>
<option value="Switzerland">Switzerland</option>
<option value="Syria">Syria</option>
<option value="Taiwan">Taiwan</option>
<option value="Tajikistan">Tajikistan</option>
<option value="Tanzania">Tanzania</option>
<option value="Thailand">Thailand</option>
<option value="The Gambia">The Gambia</option>
<option value="Timor-Leste">Timor-Leste</option>
<option value="Togo">Togo</option>
<option value="Tokelau">Tokelau</option>
<option value="Tonga">Tonga</option>
<option value="Trinidad and Tobago">Trinidad and Tobago</option>
<option value="Tunisia">Tunisia</option>
<option value="Turkey">Turkey</option>
<option value="Turkmenistan">Turkmenistan</option>
<option value="Tuvalu">Tuvalu</option>
<option value="Uganda">Uganda</option>
<option value="Ukraine">Ukraine</option>
<option value="United Arab Emirates">United Arab Emirates</option>
<option value="United Kingdom">United Kingdom</option>
<option value="United States of America">United States of America</option>
<option value="Uruguay">Uruguay</option>
<option value="Uzbekistan">Uzbekistan</option>
<option value="Vanuatu">Vanuatu</option>
<option value="Venezuela">Venezuela</option>
<option value="Vietnam">Vietnam</option>
<option value="Wallis and Futuna Islands">Wallis and Futuna Islands</option>
<option value="Yemen">Yemen</option>
<option value="Yugoslavia">Yugoslavia</option>
<option value="Zambia">Zambia</option>
<option value="Zimbabwe">Zimbabwe</option>
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
        <div id="mainTabContainer" dojoType="dijit.layout.TabContainer" style="width:40em;height:20ex">
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