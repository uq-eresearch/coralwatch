<%@ page import="org.coralwatch.dataaccess.KitRequestDao" %>
<%@ page import="org.coralwatch.model.KitRequest" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<%

    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    KitRequestDao kitRequestDao = (KitRequestDao) renderRequest.getPortletSession().getAttribute("kitrequestdao");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("kitrequestdao", PortletSession.APPLICATION_SCOPE);
%>
<h3>Kit Request</h3>

<%
    if (!errors.isEmpty()) {
        for (SubmissionError error : errors) {
%>
<div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
<%
        }
    }
    List<KitRequest> kitRequests = kitRequestDao.getAll();
    if (kitRequests.size() > 0) {
%>
<span>Previous Kit Requests</span>
<table>
    <tr>
        <td>#</td>
        <td>Requester</td>
        <td>Date</td>
        <td>Address</td>
        <td>Notes</td>
    </tr>
    <%
        for (int i = 0; i < kitRequests.size(); i++) {
    %>
    <tr>
        <td><%=(i + 1)%>
        </td>
        <td><%=kitRequests.get(i).getRequester().getDisplayName()%>
        </td>
        <td><%=kitRequests.get(i).getRequestDate()%>
        </td>
        <td><%=kitRequests.get(i).getAddress()%>
        </td>
        <td><%=kitRequests.get(i).getNotes()%>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
    }
%>
<br/>
<span>Submit Kit Requests</span>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <table>
        <tr>
            <td width="10%"><label for="address">Address</label></td>
            <td width="90%"><input class="stretched" type="text" name="address" id="address"/></td>
        </tr>
        <tr>
            <td><label for="notes">Notes</label></td>
            <td><input class="stretched" type="text" name="notes" id="notes"/></td>
        </tr>
        <tr>
            <td colspan="2"><textarea cols="80" rows="5" readonly="readonly" name="conditions" id="conditions">Terms and
                conditions here.</textarea></td>
        </tr>
        <tr>
            <td colspan="2"><input type="checkbox" name="agreement" id="agreement"/><label> I agree to the terms and
                conditions.</label></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
        </tr>
    </table>
</form>