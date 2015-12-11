$(document).ready(function() {
  var Thunderforest_SpinalMap = L.tileLayer('http://{s}.tile.thunderforest.com/spinal-map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19
  }),
    MapQuestOpen_OSM = L.tileLayer('http://otile{s}.mqcdn.com/tiles/1.0.0/{type}/{z}/{x}/{y}.{ext}', {
      type: 'map',
      ext: 'jpg',
      attribution: 'Tiles Courtesy of <a href="http://www.mapquest.com/">MapQuest</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      subdomains: '1234'
    });

    var map = L.map('map', {
      center: [39.73, -104.99],
      zoom: 4,
      layers: [Thunderforest_SpinalMap, MapQuestOpen_OSM]
  });

var baseMaps = {
  "Spinal Map": Thunderforest_SpinalMap,
  "Open Street Map": MapQuestOpen_OSM
};

L.control.layers(baseMaps).addTo(map);

function onEachFeature(feature, layer) {
  var popupContent = '';
  if (feature.properties && feature.properties.popupContent) {
    popupContent += feature.properties.popupContent;
  }

  layer.bindPopup(popupContent);
}

L.geoJson([members], {
  style: function(feature) {
    return feature.properties && feature.properties.style;
  },
  onEachFeature: onEachFeature,
  pointToLayer: function(feature, latlng) {
    return L.marker(latlng);
  }
}).addTo(map);


});
