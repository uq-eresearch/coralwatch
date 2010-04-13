<script type="text/javascript">
    if (document.createStyleSheet) {
        document.createStyleSheet('http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dijit/themes/tundra/tundra.css');
    } else {
        //        var styles = "@import url('http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dijit/themes/tundra/tundra.css');";
        var newSS = document.createElement('link');
        newSS.rel = 'stylesheet';
        newSS.href = 'http://ajax.googleapis.com/ajax/libs/dojo/1.3.2/dijit/themes/tundra/tundra.css';
        document.getElementsByTagName("head")[0].appendChild(newSS);
    }
</script>

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

    dojo.query("body").addClass("tundra");
</script>

<script type="text/javascript">
    dojo.addOnLoad(function() {
        dijit.byId("organisation").focus();
        updateLonFromDecimal();
        updateLatFromDecimal();
    });

    function updateLonFromDecimal() {
        var dec = dijit.byId("longitude").getValue();
        if (dec > 180) {
            dec = dec - 360;
        }
        var sign = (dec >= 0) ? 1 : -1;
        dec = dec * sign;
        var deg = Math.floor(dec);
        dec = (dec - deg) * 60;
        var min = Math.floor(dec);
        dec = (dec - min) * 60;
        var sec = Math.round(dec);
        dijit.byId("longitudeDeg").setValue(deg);
        dijit.byId("longitudeMin").setValue(min);
        dijit.byId("longitudeSec").setValue(sec);
        if (sign == 1) {
            dijit.byId("longitudeDir").setValue("E");
        } else {
            dijit.byId("longitudeDir").setValue("W");
        }
    }
    function updateLatFromDecimal() {
        var dec = dijit.byId("latitude").getValue();
        var sign = (dec >= 0) ? 1 : -1;
        dec = dec * sign;
        var deg = Math.floor(dec);
        dec = (dec - deg) * 60;
        var min = Math.floor(dec);
        dec = (dec - min) * 60;
        var sec = Math.round(dec);
        dijit.byId("latitudeDeg").setValue(deg);
        dijit.byId("latitudeMin").setValue(min);
        dijit.byId("latitudeSec").setValue(sec);
        if (sign == 1) {
            dijit.byId("latitudeDir").setValue("N");
        } else {
            dijit.byId("latitudeDir").setValue("S");
        }
    }
    function updateLonFromDegrees() {
        var deg = parseInt(dijit.byId("longitudeDeg").getValue());
        var min = parseInt(dijit.byId("longitudeMin").getValue());
        var sec = parseInt(dijit.byId("longitudeSec").getValue());
        var dec = deg + min / 60 + sec / 3600;
        if (dijit.byId("longitudeDir").getValue() == "W") {
            dec = -dec;
        }
        dijit.byId("longitude").setValue(dec);
    }
    function updateFTemperature() {
        dijit.byId("temperatureF").setValue((212 - 32) / 100 * dijit.byId("temperature").getValue() + 32);
    }
    function updateCTemperature() {
        dijit.byId("temperature").setValue(100 / (212 - 32) * (dijit.byId("temperatureF").getValue() - 32 ));
    }
    function updateLatFromDegrees() {
        var deg = parseInt(dijit.byId("latitudeDeg").getValue());
        var min = parseInt(dijit.byId("latitudeMin").getValue());
        var sec = parseInt(dijit.byId("latitudeSec").getValue());
        var dec = deg + min / 60 + sec / 3600;
        if (dijit.byId("latitudeDir").getValue() == "S") {
            dec = -dec;
        }
        dijit.byId("latitude").setValue(dec);
    }

</script>