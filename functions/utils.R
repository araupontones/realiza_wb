#'Useful functions for realiza
#'

#'crete directory if it does not exits -----------------------------------------
#' @param check_dir path to a directory
#' @returns if the direcory exists, nothing, if it does not exit, it creates it

create_dir_ <- function(check_dir){
  
  if(!dir.exists(check_dir))
    
    dir.create(check_dir)
}


#drop empty cases ==============================================================
#Cases with missing status, missing emprendedora, or missing date
drop_empty <- function(.data){
  
  .data %>%
    dplyr::filter(Emprendedora !="", !is.na(Data))
  
}


#'complete list of emprendedoras ===============================================
#' To have the list of all the emprendedoras in the system

complete_emprendedoras <- function(.data, grupo, db_emprendedoras){
  
  #get all the list of emprendedoras
  db <- .data %>%
    full_join(select(db_emprendedoras, 
                     ID_BM,
                     Emprendedora,
                     ), by = "Emprendedora")
  
  #artificially create a first session for those that have not been reported yet
  if(grupo == "fnm") {
    
    db <- db %>% mutate(actividades = ifelse(is.na(actividade), "Sessão Inaugural", actividade))
  }
  
  
  
  if(grupo == "sgr") {
    
    db <- db %>% mutate(Modulo = ifelse(is.na(Modulo), "1.1", Modulo))
  }
  
  
  db 
  
}

#Update status of pending events ==============================================

scheduled_status <- function(.data){
  
  today <- Sys.Date()
  .data %>%
    mutate(Status = case_when(data_posix <= today  & Status == "" ~ "Pendente",
                              Status =="" & data_posix > today ~ "Agendado",
                              T ~ Status)
    )
  #ifelse(status_var =="", "Agendado", status_var)
}


#'Create date and data_posix =================================================
#'@param date_var variable in characted with the date
#'@returns date variable in poruguese and date in posix for visualization

create_dates <- function(.data, date_var){
  
  #set locale in english to be able to read data as it comes from zoho
  lct <- Sys.getlocale("LC_TIME"); Sys.setlocale("LC_TIME", "C")
  
  #create date as string and as posix (to visualize)
  data_date <- .data %>%
    mutate(
      Data = trim(substr({{date_var}}, 1, 11)),
      data_posix = as.Date({{date_var}}, "%d-%b-%Y")
    )
  
  
  #re set localle to portuguese so the dates are in in this langiage
  prt <- Sys.setlocale("LC_ALL","Portuguese")
  
  #transform data character in Portuguese
  data_port <- data_date %>%
    mutate(Data = format(data_posix, "%d-%b-%Y"))
  
  #return 
  return(data_port)
  
}

#' Create presente and ausente variables =======================================
presente_ausente <- function(.data) {
  
  .data %>%
    mutate(presente = ifelse(Status == "Presente", 1, 0),
           ausente = ifelse(Status == "Ausente", 1, 0),
           agendado = ifelse(Status == "Agendado", 1, 0),
           pendente = ifelse(Status == "Pendente", 1, 0))
  
}


#' div for ausente presente ===================================================
#' variable to create div of status
div_status <- function(presente, ausente, agendado, pendente, ...){
  
  
  case_when(presente == 1 ~ '<div class="dot green"></div>',
            ausente == 1 ~ '<div class="dot red"></div>',
            agendado == 1 ~ '<div class="dot blue"></div>',
            pendente == 1 ~ '<div class="dot yellow">X</div>',
            is.na(ausente) ~ '<div class="dot empty"></div>',
            is.na(presente) ~ '<div class="dot empty"></div>'
            )
}
