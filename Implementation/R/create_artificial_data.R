library(rio)

#data artificial for training 
dir_lks <- "implementation/data/look ups"
infile <- "Implementation/data/0.Mock/0.artificial_turmas.R.xls"
exfile <-"Implementation/data/0.Mock/artificial_emprendedoras.xlsx"

#read data
raw <- rio::import(infile)
grupos <- import(file.path(dir_lks, "grupos.rds"))
cidades <- import(file.path(dir_lks, "cidades.rds"))
agentes <- import(file.path(dir_lks, "agentes.rds"))
turmas <- import(file.path(dir_lks, "turmas.rds"))


View(turmas)

#Create 4 new rows for each Turma
more_turmas <- lapply(split(raw, raw$Turma), function(x){
  
  Cidade = unique(x$Cidade)
  Turma = unique(x$Turma)
  Agente = unique(x$Agente)
  Grupo =  sample(grupos$Grupo,1)
  
  
  new <- tibble(
    Cidade = rep(Cidade, 4),
    Turma = rep(Turma, 4),
    Grupo = rep(Grupo, 4),
    Agente = rep(Agente, 4)
    
  )
  
  x <- mutate(x, Grupo = Grupo)
 
  y = rbind(new, x)
  
  return(y)
  
}) %>% do.call(rbind, .)

View(more_turmas)

#Bring lookup tables

ids <- more_turmas %>%
  mutate(Emprendedora = paste("Emprendedora -", row_number())
        ) %>%
  left_join(grupos, by = "Grupo") %>%
  left_join(cidades, by ="Cidade") %>%
  left_join(turmas, by = "Turma") %>%
  left_join(agentes, by = "Agente") %>%
  select(Emprendedora,
         Cidade = ID_Cidade,
         Grupos = ID_Grupo,
         Grupos_fixos = ID_Turma,
         Facilitadoras = ID_agente)

export(ids,exfile)




