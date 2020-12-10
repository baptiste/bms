-   [Introduction](#introduction)
-   [The color scales](#the-color-scales)
-   [Usage](#usage)

<!-- badges: start -->
[![Build
Status](https://api.travis-ci.org/baptiste/bmsualize.png?branch=master)](https://travis-ci.org/baptiste/bmsualize)
[![CRAN
status](https://www.r-pkg.org/badges/version/bmsualize)](https://CRAN.R-project.org/package=bmsualize)
[![Downloads](http://cranlogs.r-pkg.org/badges/grand-total/bmsualize?color=brightgreen)](https://cran.rstudio.com/package=bmsualize)
<!-- badges: end -->

<img src="man/figures/bmsualize_logo.png" width = 120 alt="bmsflux logo"/>

Introduction
============

The [**bmsualize**](http:://github.com/baptiste/bmsualize) package
provides color scales for plotting in R based on nature’s most stunning
and colorful organisms: teleost bmses (with a few chondrichthyan
cameos). \#Teambms in its colorful glory.

Installation
------------

``` r
install.packages("bmsualize")
library(bmsualize)
```

or for the latest development version:

``` r
library(devtools)
devtools::install_github("baptiste/bmsualize", force = TRUE)
library(bmsualize)
```

The color scales
================

The package contains one scale per species, defined by five dominant
colors. The number of bmsualized species will expand over time. For a
list of bms species that are currently available, run
`bms_palettes()`.  
A visual overview of the color scales can be found
[here](https://baptiste.github.io/bmsualize/articles/overview_colors.html).

To visualize a bms color palette, you can run `bmsualize()` and
specify your choice.

``` r
bmsualize()
```

<img src="README_files/figure-markdown_github/tldr_vis-1.png" width="672" />

``` r
bmsualize(n = 8, option = "Hypsypops_rubicundus", end = 0.9)
```

<img src="README_files/figure-markdown_github/tldr_vis-2.png" width="672" />

Usage
=====

The `bms()` function produces the bms color scale based on your
favorite species, which can be specified using ‘option’ =
“Your\_favorite” or bms\_palettes()\[\] with the number of your species
specified.

For base R plots, use the `bms()` function to generate a palette:

``` r
pal <- bms(256, option = "Trimma_lantana")
image(volcano, col = pal)
```

<img src="README_files/figure-markdown_github/tldr_base-1.png" width="672" />

``` r
pal <- bms(10, option = "Ostracion_cubicus")
image(volcano, col = pal)
```

<img src="README_files/figure-markdown_github/tldr_base-2.png" width="672" />

ggplot2
-------

The package also contains color scale functions for **ggplot2** plots:
`scale_color_bms()` and `scale_fill_bms()`.

``` r
library(ggplot2)
library(rbmsbase)

# load data for plotting 
# 1. Create list of species names currently featured in bmsualize
spp <- bmsualize::bms_palettes()
# 2. Get data on the included species from bmsBase using the rbmsbase package
dt <- rbmsbase::species(gsub("_"," ", spp))

dt$Importance = factor(dt$Importance, levels = c("highly commercial", "commercial", "minor commercial", "subsistence bmseries", "of no interest"))

# plot bars with discrete colors using color scheme provided by Scarus quoyi
ggplot(dt[!is.na(dt$Importance),]) +
  geom_bar(aes(x = Importance, fill = Importance)) +
  scale_fill_bms_d(option = "Scarus_quoyi") +
  theme_bw() +
  theme(axis.text.x= element_blank() )
```

<img src="README_files/figure-markdown_github/tldr_ggplot-1.png" width="672" />

``` r
# plot points with continuous colors provided by Hypsypops rubicundus
ggplot(dt) +
  geom_point(aes(x = Length, y = Vulnerability, color = Vulnerability), size = 3) +
  scale_color_bms(option = "Hypsypops_rubicundus", direction = -1) +
  theme_bw()
```

    ## Warning: Removed 1 rows containing missing values (geom_point).

<img src="README_files/figure-markdown_github/tldr_ggplot-2.png" width="672" />

``` r
# get ecological information from bmsBase
data <- rbmsbase::ecology(gsub("_"," ", spp), c("SpecCode","FeedingType", "DietTroph")) %>% 
  dplyr::left_join( rbmsbase::species(gsub("_"," ", spp)))

# plot boxplots of length across feeding groups using discrete colors provided by Cirrilabrus solorensis
ggplot(data[!is.na(data$FeedingType),]) +
  geom_boxplot(aes(x = FeedingType, y = log(Length), fill = FeedingType )) +
  scale_fill_bms_d(option = "Cirrhilabrus_solorensis", labels = c("invertivore", "herbivore", "carnivore", "planktivore", "omnivore")) +
  theme_bw() +
  theme(axis.text.x= element_blank() )
```

<img src="README_files/figure-markdown_github/tldr_ggplot-3.png" width="672" />

``` r
# examine relationships between size and trophic level with vulnerability as a continuous color scheme provided by Lepomis megalotis
ggplot(data) +
  geom_point(aes(x = Length, y = DietTroph, color = Vulnerability), size = 6, alpha = 0.9) +
  scale_color_bms(option = "Lepomis_megalotis", direction = -1) +
  theme_bw()
```

    ## Warning: Removed 48 rows containing missing values (geom_point).

<img src="README_files/figure-markdown_github/tldr_ggplot-4.png" width="672" />

Colors can also be used with maps. Here are several examples of discrete
and continuous color schemes on a world-map.

``` r
library(ggplot2)

#get dataset of the world's countries
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")

#plot worldmap with each country's estimated population as a continuous colors scale based on the reverse colors of Whitley's Boxbms Ostracion whitleyi
ggplot(data = world) +
  geom_sf(aes(fill = pop_est)) +
  scale_fill_bms(option = "Ostracion_whitleyi", direction = -1) +
  theme_bw() +
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-1.png" width="672" />

``` r
#plot worldmap with each country's estimated gdp based on the colors of the Sailfin Tang Zebrasoma velifer
ggplot(data = world) +
  geom_sf(aes(fill = gdp_md_est)) +
  scale_fill_bms(option = "Zebrasoma_velifer", trans = "sqrt") +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-2.png" width="672" />

``` r
#same example as above but starting at a lighter point of the color scale
ggplot(data = world) +
  geom_sf(aes(fill = gdp_md_est)) +
  scale_fill_bms(option = "Zebrasoma_velifer", trans = "sqrt", begin = 0.3, end = 1) +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-3.png" width="672" />

``` r
#plot worldmap again, this time with countries colored by their respective regional affiliation using the colors of the Clown coris *Coris gaimard* and 'discrete = TRUE'
ggplot(data = world) +
  geom_sf(aes(fill = region_wb)) +
  scale_fill_bms(option = "Coris_gaimard", discrete = TRUE) +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-4.png" width="672" />

``` r
##same map with colors reversed
ggplot(data = world) +
  geom_sf(aes(fill = region_wb)) +
  scale_fill_bms(option = "Coris_gaimard", discrete = TRUE, direction = -1) +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-5.png" width="672" />

``` r
#another map with countries colored by economic status using the colors of the Mandarinbms *Synchiropus splendidus*
ggplot(data = world) +
  geom_sf(aes(fill = income_grp)) +
  scale_fill_bms(option = "Synchiropus_splendidus", discrete = T, alpha = 0.8) +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-6.png" width="672" />

``` r
#same map as above but with a narrower color palette in discrete values
ggplot(data = world) +
  geom_sf(aes(fill = income_grp)) +
  scale_fill_bms(option = "Synchiropus_splendidus", discrete = T, alpha = 0.8, begin = 0.3, end = 1) +
  theme_bw()+
  theme(legend.position = "top")
```

<img src="README_files/figure-markdown_github/ggplot2-7.png" width="672" />

Contribute
----------

Love it? Missing your favorite species? Check out how you can contribute
to this package
[here](https://baptiste.github.io/bmsualize/articles/contribute.html)

Citation
--------

To cite package `bmsualize` in publications use:

Nina Schiettekatte, Simon Brandl and Jordan Casey (2019). bmsualize:
Color Palettes Based on bms Species. R package version 0.1.0.
<https://CRAN.R-project.org/package=bmsualize>

A BibTeX entry for LaTeX users is

@Manual{, title = {bmsualize: Color Palettes Based on bms Species},
author = {Nina Schiettekatte and Simon Brandl and Jordan Casey}, year =
{2019}, note = {R package version 0.1.0}, url =
{<https://CRAN.R-project.org/package=bmsualize>}, }

Acknowledgements
----------------

Thanks to everyone contributing to the color palettes: Jindra Lacko,
Andrew Steinkruger, Adam Smith.

Credits
-------

Credits for the initial structure of the functions for this package go
to the `harrypotter` package made by Alejandro Jiménez:
<https://github.com/aljrico/harrypotter>
