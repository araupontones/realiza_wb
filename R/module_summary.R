library(ggplot2)
ui_summary <- function(id){
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 4,
                   selectInput(NS(id,"by"), 
                               label = "Desagregação",
                               choices = setNames(
                                 c("Cidade", "Grupo", "actividade"),
                                 c("Cidade", "Grupo", "Actividades")
                                
                               )),
                   
                   
                   checkboxInput(NS(id,"by_time"), label = "Ao longo do tempo", value = TRUE),
                   ),
      mainPanel(
        
        plotOutput(NS(id,"plot"))
        
      )
    )
    
  )
}


#Server ===================================================================

#Server ======================================================================
serverSummary<- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    data_summary <- rio::import("data/1.zoho/3.clean/all_presencas.rds")
  
    
    data_plot <- reactive({
      
      #if user wants by time
      if(input$by_time){
        
        db <- data_summary %>%
          group_by_at(c(input$by, "week")) %>%
          summarise(mean_presenca = mean(presente, na.rm = T), .groups = 'drop')
      } else {
        
        db<- data_summary %>%
          group_by_at(input$by) %>%
          summarise(mean_presenca = mean(presente, na.rm = T), .groups = 'drop')
        
      }
      
      db %>%
        rename(target = input$by)
      
      
    })
    
    
    
    output$plot <- renderPlot({
      
      
      if(input$by_time){
        
        data_plot() %>%
          ggplot(
            aes(x = week,
                y = mean_presenca,
                color = target
                )
          ) +
          
          geom_line()
          
      } else {
        
        
        data_plot() %>%
          ggplot(
            aes(x = target,
                y = mean_presenca)
          ) +
          geom_point()
      }
      
      
    })
    
    
    observeEvent(input$by,{
      
      print(input$by)
      
    })
    
    
  })
  
  
  }
    