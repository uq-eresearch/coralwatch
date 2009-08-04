<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<ul>
    <li><a href="${baseUrl}/logout">Logout</a></li>
    <li><a href="${baseUrl}/users">All Users</a></li>
    <li><a href="${baseUrl}/surveys">All Surveys</a></li>
    <li><a href="${baseUrl}/users/${frameData.currentUser.id}">My Profile</a></li>
    <li><a href="${baseUrl}/surveys?new">New Survey</a></li>
    <#if frameData.currentUser.superUser>
    <li><a href="${baseUrl}/kit">All Kit Requests</a></li>
    </#if>
    <li><a href="${baseUrl}/kit?new">Request a kit</a></li>
    <#if frameData.currentUser.superUser>
    <li><a href="${baseUrl}/reef">All Reefs</a></li>
    <li><a href="${baseUrl}/reef?new">Add new reef name</a></li>
    <li><a href="${baseUrl}/data">Download database</a></li>
    <#if testMode>
    <li>Database upload:
	    <div dojoType="dijit.form.Form" method="post" action="${baseUrl}/data"
	         enctype="multipart/form-data">
	        <script type="dojo/method" event="onSubmit">
	            if(!this.validate()){
	                alert('Form contains invalid data.  Please correct first');
	                return false;
	            }
	            return true;
	        </script>
	        <table>
	            <tr>
	                <th><label for="resetData">Reset Data:</label></th>
	                <td><input type="checkbox" id="resetData" name="resetData" dojoType="dijit.form.CheckBox"/></td>
	            </tr>
	            <tr>
	                <th><label for="upfile">File:</label></th>
	                <td><input type="file" id="upfile" name="upfile" dojoType="dijit.form.TextBox"/></td>
	            </tr>
	        </table>
	        <button dojoType="dijit.form.Button" type="submit">Upload</button>
	    </div>
	</li>
    </#if>
    </#if>
</ul>