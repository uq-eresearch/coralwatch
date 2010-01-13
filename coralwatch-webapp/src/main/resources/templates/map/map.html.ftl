<table width="100%">
    <tr>
        <td width="10%" valign="top" style="background-color:#dddddd">

            <div id="sidebar">
                <h3>CoralWatch Surveys</h3>

                <form class="sidebar-form" onsubmit="findLocation(); return false;">
                    Find Location: <input style="width: 150px;" type="text" id="search-text" name="search-text"/>
                </form>
                <br/>
                <ul>
                <#if currentUser??>
                    <li><a href="${baseUrl}/users">${users?size} Coral Watchers</a></li>
                    <li><a href="${baseUrl}/reef">${reefList?size} Coral Reefs</a></li>
                    <li><a href="${baseUrl}/surveys">${surveys?size} Surveys</a></li>
                    <#else>
                        <li>${users?size} Coral Watchers</li>
                        <li>${reefList?size} Coral Reefs</li>
                        <li>${surveys?size} Surveys</li>
                </#if>
                </ul>
                <br/>
                <hr/>
                <br/><b>Filters</b><br/>

                <form class="sidebar-form">
                    Country:<br/><select style="width: 150px;" onChange="setSelectedCountryTag(this);">
                    <option selected="selected" value="">All Countries</option>
                <#include "../macros/countrylist.html.ftl"/>
                </select>
                </form>
                <form class="sidebar-form">
                    Reef Name:<br/><select style="width: 150px;" onChange="setSelectedReefTag(this);">
                    <option value="">All Reefs</option>
                <#list reefList as item>
                    <option value="${item.name!}">${item.name!}</option>
                </#list>
                </select>
                </form>
                <form class="sidebar-form">
                    Rating:<br/><select style="width: 150px;" onChange="setSelectedRatingTag(this);">
                    <option value="">All Stars</option>
                    <option value="1">1 Star</option>
                    <option value="2">2 Stars</option>
                    <option value="3">3 Stars</option>
                    <option value="4">4 Stars</option>
                    <option value="5">5 Stars</option>
                </select>
                </form>
                <br/>
                <hr/>
                <br/><b>Options</b><br/>
                <ul>
                <#if currentUser??>
                    <li><a href="${baseUrl}/dashboard">Dashboard</a></li>
                    <li><a href="${baseUrl}/surveys?new">Upload Data</a></li>
                    <li><a href="${baseUrl}/kit?new">Request Kit</a></li>
                    <#else>
                        <li><a href="${baseUrl}/login?redirectUrl=${baseUrl}/dashboard">Login</a></li>
                        <li><a href="${baseUrl}/login?redirectUrl=${baseUrl}/dashboard">Sign Up</a></li>
                        <li><a href="${baseUrl}/login?redirectUrl=${baseUrl}/surveys?new">Upload Data</a></li>
                        <li><a href="${baseUrl}/login?redirectUrl=${baseUrl}/kit?new">Request Kit</a></li>
                </#if>
                </ul>
                <br/>
                <hr/>
                <br/><b>Legend</b><br/>
                <ul>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/purple-circle.png"
                                                            alt="5 Stars Rating"/> 5 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/blue-circle.png"
                                                            alt="4 Stars Rating"/> 4 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/green-circle.png"
                                                            alt="3 Stars Rating"/> 3 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/yellow-circle.png"
                                                            alt="2 Stars Rating"/> 2 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/red-circle.png"
                                                            alt="1 Star Rating"/> 1 star
                        rating
                    </li>
                </ul>
                <br/>
                <hr/>
                <br/><b>Updates on</b><br/><br/>

                <div>
                    <a href="http://twitter.com/coralwatch"><img src="${baseUrl}/icons/twitter/twitter.png"
                                                                 alt="Joing CoralWatch on Twitter"/></a>
                    <a href="http://www.facebook.com/"><img src="${baseUrl}/icons/facebook/facebook.png"
                                                            alt="Joing CoralWatch on Facebook"/></a>
                </div>

            </div>
        </td>
        <td width="90%">
            <div id="timeline" style="height: 150px; border: 1px solid #aaa"></div>
            <div id="map" style="height: 650px;"></div>
        </td>
    </tr>
</table>
