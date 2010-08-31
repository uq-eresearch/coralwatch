<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>
<%@ page import="com.liferay.portal.kernel.util.Constants" %>

<portlet:defineObjects/>

<form action="<liferay-portlet:actionURL portletConfiguration="true" />" method="post" name="<portlet:namespace />fm">
    <input name="<portlet:namespace /><%=Constants.CMD%>" type="hidden" value="<%=Constants.UPDATE%>"/>

    User Page Path: <input name="<portlet:namespace />userUrl" type="text"
                           value="<%=renderRequest.getAttribute("userUrl")%>"/>
    <br/>
    Survey Page Path: <input name="<portlet:namespace />surveyUrl" type="text"
                             value="<%=renderRequest.getAttribute("surveyUrl")%>"/>
    <b/>
    Reef Page Path: <input name="<portlet:namespace />reefUrl" type="text"
                           value="<%=renderRequest.getAttribute("reefUrl")%>"/>
    <br/>
    <input type="button" value="Save" onClick="submitForm(document.<portlet:namespace />fm);"/>
</form>