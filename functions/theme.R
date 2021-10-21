library(grDevices)
library(extrafont)
library(ggplot2)
#extrafont::loadfonts(dev = 'win', quiet = T)

caption = "Dados: Dados administrativos do programa realiza | 2021"

#font 
font <- "Montserrat"
font_light <- "Montserrat Light"

#themes
blue_navy <- "#183668" 
blue_sky <- "#007DBC"
blue_ligth <- "#00AED9"
blue <-  "#01558B"
green_dark <-  "#48773E" 
green_light <- "#5DBB46"
green <-  "#279B48"
red <- "#EB1C2D"
red_dark <- "#C31F33"
orange <- "#EF402B"
orange_ligth <- "#F36D25"
yellow <- "#FDB713"
yellow_dark <-  "#F99D26"
purple_bright <-  "#E11484"
purple_dark <- "#8F1838"
brown <- "#CF8D2A" 
grey_light <-  "#F2F2F2"
grey_dark <- "#4D4D4D" 
aqua <-  "#9DDFD3"

color_FMN <- blue_navy
color_SGR <- orange
color_fmn_sgr <- green

gmdacr::un_colors()

#themes =======================================================================

#main theme -------------------------------------------------------------------
theme_realiza <- function(){
  
  theme(
    #text
    text = element_text(family = font),
    #background
    panel.background = element_blank(),
    #legend
    legend.key = element_rect(fill = NA),
    legend.text = element_text(face = "bold"),
    #axis
    axis.text = element_text(size = 11),
    axis.text.x = element_text(angle = 90),
    axis.text.y = element_text(angle = 90),
    axis.ticks = element_blank(),
    #title
    plot.title = element_text(size = 16),
    #caption
    plot.caption.position = "plot",
    plot.caption = element_text(hjust = 1)
  )
  
  
}

#theme line plot ---------------------------------------------------------------
theme_line <- function(){
  
  theme(
    #legend
    legend.position = "bottom",
    #grid
    panel.grid.major.y = element_line(linetype = "dotted", color = "grey"))
  
}
