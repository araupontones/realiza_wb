library(shiny)
library(dplyr)

ui <- fluidPage(

  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  navbarPage("Realiza",
           
             navbarMenu("FNM",
                       tabPanel("Sessoes",
                                ui_sessoes("fnm_sessoes")
                                 
                        ),
                        tabPanel("Resumo"
                                
                        )
             )
  )
)
  
    


server <- function(input, output, session) {
  
  serverSessoes("fnm_sessoes", grupo = "fnm")
}

shinyApp(ui, server)