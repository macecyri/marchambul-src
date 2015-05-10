'use strict'
gulp = require('gulp')
paths = gulp.paths
$ = require('gulp-load-plugins')(pattern: [
  'gulp-*'
  'main-bower-files'
  'uglify-save-license'
  'del'
])

gulp.task 'watch', ['markups','injectandjekyll', 'localfonts'], ->
  #  we call the 'inject' task each time a html/scss/js/coffee file is changed
  gulp.watch 'bower.json', [ 'inject' ]
  #  we call the 'markups' task each time a jade file is changed
  gulp.watch paths.src + '/**/*.jade', [ 'markups' ]
  #  we call the 'styles' task each time a scss file is changed
  gulp.watch paths.src + '/**/*.scss', [ 'styles' ]
  #  we call the 'scripts' task each time a coffee file is changed
  gulp.watch paths.src + '/**/*.coffee', [ 'updatescripts' ]



gulp.task 'jekyll', (gulpCallBack)->
  console.log "build JEKYLL"
  exec = require('child_process').exec
  jekyllCommand = "jekyll build  --source #{paths.tmp}/jekyll_src --destination #{paths.tmp}/jekyll_site --watch"

  exec jekyllCommand, (err, stdout, stderr)->
    console.log stdout


gulp.task 'injectandjekyll', ->
  $.runSequence 'inject', 'jekyll'


gulp.task 'localfonts', ->
  gulp.src $.mainBowerFiles()
  .pipe $.filter('**/*.{eot,svg,ttf,woff}')
  .pipe $.flatten()
  .pipe gulp.dest(paths.tmp + '/jekyll_src/fonts/')
