<title>${frameData.title}</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="CoralWatch" content="CoralWatch"/>
<meta name="description"
      content="CoralWatch is an organisation built on a research project at the University of Queensland, Brisbane, Australia. We have developed a cheap, simple, non-invasive method for the monitoring of coral bleaching, and assessment of coral health. Our Coral Health Chart is basically a series of sample colours, with variation in brightness representing different stages of bleaching/recovery, based on controlled experiments."/>
<meta name="keyword"
      content="coralwatch, coral, feef, monitoring, bleaching, The University of Queensland, Brisbane, Australia"/>
<link rel="icon" href="${baseUrl}/icons/favicon.ico" type="image/x-icon"/>
<link rel="shortcut icon" href="${baseUrl}/icons/favicon.ico" type="image/x-icon"/>
<link rel="stylesheet" type="text/css" href="${baseUrl}/style.css"/>
<script src="${baseUrl}/javascript/site/maxheight.js" type="text/javascript"></script>

<#--JQuery Related Libraries-->
<link rel="stylesheet" type="text/css" href="http://jqueryui.com/latest/themes/base/ui.all.css"/>
<link rel="stylesheet" type="text/css" href="${baseUrl}/javascript/jquery/star-rating/css/ui.stars.css"/>
<script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery<#if !testMode??>.min</#if>.js"></script>
<script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui<#if !testMode??>.min</#if>.js"></script>
<script type="text/javascript" src="http://jqueryui.com/latest/ui/ui.tabs.js"></script>
<script type="text/javascript" src="${baseUrl}/javascript/jquery/corners/jquery.corner.js"></script>
<script type="text/javascript" src="${baseUrl}/javascript/jquery/cloud/jquery.tagcloud.min.js"></script>
<script type="text/javascript" src="${baseUrl}/javascript/jquery/qtip/jquery.qtip-1.0.0-rc3.min.js"></script>
<script type="text/javascript" src="${baseUrl}/javascript/jquery/star-rating/js/ui.stars.js"></script>

<#--Dojo Related stuff below here-->
<link rel="stylesheet" type="text/css"
      href="http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dijit/themes/${dijitTheme}/${dijitTheme}.css"/>
<script type="text/javascript">
    var djConfig = {
        isDebug:false, parseOnLoad:true, locale:"en"
    };
</script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dojo/dojo.xd.js"></script>
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
    dojo.require("dijit.layout.ContentPane");
    dojo.require("dijit.layout.TabContainer");
    dojo.require("dijit.Menu");
    dojo.require("dijit.Tooltip");
</script>
<#--Dojo stuff above here-->

<!-- JIT Library Related -->
<link type="text/css" href="../css/base.css" rel="stylesheet"/>
<link type="text/css" href="../css/Hypertree.css" rel="stylesheet"/>
<!--[if IE]><script language="javascript" type="text/javascript" src="${baseUrl}/javascript/jit/Extras/excanvas.js"></script><![endif]-->
<script language="javascript" type="text/javascript" src="${baseUrl}/javascript/jit/jit.js"></script>

<#--Page Initialisations-->
<script type="text/javascript">
    $(document).ready(function() {
        $('.main_content').corner("5px");
        $('.rounded').corner("5px");
        $('.main_content').show();
        $("#tabs").tabs();
        new ElementMaxHeight()
    <#if initJSOnLoad??>
        init();
    </#if>
    });
</script>
