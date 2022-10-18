library(rio)
library(janitor)
library(tidyr)
library(ggplot2)

selections <- setNames(
  #values
  c("Status", "Cidade"),
  #labels
  c("Seu Todo", "Por Cidade")
  
)

ui_80_perc <- function(id){
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3,
                   selectInput(NS(id,"by"), 
                               label = h4("Números da operação por:"),
                               choices =  c("Seu Todo", "Por Cidade")
                               
                   ),
                   radioButtons(NS(id,"radio"), label = h4("Percentagem"),
                                choices = list("80%" = .8, "70%" = .7, "60%" = .6,
                                               "50%" = .5, "40%" = .4), 
                                selected = .4),
                   
                   
                   
                   
      ),
      mainPanel(
        uiOutput(NS(id,"header")),
        withSpinner(plotOutput(NS(id,"plot")), color = "black")
        
      )
    )
    
  )
}


#Server ===================================================================

#Server ======================================================================
server80Perc<- function(id, dir_data) {
  moduleServer(id, function(input, output, session) {
    
    
    ## read look up of number of modules
    modulos <- rio::import(file.path(dir_lookups, "sessoes.rds"))
    num_modulos <- nrow(modulos)
    
    ## read presencas de SGR 
    presencas <- create_data_presencas(dir_lookups, dir_data, c("Presente")) %>%
      dplyr::filter(Abordagem != "FNM",
                    actividade_label == "Modulos Obligatorios") %>%
      #drop duplicates
      group_by(ID_BM, actividade) %>%
      slice(1) %>%
      ungroup() %>%
      group_by(ID_BM) %>%
      summarise(Perc = sum(presente)/ num_modulos,
                Cidade = first(Cidade),
                Abordagem = first(Abordagem),
                .groups = 'drop')
  
    
    
    
    
    
    
    
    # reactive data -----------------------------------------------------------
    data_plot <- reactive({
      
      
      
      if(input$by == "Seu Todo"){
        
        agrupar_por <- c("Abordagem")
        
        
      } else if (input$by == "Por Cidade"){
        
        
        
        agrupar_por <- c("Cidade", "Abordagem")
        
        
      } 
      
      print(names(presencas))
      data_plot <- presencas %>%
        dplyr::filter(Perc >= as.numeric(input$radio)) %>%
        group_by_at(agrupar_por) %>%
        summarise(value = n(),
                  .groups = 'drop') 
      
      
    })
    
    
    
    output$header <- renderUI({
      
      tags$div(
        p("A abordagem SGR pede que os participantes participem de 13 sessões obrigatórias. 
          O gráfico abaixo mostra a proporção de mulheres que compareceram a 80% dessas sessões..
")





      )
      
      
      
      
    })
    
    output$plot <- renderPlot({
      
      print(names(data_plot()))
      upper_limit = max(data_plot()$value)
      
      #if it is seu todo
      if(input$by == "Seu Todo") {
        
        base_plot <- data_plot() %>% 
          ggplot(aes(x = Abordagem,
                     y = value,
                     fill = Abordagem,
                     label = value
                     )
          ) +
          geom_col()
        
      } else if (input$by %in% c("Por Cidade")){
        
        base_plot <- data_plot() %>% 
          ggplot(aes(x = Abordagem,
                     y = value,
                     fill = Abordagem,
                     label = value
                    )
          ) +
          geom_col()+
          facet_grid(~ Cidade)
        
        
      }
      
      base_plot +
        labs(y = "Número de emprendedoras",
             x = "") +
        scale_fill_manual(values = c(palette))+
        theme_realiza()
      
      # plot <- base_plot +
      #   geom_point(size = 6,
      #              shape = 21) +
      #   geom_text(hjust = -.5) 
      # 
      # if(input$by == "Cidade_Abordagem"){
      #   
      #   plot <- plot +
      #     facet_wrap(~Cidade,
      #                ncol = 3)
      #   
      #   
      #   
      # }
      # 
      # #Define theme
      # plot +
      #   scale_y_continuous(limits = c(0,upper_limit)) +
      #   scale_color_manual(values = c(palette))+
      #   scale_fill_manual(values = c(palette))+
      #   labs(
      #     y = "Número de emprendedoras",
      #     x = ""
      #   ) +
      #   theme_realiza()
      
      
      
    })
    
    
    observeEvent(input$by,{
      
      print(input$by)
      
    })
    
    
  })
  
  
}
