library(rio)
library(janitor)
library(tidyr)
library(ggplot2)

selections <- setNames(
  #values
  c("Status", "Cidade", "Componente", "Cidade_componente"),
  #labels
  c("Seu Todo", "Por Cidade", "Por Componente", "Por Cidade e Componente")
  
)

ui_totals <- function(id){
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3,
                   selectInput(NS(id,"by"), 
                               label = "Números da operação por:",
                               choices = selections
                               
                   )
      ),
      mainPanel(
        uiOutput(NS(id,"header")),
        withSpinner(plotOutput(NS(id,"plot")))
        
      )
    )
    
  )
}


#Server ===================================================================

#Server ======================================================================
serverTotals<- function(id, dir_data) {
  moduleServer(id, function(input, output, session) {
    
    #prepare data -----------------------------------------------------------------
    ## read look up of emprendedoras
    emprendedoras <- import(file.path(dir_data,"0look_ups/emprendedoras.rds"))
    presencas <- import(file.path(dir_data,"1.zoho/3.clean/all_presencas.rds"))
    
    ##identify emprendedoras that attended to the first session
    inaugural<-  presencas %>% 
      filter(actividade =="Sessão Inaugural" & Status == "Presente") %>%
      select(Emprendedora, Status)
    
    
    ##identify emprendedoras that attended to the primera sessao
    primera<- presencas %>%
      group_by(Emprendedora) %>%
      filter(data_posix == min(data_posix)) %>%
      ungroup() %>%
      mutate(actividade = "Primera sessao") %>%
      filter(Status == "Presente") %>%
      select(Emprendedora, Status_primera = Status)
    
    
    
    
    ## Join lookup of emprendedoras with peresencas of first session
    data_totais <- emprendedoras %>%
      select(Emprendedora, Cidade, 
             Componente = grupo_accronym,
             status_realiza) %>%
      left_join(inaugural, by = "Emprendedora") %>%
      left_join(primera, by = "Emprendedora") %>%
      group_by(Componente, Cidade) %>%
      ##Count total in WB data, Confirmadas, and those who attended the first session
      summarise(`Nas Listas BM` = n(),
                `Interesadas em participar` = sum(status_realiza == "CONFIRMADA", na.rm = T),
                `Veio sessao inaugural` = sum(!is.na(Status)),
                `Veio na primeira sessão` = sum(!is.na(Status_primera)),
                .groups = 'drop'
      ) %>%
      pivot_longer(-c(Componente, Cidade),
                   names_to = "Status") %>%
      mutate(Status = factor(Status,
                             levels = c("Nas Listas BM",
                                        "Interesadas em participar",
                                        "Veio sessao inaugural",
                                        "Veio na primeira sessão"
                             )))
    
    
    
    # reactive data -----------------------------------------------------------
    data_plot <- reactive({
      
      
      
      if(input$by == "Cidade_componente"){
        
        agrupar_por <- c("Cidade", "Componente", "Status")
        
      } else if (input$by %in% c("Cidade", "Componente")){
        
        agrupar_por <- c(input$by, "Status")
      } else {
        
        agrupar_por <- input$by
      }
      
      
      data_plot <- data_totais %>%
        group_by_at(agrupar_por) %>%
        summarise(value = sum(value),
                  .groups = 'drop')
      
      
    })
    
    
    
    output$header <- renderUI({
      
      HTML(
        glue("<h5>Os gráficos mostram os números de operação das 
             emprendedoras. </h5>")
        
      )
    })
    
    output$plot <- renderPlot({
      
      print(names(data_plot()))
      upper_limit = max(data_plot()$value)
      
      #if it is seu todo
      if(input$by == "Status") {
        
        base_plot <- data_plot() %>% 
          ggplot(aes(x = "",
                     y = value,
                     fill = Status,
                     label = value,
                     color = Status)
          )
        
      } else if (input$by %in% c("Cidade")){
        
        base_plot <- data_plot() %>% 
          ggplot(aes(x = Cidade,
                     y = value,
                     fill = Status,
                     label = value,
                     color = Status)
          )
      } else if (input$by %in% c("Componente","Cidade_componente")){
        
        base_plot <- data_plot() %>% 
          ggplot(aes(x = Componente,
                     y = value,
                     fill = Status,
                     label = value,
                     color = Status)
          )
        
        
      }
      
      plot <- base_plot +
        geom_point(size = 6,
                   shape = 21) +
        geom_text(hjust = -.5) 
      
      if(input$by == "Cidade_componente"){
        
        plot <- plot +
          facet_wrap(~Cidade,
                     ncol = 3)
        
        
        
      }
      
      #Define theme
      plot +
        scale_y_continuous(limits = c(0,upper_limit)) +
        scale_color_manual(values = c(palette))+
        scale_fill_manual(values = c(palette))+
        labs(
          y = "Número de emprendedoras",
          x = ""
        ) +
        theme_realiza()
      
      
      
    })
    
    
    observeEvent(input$by,{
      
      print(input$by)
      
    })
    
    
  })
  
  
}
