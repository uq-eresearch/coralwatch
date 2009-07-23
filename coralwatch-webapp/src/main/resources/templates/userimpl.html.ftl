<#include "macros/basic.html.ftl"/>

<h3>${userimpl.displayName!}</h3>
<table>
    <tr>
        <td rowspan="4"><img src="${userimpl.gravatarUrl!}"/></td>
        <td class="headercell">Username:</td>
        <td>${userimpl.username!}</td>
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