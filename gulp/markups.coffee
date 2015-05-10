'use strict'

gulp = require('gulp')
paths = gulp.paths
$ = require('gulp-load-plugins')()


gulp.task 'markups', ->
  gulp.src(paths.src + '/**/*.jade')
  .pipe $.jade()
  .pipe gulp.dest(paths.tmp + '/jekyll_src/')
