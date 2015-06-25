'use strict'

angular.module "marchambul", [
  'ui.router'
  'ui.bootstrap.tpls'
  'ui.bootstrap.accordion'
  ]
  .config ( $stateProvider, $urlRouterProvider, $httpProvider) ->
    $stateProvider
      .state 'app',
        abstract: true

      # The home context (url: '' or '/') redirect to the page showing the applications
      .state 'app.null',
        url: ''
        onEnter: ($state)->
          $state.go 'app.home'
      .state 'app.home',
        url: '/'
        controller: 'HomeCtrl'

      # The home context (url: '' or '/') redirect to the page showing the applications
      .state 'app.vendor',
        url: '/vendors/yann'
        controller: 'HomeCtrl'
        templateUrl: '/templates/vendor.html'

    $urlRouterProvider.otherwise '/'
