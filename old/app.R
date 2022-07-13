options("scipen"=100, digits = 2)
Sys.setlocale("LC_ALL","Portuguese")

 library(shiny)
 library(DT)
library(dplyr)
# library(httr)
# library(jsonlite)
# library(zohor)
# library(ggplot2)
# library(dplyr)
# library(tidyr)
# library(stringr)
# library(lubridate)
# library(janitor)
# library(forcats)
# library(gmdacr)
# library(rio)
# library(glue)

#How to download button

gmdacr::load_functions("functions")


server <- function(input, output, session) {
  
 
 

#load data =====================================================================
  rv <- reactiveValues(
    
    presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds")),
    resumo_db =  rio::import(file.path(dir_data_dash, "resumo_turmas.rds")),
    refreshed_time = import(file.path(dir_data_dash, "Last_Refreshed.rds")),
    #data by modalidade
    modalidade_db = rio::import(file.path(dir_data_dash, "precensas_dash.rds")) %>%
      filter(Modalidade == "FNM"), 
    
    resumo_modalidade = rio::import(file.path(dir_data_dash, "resumo_turmas.rds")) %>%
      filter(Modalidade == "FNM"),
    
    pallete = c(color_main, "gray", "gray")
    
   
  )
  
#download data when user clicks the button and update reactive values
  observeEvent(input$btn_refresh, {
    
    source("R_/X.Run_flow.R", encoding = "UTF-8")
    rv$presencas_db =  rio::import(file.path(dir_data_dash, "precensas_dash.rds"))
    rv$resumo_db =  rio::import(file.path(dir_data_dash, "resumo_turmas.rds"))
    
    rio::export(format(Sys.Date(), "%d de %B de %Y"), file.path(dir_data_dash, "Last_Refreshed.rds"))
    refreshed_time = import(file.path(dir_data_dash, "Last_Refreshed.rds"))
  
    
  })
  
#TITLE SECTION ----------------------------------------------------------------
  
  output$last_refreshed <- renderUI({
    
    HTML(glue::glue('<p class = "refresh">Última atualização: {rv$refreshed_time}<p>'))
    
    
  })
  
  
  
#Summary section ---------------------------------------------------------------  
  
  emprendedoras_total <- reactive(
    
    length(unique(rv$presencas_db$Emprendedora))  
  )

  output$total_emprendedoras <- renderUI(
    HTML(glue::glue('<p class = "summary-card-number">{emprendedoras_total()}<p>'))
  )
  
#monitoria section -------------------------------------------------------------
  
observeEvent(input$btn_fnm,{
  
  rv$modalidade_db = rv$presencas_db%>%
    filter(Modalidade == "FNM")
  
  rv$resumo_modalidade = rv$resumo_db %>% 
    filter(Modalidade == "FNM")
  
  rv$pallete <- c(color_main, "gray", "gray")
  
  
  
})
  
  observeEvent(input$btn_sgr,{
    
    rv$modalidade_db = rv$presencas_db%>%
      filter(Modalidade == "SGR")
    
    rv$resumo_modalidade = rv$resumo_db %>% 
      filter(Modalidade == "SGR")
    
    rv$pallete <- c("gray",color_main, "gray")
    
  })
  
  observeEvent(input$btn_both,{
    
    rv$modalidade_db = rv$presencas_db%>%
      filter(Modalidade == "SGR + FNM")
    
    rv$resumo_modalidade = rv$resumo_db %>% 
      filter(Modalidade == "SGR + FNM")
    
    rv$pallete <- c( "gray", "gray",color_main)
    
  })
  
  
  #reactives -----------------------------------------------------
  
  emprendedoras_mod_total <- reactive(
    
    length(unique(rv$modalidade_db$Emprendedora))  
  )
  
  presencias_mod <- reactive(
    
    rv$modalidade_db %>%
      extract_perc_modalidade(Presente)
  )

  atrasos_mod <- reactive(
    
    rv$modalidade_db %>%
      extract_perc_modalidade(Atrasado)
  )
  
  aulas_mod <- reactive(
    
    rv$modalidade_db %>%
      total_aulas()
  )
  
  #outputs ---------------------------------------------
  
  output$total_emprendedoras_module <- renderUI(
    HTML(glue::glue('<p class = "summary-card-number">{emprendedoras_mod_total()}<p>'))
  )
  
  output$aulas_mod <- renderUI(
    HTML(glue::glue('<p class = "summary-card-number">{aulas_mod()}<p>'))
  )
  
  
  output$presencias_mod <- renderUI(
    HTML(glue::glue('<p class = "summary-card-number">{presencias_mod()}<p>'))
  )
  
  output$atrasos_mod <- renderUI(
    HTML(glue::glue('<p class = "summary-card-number">{atrasos_mod()}<p>'))
  )
  
  
  
  #tables -------------------------------------------------------------------
  
  

  output$table_emprendedora <- renderTable({
    rv$resumo_modalidade %>%
      select(Emprendedora, `% Presente`, `Ultimas 5 Aulas`, `% Presente Parceiro`)
    
  }, sanitize.text.function = function(x) x)
  
  
  output$perro <- renderTable({
    
    rv$resumo_modalidade
  })

 
  
#plot
  
  
  output$plot_tendencia <- renderPlot({
    
    
    p_plot <- rv$presencas_db %>%
      group_by(Modalidade, Date) %>%
      summarise(Presente = mean(Presente), .groups = "drop")
    
    
    plot_line(p_plot,
              x_var = Date,
              y_var = Presente,
              color_var = Modalidade,
              pallete = rv$pallete,
              titulo = "Tendência de presença")
    
    
  })

  # 
  # output$table_emprendedora <- DT::renderDataTable({
  #   
  #   
  #   DT::datatable(
  #     table_emprendedora,
  #     escape = F,
  #     rownames = F,
  #     options = list(
  #       pageLength = 50,
  #       language = list(search = "Pesquisar",
  #                       lengthMenu = "Mostrar _MENU_ Observações",
  #                       info = "Mostrando _START_ a _END_ de _TOTAL_ entradas")
  #     )
  #   )
  #   
  #   
  #   
  #   
  # })
  # 
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
  #historico_server("historico", input_data = rv$presencas_db, data_turma = rv$resumo_db)
  
  #last refrehsed

  
 
  
  observeEvent(input$btn_refresh, {
  #download_server("dwnld")
  #historico_server("historico",input_data= rv$presencas_db, data_turma = rv$resumo_db)
  
  })
  
}

shinyApp(ui = htmlTemplate("www/index.html"), server)
