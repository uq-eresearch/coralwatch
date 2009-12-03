<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<#-- @ftlvariable name="contentTemplate" type="java.lang.String" -->
<#-- @ftlvariable name="frameData" type="au.edu.uq.itee.maenad.restlet.model.FrameData" -->
<#assign dijitTheme = "tundra" />
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head>
    <#include "include/header.html.ftl"/>
    <#if extraHeadContent??><#include "${extraHeadContent}"></#if>
</head>
<body class="${dijitTheme}" id="index" onload="new ElementMaxHeight()">
<#if initJSOnLoad??>
<script type="text/javascript">jQuery(document).ready(init);</script>
</#if>
<div id="header_tall">
    <#if frameData.currentUser??>
    <p style="font-size: 10px; text-align:left; margin: 1px;">Logged in as <a
            href="${baseUrl}/users/${frameData.currentUser.id?c}"
            style="font-size: 10px;">${frameData.currentUser.displayName}</a>, <a href="${baseUrl}/logout"
                                                                                  style="font-size: 10px;">Logout</a>
    </p>
    </#if>
    <div id="main">
        <div id="header">
            <div class="h_logo">
                <div class="left">
                    <img alt="logo" src="${baseUrl}/images/logo_h.png"/>
                </div>
            </div>
            <div id="menu">
                <div class="rightbg">
                    <div class="leftbg">
                        <div class="padding">
                            <ul class="menu_items">
                                <#list frameData.navigationItems as nav>
                                <#if nav.url!?has_content>
                                <#assign navUrlTemplate = nav.url?interpret/>
                                <li onclick="window.location='<@navUrlTemplate/>'"
                                    class="link${nav_has_next?string('',' last')}">
                                    <a href="<@navUrlTemplate/>">${nav.name}</a>
                                </li>
                                </#if>
                                </#list>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="main_content" style="display:none;">
            <#include "${contentTemplate}"/>
        </div>
        <#include "include/footer.html.ftl"/>
    </div>
</div>
</body>
</html>