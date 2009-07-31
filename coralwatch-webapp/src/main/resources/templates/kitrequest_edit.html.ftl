<#-- @ftlvariable name="kitrequest" type="org.coralwatch.model.KitRequest" -->
<#assign newObject=!(kitrequest??)/>
<#if newObject>
<h3>Request a new CoralWatch kit</h3>
<#else>
<h3>Editing Kit Request</h3>
</#if>

<div dojoType="dijit.form.Form" method="post">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct first');
        return false;
        }
        return true;
    </script>
    <table>
        <tr>
            <td class="headercell">
                <label for="address">Address:</label>
            </td>
            <td>
                <input type="text"
                       id="address"
                       name="address"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       required="true"
                        <#if newObject>
                       value="${(frameData.currentUser.address)!}"
                        <#else>
                       value="${(kitrequest.address)!}"
                        </#if>
                       trim="true"/>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <label for="notes">Notes:</label>
            </td>
            <td>
                <input type="text"
                       id="notes"
                       name="notes"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"
                       value="${(kitrequest.notes)!}"/>
            </td>
        </tr>
        <#if newObject>
        <tr>
            <td colspan="2">
                <textarea dojoType="dijit.form.Textarea" style="width:600px">Agreement text here</textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <input id="agree" dojotype="dijit.form.CheckBox"
                       name="agree"
                       required="true"
                       type="checkbox"/>
                <label for="agree"> I agree to the terms and conditions.</label>
            </td>
        </tr>
        <#else>
        <tr>
            <td class="headercell">
                <label for="dispatchdate">Set Dispatch Date:</label>
            </td>
            <td>
                <input type="text"
                       id="dispatchdate"
                       name="dispatchdate"
                       required="true"
                       isDate="true"
                        <#if kitrequest.dispatchdate??>
                       value="${(kitrequest.dispatchdate)?string("yyyy-MM-dd")!}"
                        </#if>
                       dojoType="dijit.form.DateTextBox"
                       constraints="{datePattern: 'dd/MM/yyyy', min:'2000-01-01'}"
                       lang="en-au"
                       required="true"
                       promptMessage="dd/mm/yyyy"
                       invalidMessage="Invalid date. Use dd/mm/yyyy format."/>
            </td>
        </tr>
        </#if>
    </table>

    <button dojoType="dijit.form.Button" type="submit"
            name="submit">${newObject?string("Submit Kit Request","Update")}</button>
    <#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
    <button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'">Cancel</button>
</div>