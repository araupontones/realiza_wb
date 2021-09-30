# all flow!

#1. download data -------------------------------------------------------------

source("R_/download_from_zoho.R", encoding = "UTF-8")

#2. clean data -----------------------------------------------------------------

#presenca
source("R_/clean_raw_presencas.R", encoding = "UTF-8")

#turmas
source("R_/clean_raw_turmas.R", encoding = "UTF-8")

#3. create indicators for dashboard --------------------------------------------

source("R_/create_indicators.R", encoding = "UTF-8")
