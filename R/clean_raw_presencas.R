cli::cli_alert_info("Cleaning raw presencas")


infile <- file.path(dir_raw, "precensas_raw.rds") #this is created in download_from_zoho.R
exfile <- file.path(dir_clean, "precensas_clean.rds")


#read raw presencas ---------------------------------------------------------------

p_r <- import(infile)


#clean presencas

p_c <- p_r %>%
  #remove AsistenciaID. from naes 
  rename_at(vars(starts_with("AsistenciaID.")), function(x)str_remove(x, "AsistenciaID.")) %>%
  #unlist variables
  mutate_if(is.list,unlist) %>%
  #trim names
  mutate(Empreendedora = str_trim(Emprendedora)) %>%
  #drop missing records
  filter(Cidade !="") %>%
  #rename and reorder
  select(
    ID_lista = ID,
    ID_asistencia = AsistenciaID,
    Cidade,
    Turma,
    Emprendedora,
    Date = Date_field,
    Status
  )


export(p_c, exfile)
