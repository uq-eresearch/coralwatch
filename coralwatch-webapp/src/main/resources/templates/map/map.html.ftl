<table width="100%">
    <tr>
        <td width="10%" valign="top" style="background-color:#dddddd">

            <div id="sidebar">
                <h3>CoralWatch Surveys</h3>

                <form class="sidebar-form">
                    Search: <input style="width: 150px;" type="text" id="search-text" name="search-text"/>
                </form>
                <br/>
                <hr/>
                <br/><b>Filters</b><br/>

                <form class="sidebar-form">
                    Country:<br/><select style="width: 150px;" onChange="setSelectedCountryTag(this);">
                    <option selected="selected" value="">World</option>
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
                    <li><a href="#">Login</a></li>
                    <li><a href="#">Sign Up</a></li>
                    <li><a href="#">Upload Data</a></li>
                    <li><a href="#">Request Kit</a></li>
                </ul>
                <br/>
                <hr/>
                <br/><b>Legend</b><br/>
                <ul>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/purple-circle.png"/> 5 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/blue-circle.png"/> 4 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/green-circle.png"/> 3 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/yellow-circle.png"/> 2 stars
                        rating
                    </li>
                    <li style="list-style-type: none;"><img src="${baseUrl}/icons/timemap/red-circle.png"/> 1 star
                        rating
                    </li>
                </ul>
            </div>
        </td>
        <td width="90%">
            <div id="timeline" style="height: 150px; border: 1px solid #aaa"></div>
            <div id="map" style="height: 600px;"></div>
        </td>
    </tr>
</table>
