cli::cli_alert_info("Cleaning raw presencas")


infile <- file.path(dir_raw, "precensas_raw.rds") #this is created in download_from_zoho.R
exfile <- file.path(dir_clean, "precensas_clean.rds")


#read raw presencas ---------------------------------------------------------------

p_r <- import(infile)


#clean presencas

p_c <- p_r %>%
  #remove AsistenciaID. from naes 
  rename_at(vars(starts_with("AsistenciaID.")), function(x)str_remove(x, "AsistenciaID.")) %>%
  #unlist variables -------
  mutate_if(is.list,unlist) %>%
  #drop missing records
  filter(apply(., MARGIN = 1, function(x) sum(is.na(x)| x == ""))==0) %>%
  #rename and reorder -------
  select(
    #ID_lista = ID,
    #ID_asistencia = AsistenciaID,
    Cidade,
    Turma,
    Facilitadora,
    Emprendedora,
    Date = Date_field,
    Status
  ) %>%
  #Format variables correctly -------
  mutate(Empreendedora = str_trim(Emprendedora),
         Date = dmy(Date),
         Date_label = format(Date, "%e %b %y"),
         month = month(Date, label = T, abbr = F)) %>%
  arrange(Date, Turma, Emprendedora)



#Export =======================================================================

export(p_c, exfile)

