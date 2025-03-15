const gulp = require('gulp')
const sass = require('gulp-sass')(require('sass'))
const cleancss = require('gulp-clean-css')
const replace = require('gulp-replace')
const colorConvert = require('color-convert')

const scssFiles = ['cinnamon/cinnamon*.scss', 'gnome-shell/**/*.scss', 'gtk-3.2*/gtk*.scss', 'gtk-4.0*/gtk*.scss']
const cssFiles = ['cinnamon/cinnamon*.css', 'gnome-shell/**/*.css', 'gtk-3.2*/gtk*.css', 'gtk-4.0*/gtk*.css']

// Round sass's comically-long rgb values to ints; convert rgb colors to hex:
function convertColors () {
  return replace(/(rgba?)\(\s*([\d.]+)\s*,\s*([\d.]+)%?\s*,\s*([\d.]+)%?(?:\s*,\s*([\d.]+))?\s*\)/gi,
    (match, func, r, g, b, alpha) => {
      r = Math.round(parseFloat(r))
      g = Math.round(parseFloat(g))
      b = Math.round(parseFloat(b))
      if (alpha !== undefined) { // Handle alpha if present
        return `rgba(${r}, ${g}, ${b}, ${parseFloat(alpha)})`
      }
      return `#${colorConvert.rgb.hex(r, g, b)}`.toLowerCase() // Convert RGB to HEX
    })
}

// Convert scss comments between special/normal so clean-css doesn't eat them:
function convertComments (conversion) {
  if (conversion === 'toSpecial') {
    return replace('/*', '/*!')
  } else if (conversion === 'toNormal') {
    return replace('/*!', '/*')
  }
}

function compileTask (files) {
  return gulp.src(files)
    .pipe(sass())
    .pipe(gulp.dest(file => file.base))
}

function cleanTask (files) {
  return gulp.src(files)
    .pipe(convertComments('toSpecial'))
    .pipe(cleancss({
      level: {
        1: { removeWhitespace: true, replaceZeroUnits: true }
      },
      format: 'beautify'
    }))
    .pipe(convertComments('toNormal'))
    .pipe(gulp.dest(file => file.base))
}

function colorTask (inputPath) {
  return gulp.src(inputPath)
    .pipe(convertColors())
    .pipe(gulp.dest(file => file.base))
}

exports.sass = () => compileTask(scssFiles)
exports.clean = () => cleanTask(cssFiles)

exports.default = gulp.series(
  () => compileTask(scssFiles),
  () => colorTask(cssFiles),
  () => cleanTask(cssFiles)
)
