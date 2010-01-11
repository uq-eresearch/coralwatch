<table width="100%">
    <tr>
        <td width="15%" valign="top" style="background-color:#dddddd">
            <div id="help">
                <form>
                    Filter by rating: <select onChange="setSelectedTag(this);">
                    <option value="">All Stars</option>
                    <option value="1">1 Star</option>
                    <option value="2">2 Stars</option>
                    <option value="3">3 Stars</option>
                    <option value="4">4 Stars</option>
                    <option value="5">5 Stars</option>
                </select>
                </form>
            </div>
        </td>
        <td>
            <div id="timeline" style="height: 150px; border: 1px solid #aaa"></div>
            <div id="map" style="height: 600px;"></div>
        </td>
    </tr>
</table>
