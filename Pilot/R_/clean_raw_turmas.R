cli::cli_alert_info("Cleaning raw turmas")

infile <- file.path(dir_raw, "turmas_raw.rds") #created in download_from_zoho.R
exfile <- file.path(dir_clean, "turmas_clean.rds")


#import ------------------------------------------------------------------------

t_r <- import(infile) %>%
  select(
    Turma,
    Modalidade
  )


#export ----------------------------------------------------------------------
export(t_r, exfile)
exfile
