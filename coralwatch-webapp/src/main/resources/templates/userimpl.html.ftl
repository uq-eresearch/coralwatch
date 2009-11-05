<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<script type="text/javascript">
    function deleteUser(id) {
        if (confirm("Are you sure you want to delete this user?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/users/" + id,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/users';
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Deletion failed: " + response);
                    return response;
                }
            });
        }
    }
</script>


<#include "macros/basic.html.ftl"/>
<table style="width:100%">

    <tr>
        <td><h3>${userimpl.displayName!}</h3></td>
        <td>
            <#if canUpdate>
            <button dojoType="dijit.form.Button" id="editButton"
                    onClick="window.location='${baseUrl}/users/${userimpl.id?c}?edit'">Edit
            </button>
            </#if>
            <#if canDelete>
            <button dojoType="dijit.form.Button" onClick="deleteUser(${userimpl.id?c})">Delete</button>
            </#if>
        </td>
    </tr>
    <tr>
        <td class="headercell"></td>
        <td style="width:60%"></td>
        <td rowspan="4" style="text-align:right">
            <img src="${userimpl.gravatarUrl!}"/>
            <#if userimpl == currentUser><#-- only the user themselves can change, not admins -->
            <br/>
            <a href="http://www.gravatar.com">Change Image</a>
            </#if>
        </td>
    </tr>
    <tr>
        <td class="headercell">Display Name:</td>
        <td>${userimpl.displayName!}</td>
    </tr>
    <tr>
        <td class="headercell">Email:</td>
        <td><a href="mailto:${userimpl.email!}">${userimpl.email!}</a></td>
    </tr>
    <tr>
        <td class="headercell">Member since (d/m/y):</td>
        <td>${(userimpl.registrationDate)!?string("dd/MM/yyyy")}</td>
    </tr>
    <tr>
        <td class="headercell">Occupation:</td>
        <td>${userimpl.occupation!}</td>
    </tr>
    <tr>
        <td class="headercell">Address:</td>
        <td>${userimpl.address!}</td>
    </tr>
    <tr>
        <td class="headercell">Country:</td>
        <td>${userimpl.country!}</td>
    </tr>
    <tr>
        <td class="headercell">How much do you trust ${userimpl.displayName!}?</td>
        <td>
            <div dojoType="dijit.form.Form" method="post" action="${baseUrl}/trust">
                <input type="hidden" name="trusteeId" value="${userimpl.id?c}"/>
                <input dojoType="dijit.form.RadioButton" id="trust_0" name="trust" value="0" type="radio">
                <label for="trust_0"> 0 </label>
                <input dojoType="dijit.form.RadioButton" id="trust_1" name="trust" value="1" type="radio">
                <label for="trust_1"> 1 </label>
                <input dojoType="dijit.form.RadioButton" id="trust_2" name="trust" value="2" type="radio">
                <label for="trust_2"> 2 </label>
                <input dojoType="dijit.form.RadioButton" id="trust_3" name="trust" value="3" type="radio">
                <label for="trust_3"> 3 </label>
                <input dojoType="dijit.form.RadioButton" id="trust_4" name="trust" value="4" type="radio">
                <label for="trust_4"> 4 </label>
                <input dojoType="dijit.form.RadioButton" id="trust_5" name="trust" value="5" type="radio">
                <label for="trust_5"> 5 </label>
                <button dojoType="dijit.form.Button" type="submit" name="submit">Submit</button>
            </div>
        </td>
    </tr>
</table>
<br/>
<br/>
<@createList "${conductedSurveys?size!} Surveys" conductedSurveys; item><a href="${baseUrl}/surveys/${item.id?c}"><img
        src="${baseUrl}/icons/fam/application_view_detail.png"/></a> Conducted on
        ${(item.date)!?date}</@createList>