cli::cli_alert_success("realiza by MUVA")

options("scipen"=100, digits = 2)

#define libraries --------------------------------------------------------------
libraries <- c(
  
  #html
  "httr", "jsonlite", "zohor",
  
  #ggplot
  "ggplot2",
  

  
  #tidyverse
  "dplyr", "tidyr", "stringr",
  
  #carpintery
  "lubridate", "janitor", "forcats",
  
  
  #other
  "rio", "glue"
  
)


#define paths -----------------------------------------------------------------

dir_data <- "data"
dir_raw <- file.path(dir_data, "raw")
dir_clean <- file.path(dir_data, "clean")
dir_data_dash <- file.path(dir_data, "dashboard")

#===============================================================================




suppressWarnings({
  options(defaultPackages=c(getOption("defaultPackages"),
                            
                            libraries
  )
  )
})
