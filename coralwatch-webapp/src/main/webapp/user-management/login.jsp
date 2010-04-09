<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<portlet:defineObjects/>
<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
%>
<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <%
        if (currentUser == null) {
    %>
    <table>
        <tr>
            <td>Email:</td>
            <td><input type="text" name="email"/></td>
        </tr>
        <tr>
            <td>Password:</td>
            <td><input type="password" name="password"/></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="signin" value="Sign In"/></td>
        </tr>
    </table>
    <%
    } else {
    %>
    <span>You are logged in as <%= currentUser.getDisplayName()%></span></span>
    <%
        }
    %>
</form>
