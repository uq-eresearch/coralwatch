<%@ page import="org.coralwatch.dataaccess.KitRequestDao" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet" %>
<portlet:defineObjects/>
<%
    KitRequestDao kitRequestDao = (KitRequestDao) renderRequest.getPortletSession().getAttribute("kitrequestdao");
%>
<h3>Kit Request</h3>

<p>Number of kit requests <%= kitRequestDao.getAll().size() %>
</p>

<form action="<portlet:actionURL/>" method="post" name="<portlet:namespace />fm">
    <table>
        <tr>
            <td width="10%"><label for="address">Address</label></td>
            <td width="90%"><input class="stretched" type="text" name="address" id="address"/></td>
        </tr>
        <tr>
            <td><label for="notes">Notes</label></td>
            <td><input class="stretched" type="text" name="notes" id="notes"/></td>
        </tr>
        <tr>
            <td colspan="2"><textarea cols="80" rows="5" readonly="readonly" name="conditions" id="conditions">Terms and
                conditions here.</textarea></td>
        </tr>
        <tr>
            <td colspan="2"><input type="checkbox" name="agreement" id="agreement"/><label> I agree to the terms and
                conditions.</label></td>
        </tr>
        <tr>
            <td colspan="2"><input type="submit" name="submit" value="Submit"/></td>
        </tr>
    </table>
</form>