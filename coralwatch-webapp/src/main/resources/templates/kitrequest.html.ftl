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
        <td>${(kitrequest.requester.address)!}</td>
    </tr>
    <tr>
        <td class="headercell">Dispatched on:</td>
        <td>${(kitrequest.dispatchdate)!?string}</td>
    </tr>
    <tr>
        <td class="headercell">Comments:</td>
        <td>${(kitrequest.comments)!}</td>
    </tr>
</table>