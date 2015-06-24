app = angular.module 'marchambul'

app.directive 'itineraire', ($timeout)->
  restrict: 'E'
  link: (scope, element, attrs)->
    $timeout ->

      map = L.map element[0],
        zoomControl: false
      .setView([48.934, 2.339], 15)

      L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
          attribution: ''
          maxZoom: 18
          id: 'marchambul.6b67e8ac'
          accessToken: 'pk.eyJ1IjoibWFyY2hhbWJ1bCIsImEiOiI5NzI1MTA5ODk4MjFlM2EwZWIwM2Y4N2JiMjI5NTE4ZiJ9.2SFijYH9C8e_tZ2WyWboEQ#4/48.86/2.35'
      .addTo(map)

      line_points = [
        [48.93571217045778, 2.3390954732894897]
        [48.93368764006013, 2.3396721482276917]
        [48.9338479844518, 2.3375773429870605]
        [48.93561702465373, 2.3376470804214478]
      ]


      polyline = L.polyline line_points,
        color: 'blue'
        weight: 2

      L.marker [48.93571217045778, 2.3390954732894897]
      .addTo(map)

      L.marker [48.9338479844518, 2.3375773429870605]
      .addTo(map)

      L.marker [48.93561702465373, 2.3376470804214478]
      .addTo(map)


      polyline.addTo(map)
    , 1000
