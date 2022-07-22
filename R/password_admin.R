password_admin <- function(){
  
  #Password admin ===============================================================
  
  data_login <- tibble(
    user = c("admin", "Andres"),
    password = c("admin", "admin")
  )
  
  ModalAdmin <- function(failed= FALSE){
    
    modalDialog(
      title = "Login",
      #textInput("password", "Password"),
      textInput("user", "User"),
      passwordInput("password", "Password"),
      if (failed)
        div(tags$b("O usuário ou a senha digitada estão incorretos", style = "color: red;")),
      
      easyClose = FALSE,
      footer = tagList(
        actionButton("ok", "OK")
      ))
    
  }
  
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
    } else if(input$password != password_user){
      
      showModal(
        ModalAdmin(TRUE)
      ) 
    } else {
      
      removeModal()
    }
    # if(password_user == input$password){
    #   
    #   removeModal()
    # }
    
    
  })
  
}