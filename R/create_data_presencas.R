#' create data presencas (only status == Presente)
#' And create week and month variables
#' And group all modulos into a single category

create_data_presencas <- function(dir_lookups, dir_data){
  
  
  #get name of modulos
  modulos <- import(file.path(dir_lookups,"sessoes.rds")) %>%
    mutate(actividade_label = "Modulos Obligatorios") %>%
    rename(actividade = Modulo)
  
  presencas <- import(file.path(dir_data,"1.zoho/3.clean/all_presencas.rds"))  %>%
    rename(Componente = grupo_accronym) %>% 
    filter(Status == "Presente") %>%
    #Create variables for month and semana 
    mutate(week = week -29,
           month = month(data_posix, label = T, abbr = F)
    ) %>%
    #Aggregate all modulos into a single "Modulos obligatorios" gategory
    left_join(modulos, by = "actividade")  %>%
    mutate(actividade = ifelse(is.na(actividade_label), actividade, actividade_label))
  
  
  
  presencas
  
}


#===========================================================================

#'defines variable to be treated as the period of aggregation
#'based on the input of the user.
define_var_periodo <- function(db_presencas, periodo){
  
  
  # #define periodo
  if(periodo == "Semana"){
    
    presencas <- db_presencas %>% rename(periodo = week)
  }
  
  if(periodo == "Mes"){
    
    presencas <- db_presencas %>% rename(periodo = month)
    
  }
  
  presencas
  
  
}