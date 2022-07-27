

panels_SGR_FNM <- function(id){
  

    
  navbarMenu(id,
             tabPanel("Sessoes Obligatorias",
                      value = "sessoes_sgr_fnm",
                      ui_sessoes("sgr_fnm_sessoes", grupo = "fnm_sgr")
                      
             ),
             tabPanel("Modulos Obligatorios",
                      value = "modulos_sgr_fnm",
                      ui_sessoes("sgr_fnm_modulos", grupo = "fnm_sgr")
                      
                      
             ),
             tabPanel("Por Cidade",
                      value = "cidades_sgr_fnm",
                      ui_cidades("sgr_fnm_cidades")  
                      
             )
  )
    
  
}


