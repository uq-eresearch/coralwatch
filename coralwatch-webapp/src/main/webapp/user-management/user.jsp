<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.app.CoralwatchApplication" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.services.ReputationService" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.WindowState" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Random" %>

<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    List<String> errors = (List<String>) renderRequest.getAttribute("errors");
    UserDao userDao = (UserDao) renderRequest.getAttribute("userDao");
//    UserRatingDao userRatingDao = (UserRatingDao) renderRequest.getAttribute("userRatingDao");
    DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    String cmd = ParamUtil.getString(request, Constants.CMD);
//    if (currentUser == null) {
//        cmd = Constants.ADD;
//    }
    long userId = ParamUtil.getLong(request, "userId");
    String email = "";
    String displayName = "";
    String firstName = "";
    String lastName = "";
    String phone = "";
//    String occupation = "";
    String positionDescription = "";
    String country = "";
    if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
%>
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
    dojo.require("dojox.form.Rating");

</script>

<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
<script type="dojo/method" event="onSubmit">
    if (!this.validate()) {
        alert('Form contains invalid data. Please correct errors first');
        return false;
    }
    return true;
</script>
<%
    UserImpl user = null;    
    if (cmd.equals(Constants.EDIT)) {
        user = userDao.getById(userId);
        email = user.getEmail();
        displayName = user.getDisplayName();
        firstName = user.getFirstName();
        lastName = user.getLastName();
        phone = user.getPhone();
//            occupation = user.getOccupation();
        positionDescription = user.getPositionDescription();
        country = user.getCountry();
%>
<h2 style="margin-top:0;">Edit User Profile</h2>
<br/>

<p style="text-align:justify;">CoralWatch requires all members to provide real contact details to encourage
    authenticity of data. Your profile is protected from others. Your first and last names, email address, address and
    phone number are hidden from other members.</p>
<input name="userId" type="hidden" value="<%=userId%>"/>
<%
    } else {
%>
<h2 style="margin-top:0;">Sign Up</h2>
<br/>

<p style="text-align:justify;">CoralWatch requires all members to provide real contact details to encourage
    authenticity of data. Your profile is protected from others. Your first and last names, email address, address and
    phone number are hidden from other members.</p>
<%
    }

    if (errors != null && errors.size() > 0) {
        for (String error : errors) {
%>
<div><span class="portlet-msg-error"><%=error%></span></div>
<%
    }
    }
%>
<input name="<%=Constants.CMD%>" type="hidden" value="<%=HtmlUtil.escape(cmd)%>"/>
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
                   value="<%=email == null ? "" : email%>"/> e.g. name@company.com
        </td>
    </tr>
    <tr>
        <td><label for="email2">Confirm Email:</label></td>
        <td><input type="text" name="email2" id="email2"
                   dojoType="dijit.form.ValidationTextBox"
                <%if (cmd.equals(Constants.ADD)) {%>
                   required="true"
                   validator="return this.getValue() == dijit.byId('email').getValue()"
                <%} else {%>
                   validator="return (dijit.byId('email').getValue() == '<%=email == null ? "" : email%>') || (this.getValue() == dijit.byId('email').getValue())"
                <%}%>
                   trim="true"
                   invalidMessage="Re-enter your email address."
                   value=""/></td>
    </tr>
    <tr>
        <td><label for="password">Password <%
            if (cmd.equals(Constants.EDIT)) {
        %>(optional)<%
            }
        %>:</label></td>
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
        <td><label for="password2">Confirm Password <%
            if (cmd.equals(Constants.EDIT)) {
        %>(optional)<%
            }
        %>:</label>
        </td>
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
        <td><label for="firstName">First Name:</label></td>
        <td><input type="text" name="firstName" id="firstName"
                   required="true"
                   dojoType="dijit.form.ValidationTextBox"
                   invalidMessage="Please enter your first name."
                   value="<%=firstName == null ? "" : firstName%>"/></td>
    </tr>
    <tr>
        <td><label for="lastName">Last Name:</label></td>
        <td><input type="text" name="lastName" id="lastName"
                   required="true"
                   dojoType="dijit.form.ValidationTextBox"
                   invalidMessage="Please enter your last name."
                   value="<%=lastName == null ? "" : lastName%>"/></td>
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
        <td><label for="positionDescription">Position Description:</label></td>
        <td><select name="positionDescription" id="positionDescription"
                    required="true"
                    dojoType="dijit.form.ComboBox"
                    hasDownArrow="true"
                    value="<%=positionDescription == null ? "" : positionDescription%>">
            <option selected="selected" value=""></option>
            <option value="Senior Researcher">Senior Researcher</option>
            <option value="Early Career  Researcher">Early Career Researcher</option>
            <option value="Post Doc">Post Doc</option>
            <option value="PhD Student">PhD Student</option>
            <option value="Undergrad Student">Undergrad Student</option>
            <option value="Secondary School Student">Secondary School Student</option>
            <option value="Primary School Student">Primary School Student</option>
            <option value="General Volunteer">General Volunteer</option>
            <option value="Industry Volunteer">Industry Volunteer</option>
            <option value="Tourist Volunteer">Tourist Volunteer</option>
            <option value="Dive Centre">Dive Centre</option>
            <option value="Teacher">Teacher</option>
            <option value="Other">Other</option>
        </select>
        </td>
    </tr>
    <tr>
        <td><label for="phone">Phone:</label></td>
        <td><input type="text" name="phone" id="phone"
                   dojoType="dijit.form.ValidationTextBox"
                   regExp="[+ 0-9]*"
                   invalidMessage="Please enter a valid phone number."
                   value="<%=phone == null ? "" : phone%>"/> e.g + 11 2 1111 1111
        </td>
    </tr>
    <tr>
        <td>
            <label for="addressLine1">Address Line 1</label>
        </td>
        <td>
            <input type="text"
                   name="addressLine1"
                   id="addressLine1"
                   required="false"
                   style="width: 300px;"
                   dojoType="dijit.form.TextBox"
                   trim="true"
                   value="<%=user == null || user.getAddressLine1() == null ? "" :  user.getAddressLine1()%>" />
        </td>
    </tr>
    <tr>
        <td>
            <label for="addressLine2">Address Line 2</label>
        </td>
        <td>
            <input type="text"
                   name="addressLine2"
                   id="addressLine2"
                   required="false"
                   style="width: 300px;"
                   dojoType="dijit.form.TextBox"
                   trim="true"
                   value="<%=user == null || user.getAddressLine2() == null ? "" :  user.getAddressLine2()%>" />
        </td>
    </tr>
    <tr>
        <td>
            <label for="city">City / Town</label>
        </td>
        <td>
            <input type="text"
                   name="city"
                   id="city"
                   required="false"
                   style="width: 300px;"
                   dojoType="dijit.form.TextBox"
                   trim="true"
                   value="<%=user == null || user.getCity() == null ? "" :  user.getCity()%>" />
        </td>
    </tr>
    <tr>
        <td>
            <label for="state">State / Province</label>
        </td>
        <td>
            <input type="text"
                   name="state"
                   id="state"
                   required="false"
                   style="width: 300px;"
                   dojoType="dijit.form.TextBox"
                   trim="true"
                   value="<%=user == null || user.getState() == null ? "" :  user.getState()%>" />
        </td>
    </tr>
    <tr>
        <td>
            <label for="postcode">Postcode</label>
        </td>
        <td>
            <input type="text"
                   name="postcode"
                   id="postcode"
                   required="false"
                   style="width: 300px;"
                   dojoType="dijit.form.TextBox"
                   trim="true"
                   value="<%=user == null || user.getPostcode() == null ? "" :  user.getPostcode()%>" />
        </td>
    </tr>
    <%
        }
    %>
    <tr>
        <td><label for="country">Country of Residence:</label></td>
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
        <td colspan="2"><input type="submit" name="signup" value="<%=cmd.equals(Constants.ADD) ? "Sign Up" : "Save"%>"/>
            <%
                if (cmd.equals(Constants.EDIT)) {
            %>
            <input type="button" value="Cancel"
                   onClick="self.location = '<portlet:renderURL><portlet:param name="<%=Constants.CMD%>" value="<%=Constants.VIEW%>" /><portlet:param name="userId" value="<%=String.valueOf(userId)%>" /></portlet:renderURL>';"/>
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
<%
    } else if (cmd.equals(Constants.RESET)) {
    String resetid = ParamUtil.getString(request, "resetid");
    if (resetid != null) {
        if (!resetid.equals(userDao.getById(userId).getPasswordResetId())) {
%>
<div><span class="portlet-msg-error">Your password reset link has expired. Request a new password reset link by clicking on Forgot Password link.</span>
</div>
<%
    } else {
%>
<script type="text/javascript">
    dojo.locale = "en";
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.ValidationTextBox");
</script>
<h2 style="margin-top:0;">Reset Password</h2>

<p style="text-align:justify;">Enter a new password twice to reset your lost password.</p>
<%
    if (errors != null && errors.size() > 0) {
        for (String error : errors) {
%>
<div><span class="portlet-msg-error"><%=error%></span></div>
<%
    }
    }
%>
<form dojoType="dijit.form.Form" action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <script type="dojo/method" event="onSubmit">
        if(!this.validate()){
        alert('Form contains invalid data. Please correct errors first');
        return false;
        }
        return true;
    </script>
    <input name="<%=Constants.CMD%>" type="hidden" value="<%=HtmlUtil.escape(cmd)%>"/>
    <input name="userId" type="hidden" value="<%=userId%>"/>
    <input name="resetid" type="hidden" value="<%=resetid%>"/>
    <table>
        <tr>
            <td><label for="resetpassword">New Password:</label></td>
            <td><input type="password" name="resetpassword" id="resetpassword"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       validator="var pwLen = this.getValue().length; return (pwLen >= 6)"
                       invalidMessage="Please enter a password with at least 6 characters"
                       value=""/></td>
        </tr>
        <tr>
            <td><label for="resetpassword2">Confirm Password:</label>
            </td>
            <td><input type="password"
                       name="resetpassword2"
                       id="resetpassword2"
                       required="true"
                       dojoType="dijit.form.ValidationTextBox"
                       validator="return this.getValue() == dijit.byId('resetpassword').getValue()"
                       invalidMessage="Re-enter the same password again."/></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="submit" value="Reset Password"/>
            </td>
        </tr>
    </table>
</form>

<%
    }
} else {
%>
<div><span class="portlet-msg-error">Invalid request.</span></div>
<%
    }
} else if (cmd.equals(Constants.VIEW)) {
    UserImpl user;
    if (userId <= 0) {
        user = userDao.getById(currentUser.getId());
    } else {
        user = userDao.getById(userId);
    }
%>
<script type="text/javascript">
    dojo.require("dojox.form.Rating");
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
    dojo.require("dijit.Tooltip");
    dojo.require("dijit.form.Button");
    <%if (currentUser != null && !currentUser.equals(user)) {%>
    dojo.addOnLoad(function() {
        var widget = dijit.byId("connectRating");
        dojo.connect(widget, "onClick", function() {
            dojo.xhrPost({
                url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/rating?cmd=rateuser&raterId=<%=currentUser.getId()%>&ratedId=<%=user.getId()%>&value=' + widget.value,
                timeout: 5000,
                load: function(response, ioArgs) {
                    //alert("Response: " + response)
                    return response;
                },
                error: function(response, ioArgs) {
                    alert('Cannot add rating: ' + response);
                    return response;
                }
            });
        });
    });
    <%}%>
</script>

<h2 style="margin-top:0;">User Profile</h2>

<div id="userProfileContainer" dojoType="dijit.layout.TabContainer" style="width:650px;height:60ex">
    <div id="userDetailsTab" dojoType="dijit.layout.ContentPane" title="Details" style="width:650px; height:60ex">
        <table>
            <tr>
                <th>Display Name:</th>
                <td><%=user.getDisplayName()%>
                </td>
                <td rowspan="4" style="text-align:right">
                    <img src="<%=user.getGravatarUrl()%>" alt="<%=user.getDisplayName()%>"/>
                    <%
                        if (user.equals(currentUser)) {
                    %>
                    <br/>
                    <a href="http://www.gravatar.com" target="_blank">Change Image</a>
                    <%
                        }
                    %>
                </td>
            </tr>
            <%
                if (currentUser != null && (user.equals(currentUser) || currentUser.isSuperUser())) {
            %>
            <tr>
                <th>Full Name:</th>
                <td><%=(user.getFirstName() == null || user.getLastName() == null) ? "Not Set" : user.getFirstName() + " " + user.getLastName()%>
                </td>
            </tr>
            <tr>
                <th>Email:</th>
                <td><a href="mailto:<%=user.getEmail()%>"><%=user.getEmail()%>
                </a></td>
            </tr>
            <%
                }
            %>
            <tr>
                <th>Member since (d/m/y):</th>
                <td><%=dateFormat.format(user.getRegistrationDate())%>
                </td>
            </tr>
            <tr>
                <th>Position Description:</th>
                <td><%=user.getPositionDescription() == null ? "Not Set" : user.getPositionDescription()%>
                </td>
            </tr>
            <%
                if (currentUser != null && (user.equals(currentUser) || currentUser.isSuperUser())) {
            %>
            <tr>
                <th>Phone:</th>
                <td><%=user.getPhone() == null ? "Not Set" : user.getPhone()%>
                </td>
            </tr>
            <tr>
                <th>Address:</th>
                <td><%=user.getAddressString() == null ? "Not Set" : user.getAddressString().replaceAll("\\n", "<br />")%>
                </td>
            </tr>
            <%
                }
            %>
            <tr>
                <th>Country:</th>
                <td><%= user.getCountry() == null ? "Not Set" : user.getCountry()%>
                </td>
            </tr>
            <tr>
                <th>Surveys:</th>
                <td>
                    <a href="<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_userId=<%=String.valueOf(user.getId())%>"><%=userDao.getSurveyEntriesCreated(user).size()%> survey(s)</a>
                </td>
            </tr>

            <%--Rating stuff--%>
            <%
                if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
                    if (currentUser != null && !currentUser.equals(user)) {
            %>
            <tr>
                <th>Your Rating:</th>
                <td>
                        <span id="connectRating" dojoType="dojox.form.Rating" numStars="5"
                              value="<%=ReputationService.getRaterRating(currentUser, user)%>"></span>
                </td>
            </tr>
            <%
                }
            %>
            <tr>
                <th>Overall Rating: <img
                        src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/icon/information.png")%>"
                        id="overAllRatingHelp"/>
                    <span dojoType="dijit.Tooltip" connectId="overAllRatingHelp" id="overAllRatingHelp_tooltip">
                            <strong>How is this rating calculated?</strong><br>
                            <p>This rating is calculated based on the following:</p>
                            <ul>
                                <li>Direct ranking from other volunteers</li>
                                <li>Completeness of the volunteer's profile</li>
                                <li>Direct rating on the volunteer's data</li>
                                <li>Amount of data contributed by the volunteer</li>
                                <li>Frequency of contribution of the volunteer</li>
                                <li>Cleanness and accuracy of data contributed by the volunteer</li>
                                <li>Completeness of data contributed by the volunteer</li>
                            </ul>
                        </span>
                </th>
                <td>
                    <span id="overAllRating" dojoType="dojox.form.Rating" numStars="5" disabled="disabled"
                          value="<%=ReputationService.getOverAllRating(user)%>">
                    </span>
                </td>
            </tr>
            <%
                }
            %>

            <tr>
                <%
                    if (currentUser != null && (currentUser.equals(user) || currentUser.isSuperUser())) {
                %>
                <td colspan="2">
                    <input type="button" value="Edit" onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="userId" value="<%= String.valueOf(user.getId()) %>" /></portlet:renderURL>';"/>
                <%
                    }
                %>
                </td>
            </tr>
        </table>
    </div>

    <%--Rating stuff--%>
    <%
        if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
    %>
    <div id="friendsTab" dojoType="dijit.layout.ContentPane" title="Friends" style="width:650px; height:60ex">
        <script>
            dojo.require("dojox.grid.DataGrid");
            dojo.require("dojox.data.XmlStore");
            dojo.require("dojox.form.Rating");
            dojo.require("dojo.date.locale");

            var dateFormatter = function(data) {
                return dojo.date.locale.format(new Date(Number(data)), {
                    datePattern: "dd MMM yyyy",
                    selector: "date",
                    locale: "en"
                });
            };

            var layoutMembers = [
                [
                    {
                        field: "name",
                        name: "Name",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "country",
                        name: "Country",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "joined",
                        name: "Member Since",
                        width: 10,
                        formatter: dateFormatter

                    },
                    {
                        field: "surveys",
                        name: "Surveys",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "rating",
                        name: "Overall Rating",
                        width: 10,
                        formatter: function(item) {
                            return new dojox.form.Rating({value: item.toString(), numStars:5, disabled: true});
                        }
                    },
                    {
                        field: "view",
                        name: "View",
                        width: 10,
                        formatter: function(item) {
                            var viewURL = "<a href=\"<%=renderRequest.getAttribute("userPageUrl")%>?p_p_id=userportlet_WAR_coralwatch&_userportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_userportlet_WAR_coralwatch_userId=" + item.toString() + "\">Profile</a>";
                            return viewURL;
                        }
                    }
                ]
            ];
        </script>
        <portlet:resourceURL var="friendsOfAjaxURL" id="ajax">
            <portlet:param name="friendsOf">
                <jsp:attribute name="value"><%= user.getId() %></jsp:attribute>
            </portlet:param>
        </portlet:resourceURL>
        <div dojoType="dojox.data.XmlStore"
             url="<%= friendsOfAjaxURL %>"
             jsId="userStore"
             label="title">
        </div>
        <div id="friendsGrid" style="width: 680px; height: 600px;"
             rowsPerPage="40"
             dojoType="dojox.grid.DataGrid"
             store="userStore"
             structure="layoutMembers"
             query="{}" >
        </div>
    </div>
    <%--<div id="networkTab" dojoType="dijit.layout.ContentPane" title="Network" style="width:650px; height:60ex">--%>

    <%
        }
    %>
</div>

<%
    if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
%>
<div id="networkTab" style="width:650px; height:60ex">
    <img align="left" src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/image/network_legend.png")%>"
         id="legend"/>

    <div id="center-container">
        <div id="infovis">
            <!--[if IE]>
            <script language="javascript" type="text/javascript"
                    src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/js/jit/excanvas.js")%>"></script>
            <![endif]-->
            <script type="text/javascript"
                    src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/js/jit/jit.js")%>"></script>
            <script type="text/javascript"
                    src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/js/jit/hypertree.js")%>?preventCache=<%=new Random(new Date().getTime()).nextLong()%>"></script>
        </div>
    </div>
</div>
<script type="text/javascript">
    dojo.addOnLoad(function() {
        var hyperTree = loadGraph();
        var xhrArgs = {
            url: "<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/reputation?format=json")%>&friendsOf=<%=user.getId()%>&preventCache=<%=new Random(new Date().getTime()).nextLong()%>",
            handleAs: "json",
            load: function(data) {
                var json = data;
                hyperTree.loadJSON(json);
                hyperTree.refresh();
            },
            error: function(error) {
                alert('Cannot load hyper tree. Error: ' + error);
            }
        };
        var deferred = dojo.xhrGet(xhrArgs);
        //inject the graph into the dijit tab
        var tabContainer = dijit.byId("userProfileContainer");
        var contentPane = new dijit.layout.ContentPane({title:"Network"}, "networkTab");
        tabContainer.addChild(contentPane);
    });
</script>

<%
    }
} else if (cmd.equals(Constants.PRINT)) {
    String successMsg = ParamUtil.getString(request, "successMsg");
%>
<div class="portlet-msg-success"><%=successMsg%></div>
<%
} else {
%>

<h2 style="margin-top:0;">All Members</h2>

<script>
    dojo.require("dojox.grid.DataGrid");
    dojo.require("dojox.data.XmlStore");
    dojo.require("dojo.data.ItemFileReadStore");
    dojo.require("dojo.data.ItemFileWriteStore");
    dojo.require("dojox.form.Rating");
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Button");
    dojo.require("dojo.date.locale");

    var dateFormatter = function(data) {
        return dojo.date.locale.format(new Date(Number(data)), {
            datePattern: "dd MMM yyyy",
            selector: "date",
            locale: "en"
        });
    };
    
    var datamodule = getCookie('datamodule');

    var layoutMembers = [
        [
            {
                field: "name",
                name: "Name",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "country",
                name: "Country",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "joined",
                name: "Member Since",
                width: 10,
                formatter: dateFormatter

            },
            {
                field: "surveys",
                name: "Surveys",
                width: 10,
                formatter: function(item) {
                    return Number(item);
                }
            },

            <%--Rating stuff--%>
            <%
                if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
            %>
            {
                field: "rating",
                name: "Overall Rating",
                width: 10,
                formatter: function(item) {
                    return new dojox.form.Rating({value: item.toString(), numStars:5, disabled: true});
                }
            },
            <%
            }
            %>
            {
                field: "view",
                name: "View",
                width: 10,
                formatter: function(item) {
                    var url = window.location.origin + '/web/guest/<%=renderRequest.getAttribute("userPageUrl")%>?p_p_id=userportlet_WAR_coralwatch&_userportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_userportlet_WAR_coralwatch_userId=' + item.toString();
                    if (datamodule) return '<a target="popup" href="' + url + '" onclick="window.open(\'' + url + '\',\'popup\',\'width=682,height=644\'); return false;">Profile</a>';
                    else return '<a target="_blank" href="' + url + '">Profile</a>';
                    
                    //var viewURL = "<a href=\"<%=renderRequest.getAttribute("userPageUrl")%>?p_p_id=userportlet_WAR_coralwatch&_userportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_userportlet_WAR_coralwatch_userId=" + item.toString() + "\">Profile</a>";
                    //return viewURL;
                }
            }
        ]
    ];

    var memberData = {
      identifier: 'id',
      label: 'name',
      items: []
    }

    function cmpIgnoreCase(a,b) {
      if((a === null) && (b === null)) {
        return 0;
      } else if(a === null) {
        return -1;
      } else if(b === null) {
        return 1;
      } else {
        return a.toLowerCase().localeCompare(b.toLowerCase());
      }
    }

    // Changes XML to JSON
    // Modified version from here: http://davidwalsh.name/convert-xml-json
    function xmlToJson(xml) {
        // Create the return object
        var obj = {};

        if (xml.nodeType == 1) { // element
            // do attributes
            if (xml.attributes.length > 0) {
            obj["@attributes"] = {};
                for (var j = 0; j < xml.attributes.length; j++) {
                    var attribute = xml.attributes.item(j);
                    obj["@attributes"][attribute.nodeName] = attribute.nodeValue;
                }
            }
        } else if (xml.nodeType == 3) { // text
            obj = xml.nodeValue;
        }

        // do children
        // If just one text node inside
        if (xml.hasChildNodes() && xml.childNodes.length === 1 && xml.childNodes[0].nodeType === 3) {
            obj = xml.childNodes[0].nodeValue;
        }
        else if (xml.hasChildNodes()) {
            for(var i = 0; i < xml.childNodes.length; i++) {
                var item = xml.childNodes.item(i);
                var nodeName = item.nodeName;
                if (typeof(obj[nodeName]) == "undefined") {
                    obj[nodeName] = xmlToJson(item);
                } else {
                    if (typeof(obj[nodeName].push) == "undefined") {
                        var old = obj[nodeName];
                        obj[nodeName] = [];
                        obj[nodeName].push(old);
                    }
                    obj[nodeName].push(xmlToJson(item));
                }
            }
        }
        return obj;
    }

    dojo.addOnLoad(function() {
        memberStore.comparatorMap = {};
        memberStore.comparatorMap.country = cmpIgnoreCase;
        memberStore.comparatorMap.name = cmpIgnoreCase;
        <%--Rating stuff--%>
        <%
        if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
        %>
        memberStore.comparatorMap.rating = cmpIgnoreCase;
        <%
        }
        %>

        var url = "<portlet:resourceURL id="ajax" />";

        dojo.xhrGet({
            url: url,
            handleAs: 'xml',
            preventCache: true,
            load: function(data_xml) {
                //console.log("row data = ", data_xml);
                if (data_xml) {
                    var data_JSON = xmlToJson(data_xml);
                    //console.log("XML data = ", data_JSON);

                    if (data_JSON && typeof data_JSON.members !=='undefined' && typeof data_JSON.members.member !=='undefined' && Array.isArray(data_JSON.members.member)) {
                        data_JSON.members.member.forEach(function(member) {
                            memberStore.newItem({
                                id: Number(member.view),
                                name: ((member.name || "").replace(/\\/g, "\\\\").replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t").replace(/\f/g, "\\f").replace(/"/g,"\\\"").replace(/'/g,"\\\'").replace(/\&/g, "\\&")).toString() || "",
                                country: ((member.country || "").replace(/\\/g, "\\\\").replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t").replace(/\f/g, "\\f").replace(/"/g,"\\\"").replace(/'/g,"\\\'").replace(/\&/g, "\\&")).toString() || "",
                                joined: (member.joined).toString() || "",
                                surveys: (Number(member.surveys) !== 'NaN' ? member.surveys : "0"),
                                <%--Rating stuff--%>
                                <%
                                    if (CoralwatchApplication.getConfiguration().isRatingSetup()) {
                                %>
                                rating: member.rating,
                                <%
                                }
                                %>
                                view: member.view
                            });
                        });
                    }
                }
            },
            error: function(e) {
                console.error('loading members data failed %o', e);
            }
        });
    });
</script>

<div>
    <% if (currentUser != null && currentUser.isSuperUser()) { %>
    <div style="float: right;">
        <a href="<portlet:resourceURL id="export" />">Export member details</a>
    </div>
    <% } %>
    <form dojoType="dijit.form.Form" jsId="filterForm" id="filterForm">
        <script type="dojo/method" event="onSubmit">
            if (!this.validate()) {
                alert('Enter a search key word.');
                return false;
            } else {
                grid.queryOptions = {ignoreCase: true};
                grid.filter({
                    name: "*" + dijit.byId("nameFilterField").getValue() + "*",
                    country: "*" + dijit.byId("countryFilterField").getValue() + "*"
                });
                return false;
            }
        </script>
        Name: <input type="text"
                     id="reefFilterField"
                     name="reefFilterField"
                     style="width:100px;"
                     dojoType="dijit.form.TextBox"
                     trim="true"
                     value=""/> Country: <input type="text"
                                                id="countryFilterField"
                                                name="countryFilterField"
                                                style="width:100px;"
                                                dojoType="dijit.form.TextBox"
                                                trim="true"
                                                value=""/><input type="submit" name="submit" value="Search"/>
    </form>
</div>
<br/>

<div dojoType="dojo.data.ItemFileWriteStore" jsId="memberStore" data="memberData"></div>

<div id="grid" style="width: 680px; height: 600px;"
     rowsPerPage="250"
     dojoType="dojox.grid.DataGrid"
     jsId="memberGrid"
     store="memberStore"
     structure="layoutMembers"
     queryOptions="{}"
     query="{}" >
</div>
<%
    }
%>
