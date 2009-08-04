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
               invalidMessage="Re-enter your email address."
               value="${(userimpl.email)!}"/>
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
<option value="Antigua and Barbuda">Antigua and Barbuda</option>
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
</table>
<button dojoType="dijit.form.Button" type="submit" name="submit"
        id="submitButton">${newObject?string("Create","Update")}</button>
<#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
<button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'" id="cancelButton">Cancel</button>
</div>