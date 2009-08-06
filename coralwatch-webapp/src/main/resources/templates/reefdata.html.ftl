<#-- @ftlvariable name="reef" type="org.coralwatch.model.Reef" -->
<#-- @ftlvariable name="surveys" type="java.util.List" -->
<h1>Survey Data for Reef ${(reef.name)!} (${(reef.country)!})</h1>
<p/> <#-- TODO just a hack to get around weird CSS for headings -->
<#list surveys as survey>
<h2><a href="${baseUrl}/surveys/${survey.id?c}">${survey.creator.displayName} - ${(survey.date?date)!} ${(survey.time?time)!}</a></h2>
<ul>
<p>Weather: ${(survey.weather)!}; comments: ${(survey.comments)!}</p>
<#list survey.dataset as record>
<li>${record.coralType}: ${record.darkestLetter}${record.darkestNumber} - ${record.lightestLetter}${record.lightestNumber}</li>
</#list>
</ul>
</#list>
