angular.module "marchambul"
  .controller "CarteCtrl", ($scope, $http) ->

    map = L.map('map').setView([48.874, 2.37], 12)

    L.tileLayer 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}',
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>'
        maxZoom: 18
        id: 'marchambul.6b67e8ac'
        accessToken: 'pk.eyJ1IjoibWFyY2hhbWJ1bCIsImEiOiI5NzI1MTA5ODk4MjFlM2EwZWIwM2Y4N2JiMjI5NTE4ZiJ9.2SFijYH9C8e_tZ2WyWboEQ#4/48.86/2.35'
    .addTo(map)

    marchambulIcon = L.icon
      iconUrl: 'img/marchambul-icon.png'

    $http.get("api/tournees.json").then (res)->
      console.log "res", res
      for tournee in res.data
        popup = L.popup
          closeButton: false
          maxWidth: 500
          minWidth: 200
          className: 'custom-popup'

        popup.setContent(tournee.content)

        L.marker [48.874, 2.37],
          icon: marchambulIcon
        .addTo(map)
        .bindPopup(popup)
        .openPopup()

      L.marker [48.852969123136646, 2.39244],
        icon: marchambulIcon
      .addTo(map)

      L.marker [48.8284, 2.3730],
        icon: marchambulIcon
      .addTo(map)

    console.log "tttddddd"


    # marker1.on 'mouseover', ->
    #   this.openPopup()
    #
    # marker1.on 'mouseout', ->
    #     this.closePopup()
