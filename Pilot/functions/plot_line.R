#'plot line 
plot_line <- function(.data,
                      x_var,
                      y_var,
                      color_var,
                      pallete = c(color_FMN, color_SGR, color_fmn_sgr),
                      titulo = "Tendência de Presença por Modalidade"
){
  
  .data %>%
    ggplot(aes(x = {{x_var}},
               y = {{y_var}},
               color = {{color_var}})) +
    geom_line(size = 1) +
    geom_point(show.legend = F) +
    scale_y_continuous(position = "right",
                       labels = function(x)paste0(x*100, "%")) +
    scale_color_manual(values = pallete) +
    guides(color = guide_legend(override.aes = list(size = 4)))+
    labs(y = "",
         x = "",
         title =titulo,
         caption = caption)+
    theme_realiza() +
    theme_line()
  
  
  
  
}