library(dplyr)
#'Create labels actividades FNM
#'@param .data
labels_actividades_fnm <- function(.data){
  
  .data %>%
    mutate(actividade_label  =case_when(actividade == "De mulher para mulher: Conecta!" ~ "Conecta",
                                        actividade == "Eventos de matchmaking" ~ "Matchmaking",
                                        actividade == "Eventos de networking" ~ "Networking",
                                        actividade == "Feira Financeira" ~ "Feiras",
                                        actividade == "Sessão Inaugural" ~ "Inaugural",
                                        actividade ==  "Sessões de coaching" ~ "Coaching",
                                        actividade == "Sessões individuais" ~ "Individuais",
                                        actividade == "Workshops temáticos"  ~ "Workshops"
    ),
    actividade_label = factor(actividade_label,
                              levels = c( "Inaugural",
                                          "Individuais",
                                          "Conecta",
                                          "Feiras",
                                          "Matchmaking",
                                          "Networking",
                                          "Workshops"),
                              ordered = T))
  
  
  
}
