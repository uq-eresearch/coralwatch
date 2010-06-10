<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<portlet:defineObjects/>
<%
    List<String> errors = (List<String>) renderRequest.getAttribute("errors");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
%>
<script type="text/javascript">
    dojo.locale = "en";
    dojo.require("dojo.fx");
    dojo.require("dojo.parser");
    dojo.require("dojo._base.query");
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.ComboBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.ValidationTextBox");
    dojo.require("dijit.Tooltip");
</script>
<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct errors first.');
        return false;
        }
        return true;
    </script>

    <%
        if (currentUser == null) {
    %>
    <h2>Member's Sign In</h2>
    <%
        if (errors != null && errors.size() > 0) {
            for (String error : errors) {
    %>
    <div><span class="portlet-msg-error"><%=error%></span></div>
    <%
            }
        }
    %>
    <table>
        <tr>
            <td>Email:</td>
            <td><input type="text"
                       name="signinEmail"
                       id="signinEmail"
                       dojoType="dijit.form.ValidationTextBox"
                       required="true"
                       regExp="[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,6}"
                       trim="true"
                       invalidMessage="Enter a valid email address."/></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password"
                       name="signinPassword"
                       id="signinPassword"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       invalidMessage="Please enter a password"/></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="signin" value="Sign In"/></td>
        </tr>
    </table>
    <%
    } else {
    %>
    <h2>Current User</h2>
    <span>You are logged in as <a
            href="<%=renderRequest.getAttribute("userPageUrl")%>?p_p_id=userportlet_WAR_coralwatch"><%= currentUser.getDisplayName()%>
    </a> | <a
            href="<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DEACTIVATE %>" /></portlet:actionURL>">Logout</a></span>
    <%
        }
    %>
</form>
