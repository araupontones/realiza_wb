
historico_UI <- function(id){
  
  tagList( #module trends
    
    shiny::fluidRow(
      column(
        6, plotOutput(NS(id, "plot_modalidade"), height = "700px")    
             )
  )
  )
}


historico_server <- function(id, input_data){
  
  
  moduleServer(id, function(input, output, session){
    
    
    output$plot_modalidade <- renderPlot({
      
      
      p_plot <- input_data %>%
        group_by(Modalidade, Date) %>%
        summarise(Presente = mean(Presente), .groups = "drop")
      
      
      plot_line(p_plot,
                x_var = Date,
                y_var = Presente,
                color_var = Modalidade,
                pallete = c(color_FMN, color_SGR, color_fmn_sgr),
                titulo = "Tendência de presença por modalidade")
      
      
    })
   
  
  
})
  
}
