

semana_string <- function(x){
  
  #xday <-  make_datetime(year(x), month(x), day(x))
  
  day_n <- wday(x)
  #first day of week
  ed <- x + ddays(7 - day_n) #OK!
  #last day of week
  sd <- x - (day_n - 1)
  
  glue('{day(sd)} de {month(sd, label = T, abbr = F)}-{day(ed)} de {month(ed, label = T, abbr = F)} {year(ed)}')
  
  
  
}