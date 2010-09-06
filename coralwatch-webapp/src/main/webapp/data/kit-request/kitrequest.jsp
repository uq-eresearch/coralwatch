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
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
</script>
<%
    List<String> errors = (List<String>) renderRequest.getAttribute("errors");
    KitRequestDao kitRequestDao = (KitRequestDao) renderRequest.getAttribute("kitrequestdao");
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>
<h2>Kit Request</h2>
<%
    if (errors != null && errors.size() > 0) {
        for (String error : errors) {
%>
<div><span class="portlet-msg-error"><%=error%></span></div>
<%
        }
    }
%>
<div id="surveyDetailsContainer" dojoType="dijit.layout.TabContainer" style="width:670px;height:60ex">
<%
    List<KitRequest> userKitRequests = kitRequestDao.getByRequester(currentUser);
    if (userKitRequests.size() > 0) {
%>
<div id="mykitrequest" dojoType="dijit.layout.ContentPane" title="My Kit Requests" style="width:670px; height:60ex">
    <table class="coralwatch_list_table">
        <tr>
            <th>#</th>
            <th>Date</th>
            <th>Kit Type</th>
            <th>Language</th>
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
            <td><%=userKitRequests.get(i).getKitType() == null ? "" : userKitRequests.get(i).getKitType()%>
            </td>
            <td><%=userKitRequests.get(i).getLanguage() == null ? "" : userKitRequests.get(i).getLanguage()%>
            </td>
            <td><%=userKitRequests.get(i).getDispatchdate() == null ? "Not Yet" : dateFormat.format(userKitRequests.get(i).getDispatchdate())%>
            </td>
            <td><%=userKitRequests.get(i).getAddress() == null ? "" : userKitRequests.get(i).getAddress()%>
            </td>
            <td><%=userKitRequests.get(i).getCountry() == null ? "" : userKitRequests.get(i).getCountry()%>
            </td>
            <td><%=userKitRequests.get(i).getNotes() == null ? "" : userKitRequests.get(i).getNotes()%>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</div>
<%
    }
%>
<div id="newkitrequest" dojoType="dijit.layout.ContentPane" title="New Kit Request" style="width:670px; height:60ex">
    <%
        if (currentUser == null) {
    %>
    <div><span class="portlet-msg-error">You must sign in to submit a kit request.</span></div>
    <%
        }
    %>
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
            return true;
        </script>
        <table>
            <tr>
                <td><label for="kitType">Requesting <span style="color:#FF0000">*</span></label></td>
                <td><select name="kitType" id="kitType"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="">
                    <option selected="selected" value=""></option>
                    <option value="Chart Only">Chart Only</option>
                    <option value="Do It Yourself Kit">Do It Yourself Kit</option>
                </select>
                </td>
            </tr>
            <tr>
                <td><label for="language">Language:</label></td>
                <td><select name="language" id="language"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="">
                    <option selected="selected" value=""></option>
                    <option value="English">English</option>
                    <option value="Chinese">Chinese</option>
                    <option value="Japanese">Japanese</option>
                    <option value="Spanish">Spanish</option>
                </select>
                </td>
            </tr>
            <tr>
                <td width="10%"><label for="address">Postal Address</label></td>
                <td width="90%"><input type="text"
                                       name="address"
                                       id="address"
                                       required="true"
                                       style="width:300px"
                                       dojoType="dijit.form.ValidationTextBox"
                                       invalidMessage="Address is required."
                                       trim="true"
                                       value="<%=currentUser == null || currentUser.getAddress() == null? "" :  currentUser.getAddress()%>"/>
                </td>
            </tr>
            <tr>
                <td><label for="country">Country:</label></td>
                <td><select name="country" id="country"
                            required="true"
                            dojoType="dijit.form.ComboBox"
                            hasDownArrow="true"
                            value="<%=currentUser == null || currentUser.getCountry() == null ? "" : currentUser.getCountry()%>">
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
                           dojoType="dijit.form.SimpleTextarea"
                           trim="true"/>
                </td>
            </tr>
            <tr>
                <td></td>
                <td><span style="color:#FF0000">*</span> You can download the Do It Yourself Kit from <a
                        href="http://coralwatch.org/web/guest/download-materials1">here</a> and request only the chart
                    to be mailed to you.
                </td>
            </tr>
            <%--<tr>--%>
            <%--<td colspan="2"><textarea name="conditions"--%>
            <%--id="conditions"--%>
            <%--dojoType="dijit.form.SimpleTextarea"--%>
            <%--style="width: 100%;"--%>
            <%--readonly="readonly">--%>
            <%--<jsp:include page="terms_conditions.txt"/>--%>
            <%--</textarea>--%>
            <%--</td>--%>
            <%--</tr>--%>
            <%--<tr>--%>
            <%--<td colspan="2"><input type="checkbox" name="agreement" id="agreement" required="true"--%>
            <%--dojoType="dijit.form.CheckBox"/><label> I agree to the terms and--%>
            <%--conditions.</label></td>--%>
            <%--</tr>--%>
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
<div id="allkitrequests" dojoType="dijit.layout.ContentPane" title="All Kit Requests"
     style="width:670px; height:60ex">
    <table class="coralwatch_list_table">
        <tr>
            <th>#</th>
            <th>Requester</th>
            <th>Kit Type</th>
            <th>Language</th>
            <th>Address</th>
            <th>Country</th>
            <th>Notes</th>
            <th>Dispatcher</th>
            <th>Dispatch</th>
        </tr>
        <%
            for (int i = 0; i < kitRequests.size(); i++) {
        %>
        <tr>
            <td><%=(i + 1)%>
            </td>
            <td><%=kitRequests.get(i).getRequester().getDisplayName()%>
            </td>
            <td><%=kitRequests.get(i).getKitType() == null ? "" : kitRequests.get(i).getKitType()%>
            </td>
            <td><%=kitRequests.get(i).getLanguage() == null ? "" : kitRequests.get(i).getLanguage()%>
            </td>
            <td><%=kitRequests.get(i).getAddress() == null ? "" : kitRequests.get(i).getAddress()%>
            </td>
            <td><%=kitRequests.get(i).getCountry() == null ? "" : kitRequests.get(i).getCountry()%>
            </td>
            <td><%=kitRequests.get(i).getNotes() == null ? "" : kitRequests.get(i).getNotes()%>
            </td>
            <td id="dispatcher<%=kitRequests.get(i).getId()%>"><%=kitRequests.get(i).getDispatcher() == null ? "" : kitRequests.get(i).getDispatcher().getDisplayName()%>
            </td>
            <td id="button<%=kitRequests.get(i).getId()%>"><%if (kitRequests.get(i).getDispatchdate() == null) { %>
                <button dojoType="dijit.form.Button" name="dispatch"
                        onClick="dispatch('<%=kitRequests.get(i).getId()%>'); return false;">Dispatch
                </button>
                <%} else {%> <%=dateFormat.format(kitRequests.get(i).getDispatchdate())%><%}%>
            </td>
        </tr>
        <%
            }
        %>
    </table>
</div>
<%
        }
    }
%>
</div>