#Module sessoes
library(dplyr)
library(ggplot2)
library(shinycssloaders)

#Check password ===============================================================
data_login <- tibble(
  user = c("admin", "Andres"),
  password = c("admin", "admin")
)

ModalAdmin <- function(failed= FALSE){
  
  modalDialog(
    title = "Login",
    #textInput("password", "Password"),
    textInput("user", "User"),
    passwordInput("password", "Password"),
    if (failed)
      div(tags$b("O usuário ou a senha digitada estão incorretos", style = "color: red;")),
    
    easyClose = FALSE,
    footer = tagList(
      actionButton("ok", "OK")
    ))
  
}

#message for the user =============================================================
now <- Sys.time()


foo <- function() {
  message("Saving FNM<br>")
  Sys.sleep(0.5)
  message("Saving SGR<br>")
  Sys.sleep(0.5)
  message("Refresh the dashboard to update the tables!")
  
}

#check that the data was updated correctly =====================================
check_download <- function(now){
  
    file_info <- file.info("data/2.Dashboard/sgr_stats.rds")
    last_update <- file_info$mtime
    is_refreshed <- last_update > now
    rio::export(last_update, "data/2.Dashboard/last_refreshed.rds")
    return(is_refreshed)
  
}



#Ui ============================================================================
ui_admin <- function(id){
 
  
   
   tagList(
     
   
     actionButton(NS(id,"btn_atualizar"), "Atualizar data"),
     actionButton(NS(id, "btn_check"), "Criar checks aleatórios"),
     textOutput(NS(id,"text")),
     
     #Checks --------------------------------------------------------------
     #table checks
     shinycssloaders::withSpinner(DT::dataTableOutput(NS(id,"table_check")), color = "red"),
     #buton download checks
     br(),
     uiOutput(NS(id,"ui_dwld_checks"))
     
     
 )
  
}



#Server ======================================================================
serverAdmin <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    
  #create random check  -----------------------------------------
  
    data_checks <- eventReactive(input$btn_check,{
      
      #function saved in R
      #it reads the clean presencas and selects a record by city
      #this record is the latest present record of an emprendora
      create_random_check()
      
    })
    
    
    #display checks to user
    output$table_check <- DT::renderDataTable({
      
      data_checks()
    })
    
    #download random checks -----------------------------------------------
    output$ui_dwld_checks <- renderUI({
      
      req(data_checks())
      
      downloadButton(NS(id,"downloadChecks"), "Baixar tabela de verificação")
      
      
    })
    
    
    output$downloadChecks <- downloadHandler(
      
      
      
      filename = function() {
        paste("verificacao_realiza_",Sys.Date(),".csv", sep = "")
      },
      content = function(file) {
        write.csv(data_checks(), file, row.names = FALSE)
      }
    )
    
    
    # observe(data_checks(),{
    #   
    #   downloadHandler(
    #     filename = function() {
    #       paste("j", ".csv", sep = "")
    #     },
    #     content = function(file) {
    #       write.csv(data_checks(), file, row.names = FALSE)
    #     }
    #   )
    #   
    # })
    
    
    #update the data ==========================================================
    
      observeEvent(input$btn_atualizar,{
      
        #message to the user
        shinyjs::html(id = "text", html = "Downlading...", add = TRUE)
        
        #Download the data
        source("R_/X.Run_flow.R", encoding = "UTF-8")
      
     
       
      #let the user now that all went well and saved the last_refreshed time 
      if(check_download(now)){
        
        withCallingHandlers({
          shinyjs::html("text", "")
          foo()
        },
        message = function(m) {
          shinyjs::html(id = "text", html = m$message, add = TRUE)
        })
        
        
        
      }
      
    
      })
    
   
    
    
    
  })
}