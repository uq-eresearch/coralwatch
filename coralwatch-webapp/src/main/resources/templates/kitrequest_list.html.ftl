<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<#-- @ftlvariable name="kitrequestList" type="java.util.List<org.coralwatch.model.KitRequest>" -->
<h3>All Kit Requests</h3>
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <th height="25" nowrap="nowrap">#</th>
        <th nowrap="nowrap">Requester</th>
        <th nowrap="nowrap">Date</th>
        <th nowrap="nowrap">Comments</th>
    </tr>

    <#list kitrequestList as kitrequest>
        <tr>
            <td align="center"><a href="${baseUrl}/kit/${kitrequest.id}">${kitrequest.id}</a></td>
            <td><a href="${baseUrl}/users/${kitrequest.requester.id}">${(kitrequest.requester.displayName)}</a></td>
            <td>${(kitrequest.requestDate)!?datetime}</td>
            <td>${(kitrequest.comments)!}</td>
        </tr>
    </#list>
</table>