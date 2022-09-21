

selections_semana <- setNames(
  #values
  c("Seu todo" ,
    "Por Cidade", 
    "Por Componente" 
    #"Por Cidade e Componente"
    #"Por Actividade no seu todo", 
    #"Por Actividade por Componente",  
    #"Por actividade por cidade" 
  ),
  #labels
  c("Seu todo" ,
    "Por Cidade", 
    "Por Componente" 
    #"Por Cidade e Componente"
    #"Por Actividade no seu todo", 
    #"Por Actividade por Componente",  
    #"Por actividade por cidade" 
  )
  
)

#UI ===========================================================================
#'@param periodo c("Semana", "Mes") it defines the labels of the selectors
ui_progress_sgr <- function(id){
  
  
  tagList(
    
    sidebarLayout(
      
      sidebarPanel(width = 3,
                   selectInput(NS(id,"by"), 
                               label = h4("Números da operação por:"),
                               choices = selections_semana
                               
                   )   
            
      ),
      mainPanel(
        uiOutput(NS(id,"header")),
        withSpinner(plotlyOutput(NS(id,"plot")), color = "black")
        
      )
    )
    
  )
}



#Server ======================================================================

#'@param periodo c("Semana", "Mes") defines whether to aggregate by semana or by mes
serverProgressSGR<- function(id, dir_data, db_emprendedoras) {
  moduleServer(id, function(input, output, session) {
    
 
    
    #read lookup de actividades ------------------------------------------------
    dir_lookups <- file.path(dir_data,"0look_ups")
    
    
    presencas <- reactive({
      
      create_data_presencas(dir_lookups, dir_data, c("Presente"))
    })
    
    
    #Count modulos completos in each city and compoenente -----------------------
    sgr <- reactive({
      
      presencas() %>%
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
      
      
    })
    
    
    #Create data plot
    data_plot <-reactive({
      
      create_data_progress_SGR(sgr(),db_emprendedoras, input$by) %>%
        mutate(across(c(prop_int, prop_wb), function(x){
          
          paste0(round(x * 100,1), "%")
          
        })) %>%
        mutate(Total = glue("de mulheres que han completado {completos} modulos: {mulheres}
                      {prop_wb} das listas de BM,
                      {prop_int} das interesadas
                      "))
      
      
    })
     
    
    
    
   
    

    
    
    #Plot the data -----------------------------------------------------------------
    output$plot<- renderPlotly({
      

      plot <- data_plot() %>%
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
        scale_fill_manual(values = palette,
                          name = "") +
        labs(y = "Mulheres",
             x = "Módulos concluídos")+
        theme_realiza() +
        theme(legend.text = element_text(size = 8),
              axis.text.y = element_text(hjust = 0),
              axis.text = element_text(size = 10),
              axis.title = element_text(size = 12)) 
      
      
      
      ggplotly(plot,
               tooltip = "label")  %>%
        config(displayModeBar = F) %>%
        layout(
          legend = list(orientation = "h", x = 0.4, y = -0.2 )
          
               )
      
      
    })
    
    
    
    output$header <- renderUI({
      
      HTML(
        glue("<h5>
            A meta é que as mulheres participantes do SGR concluam pelo menos 80% 
            dos 12 módulos oferecidos pelo programa.<br><br>
            O gráfico mostra o número de mulheres que completaram um certo 
            número de módulos. A linha preta indica o objetivo da participação.
            </b> </h5>")
        
      )
    })
    
    observeEvent(input$by,{
      
      print(input$by)
      
    })
    
    
  })
  
  
}
