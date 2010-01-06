<#if baseUrl?starts_with("http://localhost")>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<#else>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA-Y-sXcS7Cho7UUEWAL06lBQwtEFLLcTdtVnYJARPXeJhL0yKvxQD__Boj0suUIzkmUZHRHxL-cUVyw'></script>
</#if>
<script type="text/javascript">
    var saved = [];

    function MDControl() {
    }
    MDControl.prototype = new GControl();
    MDControl.prototype.initialize = function(map) {
        var container = document.createElement("div");
        var newSurveyButton = document.createElement("div");
        newSurveyButton.title = "Add new survey";
        newSurveyButton.className = "MDbuttons";
        container.appendChild(newSurveyButton);
        newSurveyButton.appendChild(document.createTextNode("New Survey"));
        GEvent.addDomListener(newSurveyButton, "click", function() {
            var center = map.getCenter();
            var zoom = map.getZoom();
            saved.splice(0, 2, center, zoom);
            alert("Saved Position: " + center.toUrlValue() + "\nZoomlevel: " + zoom);
        });

        var tosaved = document.createElement("div");
        tosaved.title = "Show surveys based on ratings";
        tosaved.className = "MDbuttons";
        container.appendChild(tosaved);
        tosaved.appendChild(document.createTextNode("Ratings"));
        GEvent.addDomListener(tosaved, "click", function() {
            if (saved.length > 0) {
                map.setZoom(saved[1]);
                map.panTo(saved[0]);
            }
        });
        map.getContainer().appendChild(container);
        return container;
    }

    MDControl.prototype.getDefaultPosition = function() {
        return new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(7, 31));
    }


    function init() {
        if (GBrowserIsCompatible()) {
            var mapDiv = document.getElementById("map");
            var map = new GMap2(mapDiv);
            map.setCenter(new GLatLng(-26, 134), 4);
            map.enableScrollWheelZoom();
            map.enableContinuousZoom();
            map.addControl(new GLargeMapControl3D());
            map.addControl(new GMapTypeControl());
            map.addMapType(G_PHYSICAL_MAP);
            map.setMapType(G_HYBRID_MAP);
            map.removeMapType(G_SATELLITE_MAP);
            map.getContainer().style.overflow = "hidden";
            map.addControl(new MDControl());
            placeMarkers(map);
        }
        else {
            alert("Sorry, the Google Maps API is not compatible with this browser");
        }
    }
    function placeMarkers(map) {
        jQuery.ajax({
            type: "GET",
            url: "${baseUrl}/markers",
            dataType: "xml",
            success: function(xml) {
                jQuery(xml).find("marker").each(function() {
                    var longitude = jQuery(this).find('longitude').text();
                    var latitude = jQuery(this).find('latitude').text();
                    var reef = jQuery(this).find('reef').text();

                    var marker = new GMarker(new GLatLng(latitude, longitude));
                    GEvent.addListener(marker, "click", function() {
                        marker.openInfoWindowHtml(reef);
                    });

                    map.addOverlay(marker);
                });
            }
        });
    }

</script>