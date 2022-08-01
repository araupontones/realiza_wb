#'Update data in zoho
#'@param data_ref must contain only two variables, ID and the variable to be updated
#'@param request_url is the output of `update_url_zoho()`
#'@returns updates the data in Emprendedoras sheet


update_data_zoho <- function(data_ref, request_url){
  
  
  lapply(split(data_ref, data_ref$ID_BM), function(x){
    
    #get the ID of the emprendedora
    id = x$ID_BM[1]
    #keep only variable to update
    tib <- select(x,2)
    #transform to json
    tib_jason = toJSON(tib)
    #create data for query
    data_query= paste0('{ "criteria": "ID_BM==', id, '" ,"data" :', tib_jason, '\n}')
    
    
    
    #Push data to server
    response_report <-  PATCH(request_url,
                              body = data_query,
                              add_headers(Authorization = glue('Zoho-oauthtoken {new_token}')),
                              #query = list(criteria = '"criteria": "ID!=0"'),
                              encode = "json"
    )
    
    cli::cli_alert_info(glue::glue('Updating data for ID: {id}'))
    message(glue::glue('status: {response_report$status_code}'))
    
    return(response_report$status_code)
    
    
  })
  
  
}
