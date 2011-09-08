function updateLonFromDeg() {
    var deg1 = dijit.byId("longitudeDeg1").getValue();
    if (deg1 > 180) {
        deg1 = deg1 - 360;
    }
    
    var deg2 = Math.floor(Math.abs(deg1));
    var min2 = (Math.abs(deg1) - deg2) * 60;
    var dir2 = (deg1 >= 0) ? "E" : "W";
    
    // Fix for values appearing to be 60 in text box with 6 decimal places
    // Only integers in the range 0 to 59 are permitted by Dojo validator 
    if (min2 >= 59.9999995) {
        deg2 = deg2 + 1;
        min2 = 0;
    }
    
    dijit.byId("longitudeDeg2").setValue(deg2);
    dijit.byId("longitudeMin2").setValue(min2);
    dijit.byId("longitudeDir2").setValue(dir2);
    
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
    
    dijit.byId("longitudeDeg3").setValue(deg3);
    dijit.byId("longitudeMin3").setValue(min3);
    dijit.byId("longitudeSec3").setValue(sec3);
    dijit.byId("longitudeDir3").setValue(dir3);
}
function updateLatFromDeg() {
    var deg1 = dijit.byId("latitudeDeg1").getValue();
    
    var deg2 = Math.floor(Math.abs(deg1));
    var min2 = (Math.abs(deg1) - deg2) * 60;
    var dir2 = (deg1 >= 0) ? "N" : "S";
    
    // Fix for values appearing to be 60 in text box with 6 decimal places
    // Only integers in the range 0 to 59 are permitted by Dojo validator
    if (min2 >= 59.9999995) {
        deg2 = deg2 + 1;
        min2 = 0;
    }
    
    dijit.byId("latitudeDeg2").setValue(deg2);
    dijit.byId("latitudeMin2").setValue(min2);
    dijit.byId("latitudeDir2").setValue(dir2);
    
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
    
    dijit.byId("latitudeDeg3").setValue(deg3);
    dijit.byId("latitudeMin3").setValue(min3);
    dijit.byId("latitudeSec3").setValue(sec3);
    dijit.byId("latitudeDir3").setValue(dir3);
}
function updateLonFromDegMin() {
    var deg2 = parseInt(dijit.byId("longitudeDeg2").getValue());
    var min2 = dijit.byId("longitudeMin2").getValue();
    var dir2 = dijit.byId("longitudeDir2").getValue();
    
    var deg1 = (dir2 == "E" ? 1 : -1) * (deg2 + min2 / 60);
    dijit.byId("longitudeDeg1").setValue(deg1);
    
    var deg3 = deg2;
    var min3 = Math.floor(min2);
    var sec3 = Math.round((min2 - min3) * 60);
    var dir3 = dir2;
    dijit.byId("longitudeDeg3").setValue(deg3);
    dijit.byId("longitudeMin3").setValue(min3);
    dijit.byId("longitudeSec3").setValue(sec3);
    dijit.byId("longitudeDir3").setValue(dir3);
}
function updateLatFromDegMin() {
    var deg2 = parseInt(dijit.byId("latitudeDeg2").getValue());
    var min2 = dijit.byId("latitudeMin2").getValue();
    var dir2 = dijit.byId("latitudeDir2").getValue();
    
    var deg1 = (dir2 == "N" ? 1 : -1) * (deg2 + min2 / 60);
    dijit.byId("latitudeDeg1").setValue(deg1);
    
    var deg3 = deg2;
    var min3 = Math.floor(min2);
    var sec3 = Math.round((min2 - min3) * 60);
    var dir3 = dir2;
    dijit.byId("latitudeDeg3").setValue(deg3);
    dijit.byId("latitudeMin3").setValue(min3);
    dijit.byId("latitudeSec3").setValue(sec3);
    dijit.byId("latitudeDir3").setValue(dir3);
}
function updateLonFromDegMinSec() {
    var deg3 = parseInt(dijit.byId("longitudeDeg3").getValue());
    var min3 = parseInt(dijit.byId("longitudeMin3").getValue());
    var sec3 = parseInt(dijit.byId("longitudeSec3").getValue());
    var dir3 = dijit.byId("longitudeDir3").getValue();
    
    var deg2 = deg3;
    var min2 = min3 + sec3 * 60;
    var dir2 = dir3;
    dijit.byId("longitudeDeg2").setValue(deg2);
    dijit.byId("longitudeMin2").setValue(min2);
    dijit.byId("longitudeDir2").setValue(dir2);
    
    var deg1 = (dir3 == "E" ? 1 : -1) * (deg3 + min3 / 60 + sec3 / 3600);
    dijit.byId("longitudeDeg1").setValue(deg1);
}
function updateLatFromDegMinSec() {
    var deg3 = parseInt(dijit.byId("latitudeDeg3").getValue());
    var min3 = parseInt(dijit.byId("latitudeMin3").getValue());
    var sec3 = parseInt(dijit.byId("latitudeSec3").getValue());
    var dir3 = dijit.byId("latitudeDir3").getValue();
    
    var deg2 = deg3;
    var min2 = min3 + sec3 * 60;
    var dir2 = dir3;
    dijit.byId("latitudeDeg2").setValue(deg2);
    dijit.byId("latitudeMin2").setValue(min2);
    dijit.byId("latitudeDir2").setValue(dir2);
    
    var deg1 = (dir3 == "N" ? 1 : -1) * (deg3 + min3 / 60 + sec3 / 3600);
    dijit.byId("latitudeDeg1").setValue(deg1);
}
function getFeetAndInchesFromMetres(depth) {
    var feet = depth / 0.3048;
    var inches = (feet - Math.floor(feet)) * 12.0;
    return [Math.floor(feet), Math.round(inches)];
}
function updateDepthFeet() {
    if ((dijit.byId("depth").getValue() != null) && !isNaN(dijit.byId("depth").getValue())) {
        var feetAndInches = getFeetAndInchesFromMetres(dijit.byId("depth").getValue());
        dijit.byId("depthFeet").setValue(feetAndInches[0]);
        dijit.byId("depthInches").setValue(feetAndInches[1]);
    }
}
function updateDepthMetres() {
    if (
        ((dijit.byId("depthFeet").getValue() != null) && !isNaN(dijit.byId("depthFeet").getValue())) ||
        ((dijit.byId("depthInches").getValue() != null) && !isNaN(dijit.byId("depthInches").getValue()))
    ) {
        var feet = 0;
        if ((dijit.byId("depthFeet").getValue() != null) && !isNaN(dijit.byId("depthFeet").getValue())) {
            feet = dijit.byId("depthFeet").getValue();
        }
        var inches = 0;
        if ((dijit.byId("depthInches").getValue() != null) && !isNaN(dijit.byId("depthInches").getValue())) {
            inches = dijit.byId("depthInches").getValue();
        }
        // Don't update metres if new feet/inches match current metres.
        // Example: if current metres value is 1m, this matches 3'3" so we do nothing.
        // If we proceeded with the above example, we'd change the metres field to 0.9906m,
        // which is annoying for a user that has entered the depth in metres.
        if (((dijit.byId("depth").getValue() != null) && !isNaN(dijit.byId("depth").getValue()))) {
            var currentMetres = dijit.byId("depth").getValue();
            var currentDerivedFeetAndInches = getFeetAndInchesFromMetres(currentMetres);
            if (currentDerivedFeetAndInches[0] == feet && currentDerivedFeetAndInches[1] == inches) {
                return;
            }
        }
        var metres = 0.3048 * (feet + (inches / 12.0));
        dijit.byId("depth").setValue(metres);
    }
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
