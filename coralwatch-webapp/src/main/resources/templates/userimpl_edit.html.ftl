<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<#assign newObject=!(userimpl??)/>
<#if newObject>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;Sign Up
</div>
<h3>Sign Up</h3>
<#else>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/users">Users</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/users/${userimpl.id!}">${userimpl.displayName!}</a>&ensp;&raquo;&ensp;Edit User
</div>
<h3>Editing User ${userimpl.displayName}</h3>
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
            dijit.byId("signupEmail").focus();
        });
    </script>
    <table>
        <tr>
            <td class="headercell">
                <label for="signupEmail">Email:</label>
            </td>
            <td>
                <input type="text"
                       id="signupEmail"
                       name="signupEmail"
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
                <label for="signupEmail2">Confirm Email:</label>
            </td>
            <td>
                <input type="text"
                       id="signupEmail2"
                       name="signupEmail2"
                       dojoType="dijit.form.ValidationTextBox"
                       required="true"
                       validator="return this.getValue() == dijit.byId('signupEmail').getValue()"
                       trim="true"
                       invalidMessage="Re-enter your email address."
                       value="${(userimpl.email)!}"/>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <label for="signupDisplayName">Display Name:</label>
            </td>
            <td>
                <input type="text"
                       id="signupDisplayName"
                       name="signupDisplayName"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       regExp=".......*"
                       invalidMessage="Please enter a display name with at least 6 characters"
                       value="${(userimpl.displayName)!}"/> <em>e.g. John Smith</em>
            </td>
        </tr>
        <#if !newObject && currentUser.superUser>
        <tr>
            <td class="headercell">
                <label for="role">Role:</label>
            </td>
            <td>
                <select name="role"
                        id="role"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        <#if userimpl.superUser>
                        value="Administrator"
                        <#else>
                        value="Member"
                        </#if>
                        hasDownArrow="true">
                    <option value="Member">Member</option>
                    <option value="Administrator">Administrator</option>
                </select>
            </td>
        </tr>
        </#if>
        <tr>
            <td class="headercell">
                <label for="signupOccupation">Occupation:</label>
            </td>
            <td>
                <input type="text"
                       id="signupOccupation"
                       name="signupOccupation"
                       dojoType="dijit.form.TextBox"
                       trim="true"
                       value="${(userimpl.occupation)!}"/>
            </td>
        </tr>

        <tr>
            <td class="headercell">
                <label for="signupAddress">Address:</label>
            </td>
            <td>
                <input type="text"
                       id="signupAddress"
                       name="signupAddress"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"
                       value="${(userimpl.address)!}"/>
            </td>
        </tr>

        <tr>
            <td class="headercell">
                <label for="signupCountry">Country:</label></td>
            <td>
                <select name="signupCountry"
                        id="signupCountry"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        value="${(userimpl.country)!}">
                    <option selected="selected" value=""></option>
                    <#include "macros/countrylist.html.ftl"/>
                </select>
            </td>
        </tr>

        <tr>
            <td class="headercell">
                <label for="signupPassword">New Password${newObject?string('',' (optional)')}:</label>
            </td>
            <td>
                <input type="password"
                       id="signupPassword"
                       name="signupPassword2"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       validator="var pwLen = this.getValue().length; return ${newObject?string('','(pwLen == 0) || ')}(pwLen >= 6)"
                       invalidMessage="Please enter a password with at least 6 characters"/>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <label for="signupPassword2">Confirm Password:</label>
            </td>
            <td>
                <input type="password"
                       id="signupPassword2"
                       name="signupPassword2"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       validator="return this.getValue() == dijit.byId('signupPassword').getValue()"
                       invalidMessage="Please enter the same password twice"/>
            </td>
        </tr>
    </table>
    <button dojoType="dijit.form.Button" type="submit" name="submit"
            id="submitButton">${newObject?string("Create","Update")}</button>
    <#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
    <button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'" id="cancelButton">Cancel</button>
</div>