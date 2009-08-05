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
<h3>Coral Bleaching Survey</h3>

<#if survey.creator.gravatarUrl??>
<div style="float:right;">
    <img src="${survey.creator.gravatarUrl}"/>
</div>
</#if>
<table>
    <tr>
        <td class="headercell">Creator:</td>
        <td>${(survey.creator.displayName)!}</td>
    </tr>
    <tr>
        <td class="headercell">Organisation:</td>
        <td>${(survey.organisation)!}</td>
    </tr>
    <tr>
        <td class="headercell">Organisation Type:</td>
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
        <td class="headercell">Date:</td>
        <td>${(survey.date)!?date}</td>
    </tr>
    <tr>
        <td class="headercell">Time:</td>
        <td>${(survey.time)!?time}</td>
    </tr>
    <tr>
        <td class="headercell">Weather:</td>
        <td>${(survey.weather)!}</td>
    </tr>
    <tr>
        <td class="headercell">Temperature:</td>
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
</table>
<#if canUpdate>
<button dojoType="dijit.form.Button" onClick="window.location='${baseUrl}/surveys/${survey.id?c}?edit'">Edit</button>
</#if>
<#if canDelete>
<button dojoType="dijit.form.Button" onClick="deleteSurvey(${survey.id?c})">Delete</button>
</#if>
<br/>

<br/>
<h3>Survey Data</h3>
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
            <button dojoType="dijit.form.Button" onClick="deleteSurveyRecord(${item.id?c}, ${survey.id?c})">Delete</button>
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
                       checked="checked" type="radio">
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
                    <option selected="selected" value="B">B</option>
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
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option selected="selected" value="6">6</option>
                </select>
            </td>
            <td nowrap="nowrap">
                <select name="darkestLetter"
                        id="darkestLetter"
                        style="width:60px;"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true">
                    <option selected="selected" value="B">B</option>
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
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option selected="selected" value="6">6</option>
                </select>
            </td>
        </tr>
    </table>

    <button dojoType="dijit.form.Button" type="submit" name="submit">Add</button>
</div>
</#if>
