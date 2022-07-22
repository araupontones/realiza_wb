
#https://www.zoho.com/creator/help/api/v2/update-records.html
#token to update
refresh_token = "1000.ad14e6e780b5b207ff860c6fcd878ebc.9162434e50fcf5ff68002885aa2d3636"

#refresh zoho token --------------------------------------------------------------
new_token <- zohor::refresh_token(
  base_url = "https://accounts.zoho.com",
  client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
  client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
  refresh_token = refresh_token
)


new_token

base_url <- "https://creator.zoho.com"
account_owner_name = "araupontones"
app_link_name = "rct"
report_link_name = "All_Students"
criteria = 'ID_realiza == "RCT001"'


request_url <- glue::glue("{base_url}/api/v2/{account_owner_name}/{app_link_name}/report/{report_link_name}")

#this is how the data should look like
data ='{"data" : [{"First_name":"Andres"}]
}'


#So I am going to do it programatically by
# first: create a tibble with the variables to modify
tib <- tibble(Idade = "")
tib_jason = toJSON(tib)
data_2= paste('{ "criteria": "ID!=0" ,"data" :', tib_jason, '\n}')

data_2
#"criteria": "ID!=0"
#"criteria": "ID_realiza==RCT001"
response_report <-  PATCH(request_url,
                        
                        body = data_2,
                        add_headers(Authorization = glue('Zoho-oauthtoken {new_token}')),
                        #query = list(criteria = '"criteria": "ID!=0"'),
                        encode = "json"
)



response_report$status_code


content(response_report, "text")






