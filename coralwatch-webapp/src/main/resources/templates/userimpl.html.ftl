<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/users">Users</a>&ensp;&raquo;&ensp;${userimpl.displayName!}
</div>

<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<script type="text/javascript">
    function deleteUser(id) {
        if (confirm("Are you sure you want to delete this user?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/users/" + id,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/users';
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Deletion failed: " + response);
                    return response;
                }
            });
        }
    }

    $(function() {
        $("#ratings").children().not(":radio").hide();
        $("#ratings").stars({
            cancelShow: false,
            callback: function(ui, type, value)
            {
                $.post("${baseUrl}/trust", {trust: value, trusteeId: ${userimpl.id?c}}, function(data)
                {
                    window.location = '${baseUrl}/users/${userimpl.id?c}';
                });
            }
        });

        $("#ratings2").children().not(":radio").hide();

        $("#ratings2").stars({
            cancelShow: false,
            callback: function(ui, type, value)
            {
                $.post("${baseUrl}/trust", {trust: value, trusteeId: ${userimpl.id?c}}, function(data)
                {
                    window.location = '${baseUrl}/users/${userimpl.id?c}';
                });
            }
        });
    });
    $(function() {
        $("#starify").children().not(":input").hide();
        // Create stars from :radio boxes
        $("#starify").stars({
            cancelShow: false,
            disabled: true
        });
        $("#starify2").stars({
            cancelShow: false,
            disabled: true
        });
    });

</script>


<#include "macros/basic.html.ftl"/>
<table style="width:100%">

    <tr>
        <td><h3>${userimpl.displayName!}</h3></td>
        <td>
            <#if canUpdate>
            <button dojoType="dijit.form.Button" id="editButton"
                    onClick="window.location='${baseUrl}/users/${userimpl.id?c}?edit'">Edit
            </button>
            </#if>
            <#if canDelete>
            <button dojoType="dijit.form.Button" onClick="deleteUser(${userimpl.id?c})">Delete</button>
            </#if>
        </td>
    </tr>
    <tr>
        <td class="headercell"></td>
        <td style="width:60%"></td>
        <td rowspan="4" style="text-align:right">
            <img src="${userimpl.gravatarUrl!}"/>
            <#if userimpl == currentUser><#-- only the user themselves can change, not admins -->
            <br/>
            <a href="http://www.gravatar.com">Change Image</a>
            </#if>
        </td>
    </tr>
    <tr>
        <td class="headercell">Display Name:</td>
        <td>${userimpl.displayName!}</td>
    </tr>
    <tr>
        <td class="headercell">Email:</td>
        <td><a href="mailto:${userimpl.email!}">${userimpl.email!}</a></td>
    </tr>
    <tr>
        <td class="headercell">Member since (d/m/y):</td>
        <td>${(userimpl.registrationDate)!?string("dd/MM/yyyy")}</td>
    </tr>
    <tr>
        <td class="headercell">Occupation:</td>
        <td>${userimpl.occupation!}</td>
    </tr>
    <tr>
        <td class="headercell">Address:</td>
        <td>${userimpl.address!}</td>
    </tr>
    <tr>
        <td class="headercell">Country:</td>
        <td>${userimpl.country!}</td>
    </tr>
    <tr>
        <td class="headercell">Community Trust:</td>
        <#if (communityTrust == -1)>
        <td>
            <div class="multiField" id="starify2">
                <input type="radio" name="trust" value="1" type="radio">
                <input type="radio" name="trust" value="2" type="radio">
                <input type="radio" name="trust" value="3" type="radio">
                <input type="radio" name="trust" value="4" type="radio">
                <input type="radio" name="trust" value="5" type="radio">
            </div>
            <span>&ensp;(Not Recorded)</span>
        </td>
        <#else>
        <td>
            <div class="multiField" id="starify">
                <input type="radio" name="trust" value="1" type="radio"
                       <#if (communityTrust >= 0) && (communityTrust < 1.5)>checked="checked"</#if>>
                <input type="radio" name="trust" value="2" type="radio"
                       <#if (communityTrust >= 1.5) && (communityTrust < 2.5)>checked="checked"</#if>>
                <input type="radio" name="trust" value="3" type="radio"
                       <#if (communityTrust >= 2.5) && (communityTrust < 3.5)>checked="checked"</#if>>
                <input type="radio" name="trust" value="4" type="radio"
                       <#if (communityTrust >= 3.5) && (communityTrust < 4.5)>checked="checked"</#if>>
                <input type="radio" name="trust" value="5" type="radio"
                       <#if (communityTrust >= 4.5) && (communityTrust <= 5)>checked="checked"</#if>>
            </div>
            <span>&ensp;(${communityTrust?c})</span>
        </td>
        </#if>
    </tr>
    <tr>
        <td class="headercell">Your Trust</td>
        <#if (userTrust >= 0)>
        <td>
            <form id="ratings" method="post" action="${baseUrl}/trust">
                <input type="hidden" name="trusteeId" value="${userimpl.id?c}"/>
                <input type="radio" id="trust_1" name="trust" value="1" type="radio"
                       <#if (userTrust >= 0) && (userTrust < 1.5)>checked="checked"</#if>>
                <input type="radio" id="trust_2" name="trust" value="2" type="radio"
                       <#if (userTrust >= 1.5) && (userTrust < 2.5)>checked="checked"</#if>>
                <input type="radio" id="trust_3" name="trust" value="3" type="radio"
                       <#if (userTrust >= 2.5) && (userTrust < 3.5)>checked="checked"</#if>>
                <input type="radio" id="trust_4" name="trust" value="4" type="radio"
                       <#if (userTrust >= 3.5) && (userTrust < 4.5)>checked="checked"</#if>>
                <input type="radio" id="trust_5" name="trust" value="5" type="radio"
                       <#if (userTrust >= 4.5) && (userTrust <= 5)>checked="checked"</#if>>
                <input type="submit" value="Rate" name="submit"/>
            </form>
            <span>&ensp;(${userTrust?c})</span>
        </td>
        <#else>
        <td>
            <form id="ratings2" method="post" action="${baseUrl}/trust">
                <input type="hidden" name="trusteeId" value="${userimpl.id?c}"/>
                <input type="radio" name="trust" value="1" type="radio">
                <input type="radio" name="trust" value="2" type="radio">
                <input type="radio" name="trust" value="3" type="radio">
                <input type="radio" name="trust" value="4" type="radio">
                <input type="radio" name="trust" value="5" type="radio">
                <input type="submit" value="Rate" name="submit"/>
            </form>
            <span>&ensp;(Not Recorded)</span>
        </td>
        </#if>

    </tr>
</table>
<br/>
<br/>
<@createList "${conductedSurveys?size!} Surveys" conductedSurveys; item><a href="
            ${baseUrl}/surveys/${item.id?c}"><img
        src="${baseUrl}/icons/fam/application_view_detail.png"/></a> Conducted on
        ${(item.date)!?date}</@createList>