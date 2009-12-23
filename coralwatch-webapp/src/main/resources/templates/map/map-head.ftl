<#if baseUrl?starts_with("http://localhost")>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<#else>
<script type="text/javascript"
        src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA-Y-sXcS7Cho7UUEWAL06lBQwtEFLLcTdtVnYJARPXeJhL0yKvxQD__Boj0suUIzkmUZHRHxL-cUVyw'></script>
</#if>
<script type="text/javascript">
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