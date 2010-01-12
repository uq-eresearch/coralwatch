<#assign newObject=!(reef??)/>
<#if newObject>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/reef">Reefs</a>&ensp;&raquo;&ensp;New Reef
</div>
<h3>Add New Reef</h3>
<#else>
<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/reef">Reefs</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/reef/${reef.id}">${reef.id}</a>&ensp;&raquo;&ensp;Edit
    Reef
</div>
<h3>Editing Reef</h3>
</#if>

<div dojoType="dijit.form.Form" method="post">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct first');
        return false;
        }
        return true;
    </script>
    <script type="text/javascript">
        dojo.addOnLoad(function() {
            dijit.byId("organisation").focus();
            updateLonFromDecimal();
            updateLatFromDecimal();
        });
    </script>
    <table>
        <tr>
            <td class="headercell">
                <label for="name">Reef Name:</label>
            </td>
            <td>
                <input type="text"
                       id="name"
                       name="name"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       regExp="...*"
                       invalidMessage="Enter reef name"
                       value="${(reef.name)!}"/>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <label for="country">Country:</label></td>
            <td>
                <select name="country"
                        id="country"
                        dojoType="dijit.form.ComboBox"
                        required="true"
                        hasDownArrow="true"
                        value="${(reef.country)!}">
                    <option selected="selected" value=""></option>
                    <#include "macros/countrylist.html.ftl"/>
                </select>
            </td>
        </tr>
    </table>
    <button dojoType="dijit.form.Button" type="submit" name="submit">${newObject?string("Add","Update")}</button>
    <#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
    <button dojoType="dijit.form.Button"
            onClick="window.location='${plainUrl}'">Cancel
    </button>
</div>