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

  gulp.src(tmp_dir + '/jekyll_src/**/*.html')
  # inject templateCacheHtml.js into index.html
  .pipe $.inject(partialsInjectFile, partialsInjectOptions)
  # Get the stream with the concatenated asset files (gulp-useref) and automatically change the revision number (gulp-rev) :   unicorn.css → unicorn-098f6bcd.css.
  .pipe $.debug
    title: 'before useref:'
  .pipe(assets = $.useref.assets())
  .pipe $.debug
    title: 'after useref:'
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
  # .pipe htmlFilter
  # .pipe $.minifyHtml
  #   empty: true
  #   spare: true
  #   quotes: true
  # .pipe htmlFilter.restore()
  #  finish : we copy the final html file
  .pipe gulp.dest(dist_dir + '/')


gulp.task 'partials', [ 'markups' ], ->
  partials paths.tmp

gulp.task 'html', ['inject', 'partials', 'finalAssets', 'minifyVendorCss'], ->
  html paths.tmp, paths.dist

gulp.task 'images', ->
  gulp.src(paths.src + '/assets/images/**/*')
  .pipe gulp.dest(paths.dist + '/assets/images/')

gulp.task 'fonts', ->
  gulp.src $.mainBowerFiles()
  .pipe $.filter('**/*.{eot,svg,ttf,woff}')
  .pipe $.flatten()
  .pipe gulp.dest(paths.dist + '/fonts/')

gulp.task 'misc', ->
  gulp.src(paths.src + '/**/*.ico')
  .pipe gulp.dest(paths.dist + '/')

gulp.task 'finalAssets', ->
  gulp.src(paths.src + '/assets/**/*')
  .pipe gulp.dest(paths.dist)

gulp.task 'minifyVendorCss', ->
  gulp.src(paths.tmp + '/vendor.css')
  .pipe $.debug
    title: 'befor csso'
  .pipe $.csso()
  .pipe $.debug
    title: 'after csso'
  .pipe gulp.dest(paths.dist)

gulp.task 'cleanTmp', (done) ->
  $.del [
    paths.tmp
    paths.tmp_site + '/**/*'
    '!' + paths.tmp + '/.git'
  ], done

gulp.task 'clean', (done) ->
  $.del [
    paths.dist + '/**/*'
    '!' + paths.dist + '/.git'
    '!' + paths.dist + '/.gitignore'
    '!' + paths.dist + '/**/*.md'
  ], done

gulp.task 'cserve', ->
  $.runSequence 'cleanTmp', 'serve'

gulp.task 'cleanbuild', ->
  $.runSequence 'clean', 'build'

gulp.task 'build', [
  'html'
  'images'
  'fonts'
  'misc'
]
