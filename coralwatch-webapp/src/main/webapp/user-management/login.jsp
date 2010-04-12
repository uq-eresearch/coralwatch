<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<portlet:defineObjects/>
<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
%>

<%
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    if (!errors.isEmpty()) {
        for (SubmissionError error : errors) {
%>
<div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
<%
        }
    }
%>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <%
        if (currentUser == null) {
    %>
    <h2>Member's Sign In</h2>
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
    <span>You are logged in as <a href="#"><%= currentUser.getDisplayName()%>
    </a><br/><br/><a href="#">Dashboard</a> | <a href="#"
                                                 onClick="self.location = '<portlet:actionURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.DEACTIVATE %>" /></portlet:actionURL>';">Logout</a></span>
    <%
        }
    %>
</form>
