<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>

<portlet:defineObjects/>

<form action="<liferay-portlet:actionURL portletConfiguration="true" />" method="post" name="<portlet:namespace />fm">
    <input name="<portlet:namespace /><%=Constants.CMD%>" type="hidden" value="<%=Constants.UPDATE%>"/>

    User Page Path: <input name="<portlet:namespace />userPageUrl" type="text"
                           value="<%=renderRequest.getAttribute("userPageUrl")%>"/>
    <br/>
    <input type="button" value="Save" onClick="submitForm(document.<portlet:namespace />fm);"/>
</form>