'use strict'
gulp = require('gulp')
paths = gulp.paths
$ = require('gulp-load-plugins')(pattern: [
  'gulp-*'
  'main-bower-files'
  'uglify-save-license'
  'del'
])

partials = (tmp_dir)->
  gulp.src(tmp_dir + '/serve/app/**/*.html')
  .pipe $.minifyHtml
    empty: true
    spare: true
    quotes: true
  .pipe $.angularTemplatecache('templateCacheHtml.js', root: 'app/', module: 'weegid')
  .pipe gulp.dest(tmp_dir + '/partials/')


html = (tmp_dir, dist_dir)->
  partialsInjectFile = gulp.src(tmp_dir + '/partials/templateCacheHtml.js', read: false)
  partialsInjectOptions =
    starttag: '<!-- inject:partials -->'
    ignorePath: tmp_dir + '/partials'
    addRootSlash: false
  htmlFilter = $.filter('*.html')
  jsFilter = $.filter('**/*.js')
  cssFilter = $.filter('**/*.css')
  assets = undefined

  gulp.src(tmp_dir + '/serve/*.html')
  # inject templateCacheHtml.js into index.html
  .pipe $.inject(partialsInjectFile, partialsInjectOptions)
  # Get the stream with the concatenated asset files (gulp-useref) and automatically change the revision number (gulp-rev) :   unicorn.css → unicorn-098f6bcd.css.
  .pipe(assets = $.useref.assets())
  .pipe $.rev()
  # js specific processing
  .pipe jsFilter
  .pipe $.ngAnnotate()
  .pipe $.uglify(preserveComments: $.uglifySaveLicense)
  .pipe jsFilter.restore()
  #  css specific processing
  .pipe cssFilter
  .pipe $.replace('../bootstrap-sass-official/assets/fonts/bootstrap', 'fonts')
  .pipe $.csso()
  .pipe cssFilter.restore()
  .pipe assets.restore()
  # concatenate all files (2 scripts imported -> 1 script imported) ans change revision
  .pipe $.useref()
  .pipe $.revReplace()
  #  html specific processing
  .pipe htmlFilter
  .pipe $.minifyHtml
    empty: true
    spare: true
    quotes: true
  .pipe htmlFilter.restore()
  #  finish : we copy the final html file
  .pipe gulp.dest(dist_dir + '/')



gulp.task 'partials', [ 'markups' ], ->
  partials paths.tmp

gulp.task 'partials-mobile', [ 'markups-mobile' ], ->
  partials paths.mobile_tmp


gulp.task 'html', ['inject', 'partials'], ->
  html paths.tmp, paths.dist

gulp.task 'html-mobile', ['inject-mobile', 'partials-mobile'], ->
  html paths.mobile_tmp, paths.mobile_dist


gulp.task 'images', ->
  gulp.src(paths.src + '/assets/images/**/*')
  .pipe gulp.dest(paths.dist + '/assets/images/')

gulp.task 'images-mobile', ->
  gulp.src(paths.src + '/assets/images/**/*')
  .pipe gulp.dest(paths.mobile_dist + '/assets/images/')


gulp.task 'fonts', ->
  gulp.src $.mainBowerFiles()
  .pipe $.filter('**/*.{eot,svg,ttf,woff}')
  .pipe $.flatten()
  .pipe gulp.dest(paths.dist + '/fonts/')

gulp.task 'fonts-mobile', ->
  gulp.src $.mainBowerFiles()
  .pipe $.filter('**/*.{eot,svg,ttf,woff}')
  .pipe $.flatten()
  .pipe gulp.dest(paths.mobile_dist + '/fonts/')


gulp.task 'misc', ->
  gulp.src(paths.src + '/**/*.ico')
  .pipe gulp.dest(paths.dist + '/')

gulp.task 'misc-mobile', ->
  gulp.src(paths.src + '/**/*.ico')
  .pipe gulp.dest(paths.mobile_dist + '/')


gulp.task 'cleanTmp', (done) ->
  $.del [
    paths.tmp + '/jekyll_site'
    paths.tmp + '/jekyll_src/**/*'
    '!' + paths.tmp + '/jekyll_src/.git'
  ], done

gulp.task 'cserve', ->
  $.runSequence 'cleanTmp', 'serve'

gulp.task 'cleanbuild', ->
  $.runSequence 'clean', 'build'

gulp.task 'cleanbuild:mobile', ->
  $.runSequence 'clean-mobile', 'build-mobile'

gulp.task 'build', [
  'html'
  'images'
  'fonts'
  'misc'
]

gulp.task 'build-mobile', [
  'html-mobile'
  'images-mobile'
  'fonts-mobile'
  'misc-mobile'
]
