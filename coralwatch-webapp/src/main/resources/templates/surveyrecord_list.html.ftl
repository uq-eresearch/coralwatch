<#-- @ftlvariable name="surveyrecordList" type="java.util.List<org.coralwatch.model.SurveyRecord>" -->
<table width="100%" class="list_table" cellspacing="0" cellpadding="2">
    <tr>
        <td class="headercell">Coral Type</td>
        <td class="headercell">Lightest</td>
        <td class="headercell">Darkest</td>
    </tr>
    <#list surveyrecordList as surveyrecord>
        <tr>
            <td>${surveyrecord.coralType!}
            <td>
            <td>${surveyrecord.lightestLetter!}${surveyrecord.lightestNumber!}</td>
            <td>${surveyrecord.darkestLetter!}${surveyrecord.darkestNumber!}</td>
        </tr>
    </#list>
</table>