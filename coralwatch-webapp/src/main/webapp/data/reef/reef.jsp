<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="java.util.Date" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="liferay-portlet" uri="http://liferay.com/tld/portlet" %>
<portlet:defineObjects/>

<%
    //    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
    ReefDao reefDao = (ReefDao) renderRequest.getAttribute("reefDao");
    String cmd = ParamUtil.getString(request, Constants.CMD);
    if (cmd.equals(Constants.VIEW)) {
        long reefId = ParamUtil.getLong(request, "reefId");
        Reef reef = reefDao.getById(reefId);

%>
<script type="text/javascript">
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
</script>
<h2><%=reef.getName()%> (<%=reef.getCountry()%>)</h2>

<div id="reefContainer" dojoType="dijit.layout.TabContainer" style="width:680px;height:60ex">
    <div id="graphs" dojoType="dijit.layout.ContentPane" title="Graphs" style="width:680px; height:60ex">
        <%
            if (reefDao.getSurveysByReef(reef).size() > 0) {
                String timelineChartUrl = "/graph?type=reef&id=" + reefId + "&chart=timeline&width=512&height=512&legend=false&titleSize=12&time=" + (new Date().getTime());
                String pieChartUrl = "/graph?type=reef&id=" + reefId + "&chart=shapePie&width=256&height=256&labels=true&legend=true&titleSize=12&time=" + (new Date().getTime());
                String barChartUrl = "/graph?type=reef&id=" + reefId + "&chart=coralCount&width=256&height=256&legend=false&titleSize=12&time=" + (new Date().getTime());
        %>
        <br/>

        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + timelineChartUrl)%>"
                  alt="Reef Timeline" width="512" height="512"/>
        </div>
        <br/>

        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + barChartUrl)%>"
                  alt="Colour Distribution" width="256" height="256"/>
        </div>
        <br/>

        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + pieChartUrl)%>"
                  alt="Shape Distribution" width="256" height="256"/>
        </div>
        <%
        } else {
        %>
        <span style="text-align:center;">No surveys conducted in this reef yet.</span>
        <%
            }
        %>
    </div>
    <div id="surveys" dojoType="dijit.layout.ContentPane" title="Data" style="width:680px; height:60ex">
        <div align="right">
            <a href="<%=renderResponse.encodeURL(renderRequest.getContextPath() + "/data-download?id=" + reefId)%>">Download
                Data</a>
        </div>
        <script>
            dojo.require("dojox.grid.DataGrid");
            dojo.require("dojox.data.XmlStore");
            dojo.require("dojo.date.locale");

            var dateFormatter = function(data, rowIndex) {
                return dojo.date.locale.format(new Date(data), {
                    datePattern: "dd MMM yyyy",
                    selector: "date",
                    locale: "en"
                });
            };
            var layoutSurveys = [
                [
                    {
                        field: "surveyor",
                        name: "Surveyor",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "date",
                        name: "Date",
                        width: 10,
                        formatter: dateFormatter

                    },
                    {
                        field: "reef",
                        name: "Reef",
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
                        field: "records",
                        name: "Records",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
                    },
                    {
                        field: "view",
                        name: "View",
                        width: 10,
                        formatter: function(item) {
                            var viewURL = "<a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + item.toString() + "\">More info</a>";
                            return viewURL;
                        }
                    }
                ]
            ];
        </script>
        <div dojoType="dojox.data.XmlStore"
             url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/surveys?format=xml&reefId=<%=reefId%>"
             jsId="surveyStore" label="title">
        </div>
        <div id="surveygrid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
             store="surveyStore" structure="layoutSurveys" query="{}" rowsPerPage="40">
        </div>
    </div>
</div>
<%

} else {
%>
<h2 style="margin-top:0;">All Reefs</h2>
<script>
    dojo.require("dojox.grid.DataGrid");
    dojo.require("dojox.data.XmlStore");
    dojo.require("dojo.date.locale");
    var layoutReefs = [
        [
            {
                field: "name",
                name: "Reef Name",
                width: 15,
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
                field: "surveys",
                name: "Surveys",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "view",
                name: "View",
                width: 10,
                formatter: function(item) {
                    var viewURL = "<a href=\"<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch&_reefportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_reefportlet_WAR_coralwatch_reefId=" + item.toString() + "\">More info</a>";
                    return viewURL;
                }
            },
            {
                field: "download",
                name: "Download",
                width: 10,
                formatter: function(item) {
                    var downloadUrl = "<a href=\"<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/data-download?id=" + item.toString() + "\">Download Data</a>";
                    return downloadUrl;
                }
            }
        ]
    ];
</script>
<div dojoType="dojox.data.XmlStore"
     url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/reefs?format=xml"
     jsId="reefStore" label="title">
</div>
<div id="reefgrid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
     store="reefStore" structure="layoutReefs" query="{}" rowsPerPage="40">
</div>
<%
    }
%>