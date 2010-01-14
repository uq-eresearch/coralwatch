<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<#include "userimpl-header.html.ftl"/>
<#include "macros/basic.html.ftl"/>
<#include "macros/rating.html.ftl"/>

<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/users">Users</a>&ensp;&raquo;&ensp;${userimpl.displayName!}
</div>


<div id="tabs">
    <ul>
        <li><a href="#fragment-1"><span>Details</span></a></li>
        <li><a href="#fragment-2"><span>Surveys</span></a></li>
    </ul>
    <div id="fragment-1">

        <table class="entity-table" style="width:100%">
            <tr>
                <th width="180">Display Name:</th>
                <td>${userimpl.displayName!}</td>
                <td nowrap="nowrap" style="text-align:right">
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
                <th>Email:</th>
                <td><a href="mailto:${userimpl.email!}">${userimpl.email!}</a></td>
                <td rowspan="4" style="text-align:right">
                    <img src="${userimpl.gravatarUrl!}" alt="${userimpl.displayName!}"/>
                <#if userimpl == currentUser><#-- only the user themselves can change, not admins -->
                    <br/>
                    <a href="http://www.gravatar.com">Change Image</a>
                </#if>
                </td>
            </tr>
            <tr>
                <th>Member since (d/m/y):</th>
                <td colspan="2">${(userimpl.registrationDate)!?string("dd/MM/yyyy")}</td>
            </tr>
            <tr>
                <th>Occupation:</th>
                <td colspan="2">${userimpl.occupation!}</td>
            </tr>
            <tr>
                <th>Address:</th>
                <td colspan="2">${userimpl.address!}</td>
            </tr>
            <tr>
                <th>Country:</th>
                <td colspan="2">${userimpl.country!}</td>
            </tr>
            <tr>
                <th>Surveys:</th>
                <td colspan="2"><#if (conductedSurveys?size < 1)>No surveys yet<#elseif (conductedSurveys?size = 1)>1
                    survey<#else>${conductedSurveys?size!} surveys</#if></td>
            </tr>
            <tr>
                <th>Photos:</th>
                <td colspan="2">No photos yet</td>
            </tr>
            <tr>
                <th>Videos:</th>
                <td colspan="2">No videos yet</td>
            </tr>
            <tr>
                <th>Community Trust:</th>
                <td colspan="2">
                <@createReadOnlyRator communityTrust "communityTrust" true/>
                    <a href="#" id="show-trust-cloud">Trust Cloud</a>&nbsp;<a href="#" id="show-trust-network">Trust
                    Network</a>
                </td>
            <#--</#if>-->
            </tr>
        <#if userimpl != currentUser>
            <tr>
                <th>Your Trust:</th>
                <td colspan="2">
                <@createRator userTrust "ratings" userimpl.id "${baseUrl}/usertrust" "${baseUrl}/users/${userimpl.id?c}"/>
                </td>
            </tr>
        </#if>
            <tr>
                <td colspan="3">
                    <div id="cloud-container">
                        <ul id="xpower" class="xmpl">
                        <#list allUsers as user>
                            <#if user = currentUser>
                                <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                        class="tagLink" style="color:#00ff00;"
                                        href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                                </li>
                                <#elseif user = userimpl>
                                    <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                            class="tagLink" style="color:#ff0000;"
                                            href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                                    </li>
                                <#else>
                                    <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                            class="tagLink" style="color:#0066cc"
                                            href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                                    </li>
                            </#if>
                        </#list>
                        </ul>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    <div id="jit-container">
                        <div id="infovis"></div>
                    </div>
                </td>
            </tr>

        </table>
    </div>
    <div id="fragment-2">
    <#if currentUser == userimpl>
        <a href="${baseUrl}/surveys?new">New Survey</a><br/>
    </#if>
    <@createList "${conductedSurveys?size!} Surveys" conductedSurveys; item><a href="
            ${baseUrl}/surveys/${item.id?c}"><img src="${baseUrl}/icons/fam/survey.png"/></a> Conducted
        on ${(item.date)!?date}
    </@createList>
    </div>
</div>
