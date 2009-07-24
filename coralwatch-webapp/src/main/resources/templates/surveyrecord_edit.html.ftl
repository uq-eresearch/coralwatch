<#assign newObject=!(surveyrecord??)/>
<#if newObject>
    <h3>Add Record</h3>
    <#else>
        <h3>Editing Record</h3>
</#if>

<div dojoType="dijit.form.Form" method="post">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Correct your data to proceed.');
        return false;
        }
        return true;
    </script>
    <script type="text/javascript">
        dojo.addOnLoad(function() {
            dijit.byId("coralType_0").focus();
        });
    </script>
    <table>
        <tr>
            <td class="headercell">Coral Type</td>
            <td class="headercell">Lightest</td>
            <td class="headercell">Darkest</td>
        </tr>
        <tr>
            <td><input id="coralType_0" name="coralType" value="Branching" checked="checked" type="radio">
                <label for="coralType_0">BR</label>
                <input id="coralType_1" name="coralType" value="Brain" type="radio">
                <label for="coralType_1">BO</label>
                <input id="coralType_2" name="coralType" value="Plate" type="radio">
                <label for="coralType_2">PL</label>
                <input id="coralType_3" name="coralType" value="Soft" type="radio">
                <label for="coralType_3">SO</label>
            <td>
                <select name="lightestLetter"
                        id="lightestLetter"
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
            <td>
                <select name="darkestLetter"
                        id="darkestLetter"
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
    <button dojoType="dijit.form.Button" type="submit" name="submit">${newObject?string("Add","Update")}</button>
    <#assign plainUrl=currentUrl?substring(0,currentUrl?last_index_of("?")) />
    <button dojoType="dijit.form.Button" onClick="window.location='${plainUrl}'">Cancel</button>
</div>