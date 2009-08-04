<#-- @ftlvariable name="reef" type="org.coralwatch.model.Reef" -->
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
<button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/reef/${reef.id?c}?edit'">Delete
</button>
</#if>
<br/>