<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="org.coralwatch.dataaccess.ReefDao" %>
<%@ page import="org.coralwatch.model.Reef" %>
<%@ page import="org.coralwatch.model.Survey" %>
<%@ page import="org.coralwatch.model.UserImpl" %>
<%@ page import="javax.portlet.PortletSession" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<%@ taglib prefix="liferay-portlet" uri="http://liferay.com/tld/portlet" %>
<portlet:defineObjects/>

<%
    UserImpl currentUser = (UserImpl) renderRequest.getPortletSession().getAttribute("currentUser", PortletSession.APPLICATION_SCOPE);
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

        <div><img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + pieChartUrl)%>"
                  alt="Shape Distribution" width="256" height="256"/>
            <img src="<%=renderResponse.encodeURL(renderRequest.getContextPath() + barChartUrl)%>"
                 alt="Colour Distribution" width="256" height="256"/>
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
            <portlet:resourceURL var="surveyExportURL" id="surveyExport">
                <portlet:param name="reefId">
                    <jsp:attribute name="value"><%= reefId %></jsp:attribute>
                </portlet:param>
                <portlet:param name="format" value="xls" />
            </portlet:resourceURL>
            <a href="<%= surveyExportURL %>%>">Download Data</a>
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
            
            var datamodule = getCookie('datamodule');
            
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
                        width: 5,
                        formatter: function(item) {
                            return Number(item.toString());
                        }
                    },
                    {
                        field: "view",
                        name: "View",
                        width: 9,
                        formatter: function(item) {
                            var url = window.location.origin + '/web/guest/<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=' + item.toString();
                            if (datamodule) return '<a target="popup" href="' + url + '" onclick="window.open(\'' + url + '\',\'popup\',\'width=682,height=644\'); return false;">More Info</a>';
                            else return '<a target="_blank" href="' + url + '">More Info</a>';

                            //var viewURL = "<a href=\"<%=renderRequest.getAttribute("surveyUrl")%>?p_p_id=surveyportlet_WAR_coralwatch&_surveyportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_surveyportlet_WAR_coralwatch_surveyId=" + item.toString() + "\">More info</a>";
                            //return viewURL;
                        }
                    }
                    <% if ((currentUser != null) && currentUser.isSuperUser()) { %>
                    , {
                        field: "reviewState",
                        name: "Review",
                        width: 5,
                        formatter: function(item) {
                            var reviewStateColour = null;
                            var reviewStateText = null;
                            <% for (Survey.ReviewState reviewState : Survey.ReviewState.values()) { %>
                            if (item == '<%= reviewState.name() %>') {
                                reviewStateColour = '<%= reviewState.getColour() %>';
                                reviewStateText = '<%= reviewState.getText() %>';
                            }
                            <% } %>
                            if (reviewStateColour && reviewStateText) {
                                return '<img src="<%= renderRequest.getContextPath() %>/icon/timemap/' + reviewStateColour + '-circle.png" title="' + reviewStateText + '" />';
                            }
                            else {
                                return '';
                            }
                        }
                    }
                    <% } %>
                ]
            ];
        </script>
        <liferay-portlet:resourceURL var="resourceURL" portletName="surveyportlet_WAR_coralwatch">
            <liferay-portlet:param name="format" value="xml" />
            <liferay-portlet:param name="reefId" value="<%= String.valueOf(reefId) %>" />
        </liferay-portlet:resourceURL>
        <div dojoType="dojox.data.XmlStore"
             url="<%= resourceURL %>&p_p_resource_id=list"
             jsId="surveyStore" label="title">
        </div>
        <div id="surveygrid" style="width: 653px; height: 600px;" dojoType="dojox.grid.DataGrid"
             store="surveyStore" structure="layoutSurveys" query="{}" rowsPerPage="40">
        </div>
    </div>
    <div id="mapTab" dojoType="dijit.layout.ContentPane" title="Map" style="width:650px; height:60ex">
        <%
            List<Survey> surveys = reefDao.getSurveysByReef(reef);
            if (surveys != null && surveys.size() > 0) {
        %>
        <jsp:include page="../../map/google-map-key.jsp"/>
        <div id="map" style="width: 640px; height: 53ex">
            <script type="text/javascript">
                var mapDiv = dojo.byId("map");
                var map = new google.maps.Map(mapDiv, {
                    center: new google.maps.LatLng(25.799891, 15.468750),
                    zoom: 2,
                    mapTypeId: google.maps.MapTypeId.HYBRID,
                    mapTypeControl: true,
                    overviewMapControl: true,
                    zoomControl: true,
                    zoomControlOptions: {
                        style: google.maps.ZoomControlStyle.SMALL
                    }
                });

                <%
                    // If we can find a survey with a lat/lng, center map at that point
                    for (Survey srv : surveys) {
                        if (srv.getLatitude() != null && srv.getLatitude() >= -90 && srv.getLatitude() <= 90 &&
                            srv.getLongitude() != null && srv.getLongitude() >= -180 && srv.getLongitude() <= 180) {
                %>
                map.setCenter(new google.maps.LatLng(<%=srv.getLatitude()%>, <%=srv.getLongitude()%>));
                <%
                            break;
                        }
                    }
                %>

                <%
                    // Add a map marker for each survey that has a lat/long
                    for(Survey srv : surveys) {
                        if (srv.getLatitude() != null && srv.getLatitude() >= -90 && srv.getLatitude() <= 90 &&
                            srv.getLongitude() != null && srv.getLongitude() >= -180 && srv.getLongitude() <= 180) {
                %>
                new google.maps.Marker({
                    position: new google.maps.LatLng(<%=srv.getLatitude()%>, <%=srv.getLongitude()%>),
                    map: map
                });
                <%
                        }
                    }
                %>
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

<%
  if((currentUser != null) && currentUser.isSuperUser()) {
%>
<div dojoType="dijit.form.Button">
    Remove Selected Reefs (only reefs with 0 surveys can be deleted this way)
  <script type="dojo/method" event="onClick" args="evt">
// Get all selected items from the Grid:
var items = reefgrid.selection.getSelected();
reefStore._getDeleteUrl = function(item) {
  if(item && item.element) {
    var xml = jQuery(item.element);
    if(xml) {
      var id = xml.find('delete').text();
      if(id) {
        return '/coralwatch/reefs?id='+id
      }
    }
  }
  return '/coralwatch/reefs?id=';
};
if (items.length) {
    // Iterate through the list of selected items.
    // The current item is available in the variable
    // "selectedItem" within the following function:
    dojo.forEach(items, function(selectedItem) {
        if (selectedItem !== null) {
            // Delete the item from the data store:
            reefStore.deleteItem(selectedItem);
        } // end if
    }); // end forEach
  reefStore.save({onComplete: function() {
    // the grid does not seem to get updated so just reload this page as a workaround.
    location.reload(false);
  }});
} // end if
  </script>
</div>
<%
  }
%>

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
    
    var datamodule = getCookie('datamodule');
    
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
                    var url = window.location.origin + '/web/guest/<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch&_reefportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_reefportlet_WAR_coralwatch_reefId=' + item.toString();
                    if (datamodule) return '<a target="popup" href="' + url + '" onclick="window.open(\'' + url + '\',\'popup\',\'width=682,height=644\'); return false;">Graphs</a>';
                    else return '<a target="_blank" href="' + url + '">Graphs</a>';
 
                    //var viewURL = "<a href=\"<%=renderRequest.getAttribute("reefUrl")%>?p_p_id=reefportlet_WAR_coralwatch&_reefportlet_WAR_coralwatch_<%= Constants.CMD %>=<%= Constants.VIEW %>&_reefportlet_WAR_coralwatch_reefId=" + item.toString() + "\">Graphs</a>";
                    //return viewURL;
                }
            },
            {
                field: "download",
                name: "Download",
                width: 10,
                formatter: function(item) {
                    var downloadUrl =
                    	"<a href=\"" +
                    	"<portlet:resourceURL id="surveyExport"/>" +
                    	"&<portlet:namespace/>reefId=" + item.toString() +
                    	"&<portlet:namespace/>format=xls" +
                    	"\">Raw Data</a>";
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
            reefgrid.queryOptions = {ignoreCase: true};
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
                                                     value=""/><input type="submit" name="submit" value="Search"/>search is case sensitive
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
