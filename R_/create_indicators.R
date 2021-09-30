#create indicadores presecas
cli::cli_alert_info("Create indicators from dashboard")



infile_pres <- file.path(dir_clean, "precensas_clean.rds")
infile_turmas <- file.path(dir_clean, "turmas_clean.rds")
exfile <- file.path(dir_data_dash, "precensas_dash.rds")


#import-------------------------------------------------------------------------

t_c <- import(infile_turmas)


p_c <- import(infile_pres) %>%
  #Create Presente and Ausente
  mutate(Presente = Status == "Presente",
         Ausente = Status == "Ausente",
         Atrasado = Status == "Atrasada") %>%
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
