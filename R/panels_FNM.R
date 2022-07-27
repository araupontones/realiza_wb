

panels_FNM <- function(id){
  

    
    navbarMenu(id,
               tabPanel("Sessoes Obligatorias",
                        value = "sessoes_fnm",
                        ui_sessoes("fnm_sessoes", grupo = "fnm")
                        
               ),
               tabPanel("Por Cidade",
                        value = "cidades_fnm",
                        ui_cidades("fnm_cidades")   
               )
    )
    
  
}


