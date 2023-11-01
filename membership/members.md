---
title: Members of NDSA
layout: page
permalink: /membership/members/
redirect_from: /members-list/
css:
- https://unpkg.com/leaflet@1.5.1/dist/leaflet.css
- https://unpkg.com/bootstrap-table@1.14.2/dist/bootstrap-table.min.css
javascript:
- https://unpkg.com/leaflet@1.5.1/dist/leaflet.js
- /data/member_map.js
- /js/map.js
- https://unpkg.com/bootstrap-table@1.14.2/dist/bootstrap-table.min.js
---
<p>Browse the list of members using the table.  Search or sort to find a particular organization.</p>
<p>NDSA is hoping to replace the graphical map that was previously available. We appreciate your patience. Stay tuned!</p>
<!--
<style>
  #map {
    height: 400px;
  }
</style>
-->

<div id="map"></div>



<table data-toggle="table" data-search="true" data-page-size="25" data-pagination="true" data-url="{{ '/data/members.json' | prepend: site.base_url }}">
  <thead>
    <tr>
      <th data-field="organization" data-sortable="true">Organization</th>
      <th data-field="state" data-sortable="true">
        Region
      </th>
      <th data-field="focus" data-sortable="true">
        Digital Preservation Focus
      </th>
    </tr>
  </thead>
</table>

<!--
<table class="searchable sortable">
 <thead>
   <tr>
     <th>Organization</th>
     <th>Region</th>
     <th>Digital Preservation Focus</th>
  </tr>
 </thead>
 <tbody>
   <tr>
    <td>CLOCKSS</td>
    <td>CA</td>
    <td>Distributed storeage and more</td>
  </tr>
    <tr>
    <td>Wisconsin Historical Society</td>
    <td>WI</td>
    <td>Government Information and more</td>
  </tr>
  </tr>
    <tr>
    <td>Wayne State Universtiy Student Chapter</td>
    <td>MI</td>
    <td>Student stuff</td>
  </tr>
  </tr>
    <tr>
    <td>AP Trust</td>
    <td>VA</td>
    <td>Lots of stuff</td>
  </tr>
  </tbody>
  -->