<#-- @ftlvariable name="survey" type="org.coralwatch.model.Survey" -->
<#-- @ftlvariable name="surveyRecs" type="java.util.List<org.coralwatch.model.SurveyRecord>" -->
<script type="text/javascript">
    function deleteSurvey(id) {
        if (confirm("Are you sure you want to delete this survey?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/surveys/" + id,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/surveys';
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Deletion failed: " + response);
                    return response;
                }
            });
        }
    }
    function deleteSurveyRecord(surveyRecordId, surveyId) {
        if (confirm("Are you sure you want to delete this record?")) {

            dojo.xhrDelete({
                url:"${baseUrl}/surveyrecord/" + surveyRecordId,
                timeout: 5000,
                load: function(response, ioArgs) {
                    window.location = '${baseUrl}/surveys/' + surveyId;
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
                $.post("${baseUrl}/surveyrating", {ratingValue: value, surveyId: ${survey.id?c}}, function(data)
                {
                    window.location = '${baseUrl}/surveys/${survey.id?c}';
                });
            }
        });
    });
    $(function() {
        $(".multiField").children().not(":input").hide();
        // Create stars from :radio boxes
        $(".multiField").stars({
            cancelShow: false,
            disabled: true
        });
    });
</script>

<#include "macros/basic.html.ftl"/>
<#macro lonLat value posSym negSym>
<#if (value < 0)>
<#assign absValue = -value/>
<#else>
<#assign absValue = value/>
</#if>
${value} (${absValue?floor}&deg;${((absValue - absValue?floor)*60)?floor}&apos;${((absValue*60 -(absValue*60)?floor)*60)?round}&quot; <#if (value < 0)>${negSym}<#else>${posSym}</#if>)
</#macro>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/surveys">Surveys</a>&ensp;&raquo;&ensp;${(survey.id)!}
</div>
<h3>Coral Bleaching Survey</h3>


<div id="tabs">
<ul>
    <li><a href="#fragment-1"><span>Details</span></a></li>
    <li><a href="#fragment-2"><span>Data</span></a></li>
    <li><a href="#fragment-3"><span>Graphs</span></a></li>
</ul>
<div id="fragment-1">
    <#if survey.creator.gravatarUrl??>
    <div style="float:right;">
        <a href="${baseUrl}/users/${survey.creator.id?c}"><img src="${survey.creator.gravatarUrl}"/></a><br/>

        <div class="multiField" id="starify">
            <input type="radio" name="trustValue" value="1" type="radio"
                   <#if (communityTrust >= 0) && (communityTrust < 1.5)>checked="checked"</#if>>
            <input type="radio" name="trustValue" value="2" type="radio"
                   <#if (communityTrust >= 1.5) && (communityTrust < 2.5)>checked="checked"</#if>>
            <input type="radio" name="trustValue" value="3" type="radio"
                   <#if (communityTrust >= 2.5) && (communityTrust < 3.5)>checked="checked"</#if>>
            <input type="radio" name="trustValue" value="4" type="radio"
                   <#if (communityTrust >= 3.5) && (communityTrust < 4.5)>checked="checked"</#if>>
            <input type="radio" name="trustValue" value="5" type="radio"
                   <#if (communityTrust >= 4.5) && (communityTrust <= 5)>checked="checked"</#if>>
        </div>
    </div>
    </#if>
    <table>
        <tr>
            <td class="headercell">Creator:</td>
            <td>${(survey.creator.displayName)!}</td>
        </tr>
        <tr>
            <td class="headercell">Group Name:</td>
            <td>${(survey.organisation)!}</td>
        </tr>
        <tr>
            <td class="headercell">Participating As:</td>
            <td>${(survey.organisationType)!}</td>
        </tr>
        <tr>
            <td class="headercell">Country:</td>
            <td>${(survey.reef.country)!}</td>
        </tr>

        <tr>
            <td class="headercell">Reef Name:</td>
            <td>${(survey.reef.name)!}</td>
        </tr>
        <tr>
            <td class="headercell">Latitude:</td>
            <td><@lonLat (survey.latitude) 'N' 'S'/></td>
        </tr>
        <tr>
            <td class="headercell">Longitude:</td>
            <td><@lonLat (survey.longitude) 'E' 'W'/></td>
        </tr>
        <tr>
            <td class="headercell">Date (d/m/y):</td>
            <td>${(survey.date?string("dd/MM/yyyy"))!}</td>
        </tr>
        <tr>
            <td class="headercell">Time:</td>
            <td>${(survey.time?time)!}</td>
        </tr>
        <tr>
            <td class="headercell">Light Condition:</td>
            <td>${(survey.weather)!}</td>
        </tr>
        <tr>
            <td class="headercell">Temperature (&deg;C):</td>
            <td>${(survey.temperature)!}</td>
        </tr>
        <tr>
            <td class="headercell">Activity:</td>
            <td>${(survey.activity)!}</td>
        </tr>
        <tr>
            <td class="headercell">Comments:</td>
            <td>${(survey.comments)!}</td>
        </tr>
        <tr>
            <td class="headercell">Community Rating:</td>
            <td>
                <div class="multiField" id="communityRating">
                    <input type="radio" name="ratingValue" value="1" type="radio"
                           <#if (communityRating >= 0) && (communityRating < 1.5)>checked="checked"</#if>>
                    <input type="radio" name="ratingValue" value="2" type="radio"
                           <#if (communityRating >= 1.5) && (communityRating < 2.5)>checked="checked"</#if>>
                    <input type="radio" name="ratingValue" value="3" type="radio"
                           <#if (communityRating >= 2.5) && (communityRating < 3.5)>checked="checked"</#if>>
                    <input type="radio" name="ratingValue" value="4" type="radio"
                           <#if (communityRating >= 3.5) && (communityRating < 4.5)>checked="checked"</#if>>
                    <input type="radio" name="ratingValue" value="5" type="radio"
                           <#if (communityRating >= 4.5) && (communityRating <= 5)>checked="checked"</#if>>
                </div>
                <#if (communityRating >= 0)><span>&ensp;(${communityRating?c})</span><#else><span>&ensp;(Not Recorded)</span>
            </td>
            </#if>
        </tr>
        <#if survey.creator != currentUser>
        <tr>
            <td class="headercell">Your Rating</td>
            <td>
                <form id="ratings" method="post">
                    <input type="hidden" name="surveyId" value="${survey.id?c}"/>
                    <input type="radio" id="rating_1" name="ratingValue" value="1" type="radio"
                           <#if (userRating >= 0) && (userRating < 1.5)>checked="checked"</#if>>
                    <input type="radio" id="rating_2" name="ratingValue" value="2" type="radio"
                           <#if (userRating >= 1.5) && (userRating < 2.5)>checked="checked"</#if>>
                    <input type="radio" id="rating_3" name="ratingValue" value="3" type="radio"
                           <#if (userRating >= 2.5) && (userRating < 3.5)>checked="checked"</#if>>
                    <input type="radio" id="rating_4" name="ratingValue" value="4" type="radio"
                           <#if (userRating >= 3.5) && (userRating < 4.5)>checked="checked"</#if>>
                    <input type="radio" id="rating_5" name="ratingValue" value="5" type="radio"
                           <#if (userRating >= 4.5) && (userRating <= 5)>checked="checked"</#if>>
                    <input type="submit" value="Rate" name="submit"/>
                </form>
                <#if (userRating >= 0)><span>&ensp;(${userRating?c})</span>
                <#else><span>&ensp;(Not Recorded)</span>
                </#if>
            </td>
        </tr>
        </#if>
    </table>
    <#if canUpdate>
    <button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/surveys/${survey.id?c}?edit'">Edit
    </button>
    </#if>
    <#if canDelete>
    <button dojoType="dijit.form.Button" onClick="deleteSurvey(${survey.id?c})">Delete</button>
    </#if>
</div>


<div id="fragment-2">
    <#if (surveyRecs?size > 0)>
    <table width="100%">
        <tr>
            <th class="headercell" nowrap="nowrap">Coral Type</th>
            <th class="headercell" nowrap="nowrap">Lightest</th>
            <th class="headercell" nowrap="nowrap">Darkest</th>
            <th class="headercell" nowrap="nowrap">Delete</th>
        </tr>
        <#list surveyRecs as item>
        <tr>
            <td>${item.coralType!}</td>
            <td>${item.lightestLetter!}${item.lightestNumber!}</td>
            <td>${item.darkestLetter!}${item.darkestNumber!}</td>
            <td>
                <#if canDelete>
                <button dojoType="dijit.form.Button" onClick="deleteSurveyRecord(${item.id?c}, ${survey.id?c})">Delete
                </button>
                </#if>
            </td>
        </tr>
        </#list>
    </table>
    <#else>
    <p>No Data Available</p>
    </#if>
    <#if canUpdate>
    <br/>

    <h3>Add Data</h3>

    <div dojoType="dijit.form.Form" method="post" action="${baseUrl}/surveyrecord">
        <input type="hidden" name="surveyId" value="${survey.id?c}"/>
        <table width="100%">
            <tr>
                <th class="headercell" nowrap="nowrap">Coral Type</th>
                <th class="headercell" nowrap="nowrap">Lightest</th>
                <th class="headercell" nowrap="nowrap">Darkest</th>
            </tr>
            <tr>
                <td nowrap="nowrap">
                    <input dojoType="dijit.form.RadioButton" id="coralType_0" name="coralType" value="Branching"
                           type="radio">
                    <label for="coralType_0"> Branching </label>
                    <input dojoType="dijit.form.RadioButton" id="coralType_1" name="coralType" value="Boulder"
                           type="radio">
                    <label for="coralType_1"> Boulder </label>
                    <input dojoType="dijit.form.RadioButton" id="coralType_2" name="coralType" value="Plate"
                           type="radio">
                    <label for="coralType_2"> Plate </label>
                    <input dojoType="dijit.form.RadioButton" id="coralType_3" name="coralType" value="Soft"
                           type="radio">
                    <label for="coralType_3"> Soft </label>
                </td>
                <td nowrap="nowrap">
                    <select name="lightestLetter"
                            id="lightestLetter"
                            style="width:60px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true">
                        <option selected="selected" value=""></option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                        <option value="D">D</option>
                        <option value="E">E</option>
                    </select>
                    <select name="lightestNumber"
                            id="lightestNumber"
                            style="width:60px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true">
                        <option selected="selected" value=""></option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                    </select>
                </td>
                <td nowrap="nowrap">
                    <select name="darkestLetter"
                            id="darkestLetter"
                            style="width:60px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true">
                        <option selected="selected" value=""></option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                        <option value="D">D</option>
                        <option value="E">E</option>
                    </select>
                    <select name="darkestNumber"
                            id="darkestNumber"
                            style="width:60px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true">
                        <option selected="selected" value=""></option>
                        <option value="1">1</option>
                        <option value="2">2</option>
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                    </select>
                </td>
            </tr>
        </table>

        <button dojoType="dijit.form.Button" type="submit" name="submit">Add</button>
    </div>
    </#if>
</div>


<div id="fragment-3">
    <div>
        <img src="${baseUrl}/surveys/${survey.id?c}?format=png&chart=coralCount" width="300" height="200"/>
        <img src="${baseUrl}/surveys/${survey.id?c}?format=png&chart=shapePie" width="300" height="200"/>
    </div>
</div>

</div>
