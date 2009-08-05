<div dojoType="dijit.form.Form" method="post" action="">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct first');
        return false;
        }
        return true;
    </script>
    <script type="text/javascript">
        dojo.addOnLoad(function() {
            dijit.byId("email").focus();
        });
    </script>
    <input type="hidden" name="redirectUrl" value="${redirectUrl!}"/>
    <table class="form centered">
        <tr>
            <td class="headercell">
                <label for="email">Email:</label>
            </td>
            <td>
                <input type="text"
                       id="email"
                       name="email"
                       dojoType="dijit.form.ValidationTextBox"
                       required="true"
                       regExp="[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,6}"
                       trim="true"
                       invalidMessage="Enter a valid email address."
                       value="${(userimpl.email)!}"/> <em>e.g. address@organisation.com</em>
            </td>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <label for="password">Password:</label>
            </td>
            <td>
                <input type="password" id="password" name="password" required="true"
                       dojoType="dijit.form.ValidationTextBox" regExp="....*" invalidMessage="Please enter a password"/>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <a href="${baseUrl}/forgotpassword">Forgot your password?</a>
            </td>
        </tr>
        <tr>
            <td class="headercell">
                <button dojoType="dijit.form.Button" type="submit" name="login" value="Login" id="loginButton">Login
                </button>
            </td>
            <td>
                <a href="${baseUrl}/users?new">or Sign Up Now</a>
            </td>
        </tr>
    </table>
</div>
