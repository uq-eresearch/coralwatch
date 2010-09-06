<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
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
            dojo.require("dojo.parser");
            dojo.addOnLoad(function() {
                //        grid.setSortIndex(1, true);
                surveyStore.comparatorMap = {};
                surveyStore.comparatorMap["records"] = function(a, b) {
                    var ret = 0;
                    if (Number(a) > Number(b)) {
                        ret = 1;
                    }
                    if (Number(a) < Number(b)) {
                        ret = -1;
                    }
                    return ret;
                };
                //                surveygrid.setSortIndex(0, true);
            });
            var dateFormatter = function(data) {
                return dojo.date.locale.format(new Date(Number(data)), {
                    datePattern: "dd MMM yyyy",
                    selector: "date",
                    locale: "en"
                });
            };
            var layoutSurveys = [
                [

                    {
                        field: "country",
                        name: "Country",
                        width: 10,
                        formatter: function(item) {
                            return item.toString();
                        }
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
                        field: "records",
                        name: "Records",
                        width: 10,
                        formatter: function(item) {
                            return Number(item.toString());
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
    <div id="mapTab" dojoType="dijit.layout.ContentPane" title="Map" style="width:650px; height:60ex">
        <%
            List<Survey> surveys = reefDao.getSurveysByReef(reef);
            if (surveys != null && surveys.size() > 0) {
//        if (byReef.getLatitude() != null && survey.getLongitude() != null) {
        %>
        <jsp:include page="../../map/google-map-key.jsp"/>
        <div id="map" style="width: 640px; height: 53ex">
            <script type="text/javascript">
                if (GBrowserIsCompatible()) {
                    var mavDiv = dojo.byId("map");
                    var map = new GMap2(mavDiv);
                    map.setMapType(G_HYBRID_MAP);
                    map.addControl(new GSmallMapControl());
                    map.addControl(new GMapTypeControl());
                    map.addControl(new GOverviewMapControl());
                    map.setCenter(new GLatLng(25.799891, 15.468750), 2);
                <%
                for (Survey srv : surveys) {
                    if (srv.getLatitude() != null && srv.getLongitude() != null) {
                %>
                    var center = new GLatLng(<%=srv.getLatitude()%>, <%=srv.getLongitude()%>);

                <%
                    break;
                    }
                }
                %>
                    map.setCenter(center, 5);
                <%
                for(Survey srv : surveys) {
                    if (srv.getLatitude() != null && srv.getLongitude() != null){
                %>
                    map.addOverlay(new GMarker(new GLatLng(<%=srv.getLatitude()%>, <%=srv.getLongitude()%>)));
                <%
                    }
                }
                %>
                }
            </script>
        </div>
        <%
        } else {
        %>
        <p>No GPS data available for surveys in this reef.</p>
        <%}%>
    </div>
</div>
<%

} else {
%>
<h2 style="margin-top:0;">All Reefs</h2>
<script>
    dojo.require("dojox.grid.DataGrid");
    dojo.require("dojox.data.XmlStore");
    dojo.require("dijit.form.Form");
    dojo.require("dijit.form.TextBox");
    dojo.require("dijit.form.Button");
    dojo.require("dojo.date.locale");
    dojo.require("dojo.parser");

    dojo.addOnLoad(function() {
        //        grid.setSortIndex(1, true);
        reefStore.comparatorMap = {};
        reefStore.comparatorMap["surveys"] = function(a, b) {
            var ret = 0;
            if (Number(a) > Number(b)) {
                ret = 1;
            }
            if (Number(a) < Number(b)) {
                ret = -1;
            }
            return ret;
        };
        //        reefgrid.setSortIndex(0, true);
    });
    var layoutReefs = [
        [
            {
                field: "country",
                name: "Country",
                width: 10,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "name",
                name: "Reef Name",
                width: 15,
                formatter: function(item) {
                    return item.toString();
                }
            },
            {
                field: "surveys",
                name: "Surveys",
                width: 10,
                formatter: function(item) {
                    return Number(item.toString());
                }
            },
            {
                field: "view",
                name: "View",
                width: 10,
                formatter: function(item) {
                    var viewURL = "<a href=\"<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch&_reefportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_reefportlet_WAR_coralwatch_reefId=" + item.toString() + "\">Graphs</a>";
                    return viewURL;
                }
            },
            {
                field: "download",
                name: "Download",
                width: 10,
                formatter: function(item) {
                    var downloadUrl = "<a href=\"<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/data-download?id=" + item.toString() + "\">Raw Data</a>";
                    return downloadUrl;
                }
            }
        ]
    ];
</script>

<div>
    <form dojoType="dijit.form.Form" jsId="filterForm" id="filterForm">
        <script type="dojo/method" event="onSubmit">
            if(!this.validate()){
            alert('Enter a search key word.');
            return false;
            } else {
            reefgrid.filter({
            name: "*" + dijit.byId("reefFilterField").getValue() + "*",
            country: "*" + dijit.byId("countryFilterField").getValue() + "*"
            });
            return false;
            }
        </script>
        Country: <input type="text"
                        id="countryFilterField"
                        name="countryFilterField"
                        style="width:100px;"
                        dojoType="dijit.form.TextBox"
                        trim="true"
                        value=""/> Reef Name: <input type="text"
                                                     id="reefFilterField"
                                                     name="reefFilterField"
                                                     style="width:100px;"
                                                     dojoType="dijit.form.TextBox"
                                                     trim="true"
                                                     value=""/><input type="submit" name="submit" value="Filter"/>
    </form>
</div>
<br/>

<div dojoType="dojox.data.XmlStore"
     url="<%=renderResponse.encodeURL(renderRequest.getContextPath())%>/reefs?format=xml"
     jsId="reefStore" label="title">
</div>
<div id="reefgrid" jsId="reefgrid" style="width: 680px; height: 600px;" dojoType="dojox.grid.DataGrid"
     store="reefStore" structure="layoutReefs" query="{}" rowsPerPage="40">
</div>
<%
    }
%>