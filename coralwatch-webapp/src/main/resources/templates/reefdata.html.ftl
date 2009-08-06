<#-- @ftlvariable name="reef" type="org.coralwatch.model.Reef" -->
<#-- @ftlvariable name="surveys" type="java.util.List" -->
<h1>Survey Data for Reef ${(reef.name)!} (${(reef.country)!})</h1>
<p/> <#-- TODO just a hack to get around weird CSS for headings -->
<#if (surveys?size > 1)>
<div><img src="${baseUrl}/reefdata/${reef.id?c}?format=png"/></div>
</#if>
<#list surveys as survey>
<h2><a href="${baseUrl}/surveys/${survey.id?c}">${survey.creator.displayName} - ${(survey.date?date)!} ${(survey.time?time)!}</a></h2>
<ul>
<p>Weather: ${(survey.weather)!}; comments: ${(survey.comments)!}</p>
<#list survey.dataset as record>
<li>${record.coralType}: ${record.lightestLetter}${record.lightestNumber} - ${record.darkestLetter}${record.darkestNumber}</li>
</#list>
</ul>
</#list>
<div><a href="${baseUrl}/reefdata/${reef.id?c}?format=excel">Download</a></div>
