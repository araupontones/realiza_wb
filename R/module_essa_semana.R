library(rio)
library(janitor)
library(tidyr)
library(ggplot2)

selections_semana <- setNames(
  #values
  c("Seu todo" ,
    "Por Cidade", 
    "Por Componente", 
    "Por Cidade e Componente",
    "Por Actividade no seu todo", 
    "Por Actividade por Componente",  
    "Por actividade por cidade" 
  ),
  #labels
  c("Seu todo" ,
    "Por Cidade", 
    "Por Componente", 
    "Por Cidade e Componente",
    "Por Actividade no seu todo", 
    "Por Actividade por Componente",  
    "Por actividade por cidade" 
  )
  
)

ui_essa_semana <- function(id){
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3,
                   selectInput(NS(id, "Semana"),
                               label = "Semana da operação",
                               choices = ""),
                   selectInput(NS(id,"by"), 
                               label = "Números da operação por:",
                               choices = selections_semana
                               
                   )
      ),
      mainPanel(
        uiOutput(NS(id,"header")),
        plotOutput(NS(id,"plot"))
        
      )
    )
    
  )
}


#Server ===================================================================

#Server ======================================================================
serverEssaSemana<- function(id, dir_data) {
  moduleServer(id, function(input, output, session) {
    
    
    dir_lookups <- file.path(dir_data,"0look_ups")
    
    emprendedoras <- import(file.path(dir_lookups,"emprendedoras.rds"))
    
    #get name of modulos
    modulos <- import(file.path(dir_lookups,"sessoes.rds")) %>%
      mutate(actividade_label = "Modulos Obligatorios") %>%
      rename(actividade = Modulo)
    
    
    
    presencas <- reactive(
      
     import(file.path(dir_data,"1.zoho/3.clean/all_presencas.rds"))  %>%
        rename(Componente = grupo_accronym) %>% 
        filter(Status == "Presente") %>%
        mutate(week = week -29) %>%
       left_join(modulos, by = "actividade") %>%
       mutate(actividade = ifelse(is.na(actividade_label), actividade, actividade_label))
    )
    
#dynamically update choices for input$semanas ----------------------------------
    observe({
      
      #get semanas reported
      semanas <- sort(unique(presencas()$week), decreasing = T)
      updateSelectInput(session,
                        "Semana",
                        choices = semanas)
                        
      
      
    })

    
#reactive data for semana

    this_week <- reactive({
      
      presencas() %>%
        filter(week == input$Semana)
      
    })
    
    
    data_user <- reactive({
      
      #run function create_data_week, based on the selection of the user
      data_for_this_week <- list(`Seu todo` = create_data_week(this_week(), todos = T), 
                                 `Por Cidade` = create_data_week(this_week(), F, by = Cidade),
                                 `Por Componente` = create_data_week(this_week(), F, by = Componente),
                                 `Por Cidade e Componente` = create_data_week(this_week(), F, by = c("Componente", "Cidade"), double_group = T),
                                 `Por Actividade no seu todo` = create_data_week(this_week(), F, by = actividade),
                                 `Por Actividade por Componente` = create_data_week(this_week(), F, by = c("actividade", "Componente"), double_group = T), 
                                 `Por actividade por cidade` = create_data_week(this_week(), F, by = c("actividade", "Cidade"), double_group = T)
      )
      
      db <- data_for_this_week[[input$by]]
      
      
      cuantos_names <- length(names(db))
       
      
      
      
      #Set names of data_plot based on type of plot
      if(cuantos_names==3){
        
        names(db) <- c("target", "facet", "value")
      }
      
      db
      
    })
    
    observe({
      
      print(names(data_user()))
    })
    
    #Get first and last day of the week -----------------------------------------------------------------
  
    first_day <- reactive({min(this_week()$data_posix)})
    last_day <- reactive({max(this_week()$data_posix)})
    
    # Identify the number of variables in the data
    # it there are 3 it is because it was grouped by 2 variables
    
    cuantos_names <- reactive({
      
      length(names(data_user()))
    })
    
    
    #Plot the data
    output$plot <- renderPlot({
      
      
      base_plot <- data_user() %>%
        ggplot(aes(x = target,
                   y = value,
                   )
               ) 
      
      #if it is a facet
      if(cuantos_names() ==3){
        
        plot <- base_plot +
          geom_point(size = 5,
                     shape = 21,
                     aes(fill = target)) +
          facet_wrap(~ facet)
      #elese
        } else {
        
        plot <- base_plot +
          geom_point(size = 5,
                     shape = 21,
                     aes(fill = target)
          )
      }
      
      plot +
        scale_fill_manual(values = palette)+
          labs(
            y = "Número de emprendedoras",
            x = ""
          ) +
          theme(axis.ticks = element_blank(),
                axis.title = element_text(size = 16),
                axis.title.y = element_text(margin = margin(r = 10)),
                axis.text = element_text(size = 10),
                axis.text.x = element_text(angle = 90),
                plot.background = element_blank(),
                panel.background = element_blank(),
                panel.grid.minor.y =  element_line(linetype = "dotted", color = "gray"),
                panel.grid.major.y =  element_line(linetype = "dotted", color = "gray"),
                legend.title = element_blank(),
                legend.position = "top",
                legend.text = element_text(size = 12),
                legend.key = element_rect(fill = NA)
          )
      
    })
    
    
    
    
    output$header <- renderUI({

      HTML(
        glue("<h5>Os gráficos mostram o número de total emprendedores que participaram das atividades da Realiza durante e
            <b>{first_day()} e {last_day()}</b>. </h5>")

      )
    })
    
    
    observeEvent(input$by,{
      
      print(input$by)
      
    })
    
    
  })
  
  
}
