library(shiny)
library(dplyr)
library(shinythemes)
library(plotly)




ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  shinyjs::useShinyjs(),
  theme = shinytheme("yeti"),
  
  uiOutput("last_refreshed"),
  navbarPage("Realiza",
             id = "Paneles",
             
             
             #Numeros totais ===================================================
             tabPanel("Participantes",
                      ui_totals("Totals")
             ),
             
             navbarMenu("Metas",
                        tabPanel("FNM",
                                 ui_metas_fnm("fnm")
                        ),
                        tabPanel("SGR",
                                 ui_metas_sgr("sgr"))
                        
             ),
             
            
             navbarMenu("Participação SGR",
                        tabPanel("Participação Sessoes",
                                 ui_participacaoSGR("part_sgr")
                        ),
                        tabPanel("Sessoes completas",
                                 
                                 ui_80_perc("perc_80"))
                        
                        ),
             tabPanel("Participação FNM",
                      ui_80_percFNM("perc_80_fnm")
             )
             
            
             
            
             
             
  )
)



server <- function(input, output, session) {
  
  
  #define path to data (data is saved in repo /realiza)===========================
  dir_master <- define_dir_master()
  dir_data <- file.path(dir_master,"data")
  dir_lookups <- file.path(dir_data,"0look_ups")
  
  
  #Read data =====================================================================
  
  
  emprendedoras <- import(file.path(dir_lookups,"emprendedoras.rds"))
  
  
  
  last_refreshed <- rio::import(file.path(dir_data,"2.Dashboard/last_refreshed.rds"))
  
  output$last_refreshed <- renderUI({
    
    text <- paste("Last data update:", last_refreshed)
    
    p(text)
  })
  
  
  
  
  
  #server summary ================================================================
 
  
  #Activate the servers of each gropu when the tab is selected
  #For this to work the name id of the uis and values of panel should be consisten
  #See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R

 
  
  
  
  observe({
    
    print(input$Paneles)
    activo <- input$Paneles
    
    if(activo == "Participantes") {
      
      serverTotals("Totals", dir_data)
      
    }
    
    else if (activo == "Participação Sessoes"){
      
      serverParticipacaoSGR("part_sgr", dir_data, db_emprendedoras = emprendedoras, periodo = "Semana" )
    }
    
    else if(activo == "Sessoes completas"){
      server80Perc("perc_80", dir_data, dir_lookups)
    }
    
    else if(activo == "Participação FNM"){
      server80PercFNM("perc_80_fnm", dir_data, dir_lookups)
      
    }
    else if(activo == "Essa Semana") {
      
      serverEssaSemana("essa_samana", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo == "Evolução semanal"){
      
      serverEvolucao("evolucao_semanal", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo == "Esse Mes"){
      
      serverEssaSemana("esse_mes", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo ==  "Evolução mensual"){
      
      serverEvolucao("evolucao_mensal", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo ==  "Semanal"){
      
      serverEvolucaoActividades("evolucao_semanal_act", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo ==  "Mensal"){
      
      serverEvolucaoActividades("evolucao_mensal_act", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo == "FNM"){
      serverMetasFNM("fnm", dir_data, emprendedoras)
      
    } else if(activo == "SGR"){
      
      serverMetasSGR("sgr", dir_data, emprendedoras)
      
    }
    
    
  })
  
  
  
  
  
  
}

shinyApp(ui, server)