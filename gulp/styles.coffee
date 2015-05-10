'use strict'
gulp = require('gulp')
paths = gulp.paths
$ = require('gulp-load-plugins')()

compileStyles = (src_pattern, tmp_dir)->
  sassOptions = style: 'expanded'
  gulp.src src_pattern
  .pipe $.sass(sassOptions)
  .pipe $.autoprefixer()
  .pipe $.rename
    dirname: "/"
  .pipe gulp.dest tmp_dir + '/jekyll_src/'


gulp.task 'styles', ->
  src_pattern = [
    paths.src + '/**/*.scss'
    '!' + paths.src + '/config.scss'
  ]
  compileStyles src_pattern, paths.tmp
