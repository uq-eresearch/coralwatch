<#macro createRator ratingValue formId trusteeId postUrl finalUrl>
<script type="text/javascript">
    $(function() {
        $("#${formId}").children().not(":radio").hide();
        $("#${formId}").stars({
            cancelShow: false,
            callback: function(ui, type, value)
            {
                $.post("${postUrl}", {trustValue: value, trusteeId: ${trusteeId?c}}, function(data)
                {
                    window.location = '${finalUrl}';
                });
            }
        });
    });
</script>

<form id="${formId}" method="post">
    <input type="radio" name="trustValue" value="1" type="radio"
           <#if (ratingValue >= 0) && (ratingValue < 1.5)>checked="checked"</#if>>
    <input type="radio" name="trustValue" value="2" type="radio"
           <#if (ratingValue >= 1.5) && (ratingValue < 2.5)>checked="checked"</#if>>
    <input type="radio" name="trustValue" value="3" type="radio"
           <#if (ratingValue >= 2.5) && (ratingValue < 3.5)>checked="checked"</#if>>
    <input type="radio" name="trustValue" value="4" type="radio"
           <#if (ratingValue >= 3.5) && (ratingValue < 4.5)>checked="checked"</#if>>
    <input type="radio" name="trustValue" value="5" type="radio"
           <#if (ratingValue >= 4.5) && (ratingValue <= 5)>checked="checked"</#if>>
    <input type="submit" value="Rate" name="submit"/>
</form>
<#if (ratingValue >= 0)><span>&ensp;(${ratingValue?c})</span>
<#else><span>&ensp;(Not Recorded)</span>
</#if>
</#macro>


<#macro createReadOnlyRator ratingValue divId showValue>
<script type="text/javascript">
    $(function() {
        $("#${divId}").children().not(":input").hide();
        // Create stars from :radio boxes
        $("#${divId}").stars({
            cancelShow: false,
            disabled: true
        });
    });
</script>
<div class="rator" id="${divId}">
    <input type="radio" name="ratingValue" value="1" type="radio"
           <#if (ratingValue >= 0) && (ratingValue < 1.5)>checked="checked"</#if>>
    <input type="radio" name="ratingValue" value="2" type="radio"
           <#if (ratingValue >= 1.5) && (ratingValue < 2.5)>checked="checked"</#if>>
    <input type="radio" name="ratingValue" value="3" type="radio"
           <#if (ratingValue >= 2.5) && (ratingValue < 3.5)>checked="checked"</#if>>
    <input type="radio" name="ratingValue" value="4" type="radio"
           <#if (ratingValue >= 3.5) && (ratingValue < 4.5)>checked="checked"</#if>>
    <input type="radio" name="ratingValue" value="5" type="radio"
           <#if (ratingValue >= 4.5) && (ratingValue <= 5)>checked="checked"</#if>>
</div>
<#if showValue>
<#if (ratingValue >= 0)><span>&ensp;(${ratingValue?c})</span><#else><span>&ensp;(Not Recorded)</span></#if>
</#if>
        </#macro>