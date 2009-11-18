<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/reef">Reefs</a>&ensp;&raquo;&ensp;${reef.id}
</div>

<#-- @ftlvariable name="reef" type="org.coralwatch.model.Reef" -->
<#-- @ftlvariable name="surveys" type="java.util.List" -->
<script type="text/javascript">
    function deleteReef(reefId) {
        if (confirm("Are you sure you want to delete this reef?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/reef/" + reefId,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/reef';
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Deletion failed: " + response);
                    return response;
                }
            });
        }
    }
</script>
<div style="float:right; clear:both;"><a href="${baseUrl}/reef/${reef.id?c}?format=excel">Download Data</a></div>
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
<button dojoType="dijit.form.Button" onClick="deleteReef(${reef.id?c})">Delete</button>
</#if>
<#if (surveys?size > 1)>
<div><img src="${baseUrl}/reef/${reef.id?c}?format=png" width="${imageWidth?c}" height="${imageHeight?c}"/></div>
<div><img src="${baseUrl}/reef/${reef.id?c}?format=png&chart=coralCount" width="${imageWidth?c}"
          height="${imageHeight?c}"/></div>
<div><img src="${baseUrl}/reef/${reef.id?c}?format=png&chart=shapePie" width="${imageWidth?c}"
          height="${imageHeight?c}"/></div>
</#if>
<p/> <#-- TODO just a hack to get around weird CSS for headings -->
<h2>Surveys</h2>
<p/> <#-- TODO just a hack to get around weird CSS for headings -->
<#list surveys as survey>
<h3><a href="${baseUrl}/surveys/${survey.id?c}">${survey.creator.displayName}
    - ${(survey.date?date)!} ${(survey.time?time)!}</a></h3>
<p>Weather: ${(survey.weather)!}; comments: ${(survey.comments)!}</p>
</#list>
