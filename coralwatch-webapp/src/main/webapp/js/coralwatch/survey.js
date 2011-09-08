/* Position field handling */

function updateCoordinateFromDeg(fieldNamePrefix, dirPos, dirNeg) {
    var deg1 = dijit.byId(fieldNamePrefix + "Deg1").getValue();
    if (deg1 > 180) {
        deg1 = deg1 - 360;
    }
    
    var deg2 = Math.floor(Math.abs(deg1));
    var min2 = (Math.abs(deg1) - deg2) * 60;
    var dir2 = (deg1 >= 0) ? dirPos : dirNeg;
    
    // Fix for values appearing to be 60 in text box with 6 decimal places
    // Only integers in the range 0 to 59 are permitted by Dojo validator 
    if (min2 >= 59.9999995) {
        deg2 = deg2 + 1;
        min2 = 0;
    }
    
    dijit.byId(fieldNamePrefix + "Deg2").setValue(deg2);
    dijit.byId(fieldNamePrefix + "Min2").setValue(min2);
    dijit.byId(fieldNamePrefix + "Dir2").setValue(dir2);
    
    var deg3 = deg2;
    var min3 = Math.floor(min2);
    var sec3 = Math.round((min2 - min3) * 60);
    var dir3 = dir2;
    
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
    
    dijit.byId(fieldNamePrefix + "Deg3").setValue(deg3);
    dijit.byId(fieldNamePrefix + "Min3").setValue(min3);
    dijit.byId(fieldNamePrefix + "Sec3").setValue(sec3);
    dijit.byId(fieldNamePrefix + "Dir3").setValue(dir3);
}
function updateLonFromDeg() {
    updateCoordinateFromDeg("longitude", "E", "W");
}
function updateLatFromDeg() {
    updateCoordinateFromDeg("latitude", "N", "S");
}
function updateCoordinateFromDegMin(fieldNamePrefix, dirPos) {
    var deg2 = parseInt(dijit.byId(fieldNamePrefix + "Deg2").getValue());
    var min2 = dijit.byId(fieldNamePrefix + "Min2").getValue();
    var dir2 = dijit.byId(fieldNamePrefix + "Dir2").getValue();
    
    var deg1 = (dir2 == dirPos ? 1 : -1) * (deg2 + min2 / 60);
    dijit.byId(fieldNamePrefix + "Deg1").setValue(deg1);
    
    var deg3 = deg2;
    var min3 = Math.floor(min2);
    var sec3 = Math.round((min2 - min3) * 60);
    var dir3 = dir2;
    dijit.byId(fieldNamePrefix + "Deg3").setValue(deg3);
    dijit.byId(fieldNamePrefix + "Min3").setValue(min3);
    dijit.byId(fieldNamePrefix + "Sec3").setValue(sec3);
    dijit.byId(fieldNamePrefix + "Dir3").setValue(dir3);
}
function updateLonFromDegMin() {
    updateCoordinateFromDegMin("longitude", "E");
}
function updateLatFromDegMin() {
    updateCoordinateFromDegMin("latitude", "N");
}
function updateCoordinateFromDegMinSec(fieldNamePrefix, dirPos) {
    var deg3 = parseInt(dijit.byId(fieldNamePrefix + "Deg3").getValue());
    var min3 = parseInt(dijit.byId(fieldNamePrefix + "Min3").getValue());
    var sec3 = parseInt(dijit.byId(fieldNamePrefix + "Sec3").getValue());
    var dir3 = dijit.byId(fieldNamePrefix + "Dir3").getValue();
    
    var deg2 = deg3;
    var min2 = min3 + sec3 * 60;
    var dir2 = dir3;
    dijit.byId(fieldNamePrefix + "Deg2").setValue(deg2);
    dijit.byId(fieldNamePrefix + "Min2").setValue(min2);
    dijit.byId(fieldNamePrefix + "Dir2").setValue(dir2);
    
    var deg1 = (dir3 == dirPos ? 1 : -1) * (deg3 + min3 / 60 + sec3 / 3600);
    dijit.byId(fieldNamePrefix + "Deg1").setValue(deg1);
}
function updateLonFromDegMinSec() {
    updateCoordinateFromDegMinSec("longitude", "E");
}
function updateLatFromDegMinSec() {
    updateCoordinateFromDegMinSec("latitude", "N");
}

/* Depth field handling */

function getFeetAndInchesFromMetres(metres) {
    var feet = metres / 0.3048;
    var inches = (feet - Math.floor(feet)) * 12.0;
    return [Math.floor(feet), Math.round(inches)];
}
// Check whether depth field values "match".
// Example: if current metres value is 1m, this is said to match 3'3".
// If we did a conversion from feet/inches to metres, we'd get 0.9906m,
// which would be annoying for a user that entered the depth in metres.
function areDepthFieldsConsistent() {
    var metres = 0;
    if (((dijit.byId("depth").getValue() != null) && !isNaN(dijit.byId("depth").getValue()))) {
        metres = dijit.byId("depth").getValue();
    }
    var feet = 0;
    if ((dijit.byId("depthFeet").getValue() != null) && !isNaN(dijit.byId("depthFeet").getValue())) {
        feet = dijit.byId("depthFeet").getValue();
    }
    var inches = 0;
    if ((dijit.byId("depthInches").getValue() != null) && !isNaN(dijit.byId("depthInches").getValue())) {
        inches = dijit.byId("depthInches").getValue();
    }
    var derivedFeetAndInches = getFeetAndInchesFromMetres(metres);
    return (derivedFeetAndInches[0] == feet && derivedFeetAndInches[1] == inches);
}
function updateDepthFeet() {
    if (areDepthFieldsConsistent()) {
        return;
    }
    var metres = 0;
    if ((dijit.byId("depth").getValue() != null) && !isNaN(dijit.byId("depth").getValue())) {
        metres = dijit.byId("depth").getValue();
    }
    var feetAndInches = getFeetAndInchesFromMetres(metres);
    dijit.byId("depthFeet").setValue(feetAndInches[0]);
    dijit.byId("depthInches").setValue(feetAndInches[1]);
}
function updateDepthMetres() {
    if (areDepthFieldsConsistent()) {
        return;
    }
    var feet = 0;
    if ((dijit.byId("depthFeet").getValue() != null) && !isNaN(dijit.byId("depthFeet").getValue())) {
        feet = dijit.byId("depthFeet").getValue();
    }
    var inches = 0;
    if ((dijit.byId("depthInches").getValue() != null) && !isNaN(dijit.byId("depthInches").getValue())) {
        inches = dijit.byId("depthInches").getValue();
    }
    var metres = 0.3048 * (feet + (inches / 12.0));
    dijit.byId("depth").setValue(metres);
}
function updateFTemperature() {
    if ((dijit.byId("watertemperature").getValue() != null) && !isNaN(dijit.byId("watertemperature").getValue())) {
        dijit.byId("temperatureF").setValue((212 - 32) / 100 * dijit.byId("watertemperature").getValue() + 32);
    }
}
function updateCTemperature() {
    if ((dijit.byId("temperatureF").getValue() != null) && !isNaN(dijit.byId("temperatureF").getValue())) {
        dijit.byId("watertemperature").setValue(100 / (212 - 32) * (dijit.byId("temperatureF").getValue() - 32 ));
    }
}
