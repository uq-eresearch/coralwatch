<#-- @ftlvariable name="baseUrl" type="java.lang.String" -->
<#-- @ftlvariable name="contentTemplate" type="java.lang.String" -->
<#-- @ftlvariable name="frameData" type="au.edu.uq.itee.maenad.restlet.model.FrameData" -->
<#assign dijitTheme = "tundra" />
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <title>${frameData.title}</title>

    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="CoralWatch" content="CoralWatch">
    <meta name="description"
          content="CoralWatch is an organisation built on a research project at the University of Queensland, Brisbane, Australia. We have developed a cheap, simple, non-invasive method for the monitoring of coral bleaching, and assessment of coral health. Our Coral Health Chart is basically a series of sample colours, with variation in brightness representing different stages of bleaching/recovery, based on controlled experiments."/>
    <meta name="keyword"
          content="coralwatch, coral, feef, monitoring, bleaching, The University of Queensland, Brisbane, Australia"/>

    <link rel="icon" href="${baseUrl}/icons/favicon.ico" type="image/x-icon">
    <link rel="shortcut icon" href="${baseUrl}/icons/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="${baseUrl}/style.css"/>
    <script src="${baseUrl}/javascript/site/maxheight.js" type="text/javascript"></script>


    <link rel="stylesheet" type="text/css"
          href="http://ajax.googleapis.com/ajax/libs/dojo/1.3.1/dijit/themes/${dijitTheme}/${dijitTheme}.css"/>
    <script type="text/javascript">
        var djConfig = {
            isDebug:false, parseOnLoad:true, locale:"en"
        };
    </script>
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/dojo/1.3.1/dojo/dojo.xd.js">
        // leave separate begin+end tag, otherwise the browser will ignore
        // the next /script/ section
    </script>
    <script type="text/javascript">
        dojo.locale = "en";
        dojo.require("dojo.fx");
        dojo.require("dojo.parser");
        dojo.require("dijit.Dialog");
        dojo.require("dijit.form.Form");
        dojo.require("dijit.form.Button");
        dojo.require("dijit.form.CheckBox");
        dojo.require("dijit.form.ComboBox");
        dojo.require("dijit.form.DateTextBox");
        dojo.require("dijit.form.TimeTextBox");
        dojo.require("dijit.form.Textarea");
        dojo.require("dijit.form.TextBox");
        dojo.require("dijit.form.NumberTextBox");
        dojo.require("dijit.form.ValidationTextBox");
        dojo.require("dijit.Menu");
        dojo.require("dijit.Tooltip");
    </script>
</head>
<body class="${dijitTheme}" id="index" onload="new ElementMaxHeight();">
<div id="header_tall">
    <#if frameData.currentUser??>
        <p style="font-size: 10px; text-align:left; margin: 1px;">Logged in as <a href="${baseUrl}/users/${frameData.currentUser.id}" style="font-size: 10px;">${frameData.currentUser.displayName}</a>, <a href="${baseUrl}/logout" style="font-size: 10px;">Logout</a></p>
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
                                        <li onclick="window.location='<@navUrlTemplate/>'" class="link" width="180"><a
                                                href="<@navUrlTemplate/>">${nav.name}</a>
                                        </li>
                                    </#if>
                                </#list>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="border">
            <div class="btall">
                <div class="ltall">
                    <div class="rtall">
                        <div class="tleft">
                            <div class="tright">
                                <div class="bleft">
                                    <div class="bright">
                                        <div class="main_content">
                                            <#include "${contentTemplate}"/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="footer_banner">
            <ul class="footer_banner_list">
                <li><a href="http://www.crctourism.com.au" target="_blank">
                    <img src="${baseUrl}/images/crclogo_trans.gif" alt="Sustainable Tourism"></a></li>
                <li><a href="http://www.uq.edu.au" target="_blank">
                    <img src="${baseUrl}/images/uq_med.png" alt="The University of Queensland">
                </a></li>
                <li><a href="http://www.projectaware.org" target="_blank">
                    <img src="${baseUrl}/images/projectaware.jpg" alt="Project Aware">
                </a></li>
            </ul>
            <p class="small" style="text-align:center;"><br/>Coralwatch Supporters</p>
        </div>
        <div style=" height: 61px;"></div>
        <div id="footer">
            <div class="indent">
                <div align="center">&copy;2009 CoralWatch</div>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>