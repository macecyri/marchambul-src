'use strict'

gulp = require('gulp')
argv              = require("minimist")( process.argv.slice(2) )
env               = argv.p

gulp.paths =
  src: 'src'
  dist: 'dist'
  tmp: '.tmp'
  e2e: 'e2e'
  mobile_dist: 'www'
  mobile_tmp: '.tmp.mobile'

CONFIG            = require './config'
if env
  for k of CONFIG[env] || {}
    CONFIG[k] = CONFIG[env][k]

gulp.CONFIG = CONFIG

require('require-dir') './gulp'

gulp.task 'default', ->
  gulp.start 'serve'
  return
