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
             tabPanel("Números totais",
                      ui_totals("Totals")
             ),
             navbarMenu(
               "Participação",
               tabPanel("Essa Semana",
                        ui_essa_semana("essa_samana")
                        ),
               
               "Resumo",
               tabPanel("Overview",
                        ui_overview("overview")
               ),
               tabPanel("Presencas",
                        ui_summary("summary")
                        
               )
               
               
             ),
             panels_FNM("FNM"),
             
             panels_SGR("SGR"),
             
             panels_SGR_FNM("FNM + SGR")
             
             
             
             
             
             
             
  )
)



server <- function(input, output, session) {
  
  
  sistema <- Sys.info()["sysname"]
  
  
  if(sistema == "Windows"){
    
    dir_master <- file.path(dirname(getwd()), "realiza")
    
  } else {
    
    dir_master <- "/srv/shiny-server/realiza"
  }
  
  
  dir_data <- file.path(dir_master,"data")
  
  
  last_refreshed <- rio::import(file.path(dir_data,"2.Dashboard/last_refreshed.rds"))
  
  output$last_refreshed <- renderUI({
    
    text <- paste("Última atualização:", last_refreshed)
    
    p(text)
  })
  
  
  
  
  
  #server summary ================================================================
  
  serverTotals("Totals", dir_data)
  serverEssaSemana("essa_samana", dir_data)
  
  serverOverview("overview", dir_data)
  
  serverSummary("summary", dir_data)
  
  
  #Activate the servers of each gropu when the tab is selected
  #For this to work the name id of the uis and values of panel should be consisten
  #See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
  activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
                       tipos = c("sessoes", "modulos", "cidades"),
                       input,
                       session,
                       dir_data
  )
  
  
  # 
  # observe({
  #   
  #   print(input$Paneles)
  # })
  
  
  
  
  
  
}

shinyApp(ui, server)