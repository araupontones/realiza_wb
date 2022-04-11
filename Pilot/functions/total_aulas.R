
  
  total_aulas <- function(.data){
    .data %>%
    group_by(Date, Facilitadora) %>%
      summarise(.groups = 'drop') %>%
      nrow()
    
  }

  

