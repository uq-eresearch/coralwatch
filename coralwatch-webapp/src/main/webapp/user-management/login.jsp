<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<portlet:defineObjects/>
<%
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
%>


<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <%
        if (currentUser == null) {
    %>
    <div class="coralwatch-portlet-header"><span>Member's Sign In</span></div>
    <%
        if (!errors.isEmpty()) {
            for (SubmissionError error : errors) {
    %>
    <div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
    <%
            }
        }
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
    <div class="coralwatch-portlet-header"><span>Current User</span></div>
    <span>You are logged in as <a href="#"
                                  onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.VIEW %>" /><portlet:param name="userId" value="<%= String.valueOf(currentUser.getId()) %>" /></portlet:actionURL>';"><%= currentUser.getDisplayName()%>
    </a> | <a href="#"
              onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DEACTIVATE %>" /></portlet:actionURL>';">Logout</a></span>
    <%
        }
    %>
</form>
