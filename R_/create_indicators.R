#create indicadores presecas
cli::cli_alert_info("Create indicators from dashboard")



infile_pres <- file.path(dir_clean, "precensas_clean.rds")
infile_turmas <- file.path(dir_clean, "turmas_clean.rds")
exfile <- file.path(dir_data_dash, "precensas_dash.rds")


#import-------------------------------------------------------------------------

t_c <- import(infile_turmas)
#View(p_c)

p_c <- import(infile_pres) %>%
  filter(Status != "Nao convocada") %>%
  #Create Presente and Ausente
  mutate(Presente = Status %in%c("Presente","Atrasada"),
         Ausente = Status == "Ausente",
         Atrasado = Status == "Atrasada",
         Presente_Parceiro = Status_Parceiro == "Presente",
         Ausente_Parceiro = Status_Parceiro == "Ausente",
         Convocado_Parceiro = Status_Parceiro != "Nao Convocado",
         #to not count when parceiro wasnt invited
         across(c(Presente_Parceiro, Ausente_Parceiro), function(x)case_when(Status_Parceiro == "Nao Convocado" ~ NA,    
                                                                             T ~ x)),
         Semana = semana_string(Date),
         
         #green, yellow, and red circle
         icon = case_when(Atrasado ~ '<div class="dot yellow"></div>',
                          Presente ~ '<div class="dot green"></div>',
                          Ausente ~  '<div class="dot red"></div>'
                          ) 
         # icon = case_when(Presente ~ "U+1F7E2",
         #                  Atrasado ~ "U+1F7E1",
         #                  Ausente ~  "&#8595") 
                            #"U+1F534")
  ) %>%
  #viz last 5 status
  arrange(Date, Turma, Emprendedora) %>%
  group_by(Turma, Emprendedora) %>%
  mutate(Last_5 = paste(icon, lag(icon,1),  lag(icon,2),  lag(icon,3),  lag(icon,4),  lag(icon,5)),
         Last_5 = str_remove_all(Last_5, "NA"),
         Last_5 = paste0('<div style="text-align:center">', Last_5, '</div>')
  ) %>%
  ungroup() %>%
  #fetch Modalidade
  left_join(t_c, by = "Turma") %>%
  select(
    -starts_with("ID")
  ) %>%
  #to make it better looking :)
  relocate(Modalidade, .after = Cidade) %>%
  #to ease vis
  mutate(Modalidade = factor(Modalidade,
                             levels = c("FNM", "SGR", "SGR + FNM")))



#export -----------------------------------------------------------------------
export(p_c, exfile)

