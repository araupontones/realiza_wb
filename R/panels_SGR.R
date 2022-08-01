

panels_SGR <- function(id){
  

    
  navbarMenu("SGR",
             tabPanel("Modulos Obligatorios",
                      value = "modulos_sgr",
                      ui_sessoes("sgr_modulos", grupo = "sgr")
                      
             ),
             tabPanel("Por Cidade",
                      value = "cidades_sgr",
                      ui_cidades("sgr_cidades")   
             )
  )
    
  
}


