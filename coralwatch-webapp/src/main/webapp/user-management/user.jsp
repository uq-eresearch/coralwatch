<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.UserDao" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="org.coralwatch.services.ReputationService" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="javax.portlet.WindowState" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>

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
    String occupation = "";
    String qualification = "";
    String country = "";
    String address = "";
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
        if(!this.validate()){
        alert('Form contains invalid data. Please correct errors first');
        return false;
        }
        return true;
    </script>
    <%
        if (cmd.equals(Constants.EDIT)) {
            UserImpl user = userDao.getById(userId);
            email = user.getEmail();
            displayName = user.getDisplayName();
            occupation = user.getOccupation();
            qualification = user.getQualification();
            country = user.getCountry();
            address = user.getAddress();
    %>
    <h2 style="margin-top:0;">Edit User Profile</h2>
    <br/>

    <p style="text-align:justify;">CoralWatch requires all users to provide real contact details to encourage
        authenticity of data. Your profile is protected from others.</p>
    <input name="userId" type="hidden" value="<%= userId %>"/>
    <%
    } else {
    %>
    <h2 style="margin-top:0;">Sign Up</h2>
    <br/>

    <p style="text-align:justify;">CoralWatch requires all users to provide real contact details to encourage
        authenticity of data. Your profile is protected from others.</p>
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
    <input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
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
                       value="<%=email == null ? "" : email%>"/></td>
        </tr>
        <tr>
            <td><label for="email2">Confirm Email:</label></td>
            <td><input type="text" name="email2" id="email2"
                       dojoType="dijit.form.ValidationTextBox"
                    <%if (cmd.equals(Constants.ADD)) {%>
                       required="true"
                    <%}%>
                       validator="return this.getValue() == dijit.byId('email').getValue()"
                       trim="true"
                       invalidMessage="Re-enter your email address."
                       value=""/></td>
        </tr>
        <tr>
            <td><label for="password">Password <%if (cmd.equals(Constants.EDIT)) {%>(optional)<%}%>:</label></td>
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
            <td><label for="password2">Confirm Password <%if (cmd.equals(Constants.EDIT)) {%>(optional)<%}%>:</label>
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
            <td><label for="occupation">Occupation:</label></td>
            <td><input type="text" name="occupation" id="occupation"
                       dojoType="dijit.form.TextBox"
                       value="<%=occupation == null ? "" : occupation%>"/></td>
        </tr>
        <tr>
            <td><label for="qualification">Qualification:</label></td>
            <td><select name="qualification" id="qualification"
                        required="true"
                        dojoType="dijit.form.ComboBox"
                        hasDownArrow="true"
                        value="<%=qualification == null ? "" : qualification%>">
                <option selected="selected" value=""></option>
                <option value="Senior Researcher">Senior Researcher</option>
                <option value="Junior Researcher">Junior Researcher</option>
                <option value="Post Doc">Post Doc</option>
                <option value="PhD Student">PhD Student</option>
                <option value="Undergrad Student">Undergrad Student</option>
                <option value="Secondary School Student">Secondary School Student</option>
                <option value="Primary School Student">Primary School Student</option>
                <option value="Tourist">Tourist</option>
                <option value="Dive Centre">Dive Centre</option>
                <option value="Teacher">Teacher</option>
                <option value="Industry">Industry</option>
            </select>
            </td>
        </tr>
        <tr>
            <td><label for="address">Address:</label></td>
            <td><input type="text" name="address" id="address"
                       style="width:300px"
                       dojoType="dijit.form.Textarea"
                       trim="true"
                       value="<%=address == null ? "" : address%>"/></td>
        </tr>
        <%
            }
        %>
        <tr>
            <td><label for="country">Country:</label></td>
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
<% } else if (cmd.equals(Constants.RESET)) {
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
    <input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
    <input name="userId" type="hidden" value="<%= userId %>"/>
    <input name="resetid" type="hidden" value="<%= resetid %>"/>
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
    <%
        if (currentUser != null && !currentUser.equals(user)) {
    %>
    dojo.addOnLoad(function() {
        var widget = dijit.byId("connectRating");
        dojo.connect(widget, "onClick", function() {
            dojo.xhrPost({
                url:'<%=renderResponse.encodeURL(renderRequest.getContextPath())%>' + '/rating?cmd=rateuser&raterId=<%=currentUser.getId()%>&ratedId=<%=user.getId()%>&value=' + widget.value,
                timeout: 5000,
                load: function(response, ioArgs) {
                    //                    alert("Response: " + response)
                    return response;
                },
                error: function(response, ioArgs) {
                    alert('Cannot add rating: ' + response);
                    return response;
                }
            });
        });
    });
    <%
    }
    %>
</script>
<h2 style="margin-top:0;">User Profile</h2>

<div id="userProfileContainer" dojoType="dijit.layout.TabContainer" style="width:650px;height:60ex">
    <div id="userDetailsTab" dojoType="dijit.layout.ContentPane" title="Details" style="width:650px; height:60ex">
        <table>
            <tr>
                <th>Display Name:</th>
                <td><%= user.getDisplayName()%>
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
                <th>Email:</th>
                <td><a href="mailto:<%= user.getEmail()%>"><%= user.getEmail()%>
                </a></td>
            </tr>
            <%
                }
            %>
            <tr>
                <th>Member since (d/m/y):</th>
                <td><%= dateFormat.format(user.getRegistrationDate())%>
                </td>
            </tr>
            <tr>
                <th>Role:</th>
                <td><%= user.isSuperUser() ? "Administrator" : "Member"%>
                </td>
            </tr>
            <tr>
                <th>Occupation:</th>
                <td><%= user.getOccupation() == null ? "Not Set" : user.getOccupation()%>
                </td>
            </tr>
            <tr>
                <th>Qualification:</th>
                <td><%= user.getQualification() == null ? "Not Set" : user.getQualification()%>
                </td>
            </tr>
            <tr>
                <th>Address:</th>
                <td><%= user.getAddress() == null ? "Not Set" : user.getAddress()%>
                </td>
            </tr>
            <tr>
                <th>Country:</th>
                <td><%= user.getCountry() == null ? "Not Set" : user.getCountry()%>
                </td>
            </tr>
            <tr>
                <th>Surveys:</th>
                <td>
                    <a href="<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_userId=<%=String.valueOf(user.getId())%>"><%=userDao.getSurveyEntriesCreated(user).size()%>
                        survey(s)</a></td>
            </tr>
            <%
                if (currentUser != null && !currentUser.equals(user)) {
            %>
            <tr>
                <th>Your Rating:</th>
                <td>
                    <%
                        //                        UserRating userRating = userRatingDao.getRating(currentUser, user);
//                        double userRatingValue = 0;
//                        if (userRating != null) {
//                            userRatingValue = userRating.getRatingValue();
//                        }
                    %>
                    <span id="connectRating" dojoType="dojox.form.Rating" numStars="5"
                          value="<%=ReputationService.getRaterRating(currentUser, user)%>"></span>
                </td>
            </tr>
            <%
                }
            %>
            <tr>
                <th>Overall Rating:</th>
                <td>
            <span id="overAllRating" dojoType="dojox.form.Rating" numStars="5" disabled="disabled"
                  value="<%=ReputationService.getOverAllRating(user)%>"></span>
                </td>
            </tr>

            <%--<tr>--%>
            <%--<th>Photos:</th>--%>
            <%--<td>No Photos Yet</td>--%>
            <%--</tr>--%>
            <tr>
                <%
                    if (currentUser != null && (currentUser.equals(user) || currentUser.isSuperUser())) {
                %>
                <td colspan="2"><input type="button" value="Edit"
                                       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="userId" value="<%= String.valueOf(user.getId()) %>" /></portlet:renderURL>';"/>

                    <%
                        }
                    %>
                </td>
            </tr>
        </table>
    </div>
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
                        field: "joined",
                        name: "Member Since",
                        width: 10,
                        formatter: dateFormatter

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
                        field: "surveys",
                        name: "Surveys",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "rating",
                        name: "Rating",
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
        <div dojoType="dojox.data.XmlStore"
             url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/users?format=xml&friendsOf=<%=user.getId()%>"
             jsId="userStore"
             label="title">
        </div>
        <div id="friendsGrid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
             store="userStore" structure="layoutMembers" query="{}" rowsPerPage="40">
        </div>
    </div>
    <div id="networkTab" dojoType="dijit.layout.ContentPane" title="Network" style="width:650px; height:60ex">

    </div>
</div>
<%
} else if (cmd.equals(Constants.PRINT)) {
    String successMsg = ParamUtil.getString(request, "successMsg");
%>
<div class="portlet-msg-success"><%=successMsg%>
</div>
<%
} else {
%>
<h2 style="margin-top:0;">All Users</h2>
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
                field: "joined",
                name: "Member Since",
                width: 10,
                formatter: dateFormatter

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
                field: "surveys",
                name: "Surveys",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "rating",
                name: "Rating",
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
<div dojoType="dojox.data.XmlStore"
     url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/users?format=xml" jsId="userStore"
     label="title">
</div>
<div id="grid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
     store="userStore" structure="layoutMembers" query="{}" rowsPerPage="40">
</div>
<%
    }
%>