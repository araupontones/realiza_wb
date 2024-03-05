
library(shiny)
library(shinythemes)
gmdacr::load_functions('../R')



ui <- fluidPage(
  
  #barra de navegacao
  navbarPage(
    
    title = "REALIZA",
    id = "Paneles",
    
    navbarMenu(
       'OVERVIEW',
       icon=icon("exchange-alt"),
       tabPanel(#value = "tab1", 
                title = "PARTICIPANTES",
                #tabname="tab_overview_PARTICIPANTE", 
                icon=icon("chart-line"),
                ui_totals("Totals")
                )
      
      
    )
    
    
  )
  
)

server <- function(input, output, session) {
  
  #define path to data (data is saved in repo /realiza)
  #and the data is updated in the admin tab of the dashboard
  
  dir_master <- define_dir_master()
  dir_data <- file.path(dir_master,"data")
  dir_lookups <- file.path(dir_data,"0look_ups")
  
  #get data of all the emprendedoras
  emprendedoras <- import(file.path(dir_lookups,"emprendedoras.rds"))
  
  ## gravar as base de dados.
  #all_presencas <- readRDS(paste(dir_master, "data/1.zoho/3.clean/all_presencas.rds", sep ="/"))
  #fnm_presenca <- readRDS(paste(dir_master, "data/1.zoho/3.clean/fnm.rds", sep ="/"))
  #sgr_presencas <- readRDS(paste(dir_master, "data/1.zoho/3.clean/sgr.rds", sep ="/"))
  
  #Activate only server that user is using =====================================
  
  observe({
    
    print(input$Paneles)
    activo <- input$Paneles
    
    if(activo == "Participante") {
      
      serverTotals("Totals", dir_data)
      
    }
    
    else if (activo == "Participação Sessoes"){
      
      serverParticipacaoSGR("part_sgr", dir_data, db_emprendedoras = emprendedoras, periodo = "Semana" )
    }
    
    else if(activo == "Sessoes completas"){
      server80Perc("perc_80", dir_data, dir_lookups)
    }
    
    else if(activo == "Participação FNM"){
      server80PercFNM("perc_80_fnm", dir_data, dir_lookups)
      
    }
    else if(activo == "Essa Semana") {
      
      serverEssaSemana("essa_samana", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo == "Evolução semanal"){
      
      serverEvolucao("evolucao_semanal", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo == "Esse Mes"){
      
      serverEssaSemana("esse_mes", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo ==  "Evolução mensual"){
      
      serverEvolucao("evolucao_mensal", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo ==  "Semanal"){
      
      serverEvolucaoActividades("evolucao_semanal_act", dir_data, emprendedoras, periodo = "Semana")
      
    } else if(activo ==  "Mensal"){
      
      serverEvolucaoActividades("evolucao_mensal_act", dir_data, emprendedoras, periodo = "Mes")
      
    } else if(activo == "FNM"){
      serverMetasFNM("fnm", dir_data, emprendedoras)
      
    } else if(activo == "SGR"){
      
      serverMetasSGR("sgr", dir_data, emprendedoras)
      
    }
    
    
  })
  
  
  
  
}

shinyApp(ui, server)