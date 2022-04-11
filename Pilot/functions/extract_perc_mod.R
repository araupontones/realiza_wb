extract_perc_modalidade <- function(.data, variable){
  .data %>%
  summarise(mean = mean({{variable}}, na.rm = T)) %>%
    mutate(mean = paste0(round(mean*100,2), "%")) %>%
    pull(1) 
}
