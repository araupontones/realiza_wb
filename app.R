options("scipen"=100, digits = 2)
Sys.setlocale("LC_ALL","Portuguese")

git 
 library(shiny)
 library(DT)
# library(httr)
# library(jsonlite)
# library(zohor)
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(stringr)
# library(lubridate)
# library(janitor)
# library(forcats)
# library(gmdacr)
# library(rio)
# library(glue)

gmdacr::load_functions("modules")
gmdacr::load_functions("functions")

dir_data_dash <- "data/dashboard"

vct_modalidade <- import(file.path(dir_data_dash, "vector_modalidade.rds"))

ui <- fluidPage(
  
  

  head_UI("head"),
  
  navbarPage("",
              position = "fixed-top",
    tabPanel("Historico",
             #download_UI("dwnld"),
             
             #download data
             shinycssloaders::withSpinner(uiOutput("last_refreshed"), type = 5, proxy.height= "5px", color = "black"),
             fluidRow(class="container-bottons",
             downloadButton("btn_download", "Baixe os dados para o seu computador"),
             actionButton("btn_refresh", "Atualizar dados")
             ),
             
             historico_UI("historico", vector_modalidade = vct_modalidade)
             )
   
  )
  
)

server <- function(input, output, session) {
  
#load data =====================================================================
  rv <- reactiveValues(
    
    presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds")),
    resumo_db =  rio::import(file.path(dir_data_dash, "resumo_turmas.rds")),
    refreshed_time = import(file.path(dir_data_dash, "Last_Refreshed.rds"))
    
  )
  
#download data when user clicks the button and update reactive values
  observeEvent(input$btn_refresh, {
    
    source("R_/X.Run_flow.R", encoding = "UTF-8")
    rv$presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
    rv$resumo_db =  rio::import(file.path(dir_data_dash, "resumo_turmas.rds"))
    
    rio::export(format(Sys.Date(), "%d de %B de %Y"), file.path(dir_data_dash, "Last_Refreshed.rds"))
    refreshed_time = import(file.path(dir_data_dash, "Last_Refreshed.rds"))
    
  })
  
  

#export data -----------------------------------------------------------------
  output$btn_download <- shiny::downloadHandler(
    
    time <- Sys.Date(),
    
    
    filename = function(){
      
      glue::glue("realiza_tracker_{time}.xlsx")
    },
    
    content = function(file){
      
      rio::export(rv$presencas_db, file)
    }
    
  )
  

  
  
#historico ======================================================================
  historico_server("historico", input_data = rv$presencas_db, data_turma = rv$resumo_db)
  
  #last refrehsed
  output$last_refreshed <- renderUI({
    
    HTML(glue::glue('<p class = "refresh">Última atualização: {rv$refreshed_time}<p>'))
    
    
  })
  
  observeEvent(input$btn_refresh, {
  #download_server("dwnld")
  historico_server("historico",input_data= rv$presencas_db, data_turma = rv$resumo_db)
  
  })
  
}

shinyApp(ui, server)