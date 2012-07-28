$(document).ready ->
  $('.map').each ->
    container = $(this)
    map = new L.Map this, zoomControl: false

    # NOTE: Do not use tile.openstreetmap.org for production
    osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    osmAttrib = 'Map data ©OpenStreetMap and contributors'

    osm = new L.TileLayer osmUrl, minZoom: 1, maxZoom: 18, attribution: osmAttrib

    center = new L.LatLng(container.attr('data-lat'), container.attr('data-lng'))

    map.setView center, 16
    map.addLayer osm
    map.attributionControl.setPrefix ''

    marker = new L.Marker(center)
    map.addLayer marker
