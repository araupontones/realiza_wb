library(shiny)
library(dplyr)
library(shinythemes)

ui <- fluidPage(

  tags$head(
    tags$link(rel = "stylesheet", href = "style.css")
  ),
  
  theme = shinytheme("yeti"),
  
  navbarPage("Realiza",
           
             navbarMenu("FNM",
                       tabPanel("Sessoes Obligatorias",
                                ui_sessoes("fnm_sessoes")
                                 
                        ),
                        tabPanel("Por Cidade",
                                 ui_cidades("fnm_cidades")   
                        )
             )
  )
)
  
    


server <- function(input, output, session) {
  
  serverSessoes("fnm_sessoes", grupo = "fnm")
  serverCidade("fnm_cidades", grupo = "fnm")
}

shinyApp(ui, server)