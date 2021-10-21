head_UI <- function(id){
  
  
  tagList(
    
   
    #style -----------------------------------------------------------------------
    
    tags$head(
      #font from google
      tags$meta(charset = "utf-8"),
      tags$title("Tracker realiza"),
      tags$link(rel="preconnect", href="https://fonts.gstatic.com"),
      tags$link(href="https://fonts.googleapis.com/css2?family=Libre+Franklin:wght@100;300&display=swap", rel="stylesheet"),
      #montserrat
      tags$link(href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap", rel="stylesheet"),
      
      #own style
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      #custom style
      tags$link(rel="icon", href= "https://i.ibb.co/sm00Y6K/Artboard-1-copy-2-100.jpg",
                type="image/jpg", sizes="20x20")
    ), 
    
    #Site ID --------------------------------------------------------------
    
    HTML('
    <div class = "site_head">
    
      <div class="box left site_id">
        <span style="">
        Monitoria de atendimineto do programa realiza
        </span>
      </div>
        
      <div class="box right">
        <span style="">
          Powered by:
        </span>
        <img src="images/pulpodata-bw.png" width="150px">
      </div>
    </div>

<style>
    .box { display: flex; align-items: center; padding: 20px 0px 0px 15px;}
    .right{float:right;}
    .left{float:left}
</style>

        
    ')

#uiOutput(NS(id,"last_commit")),
#HTML('</div>')



  )
}
