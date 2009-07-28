<br/>

<h3>Add Data</h3>

<div dojoType="dijit.form.Form" method="post" action="${baseUrl}/record">
    <textarea dojoType="dijit.form.Textarea" style="width:600px">
        Agreement text here

    </textarea>
    <input id="agree" dojotype="dijit.form.CheckBox"
           name="agree"
           type="checkbox"/>
    <label for="agree"> I agree to the terms and conditions.</label>
    <button dojoType="dijit.form.Button" type="submit" name="submit">Submit Kit Request</button>
</div>