library(shiny)
library(DT)
gmdacr::load_functions("modules")
gmdacr::load_functions("functions")

dir_data_dash <- "data/dashboard"

ui <- fluidPage(
  
  

  head_UI("head"),
  
  navbarPage("",
              position = "fixed-top",
    tabPanel("Historico",
             #download_UI("dwnld"),
             
             #download data
             actionButton("btn_refresh", "Atualizar dados"),
             downloadButton("btn_download", "Baixe os dados para o seu computador"),
             
             hr(),
             historico_UI("historico")
             )
   
  )
  
)

server <- function(input, output, session) {
  
#load data =====================================================================
  rv <- reactiveValues(
    
    presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
    
  )
  
#download data when user clicks the button and update reactive values
  observeEvent(input$btn_refresh, {
    
    source("R_/X.Run_flow.R", encoding = "UTF-8")
    rv$presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
    
    
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
  historico_server("historico", rv$presencas_db)
  observeEvent(input$btn_refresh, {
  #download_server("dwnld")
  historico_server("historico", rv$presencas_db)
  
  })
  
}

shinyApp(ui, server)