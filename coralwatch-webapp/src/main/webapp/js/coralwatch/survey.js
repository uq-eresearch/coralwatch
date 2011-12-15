/* Position field handling */

function round(n, d) {
    return Math.round(n * Math.pow(10, d)) / Math.pow(10, d);
}
function getDegMinDirFromDeg(deg, dirPos, dirNeg) {
    var deg2 = Math.floor(Math.abs(deg));
    var min2 = (Math.abs(deg) - deg2) * 60;
    var dir2 = (deg >= 0) ? dirPos : dirNeg;
    
    // Fix for values appearing to be 60 in text box with 6 decimal places
    // Only integers in the range 0 to 59 are permitted by Dojo validator 
    if (min2 >= 59.9999995) {
        deg2 = deg2 + 1;
        min2 = 0;
    }

    return {deg2: deg2, min2: min2, dir2: dir2};
}
function getDegMinSecDirFromDeg(deg, dirPos, dirNeg) {
    var degMinDir = getDegMinDirFromDeg(deg, dirPos, dirNeg);
    
    var deg3 = degMinDir.deg2;
    var min3 = Math.floor(degMinDir.min2);
    var sec3 = Math.round((degMinDir.min2 - min3) * 60);
    var dir3 = degMinDir.dir2;
    
    // Fix for values appearing to be 60 in text box with 6 decimal places
    // Only integers in the range 0 to 59 are permitted by Dojo validator
    if (sec3 >= 59.9999995) {
        min3 = min3 + 1;
        sec3 = 0;
    }
    if (min3 >= 59.9999995) {
        deg3 = deg3 + 1;
        min3 = 0;
    }
    
    return {deg3: deg3, min3: min3, sec3: sec3, dir3: dir3};
}
function updateCoordinateFromHidden(fieldNamePrefix, dirPos, dirNeg) {
    if (isNaN(dijit.byId(fieldNamePrefix + "Hidden").getValue())) {
        return;
    }
    var hidden = dijit.byId(fieldNamePrefix + "Hidden").getValue();
    
    var degMinDir = getDegMinDirFromDeg(hidden, dirPos, dirNeg);
    var degMinSecDir = getDegMinSecDirFromDeg(hidden, dirPos, dirNeg);

    dijit.byId(fieldNamePrefix + "Deg1").setValue(round(hidden, 6));
    
    dijit.byId(fieldNamePrefix + "Deg2").setValue(degMinDir.deg2);
    dijit.byId(fieldNamePrefix + "Min2").setValue(round(degMinDir.min2, 4));
    dijit.byId(fieldNamePrefix + "Dir2").setValue(degMinDir.dir2);
    
    dijit.byId(fieldNamePrefix + "Deg3").setValue(degMinSecDir.deg3);
    dijit.byId(fieldNamePrefix + "Min3").setValue(degMinSecDir.min3);
    dijit.byId(fieldNamePrefix + "Sec3").setValue(degMinSecDir.sec3);
    dijit.byId(fieldNamePrefix + "Dir3").setValue(degMinSecDir.dir3);
}
function updateLonFromHidden() {
    updateCoordinateFromHidden("longitude", "E", "W");
}
function updateLatFromHidden() {
    updateCoordinateFromHidden("latitude", "N", "S");
}

function updateCoordinateFromDeg(fieldNamePrefix, dirPos, dirNeg) {
    if (isNaN(dijit.byId(fieldNamePrefix + "Deg1").getValue())) {
        return;
    }
    var deg1 = dijit.byId(fieldNamePrefix + "Deg1").getValue();
    if (deg1 > 180) {
        deg1 = deg1 - 360;
    }
    var hidden = dijit.byId(fieldNamePrefix + "Hidden").getValue();
    if (isNaN(hidden) || (deg1 != round(hidden, 6))) {
        dijit.byId(fieldNamePrefix + "Hidden").setValue(deg1);
    }
}
function updateLonFromDeg() {
    updateCoordinateFromDeg("longitude", "E", "W");
}
function updateLatFromDeg() {
    updateCoordinateFromDeg("latitude", "N", "S");
}
function updateCoordinateFromDegMin(fieldNamePrefix, dirPos, dirNeg) {
    if (
        isNaN(dijit.byId(fieldNamePrefix + "Deg2").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Min2").getValue()) ||
        (dijit.byId(fieldNamePrefix + "Dir2").getValue() == "")
    ) {
        return;
    }
    var deg2 = parseInt(dijit.byId(fieldNamePrefix + "Deg2").getValue());
    var min2 = dijit.byId(fieldNamePrefix + "Min2").getValue();
    var dir2 = dijit.byId(fieldNamePrefix + "Dir2").getValue();
    
    var hidden = dijit.byId(fieldNamePrefix + "Hidden").getValue();
    var degMinDirFromHidden = getDegMinDirFromDeg(hidden, dirPos, dirNeg);

    if (
        deg2 != degMinDirFromHidden.deg2 ||
        min2 != round(degMinDirFromHidden.min2, 4) ||
        dir2 != degMinDirFromHidden.dir2
    ) {
        var deg = (dir2 == dirPos ? 1 : -1) * (deg2 + min2 / 60);
        dijit.byId(fieldNamePrefix + "Hidden").setValue(deg);
    }
}
function updateLonFromDegMin() {
    updateCoordinateFromDegMin("longitude", "E", "W");
}
function updateLatFromDegMin() {
    updateCoordinateFromDegMin("latitude", "N", "S");
}
function updateCoordinateFromDegMinSec(fieldNamePrefix, dirPos, dirNeg) {
    if (
        isNaN(dijit.byId(fieldNamePrefix + "Deg3").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Min3").getValue()) ||
        isNaN(dijit.byId(fieldNamePrefix + "Sec3").getValue()) ||
        (dijit.byId(fieldNamePrefix + "Dir3").getValue() == "")
    ) {
        return;
    }
    var deg3 = parseInt(dijit.byId(fieldNamePrefix + "Deg3").getValue());
    var min3 = parseInt(dijit.byId(fieldNamePrefix + "Min3").getValue());
    var sec3 = parseInt(dijit.byId(fieldNamePrefix + "Sec3").getValue());
    var dir3 = dijit.byId(fieldNamePrefix + "Dir3").getValue();
    
    var hidden = dijit.byId(fieldNamePrefix + "Hidden").getValue();
    var degMinSecDirFromHidden = getDegMinSecDirFromDeg(hidden, dirPos, dirNeg);
    
    if (
        deg3 != degMinSecDirFromHidden.deg3 ||
        min3 != degMinSecDirFromHidden.min3 ||
        sec3 != degMinSecDirFromHidden.sec3 ||
        dir3 != degMinSecDirFromHidden.dir3
    ) {
        var deg = (dir3 == dirPos ? 1 : -1) * (deg3 + min3 / 60 + sec3 / 3600);
        dijit.byId(fieldNamePrefix + "Hidden").setValue(deg);
    }
}
function updateLonFromDegMinSec() {
    updateCoordinateFromDegMinSec("longitude", "E", "W");
}
function updateLatFromDegMinSec() {
    updateCoordinateFromDegMinSec("latitude", "N", "S");
}

/* Depth field handling */

function getFeetFromMetres(metres) {
    return metres / 0.3048;
}
function getMetresFromFeet(feet) {
	return 0.3048 * feet;
}
// Check whether depth field values "match".
// Example: if current metres value is 1m, this is said to match 3'3".
// If we did a conversion from feet/inches to metres, we'd get 0.9906m,
// which would be annoying for a user that entered the depth in metres.
function areDepthFieldsConsistent() {
    var metres = 0;
    if (!isNaN(dijit.byId("depth").getValue())) {
        metres = dijit.byId("depth").getValue();
    }
    var feet = 0;
    if (!isNaN(dijit.byId("depthFeet").getValue())) {
        feet = dijit.byId("depthFeet").getValue();
    }
    var derivedFeet = getFeetFromMetres(metres);
    return derivedFeet == feet;
}
function updateDepthFeet() {
    if (areDepthFieldsConsistent()) {
        return;
    }
    var metres = 0;
    if (!isNaN(dijit.byId("depth").getValue())) {
        metres = dijit.byId("depth").getValue();
    }
    var feet = getFeetFromMetres(metres);
    dijit.byId("depthFeet").setValue(feet);
}
function updateDepthMetres() {
    if (areDepthFieldsConsistent()) {
        return;
    }
    var feet = 0;
    if (!isNaN(dijit.byId("depthFeet").getValue())) {
        feet = dijit.byId("depthFeet").getValue();
    }
    var metres = getMetresFromFeet(feet);
    dijit.byId("depth").setValue(metres);
}
function updateFTemperature() {
    if (!isNaN(dijit.byId("watertemperature").getValue())) {
        dijit.byId("temperatureF").setValue((212 - 32) / 100 * dijit.byId("watertemperature").getValue() + 32);
    }
}
function updateCTemperature() {
    if (!isNaN(dijit.byId("temperatureF").getValue())) {
        dijit.byId("watertemperature").setValue(100 / (212 - 32) * (dijit.byId("temperatureF").getValue() - 32 ));
    }
}
