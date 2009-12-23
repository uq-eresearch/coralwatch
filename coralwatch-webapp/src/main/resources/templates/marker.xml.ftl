<#macro entry survey>
<marker>
    <reef>${survey.reef.name}</reef>
    <longitude>${survey.longitude?c}</longitude>
    <latitude>${survey.latitude?c}</latitude>
</marker>
</#macro>
<?xml version="1.0" encoding="UTF-8"?>
<markers>
    <#list surveys as survey>
    <@entry survey/>
    </#list>
</markers>