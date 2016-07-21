$(document).ready(function() {
  var Thunderforest_SpinalMap = L.tileLayer('http://{s}.tile.thunderforest.com/spinal-map/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19
  }),
  OpenStreetMap_Mapnik = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19,
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  }),
  Thunderforest_Landscape = L.tileLayer('http://{s}.tile.thunderforest.com/landscape/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  });

  var map = L.map('map', {
    center: [39.73, -104.99],
    zoom: 4,
    layers: [ Thunderforest_SpinalMap, Thunderforest_Landscape ]
  });

  var baseMaps = {
    "Spinal Map": Thunderforest_SpinalMap,
    "Open Street Map": Thunderforest_Landscape
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
