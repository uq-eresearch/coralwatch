<%@ page import="org.coralwatch.dataaccess.KitRequestDao" %>
<%@ page import="org.coralwatch.model.KitRequest" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.portlets.error.SubmissionError" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<script type="text/javascript">
    dojo.locale = "en";
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.SimpleTextarea");
    dojo.require("dijit.form.CheckBox");
    dojo.require("dijit.form.ComboBox");
</script>
<%
    List<SubmissionError> errors = (List<SubmissionError>) renderRequest.getPortletSession().getAttribute("errors");
    KitRequestDao kitRequestDao = (KitRequestDao) renderRequest.getPortletSession().getAttribute("kitrequestdao");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<h2>Kit Request</h2>
<%
    if (!errors.isEmpty()) {
        for (SubmissionError error : errors) {
%>
<div><span class="portlet-msg-error"><%=error.getErrorMessage()%></span></div>
<%
        }
    }
    List<KitRequest> userKitRequests = kitRequestDao.getByRequester(currentUser);
    if (userKitRequests.size() > 0) {
%>
<h3>My Kit Requests</h3>
<table>
    <tr>
        <th>#</th>
        <th>Date</th>
        <th>Dispatched Date</th>
        <th>Address</th>
        <th>Country</th>
        <th>Notes</th>
    </tr>
    <%
        for (int i = 0; i < userKitRequests.size(); i++) {
    %>
    <tr>
        <td><%=(i + 1)%>
        </td>
        <td><%=dateFormat.format(userKitRequests.get(i).getRequestDate())%>
        </td>
        <td><%=userKitRequests.get(i).getDispatchdate() == null ? "Not Yet" : dateFormat.format(userKitRequests.get(i).getDispatchdate())%>
        </td>
        <td><%=userKitRequests.get(i).getAddress() == null ? "" : userKitRequests.get(i).getAddress()%>
        </td>
        <td><%=userKitRequests.get(i).getCountry() == null ? "" : userKitRequests.get(i).getCountry()%></td>
        <td><%=userKitRequests.get(i).getNotes() == null ? "" : userKitRequests.get(i).getNotes()%>
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
<h3>New Kit Requests</h3>
<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm"
      jsId="kitReqForm" id="kitReqForm">
    <script type="dojo/method" event="onSubmit">
        <%
            if (currentUser != null) {
        %>
        var isLoggedIn = true;
        <%
        } else {
        %>
        var isLoggedIn = false;
        <%
            }
        %>
        if(!isLoggedIn) {
        alert('You must sign in before you can submit a kit request.');
        return false;
        }
        if(!this.validate()){
        alert('Form contains invalid data. Please correct errors first.');
        return false;
        }
        var isValid = dojo.query('INPUT[name=agreement]', 'kitReqForm').filter(function(n) { return n.checked }).length
        > 0;
        if (!isValid) {
        alert('You must agree to the terms and conditions.');
        return false;
        }
        return true;
    </script>
    <table>
        <tr>
            <td width="10%"><label for="address">Address</label></td>
            <td width="90%"><input type="text"
                                   name="address"
                                   id="address"
                                   required="true"
                                   style="width:300px"
                                   dojoType="dijit.form.ValidationTextBox"
                                   invalidMessage="Address is required."
                                   trim="true"
                                   value="<%=currentUser.getAddress() == null? "" :  currentUser.getAddress()%>"/>
            </td>
        </tr>
        <tr>
            <td><label for="country">Country:</label></td>
            <td><select name="country" id="country"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        value="<%=currentUser.getCountry() == null ? "" : currentUser.getCountry()%>">
                <option selected="selected" value=""></option>
                <jsp:include page="/include/countrylist.jsp"/>
            </select>
            </td>
        </tr>
        <tr>
            <td><label for="notes">Notes</label></td>
            <td><input type="text"
                       name="notes"
                       id="notes"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"/>
            </td>
        </tr>
        <tr>
            <td colspan="2"><textarea name="conditions"
                                      id="conditions"
                                      dojoType="dijit.form.SimpleTextarea"
                                      style="width: 100%;"
                                      readonly="readonly">
                <jsp:include page="terms_conditions.txt"/>
            </textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2"><input type="checkbox" name="agreement" id="agreement" required="true"
                                   dojoType="dijit.form.CheckBox"/><label> I agree to the terms and
                conditions.</label></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
        </tr>
    </table>
</form>