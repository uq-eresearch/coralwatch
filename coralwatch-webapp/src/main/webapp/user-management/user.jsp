<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.WindowState" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getAttribute("errors");
    UserDao userDao = (UserDao) renderRequest.getAttribute("userDao");
    HashMap<String, String> params = (HashMap<String, String>) renderRequest.getAttribute("params");
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (currentUser == null) {
        cmd = Constants.ADD;
    }
    long userId = ParamUtil.getLong(request, "userId");
    String email = params.get("email");
    String displayName = params.get("displayName");
    String occupation = params.get("occupation");
    String country = params.get("country");
    String address = params.get("address");
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
%>
<%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dojo/dojo.xd.js"></script>--%>
<script type="text/javascript">
    dojo.locale = "en";
    dojo.require("dojo.fx");
    dojo.require("dojo.parser");
    dojo.require("dojo._base.query");
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.ComboBox");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Textarea");
    dojo.require("dijit.form.ValidationTextBox");
    dojo.require("dijit.Tooltip");
</script>
<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct errors first');
        return false;
        }
        return true;
    </script>
    <%
        if (cmd.equals(Constants.EDIT)) {
            UserImpl user = userDao.getById(userId);
            email = user.getEmail();
            displayName = user.getDisplayName();
    %>
    <h2 style="margin-top:0;">Edit User Profile</h2>
    <br/>

    <p style="text-align:justify;">CoralWatch requires all users to provide real contact details to encourage
        authenticity of data. Your profile is protected from others.</p>
    <input name="userId" type="hidden" value="<%= userId %>"/>
    <%
    } else {
    %>
    <h2 style="margin-top:0;">Sign Up</h2>
    <br/>

    <p style="text-align:justify;">CoralWatch requires all users to provide real contact details to encourage
        authenticity of data. Your profile is protected from others.</p>
    <%
        }

        if (!errors.isEmpty()) {
            for (SubmissionError error : errors) {
    %>
    <div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
    <%
            }
        }
    %>
    <input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
    <table>
        <tr>
            <td><label for="email">Email:</label></td>
            <td><input type="text" name="email" id="email"
                       dojoType="dijit.form.ValidationTextBox"
                    <%if (cmd.equals(Constants.ADD)) {%>
                       required="true"
                    <%}%>
                       regExp="[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,6}"
                       trim="true"
                       invalidMessage="Enter a valid email address."
                       value="<%=email == null ? "" : email%>"/></td>
        </tr>
        <tr>
            <td><label for="email2">Confirm Email:</label></td>
            <td><input type="text" name="email2" id="email2"
                       dojoType="dijit.form.ValidationTextBox"
                    <%if (cmd.equals(Constants.ADD)) {%>
                       required="true"
                    <%}%>
                       validator="return this.getValue() == dijit.byId('email').getValue()"
                       trim="true"
                       invalidMessage="Re-enter your email address."
                       value=""/></td>
        </tr>
        <tr>
            <td><label for="password">Password:</label></td>
            <td><input type="password" name="password" id="password"
                    <%if (cmd.equals(Constants.ADD)) {%>
                       required="true"
                    <%}%>
                       dojoType="dijit.form.ValidationTextBox"
                       validator="var pwLen = this.getValue().length; return <%=cmd.equals(Constants.ADD) ? "(pwLen >= 6)" : "(pwLen == 0)"%>"
                       invalidMessage="Please enter a password with at least 6 characters"
                       value=""/></td>
        </tr>
        <tr>
            <td><label for="password2">Confirm Password:</label></td>
            <td><input type="password"
                       name="password2"
                       id="password2"
                    <%if (cmd.equals(Constants.ADD)) {%>
                       required="true"
                    <%}%>
                       dojoType="dijit.form.ValidationTextBox"
                       validator="return this.getValue() == dijit.byId('password').getValue()"
                       invalidMessage="Re-enter the same password again."/></td>
        </tr>
        <tr>
            <td><label for="displayName">Display Name:</label></td>
            <td><input type="text" name="displayName" id="displayName"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       invalidMessage="Please enter a display name."
                       value="<%=displayName == null ? "" : displayName%>"/></td>
        </tr>
        <%
            if (cmd.equals(Constants.EDIT)) {
        %>
        <tr>
            <td><label for="occupation">Occupation:</label></td>
            <td><input type="text" name="occupation" id="occupation"
                       dojoType="dijit.form.TextBox"
                       value="<%=occupation == null ? "" : occupation%>"/></td>
        </tr>
        <tr>
            <td><label for="address">Address:</label></td>
            <td><input type="text" name="address" id="address"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"
                       value="<%=address == null ? "" : address%>"/></td>
        </tr>
        <%
            }
        %>
        <tr>
            <td><label for="country">Country:</label></td>
            <td><select name="country" id="country"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        value="<%=country == null ? "" : country%>">
                <option selected="selected" value=""></option>
                <jsp:include page="/include/countrylist.jsp"/>
            </select>
            </td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="signup"
                                   value="<%=cmd.equals(Constants.ADD) ? "Sign Up" : "Save"%>"/>
                <%
                    if (cmd.equals(Constants.EDIT)) {
                %>
                <input type="button" value="Cancel"
                       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="userId" value="<%= String.valueOf(userId) %>" /></portlet:renderURL>';"/>
                <%
                    }
                %>
            </td>
        </tr>
    </table>
    <%
        if (renderRequest.getWindowState().equals(WindowState.MAXIMIZED)) {
    %>

    <script type="text/javascript">
        document.<portlet:namespace />fm.email.focus();
    </script>
    <%
        }
    %>
</form>
<% } else {
    UserImpl user;
    if (userId <= 0) {
        user = userDao.getById(currentUser.getId());
    } else {
        user = userDao.getById(userId);
    }

%>
<h2 style="margin-top:0;">User Profile</h2>
<table>
    <tr>
        <th>Display Name:</th>
        <td><%= user.getDisplayName()%>
        </td>
        <td rowspan="4" style="text-align:right">
            <img src="<%=user.getGravatarUrl()%>" alt="<%=user.getDisplayName()%>"/>
            <%
                if (user.equals(currentUser)) {
            %>
            <br/>
            <a href="http://www.gravatar.com">Change Image</a>
            <%
                }
            %>
        </td>
    </tr>
    <tr>
        <th>Email:</th>
        <td><a href="mailto:<%= user.getEmail()%>">Send Email</a></td>
    </tr>
    <tr>
        <th>Member since (d/m/y):</th>
        <td><%= dateFormat.format(user.getRegistrationDate())%>
        </td>
    </tr>
    <tr>
        <th>Role:</th>
        <td><%= user.isSuperUser() ? "Administrator" : "Member"%>
        </td>
    </tr>
    <tr>
        <th>Occupation:</th>
        <td><%= user.getOccupation() == null ? "Not Set" : user.getOccupation()%>
        </td>
    </tr>
    <tr>
        <th>Address:</th>
        <td><%= user.getAddress() == null ? "Not Set" : user.getAddress()%>
        </td>
    </tr>
    <tr>
        <th>Country:</th>
        <td><%= user.getCountry() == null ? "Not Set" : user.getCountry()%>
        </td>
    </tr>
    <tr>
        <th>Surveys:</th>
        <td>
            <a href="<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_userId=<%=String.valueOf(user.getId())%>"><%=userDao.getSurveyEntriesCreated(user).size()%>
                survey(s)</a></td>
    </tr>
    <%--<tr>--%>
    <%--<th>Photos:</th>--%>
    <%--<td>No Photos Yet</td>--%>
    <%--</tr>--%>
    <tr>
        <%
            if (currentUser.equals(user)) {
        %>
        <td colspan="2"><input type="button" value="Edit"
                               onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="userId" value="<%= String.valueOf(user.getId()) %>" /></portlet:renderURL>';"/>

            <%
                }
                if (currentUser.isSuperUser()) {
            %>
            <input type="button" value="Delete"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="userId" value="<%= String.valueOf(user.getId()) %>" /></portlet:renderURL>';"/>
            <%
                }
            %>
        </td>
    </tr>
</table>
<%
    }
%>