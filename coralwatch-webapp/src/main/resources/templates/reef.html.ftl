<#-- @ftlvariable name="reef" type="org.coralwatch.model.Reef" -->
<script type="text/javascript">
    function deleteReef(reefId) {
        if (confirm("Are you sure you want to delete this reef?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/reef/" + reefId,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/reef';
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
<table>
    <tr>
        <td class="headercell">Reef Name:</td>
        <td>${(reef.name)!}</td>
    </tr>
    <tr>
        <td class="headercell">Country:</td>
        <td>${(reef.country)!}</td>
    </tr>
</table>
<#if canUpdate>
<button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/reef/${reef.id?c}?edit'">Edit</button>
</#if>
<#if canDelete>
<button dojoType="dijit.form.Button" onClick="deleteReef(${reef.id?c})">Delete</button>
</#if>
<br/>