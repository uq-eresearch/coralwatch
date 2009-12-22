<#macro entry survey>
<#--<#assign url = baseUrl + "/reportcard/${area.year?c}/" + type?lower_case + "/" + area.name?url + "?noframe=true"/>-->
<marker>
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