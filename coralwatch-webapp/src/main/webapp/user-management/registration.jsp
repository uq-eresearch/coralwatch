<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <table>
        <tr>
            <td>Email:</td>
            <td><input type="text" name="email" id="email"/></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="password" id="password"/></td>
        </tr>
        <tr>
            <td>Retype Password:</td>
            <td><input type="password" name="password" id="password2"/></td>
        </tr>
        <tr>
            <td>Country:</td>
            <td><input type="text" name="country" id="country"/></td>
        </tr>
        <tr>
            <td>Display Name:</td>
            <td><input type="text" name="displayName" id="displayName"/></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="Search" value="Sign Up"/></td>
        </tr>
    </table>
</form>