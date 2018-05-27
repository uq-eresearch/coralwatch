<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="org.coralwatch.dataaccess.KitRequestDao" %>
<%@ page import="org.coralwatch.model.KitRequest" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
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
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
</script>
<%
    List<String> errors = (List<String>) renderRequest.getAttribute("errors");
    KitRequestDao kitRequestDao = (KitRequestDao) renderRequest.getAttribute("kitrequestdao");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<h2>Chart Request</h2>
<%
    if (errors != null && errors.size() > 0) {
        for (String error : errors) {
%>
<div><span class="portlet-msg-error"><%=error%></span></div>
<%
        }
    }
%>
<div id="surveyDetailsContainer" dojoType="dijit.layout.TabContainer" style="width:670px; height:130ex;">
<%
    List<KitRequest> userKitRequests = kitRequestDao.getByRequester(currentUser);
    if (userKitRequests.size() > 0) {
%>
<div id="mykitrequest" dojoType="dijit.layout.ContentPane" title="My Chart Requests" style="width:670px; height:130ex">
    <ul>
        <%
            for (int i = 0; i < userKitRequests.size(); i++) {
        %>
        <li>
            <span style="font-weight: bold;">
                Request <%=(i + 1)%>
                by <%=userKitRequests.get(i).getRequester().getFullName()%>
	            on <%=dateFormat.format(userKitRequests.get(i).getRequestDate())%>
            </span>
            <table class="coralwatch_list_table" style="margin: 0.5em 0;">
                <tr>
                    <th style="width: 8em;">Requested</th>
                    <td><%=userKitRequests.get(i).getKitType() == null ? "" : userKitRequests.get(i).getKitType()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Language</th>
                    <td><%=userKitRequests.get(i).getLanguage() == null ? "" : userKitRequests.get(i).getLanguage()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Name</th>
                    <td><%=userKitRequests.get(i).getName() == null ? "" : userKitRequests.get(i).getName()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Address</th>
                    <td><%=userKitRequests.get(i).getAddressString() == null ? "" : userKitRequests.get(i).getAddressString().replaceAll("\\n", "<br />")%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Country</th>
                    <td><%=userKitRequests.get(i).getCountry() == null ? "" : userKitRequests.get(i).getCountry()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Phone</th>
                    <td><%=userKitRequests.get(i).getPhone() == null ? "" : userKitRequests.get(i).getPhone()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Email</th>
                    <td><%=userKitRequests.get(i).getEmail() == null ? "" : userKitRequests.get(i).getEmail()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Notes</th>
                    <td><%=userKitRequests.get(i).getNotes() == null ? "" : userKitRequests.get(i).getNotes()%></td>
                </tr>
                <tr>
                    <th style="width: 8em;">Dispatched</th>
                    <td><%=userKitRequests.get(i).getDispatchdate() == null ? "Not Yet" : dateFormat.format(userKitRequests.get(i).getDispatchdate())%></td>
                </tr>
            </table>
        </li>
        <%
            }
        %>
    </ul>
</div>
<%
    }
%>
<div id="newkitrequest" dojoType="dijit.layout.ContentPane" title="New Chart Request" style="width:670px; height:130ex">
    <%
        if (currentUser == null) {
    %>
    <div><span class="portlet-msg-error">You must sign in to submit a chart request.</span></div>
    <%
        }
    %>
    <form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm"
          jsId="kitReqForm" id="kitReqForm">
        <script type="dojo/method" event="onSubmit">
            <%if (currentUser != null) {%>
            var isLoggedIn = true;
            <%} else {%>
            var isLoggedIn = false;
            <%}%>
            if(!isLoggedIn) {
            alert('You must sign in before you can submit a chart request.');
            return false;
            }
            if(!this.validate()){
            alert('Form contains invalid data. Please correct errors first.');
            return false;
            }
            return true;
        </script>
        <table>
            <tr>
                <th style="vertical-align: top; padding: 0.5em; width: 115px;">
                    <label for="kitType">Requesting <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <select name="kitType" id="kitType"
                            style="width: 300px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="">
	                    <option selected="selected" value=""></option>
	                    <option value="Chart Only">Coral Health Chart only</option>
	                    <option value="Do It Yourself Kit">Complete Do it Yourself Kit (includes Coral Health Chart)</option>
	                </select>
                </td>
                <td rowspan="5">
		    <a href="javascript: (getCookie('datamodule') ? postToParent({action: 'routeTo', data: 'monitoring/'}) : window.location.href = window.location.origin + '/web/guest/monitoring-products');">
			<img alt="Chart request" src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/image/chart_request.jpeg")%>"/>
		    </a>
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="language">Language <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <select name="language" id="language"
                            style="width: 300px;"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="">
	                    <option selected="selected" value=""></option>
	                    <option value="English">English</option>
	                    <option value="Bahasa Indonesia">Bahasa Indonesia</option>
	                    <option value="Japanese">Japanese</option>
	                    <option value="Spanish">Spanish</option>
	                    <option value="Traditional Chinese (Taiwan)">Traditional Chinese (Taiwan)</option>
	                    <option value="Traditional Chinese (Hong Kong)">Traditional Chinese (Hong Kong)</option>
	                </select>
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="name">Full name <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="name"
                           id="name"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getFullName() == null ? "" :  currentUser.getFullName()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="addressLine1">Address Line 1 <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="addressLine1"
                           id="addressLine1"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getAddressLine1() == null ? "" :  currentUser.getAddressLine1()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="addressLine2">Address Line 2</label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="addressLine2"
                           id="addressLine2"
                           required="false"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getAddressLine2() == null ? "" :  currentUser.getAddressLine2()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="city">City / Town <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="city"
                           id="city"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getCity() == null ? "" :  currentUser.getCity()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="state">State / Province <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="state"
                           id="state"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getState() == null ? "" :  currentUser.getState()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="postcode">Postcode <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="postcode"
                           id="postcode"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getPostcode() == null ? "" :  currentUser.getPostcode()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="country">Country <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <select name="country" id="country"
                            required="true"
                            style="width: 300px;"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="<%=currentUser == null || currentUser.getCountry() == null ? "" : currentUser.getCountry()%>">
                    <option selected="selected" value=""></option>
                    <jsp:include page="/include/countrylist.jsp"/>
                </select>
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="phone">Phone</label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="phone"
                           id="phone"
                           required="false"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getPhone() == null ? "" :  currentUser.getPhone()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="email">Email <span style="color:#FF0000">*</span></label>
                </th>
                <td style="vertical-align: top;">
                    <input
                           type="text"
                           name="email"
                           id="email"
                           required="true"
                           style="width: 300px;"
                           dojoType="dijit.form.TextBox"
                           trim="true"
                           value="<%=currentUser == null || currentUser.getEmail() == null ? "" :  currentUser.getEmail()%>" />
                </td>
            </tr>
            <tr>
                <th style="vertical-align: top; padding: 0.5em;">
                    <label for="notes">Notes</label>
                </th>
                <td style="vertical-align: top;">
                    <textarea
                           name="notes"
                           id="notes"
                           style="width: 300px; height: 100px;"
                           dojoType="dijit.form.SimpleTextarea"
                           trim="true"
                           ></textarea>
                </td>
            </tr>
            <tr>
                <th></th>
                <td><span style="color:#FF0000">*</span> You can download the Do It Yourself Kit from <a href="#" onclick="getCookie('datamodule') ? postToParent({action: 'routeTo', data: 'monitoring/'}) : window.location.href = window.location.origin + '/web/guest/monitoring-products'">here</a> and request the chart only
                    to be mailed to you. If you cannot print the material, you should email <a href="mailto:info@coralwatch.org">info@coralwatch.org</a> to request it to be mailed to you.
                    If you would like to order multiple charts or other Coralwatch materials, you can download an order form
                    <a href="<%=renderRequest.getAttribute("orderFormUrl")%>">here</a>.
                </td>
            </tr>
            <tr>
                <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
            </tr>
        </table>
    </form>
</div>
<%
    if (currentUser != null && currentUser.isSuperUser()) {
        List<KitRequest> kitRequests = kitRequestDao.getAll();
        if (kitRequests.size() > 0) {
%>
<script type="text/javascript">
    function dispatch(id) {
        if (confirm("Are you sure you want to mark this request to dispatched?")) {
            dojo.xhrPost({
                url:"<%=renderResponse.encodeURL(renderRequest.getContextPath())%>" + "/dispatch?kitRequest=" + id + "&currentuser=" + "<%=currentUser.getId()%>",
                timeout: 5000,
                load: function(response, ioArgs) {
                    alert(response);
                    dojo.byId("button" + id).innerHTML = "Today";
                    dojo.byId("dispatcher" + id).innerHTML = "You";
                    return response;
                },
                error: function(response, ioArgs) {
                    alert("Dispatch failed: " + response);
                    return response;
                }
            });
        }
    }
</script>
<div id="allkitrequests" dojoType="dijit.layout.ContentPane" title="All Chart Requests" style="width:670px; height:130ex">
    <ul>
        <%
            for (int i = 0; i < kitRequests.size(); i++) {
        %>
        <li>
            <span style="font-weight: bold;">
                Request <%=(i + 1)%>
                by <%=kitRequests.get(i).getRequester().getFullName()%>
                on <%=dateFormat.format(kitRequests.get(i).getRequestDate())%>
            </span>
            <table class="coralwatch_list_table" style="margin: 0.5em 0;">
	            <tr>
	                <th style="width: 8em;">Requested</th>
	                <td><%=kitRequests.get(i).getKitType() == null ? "" : kitRequests.get(i).getKitType()%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Language</th>
	                <td><%=kitRequests.get(i).getLanguage() == null ? "" : kitRequests.get(i).getLanguage()%></td>
	            </tr>
	            <tr>
                    <th style="width: 8em;">Name</th>
                    <td><%=kitRequests.get(i).getName() == null ? "" : kitRequests.get(i).getName()%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Address</th>
	                <td><%=kitRequests.get(i).getAddressString() == null ? "" : kitRequests.get(i).getAddressString().replaceAll("\\n", "<br />")%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Country</th>
	                <td><%=kitRequests.get(i).getCountry() == null ? "" : kitRequests.get(i).getCountry()%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Phone</th>
	                <td><%=kitRequests.get(i).getPhone() == null ? "" : kitRequests.get(i).getPhone()%></td>
	            </tr>
	            <tr>
	                <th style="width: 8em;">Email</th>
	                <td><%=kitRequests.get(i).getEmail() == null ? "" : kitRequests.get(i).getEmail()%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Notes</th>
	                <td><%=kitRequests.get(i).getNotes() == null ? "" : kitRequests.get(i).getNotes()%></td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Dispatcher</th>
	                <td id="dispatcher<%=kitRequests.get(i).getId()%>">
	                    <%=kitRequests.get(i).getDispatcher() == null ? "" : kitRequests.get(i).getDispatcher().getDisplayName()%>
	                </td>
                </tr>
	            <tr>
	                <th style="width: 8em;">Dispatch</th>
	                <td id="button<%=kitRequests.get(i).getId()%>">
		                <%if (kitRequests.get(i).getDispatchdate() == null) { %>
		                <button
		                    name="dispatch"
		                    dojoType="dijit.form.Button"
		                    onClick="dispatch('<%=kitRequests.get(i).getId()%>'); return false;">
		                    Dispatch
		                </button>
		                <%} else {%>
		                <%=dateFormat.format(kitRequests.get(i).getDispatchdate())%>
		                <%}%>
	                </td>
	            </tr>
            </table>
        </li>
        <%
            }
        %>
    </ul>
</div>
<%
        }
    }
%>
</div>
