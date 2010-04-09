<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>

<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="com.liferay.portal.kernel.util.HttpUtil" %>
<%@ page import="com.liferay.portal.kernel.util.ParamUtil" %>
<%@ page import="com.liferay.samplehibernate.model.FoodItem" %>
<%@ page import="com.liferay.samplehibernate.util.FoodItemUtil" %>

<%@ page import="javax.portlet.WindowState" %>

<%@ page import="java.util.List" %>

<portlet:defineObjects/>

<form action="<portlet:actionURL />" method="post" name="<portlet:namespace />fm">

    <%
        String cmd = ParamUtil.getString(request, Constants.CMD);

        if (cmd.equals(Constants.ADD) || cmd.equals(Constants.EDIT)) {
            long foodItemId = 0;
            String name = "";
            int points = 0;

            if (cmd.equals(Constants.EDIT)) {
                foodItemId = ParamUtil.getLong(request, "foodItemId");

                FoodItem foodItem = FoodItemUtil.getFoodItem(foodItemId);

                name = foodItem.getName();
                points = foodItem.getPoints();
            }
    %>

    <input name="<%= Constants.CMD %>" type="hidden" value="<%= HtmlUtil.escape(cmd) %>"/>
    <input name="foodItemId" type="hidden" value="<%= foodItemId %>"/>

    <table class="lfr-table">

        <%
            if (cmd.equals(Constants.EDIT)) {
        %>

        <tr>
            <td>
                Food Item ID
            </td>
            <td>
                <%= foodItemId %>
            </td>
        </tr>

        <%
            }
        %>

        <tr>
            <td>
                Name
            </td>
            <td>
                <input name="name" type="text" value="<%= name %>">
            </td>
        </tr>
        <tr>
            <td>
                Points
            </td>
            <td>
                <input name="points" type="text" value="<%= points %>">
            </td>
        </tr>
    </table>

    <br/>

    <input type="submit" value="Save"/>

    <%
        if (renderRequest.getWindowState().equals(WindowState.MAXIMIZED)) {
    %>

    <script type="text/javascript">
        document.<portlet:namespace />fm.name.focus();
    </script>
    <%
        }
    %>

    <%
    } else {
    %>

    <input name="<%= Constants.CMD %>" type="hidden" value=""/>
    <input name="foodItemId" type="hidden" value=""/>

    <input type="button" value="Add"
           onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.ADD %>" /></portlet:renderURL>';"/>

    <br/><br/>

    <table border="1" cellpadding="4" cellspacing="0" width="100%">
        <tr>
            <td>
                <b>Food Item ID</b>
            </td>
            <td>
                <b>Name</b>
            </td>
            <td>
                <b>Points</b>
            </td>
            <td>
                <b>Action</b>
            </td>
        </tr>

        <%
            List foodItems = FoodItemUtil.getFoodItems();

            for (int i = 0; i < foodItems.size(); i++) {
                FoodItem foodItem = (FoodItem) foodItems.get(i);
        %>

        <tr>
            <td>
                <%= foodItem.getFoodItemId() %>
            </td>
            <td>
                <%= foodItem.getName() %>
            </td>
            <td>
                <%= foodItem.getPoints() %>
            </td>
            <td>
                <input type="button" value="Edit"
                       onClick="self.location = '<portlet:renderURL><portlet:param name="<%= Constants.CMD %>" value="<%= Constants.EDIT %>" /><portlet:param name="foodItemId" value="<%= String.valueOf(foodItem.getFoodItemId()) %>" /></portlet:renderURL>';"/>

                <input type="button" value="Delete"
                       onClick="document.<portlet:namespace />fm.<%= Constants.CMD %>.value = '<%= Constants.DELETE %>'; document.<portlet:namespace />fm.foodItemId.value = '<%= foodItem.getFoodItemId() %>'; document.<portlet:namespace />fm.submit();"/>
            </td>
        </tr>

        <%
            }
        %>

    </table>

    <br/>

    You can also access the list of food items via the following URLs in the XSL Content portlet.

    <br/><br/>

    <%= HttpUtil.getProtocol(request) %>://<%= request.getServerName() %>
    :<%= request.getServerPort() %><%= request.getContextPath() %>/servlet/test?<%= Constants.CMD %>=getFoodItemXml<br/>
    <%= HttpUtil.getProtocol(request) %>://<%= request.getServerName() %>
    :<%= request.getServerPort() %><%= request.getContextPath() %>/view.xsl

    <%
        }
    %>

</form>