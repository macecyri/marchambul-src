'use strict'
gulp = require('gulp')
paths = gulp.paths
$ = require('gulp-load-plugins')(pattern: [
  'gulp-*'
  'main-bower-files'
  'uglify-save-license'
  'del'
])
wiredep = require('wiredep').stream

inject = (src_pattern, exclude_bower_libraries, tmp_dir, dest_file)->
  # we want to inject in index.html all css files but vendor.css (already injected)
  injectStyles = gulp.src([
    tmp_dir + '/**/*.css'
    '!' + tmp_dir + '/vendor.css'
  ], read: false)

  # we want to inject in index.html all js files but test files and sort them with angularFilesort()
  injectScripts = gulp.src(tmp_dir + '/**/*.js')
  .pipe $.angularFilesort()

  injectOptions =
    ignorePath: [
      paths.src
      tmp_dir
    ]
    addRootSlash: false

  wiredepOptions =
    directory: 'bower_components'
    exclude: exclude_bower_libraries
    #cwd: './'

  # we want to inject into index.html:
  # - src styles (injectStyles)
  # - src scripts (injectScripts) into index.html all js files but test files and sort them with angularFilesort()
  # - bower scripts and css (but bootstrap-sass)
  gulp.src(paths.src + src_pattern)
  .pipe $.inject(injectStyles, injectOptions)
  .pipe $.inject(injectScripts, injectOptions)
  .pipe wiredep(wiredepOptions)
  .pipe gulp.dest(tmp_dir)


gulp.task 'assets', ->
  gulp.src(paths.src + '/assets/**/*')
  .pipe gulp.dest(paths.tmp + '/')

gulp.task 'inject', ['styles','assets','scripts'], ->
  exclude_bower_libraries = [
    /bootstrap-sass-official/
    /bootstrap-additions/
    /bootstrap\.css/
    /bootstrap\.css/
  ]
  inject '/**/*.html', exclude_bower_libraries, paths.tmp
