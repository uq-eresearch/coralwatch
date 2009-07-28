<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<ul>
    <li><a href="${baseUrl}/logout">Logout</a></li>
    <li><a href="${baseUrl}/users">All Users</a></li>
    <li><a href="${baseUrl}/surveys">All Surveys</a></li>
    <li><a href="${baseUrl}/users/${frameData.currentUser.id}">My Profile</a></li>
    <li><a href="${baseUrl}/surveys?new">New Survey</a></li>
    <#if frameData.currentUser.superUser>
    <li><a href="${baseUrl}/kit">All Kit Requests</a></li>
    </#if>
    <li><a href="${baseUrl}/kit?new">Request a kit</a></li>
</ul>