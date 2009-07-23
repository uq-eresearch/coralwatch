<#assign newObject=!(survey??)/>
<#if newObject>
    <h3>Create New Survey</h3>
    <#else>
        <h3>Editing Survey</h3>
</#if>
<p>Thanks for participating in this survey, please complete the following information before you enter your data for each sample.</p>
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
    });
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
        <label for="organisationType">Organisation Type:</label></td>
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
    <label for="country">Country:</label></td>
<td>
<select name="country"
        id="country"
        dojoType="dijit.form.ComboBox"
        required="true"
        hasDownArrow="true"
        value="${(survey.country)!}">
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

    <tr>
        <td class="headercell">
            <label for="reefName">Reef Name:</label></td>
        <td>
            <select name="reefName"
                    id="reefName"
                    dojoType="dijit.form.ComboBox"
                    required="true"
                    hasDownArrow="true"
                    value="${(survey.reefName)!}">
            <option value=" Parker Point Rottnest Island WA"> Parker Point Rottnest Island WA</option>
            <option value=" Rottnest Island Fay's Bay WA"> Rottnest Island Fay's Bay WA</option>
            <option value="100th site 3m">100th site 3m</option>
            <option value="12">12</option>
            <option value="Abrolhos, Canal da Barracuda">Abrolhos, Canal da Barracuda</option>
            <option value="Agincourt Reef">Agincourt Reef</option>
            <option value="Airport lagoon">Airport lagoon</option>

            <option value="Airport Lagoon, Tutuila">Airport Lagoon, Tutuila</option>
            <option value="Akumal, Mexico">Akumal, Mexico</option>
            <option value="Amphoras">Amphoras</option>
            <option value="Angaga thilla, South Ari Atoll">Angaga thilla, South Ari Atoll</option>
            <option value="Aow Leuk, Koh Tao">Aow Leuk, Koh Tao</option>
            <option value="Aow Tanote">Aow Tanote</option>

            <option value="Apo">Apo</option>
            <option value="Aquarium">Aquarium</option>
            <option value="Arthur's Rock / Koala">Arthur's Rock / Koala</option>
            <option value="BAIS">BAIS</option>
            <option value="Banana Bay of Ken Ting">Banana Bay of Ken Ting</option>
            <option value="Bantayan">Bantayan</option>

            <option value="Barracuda Point">Barracuda Point</option>
            <option value="Barracuda Reef">Barracuda Reef</option>
            <option value="Big Coral">Big Coral</option>
            <option value="black rock, panay">black rock, panay</option>
            <option value="Blue Bowl, Wakatobi">Blue Bowl, Wakatobi</option>
            <option value="Blue Channel">Blue Channel</option>

            <option value="Blue Pools">Blue Pools</option>
            <option value="Boundary Island">Boundary Island</option>
            <option value="Boy Scout">Boy Scout</option>
            <option value="Buck">Buck</option>
            <option value="Buruanga, Panay">Buruanga, Panay</option>
            <option value="Cabbage Patch 3m">Cabbage Patch 3m</option>

            <option value="Canyon Reef">Canyon Reef</option>
            <option value="Captain's Point, Pulau Aur">Captain's Point, Pulau Aur</option>
            <option value="Carrie Bow Caye North">Carrie Bow Caye North</option>
            <option value="Carrizales, Manzanillo, Colima">Carrizales, Manzanillo, Colima</option>
            <option value="Cayo Blanco">Cayo Blanco</option>
            <option value="Cayo Blanko">Cayo Blanko</option>

            <option value="cebu/mactan">cebu/mactan</option>
            <option value="Chabahar Gulf'">Chabahar Gulf'</option>
            <option value="Chabahar Gulf'(Big sea 1)">Chabahar Gulf'(Big sea 1)</option>
            <option value="CHALE REEF">CHALE REEF</option>
            <option value="Champagne Reef">Champagne Reef</option>
            <option value="Chek Chau Island">Chek Chau Island</option>

            <option value="CHIBISI">CHIBISI</option>
            <option value="Christmas Island">Christmas Island</option>
            <option value="Christmas Island - Chicken Farm">Christmas Island - Chicken Farm</option>
            <option value="Clear Water Bay, 1st Beach">Clear Water Bay, 1st Beach</option>
            <option value="Clerke Reef - Rowley Shoals Marine Park">Clerke Reef - Rowley Shoals Marine Park</option>
            <option value="Cockroach Island">Cockroach Island</option>

            <option value="Coral Coast">Coral Coast</option>
            <option value="Coral Gardens, Wakatobi">Coral Gardens, Wakatobi</option>
            <option value="CORS REEF">CORS REEF</option>
            <option value="Davis Reef">Davis Reef</option>
            <option value="Dia Pai">Dia Pai</option>
            <option value="Double Wreck">Double Wreck</option>

            <option value="Douglas Bay Point">Douglas Bay Point</option>
            <option value="Douglas Bay Point - Dominica">Douglas Bay Point - Dominica</option>
            <option value="Drunkenmans Cay">Drunkenmans Cay</option>
            <option value="East Peels Island-Moreton Bay">East Peels Island-Moreton Bay</option>
            <option value="Easy Street">Easy Street</option>
            <option value="Eddy Reef">Eddy Reef</option>

            <option value="El Aquario">El Aquario</option>
            <option value="Emily Bay">Emily Bay</option>
            <option value="Fab Point, Koh Rong Samloem">Fab Point, Koh Rong Samloem</option>
            <option value="Fiddle Garden">Fiddle Garden</option>
            <option value="Fish Bay">Fish Bay</option>
            <option value="Fishermans Bay">Fishermans Bay</option>

            <option value="Flat Cay">Flat Cay</option>
            <option value="Flinders">Flinders</option>
            <option value="Flying Fish Cove">Flying Fish Cove</option>
            <option value="Fourth Cut">Fourth Cut</option>
            <option value="front reef edge slope">front reef edge slope</option>
            <option value="Gibson Bight">Gibson Bight</option>

            <option value="Ginger Island">Ginger Island</option>
            <option value="Glover's Reef">Glover's Reef</option>
            <option value="Government Beach">Government Beach</option>
            <option value="Grande Island">Grande Island</option>
            <option value="Great Barrier Reef">Great Barrier Reef</option>
            <option value="Hamm">Hamm</option>

            <option value="Hans Creek">Hans Creek</option>
            <option value="Hardy Reef">Hardy Reef</option>
            <option value="Heron Island">Heron Island</option>
            <option value="Hiroshi, Kosrae">Hiroshi, Kosrae</option>
            <option value="Hon Mun, Mama Hanh beach">Hon Mun, Mama Hanh beach</option>
            <option value="Hornets Reef">Hornets Reef</option>

            <option value="Inner Reef">Inner Reef</option>
            <option value="Japanese Gardens">Japanese Gardens</option>
            <option value="Japanese Gardens, Koh Tao">Japanese Gardens, Koh Tao</option>
            <option value="Kadongo">Kadongo</option>
            <option value="Kaledupa">Kaledupa</option>
            <option value="Kaledupa 1, Wakatobi">Kaledupa 1, Wakatobi</option>

            <option value="Kaledupa Double Spur">Kaledupa Double Spur</option>
            <option value="Kata Beach- North side">Kata Beach- North side</option>
            <option value="kavarathi reef,lakshadweep,india">kavarathi reef,lakshadweep,india</option>
            <option value="Kending National Park ">Kending National Park </option>
            <option value="Kennedy Wall">Kennedy Wall</option>
            <option value="KERAMA OKINAWA">KERAMA OKINAWA</option>

            <option value="KMSU REEF">KMSU REEF</option>
            <option value="Ko Wai main beach">Ko Wai main beach</option>
            <option value="Koh Bon West">Koh Bon West</option>
            <option value="Koh Ma">Koh Ma</option>
            <option value="Koh Mae Urai, Krabi">Koh Mae Urai, Krabi</option>
            <option value="Koh Man Wichai">Koh Man Wichai</option>

            <option value="koh phai">koh phai</option>
            <option value="Koh Pho Ta">Koh Pho Ta</option>
            <option value="Koh Sak East">Koh Sak East</option>
            <option value="Koh Sak West">Koh Sak West</option>
            <option value="Koh Talu Rayong">Koh Talu Rayong</option>
            <option value="Koh Talu, Krabi">Koh Talu, Krabi</option>

            <option value="Kolbe">Kolbe</option>
            <option value="Kwo Chau Wan">Kwo Chau Wan</option>
            <option value="La Boca">La Boca</option>
            <option value="La Boquita, Manzanillo,Colima,México">La Boquita, Manzanillo,Colima,México</option>
            <option value="La Bym">La Bym</option>
            <option value="la Ratinga">la Ratinga</option>

            <option value="Lady Elliot Island">Lady Elliot Island</option>
            <option value="Lankanfinolhu, North Male Atoll">Lankanfinolhu, North Male Atoll</option>
            <option value="Lapus Lapus">Lapus Lapus</option>
            <option value="Lauro Reef">Lauro Reef</option>
            <option value="Lighthouse Bay, Koh Tao">Lighthouse Bay, Koh Tao</option>
            <option value="Lime Cay">Lime Cay</option>

            <option value="Little Gobal">Little Gobal</option>
            <option value="Lizard Island">Lizard Island</option>
            <option value="Longsodaan MPA">Longsodaan MPA</option>
            <option value="Low Isles">Low Isles</option>
            <option value="Lungsodaan MPA Philippines">Lungsodaan MPA Philippines</option>
            <option value="Mackay">Mackay</option>

            <option value="Mactan/Cebu">Mactan/Cebu</option>
            <option value="Mae Haad Reef, Koh Tao">Mae Haad Reef, Koh Tao</option>
            <option value="Mamutik Is. Kota Kinabalu - West">Mamutik Is. Kota Kinabalu - West</option>
            <option value="Mamutik Island">Mamutik Island</option>
            <option value="Mangel Halto">Mangel Halto</option>
            <option value="Mango Bay, Koh Tao">Mango Bay, Koh Tao</option>

            <option value="marakal coral garden">marakal coral garden</option>
            <option value="Marina Bay">Marina Bay</option>
            <option value="Masthead Island">Masthead Island</option>
            <option value="Matamanoa Home Reef">Matamanoa Home Reef</option>
            <option value="Maya Bay, Krabi">Maya Bay, Krabi</option>
            <option value="Mermaid Reef MNNR">Mermaid Reef MNNR</option>

            <option value="Mid Reef North of Island Sign">Mid Reef North of Island Sign</option>
            <option value="Middle Garden">Middle Garden</option>
            <option value="Mike's Maze ">Mike's Maze </option>
            <option value="Mike's Maze I">Mike's Maze I</option>
            <option value="Minabe, Wakayama-ken">Minabe, Wakayama-ken</option>
            <option value="Monkey Island">Monkey Island</option>

            <option value="Mooloolah River training wall">Mooloolah River training wall</option>
            <option value="Moon Arm">Moon Arm</option>
            <option value="Moore Reef">Moore Reef</option>
            <option value="mugi,tokushima-ken">mugi,tokushima-ken</option>
            <option value="Mushroom Garden">Mushroom Garden</option>
            <option value="n/a - directly offshore from Information Centre">n/a - directly offshore from Information Centre</option>

            <option value="Nanbu Wakayama">Nanbu Wakayama</option>
            <option value="Naviavia">Naviavia</option>
            <option value="Navy Island">Navy Island</option>
            <option value="Nawakama">Nawakama</option>
            <option value="nay band bay">nay band bay</option>
            <option value="nay band reef">nay band reef</option>

            <option value="Njari Island">Njari Island</option>
            <option value="Noosa Caves">Noosa Caves</option>
            <option value="North Curlew Caye">North Curlew Caye</option>
            <option value="North Keppel Island">North Keppel Island</option>
            <option value="North West Island">North West Island</option>
            <option value="Nose Reef">Nose Reef</option>

            <option value="Other">Other</option>
            <option value="Oarsman Bay">Oarsman Bay</option>
            <option value="OJIMA OKINAWA">OJIMA OKINAWA</option>
            <option value="OKINAWA">OKINAWA</option>
            <option value="OKINAWA CAPE MAEDA">OKINAWA CAPE MAEDA</option>
            <option value="OKINAWA SUNABE">OKINAWA SUNABE</option>

            <option value="Old Pier">Old Pier</option>
            <option value="Opal Reefs">Opal Reefs</option>
            <option value="Orca Rock">Orca Rock</option>
            <option value="Osprey Reef">Osprey Reef</option>
            <option value="Other">Other</option>
            <option value="oujima">oujima</option>

            <option value="Over Yonder">Over Yonder</option>
            <option value="Pak Kasims">Pak Kasims</option>
            <option value="Pak Lap Jai">Pak Lap Jai</option>
            <option value="Pamegaran Reef">Pamegaran Reef</option>
            <option value="Papa Mashilinghi">Papa Mashilinghi</option>
            <option value="Paradise Reef">Paradise Reef</option>

            <option value="Pelong Rock">Pelong Rock</option>
            <option value="Perhentian Island, Terenganu State">Perhentian Island, Terenganu State</option>
            <option value="Peter Island - Great Harbour">Peter Island - Great Harbour</option>
            <option value="Phi Phi Ley Wall, Krabi">Phi Phi Ley Wall, Krabi</option>
            <option value="Pieces of Eight">Pieces of Eight</option>
            <option value="Piedra del Medio">Piedra del Medio</option>

            <option value="Pierbaai Reef, Monitoring Site 1">Pierbaai Reef, Monitoring Site 1</option>
            <option value="Pierbaai Reef, Monitoring Site 2">Pierbaai Reef, Monitoring Site 2</option>
            <option value="Pinnacles">Pinnacles</option>
            <option value="Pixie Pinnacle">Pixie Pinnacle</option>
            <option value="Playa Funch, Bonaire">Playa Funch, Bonaire</option>
            <option value="Polka Point, North Stradbroke Island, QLD">Polka Point, North Stradbroke Island, QLD</option>

            <option value="Porto de Mos Wall">Porto de Mos Wall</option>
            <option value="Proselyte Reef">Proselyte Reef</option>
            <option value="Puerto Morelos, Bonanza">Puerto Morelos, Bonanza</option>
            <option value="Puerto Morelos, Jardines">Puerto Morelos, Jardines</option>
            <option value="Puerto Morelos, La Ceiba">Puerto Morelos, La Ceiba</option>
            <option value="Puerto Morelos, Picudas">Puerto Morelos, Picudas</option>

            <option value="Pulau Hantu">Pulau Hantu</option>
            <option value="Pulau Lang, Aur/Dayang">Pulau Lang, Aur/Dayang</option>
            <option value="Pulau Ling, Redang">Pulau Ling, Redang</option>
            <option value="Pulau Payar - Sponge Reef">Pulau Payar - Sponge Reef</option>
            <option value="Pulau Semakau">Pulau Semakau</option>
            <option value="Rackmans Cay">Rackmans Cay</option>

            <option value="rainbow reef">rainbow reef</option>
            <option value="Range">Range</option>
            <option value="Rasdhoo atoll, central Maldives">Rasdhoo atoll, central Maldives</option>
            <option value="Red Slave Hut">Red Slave Hut</option>
            <option value="Red Slave, Bonaire">Red Slave, Bonaire</option>
            <option value="Reef edge ">Reef edge </option>

            <option value="Reef edge island Sign East to old AB marker">Reef edge island Sign East to old AB marker</option>
            <option value="Reef Wall NNE of Island Sign">Reef Wall NNE of Island Sign</option>
            <option value="Ribbon No. 10 Reef">Ribbon No. 10 Reef</option>
            <option value="Ribbon reef No. 3 Clam Gardens">Ribbon reef No. 3 Clam Gardens</option>
            <option value="Ribbon Reef No. 3; Clam Gardens">Ribbon Reef No. 3; Clam Gardens</option>
            <option value="Richelieu Rock">Richelieu Rock</option>

            <option value="Ridge 1, Wakatobi">Ridge 1, Wakatobi</option>
            <option value="Riggs Reef">Riggs Reef</option>
            <option value="Rinas Hole">Rinas Hole</option>
            <option value="Rose Garden">Rose Garden</option>
            <option value="Sab Mahmoud">Sab Mahmoud</option>
            <option value="Sabang Bay">Sabang Bay</option>

            <option value="scott's head drop">scott's head drop</option>
            <option value="Sea [Gardens]">Sea [Gardens]</option>
            <option value="Sea Fans">Sea Fans</option>
            <option value="Sea Haven">Sea Haven</option>
            <option value="Seihyou Kaigan, OGASAWARA">Seihyou Kaigan, OGASAWARA</option>
            <option value="Sentinel Rock">Sentinel Rock</option>

            <option value="Shabaha">Shabaha</option>
            <option value="Shag Rock">Shag Rock</option>
            <option value="Shark Island">Shark Island</option>
            <option value="Shark Island, Koh Tao">Shark Island, Koh Tao</option>
            <option value="Shark Point">Shark Point</option>
            <option value="Similans Island 9">Similans Island 9</option>

            <option value="Slaughter Bay">Slaughter Bay</option>
            <option value="Solomon A">Solomon A</option>
            <option value="Solomon B">Solomon B</option>
            <option value="Somosomo - Gau">Somosomo - Gau</option>
            <option value="South Water Caye South Beach">South Water Caye South Beach</option>
            <option value="Sponge Garden, Koh Rong Samloem">Sponge Garden, Koh Rong Samloem</option>

            <option value="Steve's Bommie">Steve's Bommie</option>
            <option value="Sumilon">Sumilon</option>
            <option value="Sunabe seawall">Sunabe seawall</option>
            <option value="Sunshine Reef">Sunshine Reef</option>
            <option value="SW mid reef flat">SW mid reef flat</option>
            <option value="TAGO Beach, Kushimoto Wakayama">TAGO Beach, Kushimoto Wakayama</option>

            <option value="TAGO, Nishiizu">TAGO, Nishiizu</option>
            <option value="Tai Tam Turtle Cove">Tai Tam Turtle Cove</option>
            <option value="Taiyong Wreck">Taiyong Wreck</option>
            <option value="Temple">Temple</option>
            <option value="Tenacatita Coral Reef">Tenacatita Coral Reef</option>
            <option value="Tern Cay">Tern Cay</option>

            <option value="Terumbu Kili, Redang">Terumbu Kili, Redang</option>
            <option value="test">test</option>
            <option value="thailand/ pattaya">thailand/ pattaya</option>
            <option value="The coral gardens">The coral gardens</option>
            <option value="The Dome">The Dome</option>
            <option value="The Float Ningaloo reef WA">The Float Ningaloo reef WA</option>

            <option value="The Wall">The Wall</option>
            <option value="Third Cut">Third Cut</option>
            <option value="Thulhagiri Island lagoon, Maldives">Thulhagiri Island lagoon, Maldives</option>
            <option value="Tiss">Tiss</option>
            <option value="Tobacco Caye Channel North">Tobacco Caye Channel North</option>
            <option value="Tobacco Caye Channel South">Tobacco Caye Channel South</option>

            <option value="Tobacco Caye-South">Tobacco Caye-South</option>
            <option value="TOKORIKI WALL">TOKORIKI WALL</option>
            <option value="Tonggusong, Simunul, Tawi-Tawi">Tonggusong, Simunul, Tawi-Tawi</option>
            <option value="Toucari Caves">Toucari Caves</option>
            <option value="Triumphant Arches, Hawaii">Triumphant Arches, Hawaii</option>
            <option value="Tubbataha Atolls">Tubbataha Atolls</option>

            <option value="Twin Sisters">Twin Sisters</option>
            <option value="Two Tonne">Two Tonne</option>
            <option value="ulua beach">ulua beach</option>
            <option value="Undine">Undine</option>
            <option value="Vietnam, Nha Trang">Vietnam, Nha Trang</option>
            <option value="Vietnam, Phu Quoc, north - Turtle Island">Vietnam, Phu Quoc, north - Turtle Island</option>

            <option value="Virador, Bahia Culedra, North Pacific">Virador, Bahia Culedra, North Pacific</option>
            <option value="Wakotobi. Ridge I">Wakotobi. Ridge I</option>
            <option value="Walung - Kosrae">Walung - Kosrae</option>
            <option value="Watamula">Watamula</option>
            <option value="Whale Shoals">Whale Shoals</option>
            <option value="Wheeler Reef">Wheeler Reef</option>

            <option value="White Rock, Koh Tao">White Rock, Koh Tao</option>
            <option value="Wistari reef">Wistari reef</option>
            <option value="Woongarra Marine Park: Barolin Rocks">Woongarra Marine Park: Barolin Rocks</option>
            <option value="Woongarra Marine Park: Hoffmans Rocks">Woongarra Marine Park: Hoffmans Rocks</option>
            <option value="Wreck Reef">Wreck Reef</option>
            <option value="Yakushima Island, Tank-shita">Yakushima Island, Tank-shita</option>

            <option value="Yakushima Island. haruta">Yakushima Island. haruta</option>
            <option value="Yakushima Island. shitoko">Yakushima Island. shitoko</option>
            <option value="Yellow Submarine House Reef">Yellow Submarine House Reef</option>

            </select>
        </td>
    </tr>
    <tr>
        <td class="headercell">
            <label for="latitude">Latitude:</label>
        </td>
        <td>
            <input type="text"
                    id="latitude"
                    name="latitude"
                    required="true"
                    constraints="{places:6}"
                    dojoType="dijit.form.NumberTextBox"
                    trim="true"
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
                    constraints="{places:6}"
                    dojoType="dijit.form.NumberTextBox"
                    trim="true"
                    invalidMessage="Enter a valid longitude value."
                   value="${(survey.longitude)!}"/>
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
                    dojoType="dijit.form.DateTextBox"
                    constraints="{datePattern: 'dd/MM/yyyy', min:'2000-01-01'}"
                    lang="en-au"
                    required="true"
                    promptMessage="dd/mm/yyyy"
                    invalidMessage="Invalid date. Use dd/mm/yyyy format."
                    <#if !newObject>
                        value="${(survey.date)!?date}"
                     <#else>
                         value="${(survey.date)!}"
                    </#if>
                    />
        </td>
    </tr>
    <tr>
        <td class="headercell">
            <label for="time">Time:</label></td>
        <td>
            <input id="time"
                   name="time"
                   type="text"
                   required="true"
                   dojoType="dijit.form.TimeTextBox"
                   <#if !newObject>
                        value="${(survey.time)!?time}"/>
                   </#if>
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