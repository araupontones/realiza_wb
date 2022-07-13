#dependencies
source("functions/download_all_reports.R")
library(rio)

exdir <- "data/0look_ups"
create_dir_(exdir)



#read data from zoho 
fac_zoho <- download_realiza("Facilitadoras_Report")
grupos_zoho <- download_realiza("Grupos_Report")
turmas_zoho <- download_realiza("Turmas_fixas_report")
actividades_zoho <- download_realiza("Actividades_Report")


#Look Up agentes ===============================================================

agentes <- fac_zoho %>% 
  filter(Roles == "Agente") %>%
  select(ID_agente = ID,
         Agente = Facilitadora)




export(agentes, file.path(exdir, "agentes.rds"))



# Look Up facilitadoras =======================================================
facilitadoras <- fac_zoho %>% 
  filter(Roles == "Facilitadora") %>%
  select(ID_facilitadora = ID,
         Facilitadora = Facilitadora)




export(facilitadoras, file.path(exdir, "facilitadoras.rds"))



#Look Up Cidade ==============================================================

cidades <- fac_zoho %>%
  select(ends_with("Cidade")) %>%
  group_by(Cidade) %>%
  slice(1) %>%
  ungroup()


export(cidades, file.path(exdir, "cidades.rds"))

#Look Up Grupo ================================================================
grupos <- grupos_zoho %>%
  select(Grupo = grupo,
         ID_Grupo = ID)

export(grupos, file.path(exdir, "grupos.rds"))


#Look up Turmas ===============================================================
turmas <- turmas_zoho %>%
  select(Turma = turma_fixa,
         ID_Turma = ID)

export(turmas, file.path(exdir, "turmas.rds"))

#Actividades =================================================================
View(actividades_zoho)

actividades <- actividades_zoho %>%
  select(actividade,
         ID_actividade = ID, 
         por,
         Grupal_o_individual,
         sessoes = sessoies_obrigatorias)

export(actividades, file.path(exdir, "actividades.rds"))

