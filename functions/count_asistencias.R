#'calculate mean of asistencias, total de sesoses, etc
#'

library(dplyr)
count_asistencias <- function(.data, responsible = "Agente", name_actividade = "actividade_label", ...){
  .data %>%
  group_by_at(c(responsible ,"Emprendedora", name_actividade, ...))  %>%
    summarise(div = paste(div, collapse = ""),
              presente_promedio = mean(presente, na.rm = T),
              presente_total = sum(presente, na.rm = T),
              ausente_total = sum(ausente, na.rm = T),
              sessoes_total = presente_total + ausente_total,
              .groups = "drop"
              
    )
  
}
