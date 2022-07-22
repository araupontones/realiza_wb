infile <- file.path(dir_data_dash, "precensas_dash.rds")


p <- import(infile)

p_plot <- p %>%
  group_by(Modalidade, Date) %>%
  summarise(Presente = mean(Presente), .groups = "drop")

 


plot_line(p_plot,
          x_var = Date,
          y_var = Presente,
          color_var = Modalidade,
          pallete = c(color_FMN, color_SGR, color_fmn_sgr),
          titulo = "Tendência de presença por modalidade")








   