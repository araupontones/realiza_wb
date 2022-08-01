panel_powerBI <- function(id){
  
  tabPanel(id,
           tags$iframe(src= "https://app.powerbi.com/view?r=eyJrIjoiYzhhOTU4YzQtNDZmNy00NmUwLWI3YzItZTQzNzg1YmVmYTFlIiwidCI6IjFmMTU1ZTFlLWQyZGYtNDYzYi04NDZjLWM4NzJiZWU0Yjg0NCJ9&pageName=ReportSection585f835ab05e5c55ba91",
                       width = "100%",
                       height= "600px",
                       frameborder="0",
                       allowfullscreen="true"
                       
           )
           
  )
  
}