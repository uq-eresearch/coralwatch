<#include "macros/basic.html.ftl"/>

<h3>${userimpl.displayName!}</h3>
<table style="width:100%">
    <tr>
        <td class="headercell">Username:</td>
        <td style="width:60%">${userimpl.username!}</td>
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
        <td class="headercell">Member since:</td>
        <td>${(userimpl.registrationDate)!?date}</td>
    </tr>
    <tr>
        <td>
            <#if canUpdate>
                <button dojoType="dijit.form.Button"
                        onClick="window.location='${baseUrl}/users/${userimpl.id}?edit'">Edit
                </button>
            </#if>
        </td>
        <td align="right">
            <#if canDelete>
                <button dojoType="dijit.form.Button"
                        onClick="window.location='${baseUrl}/users/${userimpl.id}?delete'">Delete
                </button>
            </#if>
        </td>
    </tr>
</table>
<br/>
<br/>
<@createList "Surveys" conductedSurveys; item><a href="${baseUrl}/surveys/${item.id}">${item.id}</a> Conducted on
${(item.date)!?date}</@createList>