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
             
            panels_FNM("FNM"),
             
            panels_SGR("SGR"),
             
            panels_SGR_FNM("FNM + SGR"),
             
             tabPanel("Feedback",
                      tags$iframe(src= "https://app.powerbi.com/view?r=eyJrIjoiZWE2ZjA0NWItYWE0NS00M2M4LThjNWUtMzFmOTMzMWM0NDMwIiwidCI6IjFmMTU1ZTFlLWQyZGYtNDYzYi04NDZjLWM4NzJiZWU0Yjg0NCJ9&pageName=ReportSection19c755afbc835e848d83",
                                  width = "100%",
                                  height= "600px",
                                  frameborder="0",
                                  allowfullscreen="true"
                                  
                                  )
                      
                      ),
             
             
             tabPanel("Admin",
                      ui_admin("admin"))
  )
)




server <- function(input, output, session) {
  

  
#Activate the servers of each gropu when the tab is selected
#For this to work the name id of the uis and values of panel should be consisten
#See consistency in panels_FNM.R | Panels_SGR.R | Panels_SGR_FNM.R
activate_tabs_grupos(grupos = c("fnm", "sgr", "sgr_fnm"), 
                     tipos = c("sessoes", "modulos", "cidades"),
                     input,
                     session
                     )

  
  
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