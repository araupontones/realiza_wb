cli::cli_alert_info("Creating table summary")

infile <- file.path(dir_data_dash, "precensas_dash.rds")
exfile <- file.path(dir_data_dash, "resumo_turmas.rds")
ex_modalidade <- file.path(dir_data_dash, "vector_modalidade.rds") #to export vector of modalidade

r <- rio::import(infile)


#summary by turma and emprendedora ==================================================
names(r)

s <- r %>%
  group_by(Modalidade, Turma, Emprendedora) %>%
  summarise(Total_Aulas = n(),
            Perc_Presente = mean(Presente, na.rm = T),
            Perc_Atrasado = mean(Atrasado, na.rm = T),
            Ultimas_5_Aulas = last(Last_5),
            Convocatorias_Parceiro = sum(Convocado_Parceiro, na.rm = T),
            Perc_Presente_Parceiro = mean(Presente_Parceiro, na.rm = T),
            .groups = 'drop'
            ) %>%
  #beauty names for table
  mutate(across(contains("Perc"), function(x)paste0(round(x*100,2),"%")),
         across(contains("Perc"), function(x)str_replace_all(x,"NaN%", "-"))
         ) %>%
  rename_all(function(x)str_replace_all(x,"_"," ")) %>%
  rename_all(function(x)str_replace_all(x,"Perc","%"))


#vector of modalidades (for dashboard)
vct_modalidade <- sort(levels(s$Modalidade))

#export
rio::export(s, exfile)
rio::export(vct_modalidade, ex_modalidade)



