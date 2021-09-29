#download data from zoho
#remember to download zohor: 
#devtools::install_github("araupontones/zohor")

cli::cli_alert_info("Download data from Zoho")


#define parameters ------------------------------------------------------------
exfile_pres <- file.path(dir_raw, "precensas_raw.rds")
exfile_turmas <- file.path(dir_raw, "turmas_raw.rds")


fetch_this <- c("roster_precensas", "Turma_reporte")




#download data ------------------------------------------------------------------
                   


reportes <- purrr::map(fetch_this, download_realiza)
names(reportes) <- fetch_this

presencas <- reportes$roster_precensas
turmas <- reportes$Turma_reporte



#export ------------------------------------------------------------------------
export(presencas, exfile_pres)
export(turmas, exfile_turmas)


