#clean list names
clean_zoho_list <- function(x){
  
  ifelse(str_detect(x,"list"),
         str_extract(x, '(?<=display_value = ").*?(?=", ID)'),
         x)
}


