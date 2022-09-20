gmdacr::load_functions("R")

dir_master <- define_dir_master()
dir_data <- file.path(dir_master,"data")
dir_lookups <- file.path(dir_data,"0look_ups")

actividades <- import(file.path(dir_lookups,"actividades.rds")) %>%
  select(actividade, sessoes)

names(presencas)
names(actividades)
View(actividades)

presencas <- create_data_presencas(dir_lookups, dir_data, c("Presente", "Ausente", "Pendente") )


tabyl(presencas, actividade)
fnm <- presencas %>%
  filter(actividade != "Modulos Obligatorios") %>%
  group_by(ID_BM, Cidade, actividade) %>%
  summarise(presente = sum(presente),
            .groups = 'drop') %>%
  left_join(actividades) %>%
  #Estimate level of progress by emprendedora and actividade
  mutate(completas = presente/as.numeric(sessoes) * 100,
         #Create groups of progress
         progress = case_when(completas == 0 ~ "0",
                              between(completas,1,25) ~ "1-25%",
                              between(completas, 26,50) ~ "26-50%",
                              between(completas,51,75) ~ "51-75%",
                              between(completas, 76,99) ~ "76-99",
                              completas > 99 ~ "100%"
                              
                              ) 
         
         
         ) %>%
  #Count by cidade
  group_by(Cidade, actividade, progress) %>%
  summarise(mulheres = n())
 
View(fnm)

View(act)

presencas <- import(file.path(dir_data,"1.zoho/3.clean/all_presencas.rds"))

                    