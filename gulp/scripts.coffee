'use strict'
gulp = require('gulp')
paths = gulp.paths
CONFIG = gulp.CONFIG

$ = require('gulp-load-plugins')()

coffeeConstantsFilter = $.filter('**/constants.coffee')

compileScripts = (src_pattern, tmp_dir)->
  gulp.src src_pattern
  .pipe $.plumber
    errorHandler: (err)->
      console.log 'error plumber' : err
      @emit 'end'
  #  we replace env CONFIG parameters in the constants file
  .pipe coffeeConstantsFilter
  .pipe $.replace(/CONFIG\[([^\]]*)]/g, (match, contents)-> CONFIG[contents])
  .pipe coffeeConstantsFilter.restore()
  #  End replace env CONFIG parameters in the constants file
  .pipe $.coffeelint()
  .pipe $.coffeelint.reporter()
  .pipe $.coffee()
  .on 'error', (err) ->
    console.error err.toString()
    @emit 'end'

  .pipe gulp.dest(tmp_dir + '/')
  .pipe $.size()


gulp.task 'scripts', ->
  src_pattern = [
    paths.src + '/**/*.coffee'
  ]
  compileScripts src_pattern, paths.tmp





# task used exclusively with WATCH when we are in dev mode, it is basically like the 'scripts' task but without the coffeeConstantsFilter
gulp.task 'updatescripts', ->

  gulp.src([paths.src + '/{app,components}/**/*.coffee', '!' + paths.src + '/app/**/*.mobile.coffee', '!**/constants.coffee'])
  .pipe $.plumber
    errorHandler: (err)->
      console.log 'error plumber' : err
      @emit 'end'
  .pipe $.coffeelint()
  .pipe $.coffeelint.reporter()
  .pipe $.coffee()
  .on 'error', (err) ->
    console.error err.toString()
    @emit 'end'

  .pipe gulp.dest(paths.tmp + '/')
  .pipe $.size()
