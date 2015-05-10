browserSyncInit = (baseDir, files, browser) ->
  browser = if browser == undefined then 'default' else browser
  routes = null
  if baseDir == paths.src or util.isArray(baseDir) and baseDir.indexOf(paths.src) != -1
    routes = '/bower_components': 'bower_components'
  browserSync.instance = browserSync.init(files,
    startPath: '/'
    server:
      baseDir: baseDir
      routes: routes
    browser: browser)

serve = (tmp_dir)->
  baseDir = tmp_dir + '/jekyll_site'
  browserSyncInit baseDir, [
    tmp_dir + '/jekyll_site/**/*.css'
    tmp_dir + '/jekyll_site/**/*.js'
    tmp_dir + '/jekyll_site/**/*'
    tmp_dir + '/jekyll_site/**/*.html'
  ]


'use strict'
gulp = require('gulp')
paths = gulp.paths
util = require('util')
browserSync = require('browser-sync')

gulp.task 'serve', [ 'watch' ], ->
  serve paths.tmp

gulp.task 'serve:mobile', [ 'watch-mobile' ], ->
  serve paths.mobile_tmp

gulp.task 'serve:dist', [ 'build' ], ->
  browserSyncInit paths.dist
