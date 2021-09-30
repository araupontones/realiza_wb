#download data from zoho

download_UI <- function(id){
  
  tagList( #module trends
    
    actionButton(NS(id, "btn_refresh"), "Atualizar dados"),
    downloadButton(NS(id, "btn_download"), "Baixe os dados para o seu computador"),
    
    hr(),
    
    DTOutput(NS(id,"data_preview"))
    
    
  )
}


download_server <- function(id){
  
  
  moduleServer(id, function(input, output, session){
    
    
    rv <- reactiveValues(
      
      presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
     
    )
    
    #download data when user clicks the button and update reactive values
    observeEvent(input$btn_refresh, {
      
      source("R_/X.Run_flow.R", encoding = "UTF-8")
       rv$presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
      
      
    })
    
    
    #check data
    output$data_preview <- DT::renderDataTable({
      
      datatable(
      rv$presencas_db,
      rownames = F,
      options = list(pageLength = 100)
      )
      
    })
  
    
    #download data ------------------------------------
    
    output$btn_download <- shiny::downloadHandler(
      
      time <- Sys.Date(),
      
      
      filename = function(){
        
        glue::glue("realiza_tracker_{time}.xlsx")
      },
      
      content = function(file){
        
        rio::export(rv$presencas_db, file)
      }
      
    )
    
  })
  
  
}