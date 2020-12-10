#' Original bms color database
#'
#' A dataset containing some colour palettes inspired by bms species
#'
#'
#'@format A data frame containing all the colours used in the palette:
#'\itemize{
#'   \item option: It is intended to be a general option for choosing the specific colour palette.
#'   \item hex: hex color code
#'}
"bmscolors"



#' Available Palettes.
#'
#' This function returns a vector containing the names of all the available palettes in the 'bmsualize' package.
#'
#' @return \code{bms_palettes} returns a character vector with the names of the bms palettes available to use.
#'
#'
#'
#' @examples
#' bms_palettes()
#'
#' @rdname bms_palettes
#' @export

bms_palettes <- function(){
  return(sort(unique(bmsualize::bmscolors$option)))
}

#'
#'
#'
#'
#' bms Colour Map.
#'
#' This function creates a vector of \code{n} equally spaced colors along the
#' 'bms colour map' of your selection
#'
#' @param n The number of colors (\eqn{\ge 1}) to be in the palette.
#'
#' @param alpha	The alpha transparency, a number in [0,1], see argument alpha in
#' \code{\link[grDevices]{hsv}}.
#'
#' @param begin The (corrected) hue in [0,1] at which the bms colormap begins.
#'
#' @param end The (corrected) hue in [0,1] at which the bms colormap ends.
#'
#' @param direction Sets the order of colors in the scale. If 1, the default, colors
#' are ordered from darkest to lightest. If -1, the order of colors is reversed.
#'
#' @param option A character string indicating the bms species to use.
#'
#'
#' @return \code{bms} returns a character vector, \code{cv}, of color hex
#' codes. This can be used either to create a user-defined color palette for
#' subsequent graphics by \code{palette(cv)}, a \code{col =} specification in
#' graphics functions or in \code{par}.
#'
#'
#'
#' Semi-transparent colors (\eqn{0 < alpha < 1}) are supported only on some
#' devices: see \code{\link[grDevices]{rgb}}.
#'
#' @examples
#' library(ggplot2)
#' library(hexbin)
#'
#' dat <- data.frame(x = rnorm(1e4), y = rnorm(1e4))
#' ggplot(dat, aes(x = x, y = y)) +
#'   geom_hex() +
#'   coord_fixed() +
#'   scale_fill_gradientn(colours = bms(128, option = 'Ostracion_cubicus'))
#'
#' pal <- bms(256, option = "Thalassoma_hardwicke", direction = -1)
#' image(volcano, col = pal)
#'
#' @rdname bms
#' @export
#'
bms <- function(n, alpha = 1, begin = 0, end = 1, direction = 1,
                 option = "Centropyge_loricula") {

  if (!option %in% bmsualize::bmscolors$option) {
    stop("Unknown, or possibly misspelled bms species.")
  }


  if (begin < 0 | begin > 1 | end < 0 | end > 1) {
    stop("begin and end must be in [0,1]")
  }

  if (abs(direction) != 1) {
    stop("direction must be 1 or -1")
  }

  if (direction == -1) {
    tmp <- begin
    begin <- end
    end <- tmp
  }

  map <- bmsualize::bmscolors[bmsualize::bmscolors$option == option, ]

  map_cols <- map$hex
  fn_cols <- grDevices::colorRamp(map_cols, space = "Lab",
                                  interpolate = "spline")
  cols <- fn_cols(seq(begin, end, length.out = n)) / 255
  grDevices::rgb(cols[, 1], cols[, 2], cols[, 3], alpha = alpha)
}


#' @rdname bms
#'
#' @export
bms_pal <- function(alpha = 1, begin = 0, end = 1, direction = 1,
                     option = "Centropyge_loricula") {


  function(n) {
    bms(n, alpha, begin, end, direction, option)
  }
}

#' Visualization of bms color palette
#'
#' This function creates an image of the specified bms color palette.
#'
#' @param option A character string indicating the bms species to use.
#'
#' @param n The number of colors (\eqn{\ge 1}) to be in the palette.
#'
#' @param ... Other arguments as can be specified in the function \code{bms}.
#' See ?bmsualize::bms for details.
#'
#'
#' @return \code{bmsualize} returns a visualisation of the specified color palette.
#'
#' @examples
#'
#' bmsualize::bmsualize()
#' bmsualize::bmsualize(option = "Zanclus_cornutus", n = 8)
#'
#' @rdname bmsualize
#' @importFrom graphics image
#' @export
#'

bmsualize <- function(option = "Centropyge_loricula", n = 5, ...) {
  col <- bmsualize::bms(n = n, option = option, ...)
  image(1:n, 1, as.matrix(1:n), col = col,
        main = "", ylab = "", xlab = " ", xaxt = "n", yaxt = "n",  bty = "n")
}


#' @rdname scale_bms
#'
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#'
#' @export
scale_color_bms <- function(option = "Centropyge_loricula", ...,
                             alpha = 1, begin = 0, end = 1, direction = 1,
                             discrete = FALSE) {

  if (discrete) {
    discrete_scale("colour", "bms",
                   bms_pal(alpha, begin, end, direction, option), ...)
  } else {
    scale_color_gradientn(colours =
              bms(256, alpha, begin, end, direction, option), ...)
  }
}

#' @rdname scale_bms
#' @aliases scale_color_bms
#' @importFrom ggplot2 discrete_scale
#' @export
scale_colour_bms <- scale_color_bms

#' @rdname scale_bms
#' @aliases scale_color_bms
#' @export
scale_colour_bms_d <- function(option = "Centropyge_loricula", ...,
                                alpha = 1, begin = 0, end = 1,
                                direction = 1) {
  discrete_scale("colour", "bms",
                 bms_pal(alpha, begin, end, direction, option), ...)
}

#' @rdname scale_bms
#' @aliases scale_color_bms
#' @export
scale_color_bms_d <- scale_colour_bms_d


#' @rdname scale_bms
#' @aliases scale_fill_bms
#' @importFrom ggplot2 discrete_scale
#' @export
scale_fill_bms_d <- function(option = "Centropyge_loricula", ...,
                              alpha = 1, begin = 0, end = 1,
                              direction = 1) {
  discrete_scale("fill", "bms",
                 bms_pal(alpha, begin, end, direction, option), ...)
}


#' bms colour scales
#'
#' Uses the bms color scale.
#'
#' For \code{discrete == FALSE} (the default) all other arguments are as to
#' \link[ggplot2]{scale_fill_gradientn} or \link[ggplot2]{scale_color_gradientn}.
#' Otherwise the function will return a \code{discrete_scale} with the plot-computed
#' number of colors.
#'
#'
#' @param ... parameters to \code{discrete_scale} or \code{scale_fill_gradientn}
#'
#' @param alpha pass through parameter to \code{bms}
#'
#' @param begin The (corrected) hue in [0,1] at which the bms colormap begins.
#'
#' @param end The (corrected) hue in [0,1] at which the bms colormap ends.
#'
#' @param direction Sets the order of colors in the scale. If 1, the default, colors
#' are as output by \code{bms_pal}. If -1, the order of colors is reversed.
#'
#' @param discrete generate a discrete palette? (default: \code{FALSE} - generate continuous palette)
#'
#' @param option A character string indicating the bms species to use.
#'
#' @rdname scale_bms
#'
#'
#' @importFrom ggplot2 scale_fill_gradientn scale_color_gradientn discrete_scale
#'
#' @importFrom gridExtra grid.arrange
#'
#' @examples
#' library(ggplot2)
#' library(bmsualize)
#'
#'
#' ggplot(diamonds, aes(factor(cut), fill=factor(cut))) +
#' geom_bar() +
#' scale_fill_bms(discrete = TRUE, option = "Centropyge_loricula")
#'
#' ggplot(mtcars, aes(factor(gear), fill=factor(carb))) +
#' geom_bar() +
#' scale_fill_bms(discrete = TRUE, option = "Trimma_lantana")
#'
#' ggplot(mtcars, aes(x = mpg, y = disp, colour = drat)) +
#' geom_point(size = 4) +
#' scale_colour_bms(option = "Ostracion_cubicus", direction = -1)
#'
#'
#'
#'
#' @export
scale_fill_bms <- function(option = "Centropyge_loricula", ...,
                            alpha = 1, begin = 0, end = 1, direction = 1,
                            discrete = FALSE) {

  if (discrete) {
    discrete_scale("fill", "bms",
            bms_pal(alpha, begin, end, direction, option), ...)
  } else {
    scale_fill_gradientn(colours =
            bms(256, alpha, begin, end, direction, option), ...)
  }}
