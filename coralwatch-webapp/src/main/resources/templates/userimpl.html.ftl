<#-- @ftlvariable name="userimpl" type="org.coralwatch.model.UserImpl" -->
<#include "userimpl-header.html.ftl"/>
<script type="text/javascript">

    function addEvent(obj, type, fn) {
        if (obj.addEventListener) obj.addEventListener(type, fn, false);
        else obj.attachEvent('on' + type, fn);
    }
    ;

    function getTree() {
        //init data
        var json = {
            "id": "${userimpl.id?c}",
            "name": "${userimpl.displayName!}",
            "children": [],
            "data": {
                "avatar":"${userimpl.gravatarUrl!}"
            }
        };

        var infovis = document.getElementById('infovis');
        var w = infovis.offsetWidth, h = infovis.offsetHeight;

        //init canvas
        //Create a new canvas instance.
        var canvas = new Canvas('mycanvas', {
            //Where to append the canvas widget
            'injectInto': 'infovis',
            'width': w,
            'height': h,

            //Optional: create a background canvas and plot
            //concentric circles in it.
            'backgroundCanvas': {
                'styles': {
                    'strokeStyle': '#555'
                },

                'impl': {
                    'init': function() {
                    },
                    'plot': function(canvas, ctx) {
                        var times = 6, d = 100;
                        var pi2 = Math.PI * 2;
                        for (var i = 1; i <= times; i++) {
                            ctx.beginPath();
                            ctx.arc(0, 0, i * d, 0, pi2, true);
                            ctx.stroke();
                            ctx.closePath();
                        }
                    }
                }
            }
        });
        //end
        //init RGraph
        var rgraph = new RGraph(canvas, {
            //Set Node and Edge colors.
            interpolation: 'polar',
            levelDistance: 100,
            Node: {
                color: '#ccddee'
            },

            Edge: {
                color: '#772277'
            },

            //Add the name of the node in the correponding label
            //and a click handler to move the graph.
            //This method is called once, on label creation.
            onCreateLabel: function(domElement, node) {
                domElement.innerHTML = node.name;
                $(domElement).qtip(
                {
                    content: '<img src="' + node.data.avatar + '" />',
                    //                        content: node.data,
                    position: {
                        corner: {
                            tooltip: 'bottomMiddle',
                            target: 'topMiddle'
                        }
                    },
                    style: {
                        tip: true, // Give it a speech bubble tip with automatic corner detection
                        name: 'cream'
                    }

                });
                domElement.onclick = function() {
                    rgraph.onClick(node.id);
                };
            },
            //Change some label dom properties.
            //This method is called each time a label is plotted.
            onPlaceLabel: function(domElement, node) {
                var style = domElement.style;
                style.display = '';
                style.cursor = 'pointer';

                if (node._depth <= 1) {
                    style.fontSize = "0.8em";
                    style.color = "#ccc";

                } else if (node._depth == 2) {
                    style.fontSize = "0.7em";
                    style.color = "#494949";

                } else {
                    style.display = 'none';
                }

                var left = parseInt(style.left);
                var w = domElement.offsetWidth;
                style.left = (left - w / 2) + 'px';
            }
        });

        //load JSON data
        rgraph.loadJSON(json);

    <#list trustTable as trust>
        rgraph.graph.addAdjacence({'id': '${trust.trustee.id!}', 'name' : '${trust.trustee.displayName!}', "data": {"avatar":"${trust.trustee.gravatarUrl!}"}}, {'id': '${trust.trustor.id!}', 'name' : '${trust.trustor.displayName!}',"data": {"avatar":"${trust.trustor.gravatarUrl!}"}}, null);
    </#list>
        rgraph.refresh();
    }

</script>
<#include "macros/basic.html.ftl"/>
<#include "macros/rating.html.ftl"/>

<div class="breadcrumbs">
    <a href="${baseUrl}/">Home</a>&ensp;&raquo;&ensp;<a href="${baseUrl}/dashboard">Dashboard</a>&ensp;&raquo;&ensp;<a
        href="${baseUrl}/users">Users</a>&ensp;&raquo;&ensp;${userimpl.displayName!}
</div>


<div id="tabs">
    <ul>
        <li><a href="#fragment-1"><span>Details</span></a></li>
        <li><a href="#fragment-2"><span>Surveys</span></a></li>
    </ul>
    <div id="fragment-1">

        <table style="width:100%">

            <tr>
                <td></td>
                <td colspan="2">
                    <#if canUpdate>
                    <button dojoType="dijit.form.Button" id="editButton"
                            onClick="window.location='${baseUrl}/users/${userimpl.id?c}?edit'">Edit
                    </button>
                    </#if>
                    <#if canDelete>
                    <button dojoType="dijit.form.Button" onClick="deleteUser(${userimpl.id?c})">Delete</button>
                    </#if>
                </td>
            </tr>
            <tr>
                <td class="headercell"></td>
                <td style="width:60%"></td>
                <td rowspan="4" style="text-align:right">
                    <img src="${userimpl.gravatarUrl!}"/>
                    <#if userimpl == currentUser><#-- only the user themselves can change, not admins -->
                    <br/>
                    <a href="http://www.gravatar.com">Change Image</a>
                    </#if>
                </td>
            </tr>
            <tr>
                <td class="headercell">Display Name:</td>
                <td colspan="2">${userimpl.displayName!}</td>
            </tr>
            <tr>
                <td class="headercell">Email:</td>
                <td colspan="2"><a href="mailto:${userimpl.email!}">${userimpl.email!}</a></td>
            </tr>
            <tr>
                <td class="headercell">Member since (d/m/y):</td>
                <td colspan="2">${(userimpl.registrationDate)!?string("dd/MM/yyyy")}</td>
            </tr>
            <tr>
                <td class="headercell">Occupation:</td>
                <td colspan="2">${userimpl.occupation!}</td>
            </tr>
            <tr>
                <td class="headercell">Address:</td>
                <td colspan="2">${userimpl.address!}</td>
            </tr>
            <tr>
                <td class="headercell">Country:</td>
                <td colspan="2">${userimpl.country!}</td>
            </tr>
            <tr>
                <td class="headercell">Surveys:</td>
                <td colspan="2">No surveys yet</td>
            </tr>
            <tr>
                <td class="headercell">Photos:</td>
                <td colspan="2">No photos yet</td>
            </tr>
            <tr>
                <td class="headercell">Videos:</td>
                <td colspan="2">No videos yet</td>
            </tr>
            <tr>
                <td class="headercell">Community Trust:</td>
                <td colspan="2">
                    <@createReadOnlyRator communityTrust "communityTrust" true/>
                    <a onClick="jQuery('#cloudPopup').dialog('open');$('#xpower').tagcloud({type:'sphere',sizemin:8,sizemax:26,power:.2, height: 360});return false;"
                       href=".">
                        Trust Cloud
                    </a>

                    <div id="cloudPopup" title="CoralWatch Trust Cloud" style="display:none;">
                        <pre class="example" style="display:none">$("#xpower");</pre>
                        <ul id="delicious" class="xmpl">
                            <#list allUsers as user>
                            <#if user = currentUser>
                            <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                    class="tagLink" style="color:#00ff00;"
                                    href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                            </li>
                            <#elseif user = userimpl>
                            <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                    class="tagLink" style="color:#ff0000;"
                                    href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                            </li>
                            <#else>
                            <li rating="${communityTrustForAll[user.id?string]}" rel="${user.gravatarUrl!}"><a
                                    class="tagLink" style="color:#0066cc"
                                    href="${baseUrl}/users/${user.id?c}">${user.displayName}</a>
                            </li>
                            </#if>
                            </#list>
                        </ul>
                    </div>
                </td>
                <#--</#if>-->
            </tr>
            <#if userimpl != currentUser>
            <tr>
                <td class="headercell">Your Trust:</td>
                <td colspan="2">
                    <@createRator userTrust "ratings" userimpl.id "${baseUrl}/usertrust" "${baseUrl}/users/${userimpl.id?c}"/>
                </td>
            </tr>
            </#if>
            <tr>
                <td colspan="3">
                    <div id="container">
                        <div id="center-container">
                            <div id="infovis"></div>
                        </div>
                    </div>
                </td>
            </tr>

        </table>
    </div>
    <div id="fragment-2">
        <@createList "${conductedSurveys?size!} Surveys" conductedSurveys; item><a href="
            ${baseUrl}/surveys/${item.id?c}"><img src="${baseUrl}/icons/fam/survey.png"/></a> Conducted
        on ${(item.date)!?date}
        </@createList>
    </div>
</div>
