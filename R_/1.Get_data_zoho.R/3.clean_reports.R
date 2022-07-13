#'clean data for dashboard 
#' takes the data creted in 2.append_reports
#' Cleans and exports to dashboard

library(rio)
library(dplyr)

#define input directories and files
indir <- "data/1.zoho/2.Append_raw"

infile_fnm <- file.path(indir,"fnm.rds")
infile_sgr <- file.path(indir,"sgr.rds")


#define exit directories  and files
exdir <- "data/1.zoho/3.clean"
create_dir_(exdir)
exfile_fnm <- file.path(exdir, "fnm.rds")
exfile_sgr <- file.path(exdir, "sgr.rds")


#Clean FNM =====================================================================

fnm_clean <- import(infile_fnm) %>%
#clean dates (get rid of time, to be in portuguese, and create data_posix for vis)
create_dates(Data) %>%
  #drop cases with emptu date, missing status, or missing name of emprendedora
  drop_empty() %>%
  presente_ausente() 


export(fnm_clean, exfile_fnm)


#Clean SGR ====================================================================
sgr_clean <- import(infile_sgr) %>%
  #clean dates (get rid of time, to be in portuguese, and create data_posix for vis)
create_dates(Data) %>%
  #drop cases with emptu date, missing status, or missing name of emprendedora
  drop_empty() %>%
  presente_ausente() 
                
export(sgr_clean, exfile_sgr)
exfile_sgr

#remove temp objects
rm(indir, infile_fnm, infile_sgr, exdir, exfile_fnm, exfile_sgr,
   fnm_clean, sgr_clean)
