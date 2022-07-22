#Module sessoes
library(dplyr)
library(ggplot2)
library(shinymanager)

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
     textOutput(NS(id,"text"))
     
 )
  
}



#Server ======================================================================
serverAdmin <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    
    
   
  
    
    
    
    
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