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
             navbarMenu("Resumo",
                        tabPanel("Overview",
                                 ui_overview("overview")
                        ),
                        tabPanel("Presencas",
                                 ui_summary("summary")
                                 
                        )
                        
             ),
             
            
             
            panels_FNM("FNM"),
             
            panels_SGR("SGR"),
             
            panels_SGR_FNM("FNM + SGR"),
             
            panel_powerBI("Feedback"),
            
            tabPanel("Admin",
                     ui_admin("admin")),
             
         
                       
                 
           
            
            
  )
)




server <- function(input, output, session) {
  
last_refreshed <- rio::import("data/2.Dashboard/last_refreshed.rds")

output$last_refreshed <- renderUI({
  
  text <- paste("Última atualização:", last_refreshed)
  
  p(text)
})

  
#Server grupos  ================================================================
#Activate the servers of each gropu when the tab is selected
#For this to work the name id of the uis and values of panel should be consisten
#See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
                     tipos = c("sessoes", "modulos", "cidades"),
                     input,
                     session
                     )

  
#server summary ================================================================
serverOverview("overview") 
serverSummary("summary")
  
  observe({
    
    print(input$Paneles)
  })
  
  #Password admin ===============================================================
  
paneles <- c("Admin", "Feedback", "sessoes_fnm", "modulos_sgr", "sessoes_sgr_fnm")

lapply(paneles, function(x){
  
  observe({
    if (input$Paneles == x)  {
      
      showModal(
        ModalAdmin()
      )
      
    }
  })
  
  
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