<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<#-- @ftlvariable name="kitrequestList" type="java.util.List<org.coralwatch.model.KitRequest>" -->
<h3>All Kit Requests</h3>
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <th height="25" nowrap="nowrap">#</th>
        <th nowrap="nowrap">Requester</th>
        <th nowrap="nowrap">Date</th>
        <th nowrap="nowrap">Dispatched</th>
    </tr>

    <#list kitrequestList as kitrequest>
        <tr>
            <td align="center"><a href="${baseUrl}/kit/${kitrequest.id?c}"><img class="icon" src="${baseUrl}/icons/fam/application_view_detail.png"/></a></td>
            <td><a href="${baseUrl}/users/${kitrequest.requester.id?c}">${(kitrequest.requester.displayName)}</a></td>
            <td>${(kitrequest.requestDate)!?datetime}</td>
            <td><#if kitrequest.dispatchdate??>
                ${(kitrequest.dispatchdate)?string("dd/MM/yyyy")!}
                </#if>
            </td>
        </tr>
    </#list>
</table>