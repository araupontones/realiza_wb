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
    filter(Status != "", Emprendedora !="", !is.na(Data))
  
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
           ausente = ifelse(Status == "Ausente", 1, 0))
  
}


#' div for ausente presente ===================================================
#' variable to create div of status
div_status <- function(presente, ausente){
  
  
  case_when(presente == 1 ~ '<div class="dot green"></div>',
            ausente == 1 ~ '<div class="dot red"></div>',
            is.na(ausente) ~ '<div class="dot empty"></div>',
            is.na(presente) ~ '<div class="dot empty"></div>'
            )
}
