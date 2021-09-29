# all flow!

#1. download data -------------------------------------------------------------

source("R/download_from_zoho.R", encoding = "UTF-8")

#2. clean data -----------------------------------------------------------------

#presenca
source("R/clean_raw_presencas.R", encoding = "UTF-8")

#turmas
source("R/clean_raw_turmas.R", encoding = "UTF-8")

#3. create indicators for dashboard --------------------------------------------

source("R/create_indicators.R", encoding = "UTF-8")
