
historico_UI <- function(id, vector_modalidade){
  
  tagList( #module trends
    
    fluidRow(id = "select-historico",
     hr(),
      selectInput(NS(id, "select_turma"), label = "Modalidade", 
                  choices = vector_modalidade)
    ),
    
    br(),
    shiny::fluidRow(
      column(
        5, plotOutput(NS(id, "plot_modalidade"), width = "90%")    
             ),
      column(7, DT::DTOutput(NS(id,"resumo_turmas")))
  )
  )
}


historico_server <- function(id, input_data, data_turma){
  
  
  moduleServer(id, function(input, output, session){
    
    
    
    pallete_plot <- reactive(
      
      if(input$select_turma == "FNM"){
        
         c(color_FMN, "gray", "gray")
      } else if( input$select_turma == "SGR"){
        
        pallete = c("gray", color_SGR, "gray")
      } else{
        
        pallete = c("gray", "gray", color_fmn_sgr)
      }
      
    )
    
    
    output$plot_modalidade <- renderPlot({
      
      
      p_plot <- input_data %>%
        group_by(Modalidade, Date) %>%
        summarise(Presente = mean(Presente), .groups = "drop")
      
      
      plot_line(p_plot,
                x_var = Date,
                y_var = Presente,
                color_var = Modalidade,
                pallete = pallete_plot(),
                titulo = "Tendência de presença por modalidade")
      
      
    })
    
    
    data_table <- reactive(
      data_turma
    )
    
    output$resumo_turmas <- DT::renderDataTable({
      
      dat <-  data_table()  %>%
        filter(Modalidade == input$select_turma)
      
      datatable(
        dat,
        escape = F,
        rownames = F,
        options = list(
          pageLength = 50,
          language = list(search = "Pesquisar",
                                       lengthMenu = "Mostrar _MENU_ Observações",
                                       info = "Mostrando _START_ a _END_ de _TOTAL_ entradas")
                       )
        )
      
      
      
      
    })
   
  
  
})
  
}
