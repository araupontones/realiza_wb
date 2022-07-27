panel_powerBI <- function(id){
  
  tabPanel(id,
           tags$iframe(src= "https://app.powerbi.com/view?r=eyJrIjoiZWE2ZjA0NWItYWE0NS00M2M4LThjNWUtMzFmOTMzMWM0NDMwIiwidCI6IjFmMTU1ZTFlLWQyZGYtNDYzYi04NDZjLWM4NzJiZWU0Yjg0NCJ9&pageName=ReportSection19c755afbc835e848d83",
                       width = "100%",
                       height= "600px",
                       frameborder="0",
                       allowfullscreen="true"
                       
           )
           
  )
  
}