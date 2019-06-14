$(document).ready(function() {
  var Stamen_Terrain = L.tileLayer('http://stamen-tiles-{s}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.{ext}', {
      attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      subdomains: 'abcd',
      minZoom: 0,
      maxZoom: 18,
      ext: 'png'
    }),
    CartoDB_Positron = L.tileLayer('http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
      subdomains: 'abcd',
      maxZoom: 19
    });

  var map = L.map('map', {
    // center: [39.73, -104.99],
    zoom: 4,
    layers: [CartoDB_Positron, Stamen_Terrain]
  });

  var baseMaps = {
    "Positron": CartoDB_Positron,
    "Terrain": Stamen_Terrain,
  };

  L.control.layers(baseMaps).addTo(map);

  function onEachFeature(feature, layer) {
    var popupContent = '';
    if (feature.properties && feature.properties.popupContent) {
      popupContent += feature.properties.popupContent;
    }

    layer.bindPopup(popupContent);
  }

  var member_group = L.geoJson([members], {
    style: function(feature) {
      return feature.properties && feature.properties.style;
    },
    onEachFeature: onEachFeature,
    pointToLayer: function(feature, latlng) {
      return L.marker(latlng);
    }
  }).addTo(map);

  group = new L.FeatureGroup();
  group.addLayer(member_group);
  map.addLayer(group);

  map.fitBounds(group.getBounds());


});