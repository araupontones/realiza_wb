#Module sessoes
library(dplyr)
ui_sessoes <- function(id){
  
  tagList(
    
    
    sidebarLayout(
      sidebarPanel(width = 2,
                   #Inputs Cidade
                   selectInput(NS(id,"cidades"), "Cidade",
                               c("Beira", "Maputo", "Nampula")
                   ),
                   
                   #Inputs Agente
                   selectInput(NS(id,"agentes"), "Agente",
                               c("")
                   )
      ),
      mainPanel(width = 10,
                #Header of Agente (name and % of assistance)
                uiOutput(NS(id,"header")),
                #table with presences
                DT::DTOutput(NS(id,"table"))
      )
    )
    
    
    
  )
  
}



#Server ======================================================================
serverSessoes <- function(id, grupo) {
  moduleServer(id, function(input, output, session) {
    
    #read data of the group
    infile_sessoes <- glue::glue("data/2.Dashboard/{grupo}_div.rds")
    data_sessoes <- rio::import(infile_sessoes)
    
    infile_stats <- glue::glue("data/2.Dashboard/{grupo}_stats.rds")
    data_stats <- rio::import(infile_stats)
    
    #Reactive elements ========================================================
    
    #react to selected cidade
    data_cidade <- reactive({
      
      data_sessoes %>%
        dplyr::filter(Cidade == input$cidades)
    })
    
    agentes_reactive <- reactive({
      
      sort(unique(data_cidade()$Agente))
      
    })
    #update options of input agentes
    observeEvent(agentes_reactive(),{
      
      updateSelectInput(session, "agentes",
                        choices = agentes_reactive(),
                        
      )
      
    })
    
    
    data_agente <- reactive({
      
      data_cidade() %>%
        dplyr::filter(Agente == input$agentes) %>%
        select(-c(Cidade, Agente)) 
    })
    
    #Average presence by agente
    stats_agentes <- reactive({
      
      data_stats %>%
      dplyr::filter(Cidade == input$cidades) %>%
      group_by(Agente) %>%
      summarise(sessoes = sum(sessoes_total, na.rm = T),
                presencas = sum(presente_total, na.rm = T),
                presencas_avg = presencas/sessoes,
                .groups = 'drop'
      ) %>%
        mutate(presencas_avg = scales::percent(presencas_avg))
      
    })
    
    #Main page ================================================================
    
    
    output$header <- renderUI({
      #get average of presencas of this agente
      avg <- stats_agentes()$presencas_avg[stats_agentes()$Agente == input$agentes]
      
      tags$div(
      h1(paste0(input$cidades, ": ", input$agentes)),
      h2(paste0("Média de presenças: ", avg)),
      tags$p(class = "note",
             "O número de bolinhas representa o número de sessões obrigatórias por tipo de evento."
      ),
        tags$div(
          tags$p(
            tags$div(class = "dot green"), "Presente",
            tags$div(class = "dot red"), "Ausente",
            tags$div(class = "dot blue"), "Agendado",
            tags$div(class = "dot empty"), "Sem Agenda"
            
          )
        ),
     
      )
      
    })
    
    
    
    output$table <- DT::renderDT({
      
      
      DT::datatable(
        data_agente(),
        escape = F,
        rownames = F,
        options = list(pageLength = nrow(data_agente()),
                       dom = 't',
                       ordering = F,
                       selector = "td:not(.not-selectable)")
      )
      
    })
    
  })
}