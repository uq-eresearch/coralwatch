<#assign newObject=!(userimpl??)/>
<#if newObject>
<h3>Sign Up</h3>
<#else>
<h3>Editing User ${userimpl.username}</h3>
</#if>

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
    <#if newObject>
        dijit.byId("username").focus();
    <#else>
        dijit.byId("displayName").focus();
    </#if>
    });
</script>
<table>
<#if newObject>
<tr>
    <td class="headercell">
        <label for="username">Username:</label>
    </td>
    <td>
        <input type="text"
               id="username"
               name="username"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp=".......*"
               invalidMessage="Please enter a username with at least 6 characters"/>
    </td>
</tr>
</#if>
<tr>
    <td class="headercell">
        <label for="displayName">Display Name:</label>
    </td>
    <td>
        <input type="text"
               id="displayName"
               name="displayName"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               regExp=".......*"
               invalidMessage="Please enter a display name with at least 6 characters"
               value="${(userimpl.displayName)!}"/> <em>e.g. John Smith</em>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="password">New Password${newObject?string('',' (optional)')}:</label>
    </td>
    <td>
        <input type="password"
               id="password"
               name="password"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               validator="var pwLen = this.getValue().length; return ${newObject?string('','(pwLen == 0) || ')}(pwLen >= 6)"
               invalidMessage="Please enter a password with at least 6 characters"/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="password2">Confirm Password:</label>
    </td>
    <td>
        <input type="password"
               id="password2"
               name="password2"
               required="true"
               dojoType="dijit.form.ValidationTextBox"
               validator="return this.getValue() == dijit.byId('password').getValue()"
               invalidMessage="Please enter the same password twice"/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="occupation">Occupation:</label>
    </td>
    <td>
        <input type="text"
               id="occupation"
               name="occupation"
               dojoType="dijit.form.TextBox"
               trim="true"
               value="${(userimpl.occupation)!}"/>
    </td>
</tr>
<tr>
    <td class="headercell">
        <label for="email">Email:</label>
    </td>
    <td>
        <input type="text"
               id="email"
               name="email"
               dojoType="dijit.form.ValidationTextBox"
               required="true"
               regExp="[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,6}"
               trim="true"
               invalidMessage="Enter a valid email address."
               value="${(userimpl.email)!}"/> <em>e.g. address@organisation.com</em>
    </td>
</tr>

<tr>
    <td class="headercell">
        <label for="email2">Confirm Email:</label>
    </td>
    <td>
        <input type="text"
               id="email2"
               name="email2"
               dojoType="dijit.form.ValidationTextBox"
               required="true"
               validator="return this.getValue() == dijit.byId('email').getValue()"
               trim="true"
               invalidMessage="Re-enter your email address."/>
    </td>
</tr>

<tr>
    <td class="headercell">
        <label for="address">Address:</label>
    </td>
    <td>
        <input type="text"
               id="address"
               name="address"
               style="width:300px"
               dojoType="dijit.form.Textarea"
               trim="true"
               value="${(userimpl.address)!}"/>
    </td>
</tr>

<tr>
<td class="headercell">
    <label for="country">Country:</label></td>
<td>
<select name="country"
        id="country"
        dojoType="dijit.form.ComboBox"
        hasDownArrow="true"
        value="${(userimpl.country)!}">
<option value="Afghanistan">Afghanistan</option>
<option value="Albania">Albania</option>
<option value="Algeria">Algeria</option>
<option value="American Samoa">American Samoa</option>
<option value="Andorra">Andorra</option>

<option value="Angola">Angola</option>
<option value="Anguilla">Anguilla</option>
<option value="Antarctica">Antarctica</option>
<option value="Antigua And Barbuda">Antigua And Barbuda</option>
<option value="Argentina">Argentina</option>
<option value="Armenia">Armenia</option>

<option value="Aruba">Aruba</option>
<option selected="selected" value="Australia">Australia</option>
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
<option value="Bosnia And Herzegowina">Bosnia And Herzegowina</option>
<option value="BW">Botswana</option>
<option value="BV">Bouvet Island</option>

<option value="BR">Brazil</option>
<option value="IO">British Indian Ocean Territory</option>
<option value="BN">Brunei Darussalam</option>
<option value="BG">Bulgaria</option>
<option value="BF">Burkina Faso</option>
<option value="BI">Burundi</option>

<option value="KH">Cambodia</option>
<option value="CM">Cameroon</option>
<option value="CA">Canada</option>
<option value="CV">Cape Verde</option>
<option value="KY">Cayman Islands</option>
<option value="CF">Central African Republic</option>

<option value="TD">Chad</option>
<option value="CL">Chile</option>
<option value="CN">China</option>
<option value="CX">Christmas Island</option>
<option value="CC">Cocos (Keeling) Islands</option>
<option value="CO">Colombia</option>

<option value="KM">Comoros</option>
<option value="CG">Congo</option>
<option value="CK">Cook Islands</option>
<option value="CR">Costa Rica</option>
<option value="CI">Cote D'Ivoire</option>
<option value="HR">Croatia (Local Name: Hrvatska)</option>

<option value="CU">Cuba</option>
<option value="CY">Cyprus</option>
<option value="CZ">Czech Republic</option>
<option value="DK">Denmark</option>
<option value="DJ">Djibouti</option>
<option value="DM">Dominica</option>

<option value="DO">Dominican Republic</option>
<option value="TP">East Timor</option>
<option value="EC">Ecuador</option>
<option value="EG">Egypt</option>
<option value="SV">El Salvador</option>
<option value="GQ">Equatorial Guinea</option>

<option value="ER">Eritrea</option>
<option value="EE">Estonia</option>
<option value="ET">Ethiopia</option>
<option value="FK">Falkland Islands (Malvinas)</option>
<option value="FO">Faroe Islands</option>
<option value="FJ">Fiji</option>

<option value="FI">Finland</option>
<option value="FR">France</option>
<option value="GF">French Guiana</option>
<option value="PF">French Polynesia</option>
<option value="TF">French Southern Territories</option>
<option value="GA">Gabon</option>

<option value="GM">Gambia</option>
<option value="GE">Georgia</option>
<option value="DE">Germany</option>
<option value="GH">Ghana</option>
<option value="GI">Gibraltar</option>
<option value="GR">Greece</option>

<option value="GL">Greenland</option>
<option value="GD">Grenada</option>
<option value="GP">Guadeloupe</option>
<option value="GU">Guam</option>
<option value="GT">Guatemala</option>
<option value="GN">Guinea</option>

<option value="GW">Guinea-Bissau</option>
<option value="GY">Guyana</option>
<option value="HT">Haiti</option>
<option value="HM">Heard And Mc Donald Islands</option>
<option value="VA">Holy See (Vatican City State)</option>
<option value="HN">Honduras</option>

<option value="HK">Hong Kong</option>
<option value="HU">Hungary</option>
<option value="IS">Icel And</option>
<option value="IN">India</option>
<option value="ID">Indonesia</option>
<option value="IR">Iran (Islamic Republic Of)</option>

<option value="IQ">Iraq</option>
<option value="IE">Ireland</option>
<option value="IL">Israel</option>
<option value="IT">Italy</option>
<option value="JM">Jamaica</option>
<option value="JP">Japan</option>

<option value="JO">Jordan</option>
<option value="KZ">Kazakhstan</option>
<option value="KE">Kenya</option>
<option value="KI">Kiribati</option>
<option value="KP">Korea, Dem People'S Republic</option>
<option value="KR">Korea, Republic Of</option>

<option value="KW">Kuwait</option>
<option value="KG">Kyrgyzstan</option>
<option value="LA">Lao People'S Dem Republic</option>
<option value="LV">Latvia</option>
<option value="LB">Lebanon</option>
<option value="LS">Lesotho</option>

<option value="LR">Liberia</option>
<option value="LY">Libyan Arab Jamahiriya</option>
<option value="LI">Liechtenstein</option>
<option value="LT">Lithuania</option>
<option value="LU">Luxembourg</option>
<option value="MO">Macau</option>

<option value="MK">Macedonia</option>
<option value="MG">Madagascar</option>
<option value="MW">Malawi</option>
<option value="MY">Malaysia</option>
<option value="MV">Maldives</option>
<option value="ML">Mali</option>

<option value="MT">Malta</option>
<option value="MH">Marshall Islands</option>
<option value="MQ">Martinique</option>
<option value="MR">Mauritania</option>
<option value="MU">Mauritius</option>
<option value="YT">Mayotte</option>

<option value="MX">Mexico</option>
<option value="FM">Micronesia, Federated States</option>
<option value="MD">Moldova, Republic Of</option>
<option value="MC">Monaco</option>
<option value="MN">Mongolia</option>
<option value="MS">Montserrat</option>

<option value="MA">Morocco</option>
<option value="MZ">Mozambique</option>
<option value="MM">Myanmar</option>
<option value="NA">Namibia</option>
<option value="NR">Nauru</option>
<option value="NP">Nepal</option>

<option value="NL">Netherlands</option>
<option value="AN">Netherlands Ant Illes</option>
<option value="NC">New Caledonia</option>
<option value="NZ">New Zealand</option>
<option value="NI">Nicaragua</option>
<option value="NE">Niger</option>

<option value="NG">Nigeria</option>
<option value="NU">Niue</option>
<option value="NF">Norfolk Island</option>
<option value="MP">Northern Mariana Islands</option>
<option value="NO">Norway</option>
<option value="OM">Oman</option>

<option value="PK">Pakistan</option>
<option value="PW">Palau</option>
<option value="PA">Panama</option>
<option value="PG">Papua New Guinea</option>
<option value="PY">Paraguay</option>
<option value="PE">Peru</option>

<option value="PH">Philippines</option>
<option value="PN">Pitcairn</option>
<option value="PL">Poland</option>
<option value="PT">Portugal</option>
<option value="PR">Puerto Rico</option>
<option value="QA">Qatar</option>

<option value="RE">Reunion</option>
<option value="RO">Romania</option>
<option value="RU">Russian Federation</option>
<option value="RW">Rwanda</option>
<option value="KN">Saint K Itts And Nevis</option>
<option value="LC">Saint Lucia</option>

<option value="VC">Saint Vincent, The Grenadines</option>
<option value="WS">Samoa</option>
<option value="SM">San Marino</option>
<option value="ST">Sao Tome And Principe</option>
<option value="SA">Saudi Arabia</option>
<option value="SN">Senegal</option>

<option value="SC">Seychelles</option>
<option value="SL">Sierra Leone</option>
<option value="SG">Singapore</option>
<option value="SK">Slovakia (Slovak Republic)</option>
<option value="SI">Slovenia</option>
<option value="SB">Solomon Islands</option>

<option value="SO">Somalia</option>
<option value="ZA">South Africa</option>
<option value="GS">South Georgia , S Sandwich Is.</option>
<option value="ES">Spain</option>
<option value="LK">Sri Lanka</option>
<option value="SH">St. Helena</option>

<option value="PM">St. Pierre And Miquelon</option>
<option value="SD">Sudan</option>
<option value="SR">Suriname</option>
<option value="SJ">Svalbard, Jan Mayen Islands</option>
<option value="SZ">Sw Aziland</option>
<option value="SE">Sweden</option>

<option value="CH">Switzerland</option>
<option value="SY">Syrian Arab Republic</option>
<option value="TW">Taiwan</option>
<option value="TJ">Tajikistan</option>
<option value="TZ">Tanzania, United Republic Of</option>
<option value="TH">Thailand</option>

<option value="TG">Togo</option>
<option value="TK">Tokelau</option>
<option value="TO">Tonga</option>
<option value="TT">Trinidad And Tobago</option>
<option value="TN">Tunisia</option>
<option value="TR">Turkey</option>

<option value="TM">Turkmenistan</option>
<option value="TC">Turks And Caicos Islands</option>
<option value="TV">Tuvalu</option>
<option value="UG">Uganda</option>
<option value="UA">Ukraine</option>
<option value="AE">United Arab Emirates</option>

<option value="GB">United Kingdom</option>
<option value="US">United States</option>
<option value="UM">United States Minor Is.</option>
<option value="UY">Uruguay</option>
<option value="UZ">Uzbekistan</option>
<option value="VU">Vanuatu</option>

<option value="VE">Venezuela</option>
<option value="VN">Viet Nam</option>
<option value="VG">Virgin Islands (British)</option>
<option value="VI">Virgin Islands (U.S.)</option>
<option value="WF">Wallis And Futuna Islands</option>
<option value="EH">Western Sahara</option>

<option value="YE">Yemen</option>
<option value="YU">Yugoslavia</option>
<option value="ZR">Zaire</option>
<option value="ZM">Zambia</option>
<option value="ZW">Zimbabwe</option>
</select>
</td>
</tr>
</table>
<button dojoType="dijit.form.Button" type="submit" name="submit" id="submitButton">${newObject?string("Create","Update")}</button>
<#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
<button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'" id="cancelButton">Cancel</button>
</div>