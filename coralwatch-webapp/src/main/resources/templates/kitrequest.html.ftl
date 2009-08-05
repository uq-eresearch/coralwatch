<#-- @ftlvariable name="kitrequest" type="org.coralwatch.model.KitRequest" -->
<script type="text/javascript">
    function deleteKitRequest(id) {
        if (confirm("Are you sure you want to delete this kit request?")) {
            dojo.xhrDelete({
                url:"${baseUrl}/kit/" + id,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/kit';
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
    <button dojoType="dijit.form.Button" onClick="deleteKitRequest(${kitrequest.id?c})">Delete</button>
</#if>
<br/>