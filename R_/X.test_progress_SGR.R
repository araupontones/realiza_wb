gmdacr::load_functions("R")

gmdacr::load_functions("R")
dir_master <- define_dir_master()
dir_data <- file.path(dir_master,"data")
dir_lookups <- file.path(dir_data,"0look_ups")

gray<-"#F5F5F5"
completed <- "#2A6B94"
moreHalf <- "#61C2B1"
lesHalf <- "#AAF2BB"


  

emprendedoras <- import(file.path(dir_lookups,"emprendedoras.rds"))



#Load Presencas

presencas <- create_data_presencas(dir_lookups, dir_data, c("Presente") )
View(sgr)
tabyl(presencas, actividade)
#Track progress of emprendedoras agains targets
sgr <- presencas %>%
  #remove modulos (because it is SGR)
  filter(actividade == "Modulos Obligatorios",
         Componente != "FNM") %>%
  #Count presencas by actividade
  group_by(ID_BM,Cidade,Componente) %>%
  summarise(presente = sum(presente),
            .groups = 'drop') %>%
mutate(completos = factor(as.character(presente),
                          levels = as.character(seq(1,12)),
                          ordered = T
                          )
       ) %>%
  #Count by cidade
  group_by(Cidade, Componente, completos) %>%
  summarise(mulheres = n(),
            .groups = 'drop')

  

#count emprendedoras por
#by<- "Seu todo"
by <- "Por Cidade"
#by <- "Por Componente"





data_plot <- create_data_progress_SGR(sgr,emprendedoras, by) %>%
  mutate(across(c(prop_int, prop_wb), function(x){
    
    paste0(round(x * 100,1), "%")
    
  })) %>%
  mutate(Total = glue("de mulheres que han completado {completos} modulos: {mulheres}
                      {prop_wb} das listas de BM,
                      {prop_int} das interesadas
                      "))
 


#Plot--------------------------------------------------------------------------
  plot <- data_plot %>%
  ggplot(aes
         (x = as.numeric(completos),
           y = mulheres,
           fill = target,
           label = Total
         )
  ) +
  geom_col(position = "dodge",
           width = .8) +
  geom_vline(xintercept = 10) +
  scale_x_continuous(breaks = seq(1,12,1),
                     labels = seq(1,12,1)) +
  scale_fill_manual(values = palette) +
  labs(y = "Mulheres",
       x = "Módulos concluídos")+
  theme_realiza()
  



ggplotly(plot, tooltip = "label")

# gmdacr::load_functions("R")
# View(fnm)
# 
# View(act)
# 
# presencas <- import(file.path(dir_data,"1.zoho/3.clean/all_presencas.rds"))

