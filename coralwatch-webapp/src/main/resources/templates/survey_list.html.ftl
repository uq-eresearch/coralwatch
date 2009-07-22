<h3>List of All Surveys</h3>
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <th height="25" nowrap="nowrap">#</th>
        <th nowrap="nowrap">Surveyor</th>
        <th nowrap="nowrap">Conducted</th>
        <th nowrap="nowrap">Location</th>
    </tr>

    <#list surveyList as survey>
        <tr>
            <td align="center"><a href="${baseUrl}/surveys/${survey.id}">${survey.id}</a></td>
            <td><a href="${baseUrl}/users/${survey.creator.id}">${(survey.creator.displayName)}</a></td>
            <td>${(survey.date)!?date}</td>
            <td>${(survey.country)!}</td>
        </tr>
    </#list>
</table>