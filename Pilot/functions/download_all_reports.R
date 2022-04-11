download_realiza <- function(report){
  
  rep <- zohor::get_report_bulk(url_app = "https://creator.zoho.com",
                               account_owner_name = "araupontones",
                               app_link_name = "rct",
                               report_link_name = report,
                               access_token = "",
                               criteria = "ID != 0",
                               limit = 200,
                               from = 1,
                               client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
                               client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
                               refresh_token = "1000.b11df28b89daaeb2df10fa2c43178db6.6f953944b607f0ff366915cb9a770edc"
                               
  )                       
  
  
  return(rep)
  
  
  
  
}

