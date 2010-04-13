<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.WindowState" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    UserDao userDao = (UserDao) renderRequest.getPortletSession().getAttribute("userDao");
    HashMap<String, String> params = (HashMap<String, String>) renderRequest.getPortletSession().getAttribute("params");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (currentUser == null) {
        cmd = Constants.ADD;
    }
%>
<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <%
        long userId = ParamUtil.getLong(request, "userId");
        String email = params.get("email");
        String displayName = params.get("displayName");
        String country = params.get("country");
        String address = params.get("address");
        if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
            if (cmd.equals(Constants.EDIT)) {
                UserImpl user = userDao.getById(userId);
                email = user.getEmail();
                displayName = user.getDisplayName();
    %>
    <div class="coralwatch-portlet-header"><span>Edit User Profile</span></div>
    <input name="userId" type="hidden" value="<%= userId %>"/>
    <%
    } else {
    %>
    <div class="coralwatch-portlet-header"><span>Sign Up</span></div>
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
            <td><input type="text" name="email" id="email" value="<%=email%>"/></td>
        </tr>
        <tr>
            <td><label for="email2">Confirm Email:</label></td>
            <td><input type="text" name="email2" id="email2" value=""/></td>
        </tr>
        <tr>
            <td><label for="password">Password:</label></td>
            <td><input type="password" name="password" id="password" value=""/></td>
        </tr>
        <tr>
            <td><label for="password2">Confirm Password:</label></td>
            <td><input type="password" name="password2" id="password2"/></td>
        </tr>
        <tr>
            <td><label for="displayName">Display Name:</label></td>
            <td><input type="text" name="displayName" id="displayName" value="<%=displayName%>"/></td>
        </tr>
        <%
            if (cmd.equals(Constants.EDIT)) {
        %>
        <tr>
            <td><label for="address">Address:</label></td>
            <td><input type="text" name="address" id="address" value="<%=address%>"/></td>
        </tr>
        <%
            }
        %>
        <tr>
            <td><label for="country">Country:</label></td>
            <td><select name="country" id="country">
                <option selected="selected" value="<%=country%>"></option>
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
<div class="coralwatch-portlet-header"><span>User Profile</span></div>
<table>
    <tr>
        <th>Display Name:</th>
        <td><%= user.getDisplayName()%>
        </td>
    </tr>
    <tr>
        <th>Email:</th>
        <td><a href="mailto:<%= user.getEmail()%>"><%= user.getEmail()%>
        </a></td>
    </tr>
    <tr>
        <th>Member since (d/m/y):</th>
        <td><%= user.getRegistrationDate()%>
        </td>
    </tr>
    <tr>
        <th>Occupation:</th>
        <td><%= user.getOccupation() == null ? "" : user.getOccupation()%>
        </td>
    </tr>
    <tr>
        <th>Address:</th>
        <td><%= user.getAddress() == null ? "" : user.getAddress()%>
        </td>
    </tr>
    <tr>
        <th>Aurveys:</th>
        <td></td>
    </tr>
    <%
        if (currentUser.equals(user)) {
    %>
    <tr>
        <td colspan="2"><input type="button" value="Edit"
                               onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="userId" value="<%= String.valueOf(user.getId()) %>" /></portlet:renderURL>';"/>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    }
%>