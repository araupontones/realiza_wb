#Module sessoes
library(dplyr)
library(ggplot2)
library(shinycssloaders)




#Ui ============================================================================
ui_overview <- function(id){
 
  
   
   tagList(
    
  selectInput(NS(id,"cidades"), label = "Cidade", choices = c("Todas", "Beira", "Maputo", "Nampula")),
   uiOutput(NS(id, "cards_total"))

 )
  
}



#Server ======================================================================
serverOverview <- function(id) {
  moduleServer(id, function(input, output, session) {
    
   #prepare data -----------------------------------------------------------
    emprendedoras <- rio::import("data/0look_ups/emprendedoras.rds")
    data_overview <- rio::import("data/1.zoho/3.clean/all_presencas.rds")
    
    
    #data reactive by cidade ==================================================
    data_emp_cidades <- reactive({
      if(!input$cidades %in% unique(emprendedoras$Cidade)) {
        
        
        db <- emprendedoras
        
      } else {
        
        
        db <- emprendedoras %>% dplyr::filter(Cidade == input$cidades)
      }
      
      db
      
    })
    
    
    data_overview_cidades <- reactive({
      
      if(!input$cidades %in% unique(data_overview$Cidade)) {
        
        
        db <- data_overview
        
      } else {
        
        
        db <- data_overview %>% dplyr::filter(Cidade == input$cidades)
      }
      
      db
      
    })
    
    
#data for cards ================================================================
    data_cards <- reactive({
      
      #registradas
      total <- data_emp_cidades() %>%
        group_by(grupo_accronym) %>%
        summarise(total_emp = n(), .groups = 'drop',
                  #Mulheres confirmadas no programa
                  confirmadas  = sum(status_realiza == "CONFIRMADA"), 
                  confirmadas_perc  = paste0(round(confirmadas / total_emp * 100,2), "%")
                  
        )
      
      
      #presencas 
      
      atividades <- data_overview_cidades()  %>%
        #Only keey unique activities
        dplyr::filter(!is.na(actividade)) %>%
        group_by(grupo_accronym) %>%
        summarise(total_act = length(unique(actividade, Data)),
                  #presencas sessao inaugural do total
                  sessao_inagural = sum(actividade == "Sessão Inaugural" & Status == "Presente"),
                  #count confirmadas en listas
                  confirmadas = sum(status_realiza == "CONFIRMADA"),
                  #count presencas
                  presencas = sum(Status == "Presente" & status_realiza == "CONFIRMADA"),
                  #estimate ration of presencas of confirmadas
                  presenca_perc = paste0(round(presencas/confirmadas * 100,1), "%"),
                  .groups = 'drop'
                  
        )
      
      
      #all info in one table
      data_cards <- total %>%
        left_join(atividades,  by= "grupo_accronym") %>%
        mutate(sessao_inagural_perc = paste0(round(sessao_inagural / total_emp * 100,2), "%"))
      
      data_cards
      
      
    })
    
   
    
    
    
#create cards ===================================================================
    cards <- reactive({
      
      
      lapply(split(data_cards(), data_cards()$grupo_accronym), function(x){
        
        titulo <- x$grupo_accronym[1]
        
        tags$div(class = 'card col-sm-4',
                 
                 tags$div(class = 'card-body',
                          
                          h2(class = 'card-title', titulo),
                          tags$ul(class = 'list-group',
                                  tags$li(class = 'list-group-item',
                                          paste("Emprendedoras inscritas no programa:", x$total_emp)
                                  ),
                                  tags$li(class = 'list-group-item',
                                          paste("Total confirmadas:", x$confirmadas_perc)
                                  ),
                                  tags$li(class = 'list-group-item',
                                          paste("Participou da sessão inaugural (do total):", x$sessao_inagural_perc)
                                  ),
                                  tags$li(class = 'list-group-item',
                                          paste("Taxa de presença nas actividades (das confirmadas):", x$presenca_perc)
                                  )
                          )
                          
                 )
                 
        )
        
      
      
    }) 
      
      })
    
    
    output$cards_total <- renderUI({
      
      tags$div(class = 'card-group',
               
               cards()
               
      )
      
      
    })
   
                
   
   
   
    
    
    
  })
}