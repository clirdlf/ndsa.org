---
title: Members List
layout: page
permalink: /members-list/
css:
  - //cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css
  - /css/bootstrap-table.min.css
javascript:
  - //cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js
  - /js/members.js
  - /js/map.js
  - /js/bootstrap-table.min.js
---

<style>
#map { height: 400px; }
</style>

<div id="map"></div>

<table id="table"
  data-toolbar="#toolbar"
  data-search="true"
  data-show-refresh="true"
  data-show-toggle="true"
  data-show-columns="true"
  data-show-export="true"
  data-detail-view="true"
  data-detail-formatter="detailFormatter"
  data-minimum-count-columns="2"
  data-show-pagination-switch="true"
  data-pagination="true"
  data-id-field="id"
  data-page-list="[10, 25, 50, 100, ALL]"
  data-show-footer="false"
  data-side-pagination="server"
  data-url="/data/members.json"
  data-response-handler="responseHandler">
</table>
