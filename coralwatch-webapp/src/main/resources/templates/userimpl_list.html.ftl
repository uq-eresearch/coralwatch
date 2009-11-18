<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;Users
</div>

<#-- @ftlvariable name="userimplList" type="java.util.List<org.coralwatch.model.UserImpl>" -->
<h3>List of All Users</h3>
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <th height="25" nowrap="nowrap"></th>
        <th nowrap="nowrap">Display Name</th>
        <th nowrap="nowrap">Email</th>
        <th nowrap="nowrap">Joined</th>
        <th nowrap="nowrap">Role</th>
    </tr>
    <#list userimplList as userimpl>
    <tr>
        <td align="center">
            <a href="${baseUrl}/users/${userimpl.id?c}">
                <img class="icon" src="${baseUrl}/icons/fam/user.png"/>
            </a>
        </td>
        <td><a href="${baseUrl}/users/${userimpl.id?c}">${userimpl.displayName}</a></td>
        <td>${userimpl.email}</td>
        <td>${(userimpl.registrationDate)!?date}</td>
        <td>
            <#if userimpl.superUser>
            Administrator
            <#else>
            Member
            </#if>
        </td>
    </tr>
    </#list>
</table>