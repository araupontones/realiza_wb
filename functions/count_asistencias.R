#'calculate mean of asistencias, total de sesoses, etc
#'

library(dplyr)
count_asistencias <- function(.data, responsible = "Agente"){
  .data %>%
  group_by_at(c(responsible ,"Emprendedora", "actividade_label"))  %>%
    summarise(div = paste(div, collapse = ""),
              presente_promedio = mean(presente, na.rm = T),
              presente_total = sum(presente, na.rm = T),
              ausente_total = sum(ausente, na.rm = T),
              sessoes_total = presente_total + ausente_total,
              .groups = "drop"
              
    )
  
}
