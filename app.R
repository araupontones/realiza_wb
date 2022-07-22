library(shiny)
library(dplyr)
library(shinythemes)

ui <- fluidPage(
  
  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  shinyjs::useShinyjs(),
  theme = shinytheme("yeti"),
  
  navbarPage("Realiza",
             id = "Paneles",
             
             navbarMenu("FNM",
                        tabPanel("Sessoes Obligatorias",
                                 ui_sessoes("fnm_sessoes", grupo = "fnm")
                                 
                        ),
                        tabPanel("Por Cidade",
                                 ui_cidades("fnm_cidades")   
                        )
             ),
             navbarMenu("SGR",
                        tabPanel("Modulos Obligatorios",
                                 ui_sessoes("sgr_sessoes", grupo = "sgr")
                                 
                        ),
                        tabPanel("Por Cidade",
                                 ui_cidades("sgr_cidades")   
                        )
             ),
             
             navbarMenu("FNM + SGR",
                        tabPanel("Sessoes Obligatorias",
                                 ui_sessoes("sgr_fnm_modulos", grupo = "fnm_sgr")

                        ),
                        tabPanel("Modulos Obligatorios",
                                 ui_sessoes("sgr_fnm_sessoes", grupo = "fnm_sgr")


                        ),
                        tabPanel("Por Cidade",
                                 ui_cidades("sgr_fnm_cidades")  

                        )
             ),
             
             
             tabPanel("Admin",
                      ui_admin("admin"))
  )
)




server <- function(input, output, session) {
  
  
  grupos <- c("fnm", "sgr", "sgr_fnm")
  
  lapply(grupos, function(x){
    
    id_sessoes <- paste0(x,"_sessoes")
    id_cidades <- paste0(x,"_cidades")
    
    serverSessoes(id_sessoes, grupo = x)
    serverCidade(id_cidades, grupo = x)
  })
  
  
  #sessoes FNM sgr
  serverSessoes("sgr_fnm_modulos", grupo = "fnm_sgr", "sessoes")
  
  
  observe({
    
    print(input$Paneles)
  })
  
  #Password admin ===============================================================
  
  
  
  observe({
    if (input$Paneles == "Admin")  {
      
      showModal(
        ModalAdmin()
      )
      
    }
  })
  
  observeEvent(input$ok,{
    
    password_user <- data_login$password[data_login$user == input$user]
    
    #If user doesnt exist
    if(length(password_user)==0){
      
      showModal(
        ModalAdmin(TRUE)
      ) 
      #if password is incorrect
    } else if(input$password != password_user){
      
      showModal(
        ModalAdmin(TRUE)
      ) 
    } else {
      
      removeModal()
    }
   
    
    
  })
  
  
  serverAdmin("admin")
  
}

shinyApp(ui, server)