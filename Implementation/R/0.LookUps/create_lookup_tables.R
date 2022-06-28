#dependencies
source("functions/download_all_reports.R")
library(rio)

exdir <- "implementation/data/look ups"

facilitadoras <- "Facilitadoras_Report"
grupos <- "Grupos_Report"


fac_zoho <- download_realiza(facilitadoras)
grupos_zoho <- download_realiza(grupos)
turmas_zoho <- download_realiza("Turmas_fixas_report")

View(turmas_zoho)

View(grupos_zoho)
#Look Up agentes ===============================================================

agentes <- fac_zoho %>% 
  filter(Roles == "Agente") %>%
  select(ID_agente = ID,
         Agente = Facilitadora)



export(agentes, file.path(exdir, "agentes.rds"))


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
