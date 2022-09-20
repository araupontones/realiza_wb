library(shiny)
library(dplyr)
library(shinythemes)




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
             tabPanel("Números totais",
                      ui_totals("Totals")
             ),
             navbarMenu(
               "Participação",
               
               #Semanal --------------------------------------------------------
               "Semanal",
               tabPanel("Essa Semana",
                        ui_essa_semana("essa_samana", "Semana")
                       
                        ),
               tabPanel( 
                 "Evolução semanal",
                 ui_evolucao("evolucao_semanal", "Semana")
                 ),
               
               
               #mensal ----------------------------------------------------------
               "Mensal",
               tabPanel("Esse Mes",
                        ui_essa_semana("esse_mes", "Mes")
                       
               ),
               
               tabPanel( "Evolução mensual",
                         ui_evolucao("evolucao_mensal", "Mes")
                         )
              
              
               # tabPanel("Presencas",
               #          ui_summary("summary")
                        
               #)
               
               
             ),
             
             navbarMenu("Participação Actividades",
                       
                        tabPanel("Semanal",
                                 ui_evolucao_actividades("evolucao_semanal_act", "Semana")),
                        tabPanel("Mensal",
                                 ui_evolucao_actividades("evolucao_mensal_act", "Mes"))
                        
                        )
             # panels_FNM("FNM"),
             # 
             # panels_SGR("SGR"),
             # 
             # panels_SGR_FNM("FNM + SGR")
             
             
             
             
             
             
             
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
    
    text <- paste("Última atualização:", last_refreshed)
    
    p(text)
  })
  
  
  
  
  
  #server summary ================================================================
  
  serverTotals("Totals", dir_data)
  #Semanal ------------------------------------------------------------------
  serverEssaSemana("essa_samana", dir_data, emprendedoras, periodo = "Semana")
  serverEvolucao("evolucao_semanal", dir_data, emprendedoras, periodo = "Semana")
  
  #Monthly --------------------------------------------------------------------
  serverEssaSemana("esse_mes", dir_data, emprendedoras, periodo = "Mes")
  serverEvolucao("evolucao_mensal", dir_data, emprendedoras, periodo = "Mes")
  #serverOverview("overview", dir_data)
  
  
  #Evoucao actividades ========================================================
  
  serverEvolucaoActividades("evolucao_semanal_act", dir_data, emprendedoras, periodo = "Semana")
  serverEvolucaoActividades("evolucao_mensal_act", dir_data, emprendedoras, periodo = "Mes")
  
  #serverSummary("summary", dir_data)
  
  
  #Activate the servers of each gropu when the tab is selected
  #For this to work the name id of the uis and values of panel should be consisten
  #See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
  activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
                       tipos = c("sessoes", "modulos", "cidades"),
                       input,
                       session,
                       dir_data
  )
  
  

  observe({

    print(input$Paneles)
  })

  
  
  
  
  
}

shinyApp(ui, server)