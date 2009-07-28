<div id="mapstraction" style="width: 750px; height: 600px;"></div>

<script src="http://maps.google.com/maps?file=api&v=2&key=ABQIAAAAYfI_xw3MwUbmAScWsa72VBSeiHve5IwsMuqAjxrbixTJ6mqDsxTZLbNcpVxq9PneOXm7mkBjelEQpw" type="text/javascript"></script>

<script type="text/javascript" src="${baseUrl}/javascript/mapstraction/mapstraction.js"></script>

<script type="text/javascript">
// initialise the map with your choice of API
var mapstraction = new Mapstraction('mapstraction','google');

// create a lat/lon object
var myPoint = new LatLonPoint(-23.442823,151.91519);

// display the map centered on a latitude and longitude (Google zoom levels)
mapstraction.setCenterAndZoom(myPoint, 4);
mapstraction.setMapType(Mapstraction.HYBRID);
mapstraction.addControls({
    pan: true,
    zoom: 'small',
    map_type: true
});
// create a marker positioned at a lat/lon
my_marker = new Marker(myPoint);

my_marker.setIcon('icon.gif');
mapstraction.addMarker( new Marker( new LatLonPoint(-23.442823,151.91519)));

// add a label to the marker
my_marker.setLabel("<blink>Heron Island</blink>");

var text = "<b>Heron Island</b>";

// add info bubble to the marker
my_marker.setInfoBubble(text);

// display marker
mapstraction.addMarker(my_marker);

// open the marker
my_marker.openBubble();

mapstraction.addEventListener('click', function(p) { alert('Mapstraction Event Handling - Mouse clicked at ' + p)  });

ufoo = function() { mapstraction.removeMarker(my_marker); }
</script>