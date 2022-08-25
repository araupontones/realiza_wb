#' Get records - Quick view
#'
#' This API fetches the records displayed by a report of a Zoho Creator application.
#' Its response will contain the data from the fields displayed in the report's quick view.
#' A maximum of 200 records can be fetched per request.
#'
#'
#' @param  url_app the base URL of your Creator account
#' For example, it's creator.zoho.com if your account belongs to Zoho's
#' US DC, and is creator.zoho.eu if it belongs to Zoho's EU DC.
#' @param account_owner_name the username of the Creator account's owner
#' @param app_link_name the link name of the target application
#' @param report_link_name the link name of the target report
#' @param access_token the refreshed access token

#' @return  A tibble of the report that was queried




#get report

get_report_bulk <- function(
  url_app,
  account_owner_name,
  app_link_name,
  report_link_name,
  access_token,
  criteria = "",
  limit = 200,
  from = 1,
  client_id,
  client_secret ,
  refresh_token
){
  
  
  #refresh if it has never been refreshed
  if(!exists("last_token_refreshed")){
    
    cli::cli_alert("Refreshing token")
    
    new_token <- zohor::refresh_token(
      base_url = "https://accounts.zoho.com",
      client_id = client_id,
      client_secret = client_secret,
      refresh_token = refresh_token
    )
    
  }
  
  #check time since last refreshed
  
  now <- Sys.time() #time now
  time_diff <- lubridate::time_length(now - last_token_refreshed, unit = "seconds")
  
  
  
  #refresh if more thatn 3,580 seconds have passed since the last time it was refreshed
  if(time_diff > 3580){
    
    
    new_token <- zohor::refresh_token(
      base_url = "https://accounts.zoho.com",
      client_id = client_id,
      client_secret = client_secret,
      refresh_token = refresh_token
    )
    
    cli::cli_alert_success(glue::glue("Token was refrehed {time_diff} seconds ago: Refreshing token!"))
    
  }
  
  #download report
  #2. download report
  reporte <- get_report(
    url_app = "https://creator.zoho.com" ,
    account_owner_name = account_owner_name ,
    app_link_name = app_link_name,
    report_link_name = report_link_name,
    access_token = new_token,
    criteria = criteria,
    from = 1
  )
  
  rows <- nrow(reporte)
  from <- nrow(reporte)
  has_more <- rows >=200
 
  #Continue downloading while there are more rows in the report
  while(rows >=200){
    

      reporte_2 <- get_report(
        url_app = "https://creator.zoho.com" ,
        account_owner_name = account_owner_name ,
        app_link_name = app_link_name,
        report_link_name = report_link_name,
        access_token = new_token,
        criteria = criteria,
        from = from
      )
      
    
  
    
    rows <- nrow(reporte_2)
 
    #set the count to 1 in case there's no more data
    if(length(rows)==0){

      rows <- 1
    
      }
    
   
    reporte <- plyr::rbind.fill(reporte, reporte_2) ##!!
    
    from <- nrow(reporte) +1
    
  }
  
  
  cli::cli_alert_success(report_link_name)
  
  ##unnest variables in list format
  reporte_clean <- reporte %>%
    mutate_if(is.list, unnest_value_from_list) %>%
    mutate_if(is.list, unlist)
  
  
  return(reporte_clean)
  
}



