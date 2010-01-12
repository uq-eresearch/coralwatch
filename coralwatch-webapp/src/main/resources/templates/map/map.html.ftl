<table width="100%">
    <tr>
        <td width="20%" valign="top" style="background-color:#dddddd">

            <div id="sidebar">
                <h3>CoralWatch Surveys</h3>

                <form class="sidebar-form">
                    Search: <input type="text" id="search-text" name="search-text"/>
                </form>
                <br/>
                <hr/>
                <br/><b>Filters</b><br/>

                <form class="sidebar-form">
                    Country: <select onChange="setSelectedCountryTag(this);">
                    <option selected="selected" value="">World</option>
                    <#include "../macros/countrylist.html.ftl"/>
                </select>
                </form>
                <form class="sidebar-form">
                    Reef Name: <select onChange="setSelectedReefTag(this);">
                    <option value="">All Reefs</option>
                    <option value="1">1 Star</option>
                    <option value="2">2 Stars</option>
                    <option value="3">3 Stars</option>
                    <option value="4">4 Stars</option>
                    <option value="5">5 Stars</option>
                </select>
                </form>
                <form class="sidebar-form">
                    Rating: <select onChange="setSelectedRatingTag(this);">
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
            </div>
        </td>
        <td>
            <div id="timeline" style="height: 150px; border: 1px solid #aaa"></div>
            <div id="map" style="height: 600px;"></div>
        </td>
    </tr>
</table>
