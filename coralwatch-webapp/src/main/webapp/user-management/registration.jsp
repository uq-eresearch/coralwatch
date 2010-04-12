<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<div class="coralwatch-portlet-header"><span>Sign Up</span></div>
<%
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    HashMap<String, String> params = (HashMap<String, String>) renderRequest.getPortletSession().getAttribute("params");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    if (currentUser == null) {
%>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">

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
            <td><label for="email">Email:</label></td>
            <td><input type="text" name="email" id="email"
                       value="<%=params.get("email") == null ? "" : params.get("email")%>"/></td>
        </tr>
        <tr>
            <td><label for="email2">Confirm Email:</label></td>
            <td><input type="text" name="email2" id="email2"
                       value="<%=params.get("email2") == null ? "" : params.get("email2")%>"/></td>
        </tr>
        <tr>
            <td><label for="password">Password:</label></td>
            <td><input type="password" name="password" id="password"/></td>
        </tr>
        <tr>
            <td><label for="password2">Retype Password:</label></td>
            <td><input type="password" name="password" id="password2"/></td>
        </tr>
        <tr>
            <td><label for="country">Country:</label></td>
            <td><select name="country" id="country">
                <option selected="selected"
                        value="<%=params.get("country") == null ? "" : params.get("country")%>"></option>
                <jsp:include page="/include/countrylist.jsp"/>
            </select>
            </td>
        </tr>
        <tr>
            <td><label for="displayName">Display Name:</label></td>
            <td><input type="text" name="displayName" id="displayName"
                       value="<%=params.get("displayName") == null ? "" : params.get("displayName")%>"/></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="Search" value="Sign Up"/></td>
        </tr>
    </table>
</form>
<%
} else {
%>
<div><span class="portlet-msg-error">You are already a member of CoralWatch.</span></div>
<%
    }
%>