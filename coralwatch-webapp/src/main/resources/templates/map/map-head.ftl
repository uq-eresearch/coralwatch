<script src="http://openlayers.org/api/OpenLayers.js" type="text/javascript"></script>
<script src="http://api.maps.yahoo.com/ajaxymap?v=3.0&amp;appid=b_nhTtDV34FNyIf6NLQW9XqlE_al3Ngb7arZwVXevjhLQv3yQq1wDioFmty818N34pE-"
        type="text/javascript"></script>
<#if fullUI>
<script src='http://dev.virtualearth.net/mapcontrol/mapcontrol.ashx?v=6.1'></script>
<#if baseUrl?starts_with("http://localhost")>
<script src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAAjpkAC9ePGem0lIq5XcMiuhR_wWLPFku8Ix9i2SXYRVK3e45q1BQUd_beF8dtzKET_EteAjPdGDwqpQ'></script>
<#else>
<script src='http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAA-Y-sXcS7Cho7UUEWAL06lBQwtEFLLcTdtVnYJARPXeJhL0yKvxQD__Boj0suUIzkmUZHRHxL-cUVyw'></script>
</#if>
</#if>
<script type="text/javascript">

    var projSM = new OpenLayers.Projection("EPSG:900913");
    var projWGS = new OpenLayers.Projection("EPSG:4326");
    var bounds = new OpenLayers.Bounds(101.60156, -44.68428, 167.34375, -2.241628);
    bounds.transform(projWGS, projSM);

    var styleMap = new OpenLayers.StyleMap({
        strokeColor: "black",
        strokeWidth: 2,
        strokeOpacity: 0.5,
        fillOpacity: 0.4,
        cursor: "pointer"
    });
    var map;
    function init() {
        var options = {
            controls: [],
            projection: projSM,
            displayProjection: projWGS,
            units: "m",
            numZoomLevels: 18,
            maxResolution: 156543.0339,
            maxExtent: new OpenLayers.Bounds(-20037508, -20037508, 20037508, 20037508.34)
        };
        map = new OpenLayers.Map('openlayersmap', options);
        var ghyb = new OpenLayers.Layer.Google("Google Hybrid", {type: G_HYBRID_MAP, sphericalMercator: true});
        map.addLayer(ghyb);
    <#if fullUI>
        var vehybrid = new OpenLayers.Layer.VirtualEarth("VirtualEarth Hybrid", {type: VEMapStyle.Hybrid, sphericalMercator: true});
        map.addLayer(vehybrid);
        var yhyb = new OpenLayers.Layer.Yahoo("Yahoo Hybrid", {type: YAHOO_MAP_HYB, sphericalMercator: true});
        map.addLayer(yhyb);
    </#if>

    <#if fullUI>
        map.addControl(new OpenLayers.Control.Navigation());
        map.addControl(new OpenLayers.Control.PanZoomBar());
        map.addControl(new OpenLayers.Control.LayerSwitcher({'ascending':false}));
        map.addControl(new OpenLayers.Control.MousePosition());
        map.addControl(new OpenLayers.Control.KeyboardDefaults());
    </#if>
        if (!map.getCenter()) {
            map.zoomToExtent(bounds);
        }
    }

</script>