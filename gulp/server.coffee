browserSyncInit = (baseDir, files, browser) ->
  browser = if browser == undefined then 'default' else browser
  routes = '/bower_components': 'bower_components'
  browserSync.instance = browserSync.init(files,
    startPath: '/'
    server:
      baseDir: baseDir
      routes: routes
    browser: browser)

serve = (tmp_dir)->
  baseDir = tmp_dir
  browserSyncInit baseDir, [
    tmp_dir + '/**/*.css'
    tmp_dir + '/**/*.js'
    tmp_dir + '/**/*'
    tmp_dir + '/**/*.html'
  ]


'use strict'
gulp = require('gulp')
paths = gulp.paths
util = require('util')
browserSync = require('browser-sync')

gulp.task 'serve', [ 'watch' ], ->
  serve paths.tmp_site

gulp.task 'serve:dist', [ 'build' ], ->
  browserSyncInit paths.dist
