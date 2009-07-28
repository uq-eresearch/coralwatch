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
        <#if newObject>
        <tr>
            <td>
                <textarea dojoType="dijit.form.Textarea" style="width:600px">
                    Agreement text here

                </textarea>
            </td>
        </tr>
        <tr>
            <td>
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
        <tr>
            <td class="headercell">
                <label for="comments">Comments:</label>
            </td>
            <td>
                <input type="text"
                       id="comments"
                       name="comments"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"
                       value="${(kitrequest.comments)!}"/>
            </td>
        </tr>
        </#if>
    </table>

    <button dojoType="dijit.form.Button" type="submit" name="submit">${newObject?string("Submit Kit Request","Update")}</button>
<#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
<button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'">Cancel</button>
</div>