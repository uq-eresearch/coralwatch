<#-- @ftlvariable name="kitrequest" type="org.coralwatch.model.KitRequest" -->
<h3>Kit Request Details</h3>
<table>
    <tr>
        <td class="headercell">Requester:</td>
        <td>${(kitrequest.requester.displayName)!}</td>
    </tr>
    <tr>
        <td class="headercell">Request Date:</td>
        <td>${(kitrequest.requestDate)!?datetime}</td>
    </tr>
    <tr>
        <td class="headercell">Address:</td>
        <td>${(kitrequest.address)!}</td>
    </tr>
    <tr>
        <td class="headercell">Dispatched on:</td>
        <#if kitrequest.dispatchdate??>
        <td>${(kitrequest.dispatchdate)?string("dd/MM/yyyy")!}</td>
        </#if>
    </tr>
    <tr>
        <td class="headercell">Comments:</td>
        <td>${(kitrequest.notes)!}</td>
    </tr>
</table>
<#if canUpdate>
    <button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/kit/${kitrequest.id?c}?edit'">Edit</button>
</#if>
<#if canDelete>
    <button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/kit/${kitrequest.id?c}?edit'">Delete
    </button>
</#if>
<br/>