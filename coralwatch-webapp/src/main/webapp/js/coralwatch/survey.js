/* Position field handling */

function round(n, d) {
    return Math.round(n * Math.pow(10, d)) / Math.pow(10, d);
}

function updatePositionFromDeg(fieldNamePrefix) {
    if (isNaN(dijit.byId(fieldNamePrefix + "Deg1").getValue())) {
        dijit.byId(fieldNamePrefix).setValue(Number.NaN);
    }
    else {
        var deg1 = dijit.byId(fieldNamePrefix + "Deg1").getValue();
        var deg = (deg1 > 180) ? (deg1 - 360) : deg1;
        dijit.byId(fieldNamePrefix).setValue(deg);
    }
    positionMarker();
}

function updatePositionFromDegMin(fieldNamePrefix, dirPos, dirNeg) {
    if (
        isNaN(dijit.byId(fieldNamePrefix + "Deg2").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Min2").getValue()) ||
        (dijit.byId(fieldNamePrefix + "Dir2").getValue() == "")
    ) {
        dijit.byId(fieldNamePrefix).setValue(Number.NaN);
    }
    else {
        var deg2 = parseInt(dijit.byId(fieldNamePrefix + "Deg2").getValue());
        var min2 = dijit.byId(fieldNamePrefix + "Min2").getValue();
        var dir2 = dijit.byId(fieldNamePrefix + "Dir2").getValue();
        var deg = (dir2 == dirPos ? 1 : -1) * (deg2 + min2 / 60);
        dijit.byId(fieldNamePrefix).setValue(deg);
    }
    positionMarker();
}

function updatePositionFromDegMinSec(fieldNamePrefix, dirPos, dirNeg) {
    if (
        isNaN(dijit.byId(fieldNamePrefix + "Deg3").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Min3").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Sec3").getValue()) ||
        (dijit.byId(fieldNamePrefix + "Dir3").getValue() == "")
    ) {
        dijit.byId(fieldNamePrefix).setValue(Number.NaN);
    }
    else {
        var deg3 = parseInt(dijit.byId(fieldNamePrefix + "Deg3").getValue());
        var min3 = parseInt(dijit.byId(fieldNamePrefix + "Min3").getValue());
        var sec3 = parseInt(dijit.byId(fieldNamePrefix + "Sec3").getValue());
        var dir3 = dijit.byId(fieldNamePrefix + "Dir3").getValue();
        var deg = (dir3 == dirPos ? 1 : -1) * (deg3 + min3 / 60 + sec3 / 3600);
        dijit.byId(fieldNamePrefix).setValue(deg);
    }
    positionMarker();
}

function onChangePositionDeg(fieldId) {
    if (isNaN(dijit.byId(fieldId).getValue())) {
        return;
    }
    
    dijit.byId("latitudeDeg2").setValue(Number.NaN);
    dijit.byId("latitudeMin2").setValue(Number.NaN);
    dijit.byId("latitudeDir2").setValue("");
    dijit.byId("longitudeDeg2").setValue(Number.NaN);
    dijit.byId("longitudeMin2").setValue(Number.NaN);
    dijit.byId("longitudeDir2").setValue("");
    
    dijit.byId("latitudeDeg3").setValue(Number.NaN);
    dijit.byId("latitudeMin3").setValue(Number.NaN);
    dijit.byId("latitudeSec3").setValue(Number.NaN);
    dijit.byId("latitudeDir3").setValue("");
    dijit.byId("longitudeDeg3").setValue(Number.NaN);
    dijit.byId("longitudeMin3").setValue(Number.NaN);
    dijit.byId("longitudeSec3").setValue(Number.NaN);
    dijit.byId("longitudeDir3").setValue("");
    
    updatePositionFromDeg("latitude");
    updatePositionFromDeg("longitude");
}

function onChangePositionDegMin(fieldId) {
    if (
        (fieldId.match(/^.*Deg2$/) && isNaN(dijit.byId(fieldId).getValue())) ||
        (fieldId.match(/^.*Min2$/) && isNaN(dijit.byId(fieldId).getValue())) ||
        (fieldId.match(/^.*Dir2$/) && (dijit.byId(fieldId).getValue() === ""))
    ) {
        return;
    }
    
    dijit.byId("latitudeDeg1").setValue(Number.NaN);
    dijit.byId("longitudeDeg1").setValue(Number.NaN);
    
    dijit.byId("latitudeDeg3").setValue(Number.NaN);
    dijit.byId("latitudeMin3").setValue(Number.NaN);
    dijit.byId("latitudeSec3").setValue(Number.NaN);
    dijit.byId("latitudeDir3").setValue("");
    dijit.byId("longitudeDeg3").setValue(Number.NaN);
    dijit.byId("longitudeMin3").setValue(Number.NaN);
    dijit.byId("longitudeSec3").setValue(Number.NaN);
    dijit.byId("longitudeDir3").setValue("");
    
    updatePositionFromDegMin("latitude", "N", "S");
    updatePositionFromDegMin("longitude", "E", "W");
}

function onChangePositionDegMinSec(fieldId) {
    if (
        (fieldId.match(/^.*Deg3$/) && isNaN(dijit.byId(fieldId).getValue())) ||
        (fieldId.match(/^.*Min3$/) && isNaN(dijit.byId(fieldId).getValue())) ||
        (fieldId.match(/^.*Sec3$/) && isNaN(dijit.byId(fieldId).getValue())) ||
        (fieldId.match(/^.*Dir3$/) && (dijit.byId(fieldId).getValue() === ""))
    ) {
        return;
    }
    
    dijit.byId("latitudeDeg1").setValue(Number.NaN);
    dijit.byId("longitudeDeg1").setValue(Number.NaN);
    
    dijit.byId("latitudeDeg2").setValue(Number.NaN);
    dijit.byId("latitudeMin2").setValue(Number.NaN);
    dijit.byId("latitudeDir2").setValue("");
    dijit.byId("longitudeDeg2").setValue(Number.NaN);
    dijit.byId("longitudeMin2").setValue(Number.NaN);
    dijit.byId("longitudeDir2").setValue("");
    
    updatePositionFromDegMinSec("latitude", "N", "S");
    updatePositionFromDegMinSec("longitude", "E", "W");
}

function onChangeDepthMetres() {
    if (isNaN(dijit.byId("depthMetres").getValue())) {
        return;
    }
    dijit.byId("depthFeet").setValue(Number.NaN);
    dijit.byId("depth").setValue(dijit.byId("depthMetres").getValue());
}
function onChangeDepthFeet() {
    if (isNaN(dijit.byId("depthFeet").getValue())) {
        return;
    }
    dijit.byId("depthMetres").setValue(Number.NaN);
    dijit.byId("depth").setValue(dijit.byId("depthFeet").getValue() * 0.3048);
}
function onChangeDepthDisabled() {
    var disabled = dijit.byId("depthDisabled").checked;
    if (disabled) {
        dijit.byId("depth").setValue(Number.NaN);
        dijit.byId("depthMetres").setValue(Number.NaN);
        dijit.byId("depthFeet").setValue(Number.NaN);
    }
    dijit.byId("depthMetres").setDisabled(disabled);
    dijit.byId("depthFeet").setDisabled(disabled);
}

function onChangeWaterTemperatureC() {
    if (isNaN(dijit.byId("waterTemperatureC").getValue())) {
        return;
    }
    dijit.byId("waterTemperatureF").setValue(Number.NaN);
    dijit.byId("waterTemperature").setValue(dijit.byId("waterTemperatureC").getValue());
}
function onChangeWaterTemperatureF() {
    if (isNaN(dijit.byId("waterTemperatureF").getValue())) {
        return;
    }
    dijit.byId("waterTemperatureC").setValue(Number.NaN);
    dijit.byId("waterTemperature").setValue(100 / (212 - 32) * (dijit.byId("waterTemperatureF").getValue() - 32));
}
function onChangeWaterTemperatureDisabled() {
    var disabled = dijit.byId("waterTemperatureDisabled").checked;
    if (disabled) {
        dijit.byId("waterTemperature").setValue(Number.NaN);
        dijit.byId("waterTemperatureC").setValue(Number.NaN);
        dijit.byId("waterTemperatureF").setValue(Number.NaN);
    }
    dijit.byId("waterTemperatureC").setDisabled(disabled);
    dijit.byId("waterTemperatureF").setDisabled(disabled);
}
