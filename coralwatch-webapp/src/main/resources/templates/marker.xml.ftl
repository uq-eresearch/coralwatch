<#macro entry survey>
<event start="${survey.date?string("EEE, dd MMM yyyy HH:mm:ss Z")}" title="${survey.reef.name}">
    <reef>${survey.reef.name}</reef>
    <longitude>${survey.longitude?c}</longitude>
    <latitude>${survey.latitude?c}</latitude>
</event>
</#macro>
<?xml version="1.0" encoding="UTF-8"?>
<data>
    <#list surveys as survey>
    <@entry survey/>
    </#list>
</data>