<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<#-- @ftlvariable name="reefList" type="java.util.List<org.coralwatch.model.Reef>" -->
<h3>List of All Surveys</h3>
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <th height="25" nowrap="nowrap">#</th>
        <th nowrap="nowrap">Name</th>
        <th nowrap="nowrap">Country</th>
    </tr>

    <#list reefList as reef>
        <tr>
            <td align="center"><a href="${baseUrl}/reef/${reef.id?c}">${reef.id}</a></td>
            <td>${(reef.name)!}</td>
            <td>${(reef.country)!}</td>
        </tr>
    </#list>
</table>