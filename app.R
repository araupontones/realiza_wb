library(shiny)
library(DT)
gmdacr::load_functions("modules")

dir_data_dash <- "data/dashboard"

ui <- fluidPage(
  
  head_UI("head"),
  
  navbarPage("",
              position = "fixed-top",
    tabPanel("Historico",
             download_UI("dwnld")
             )
   
  )
  
)

server <- function(input, output, session) {
  
  
  download_server("dwnld")
  
}

shinyApp(ui, server)