library(rio)
library(glue)
library(httr)
library(jsonlite)



#Data to post in zoho =============================================
infile <-"Implementation/data/0.Mock/artificial_emprendedoras.xlsx"
artificial <- import(infile)
data_1 <- artificial %>% filter(row_number() <=200)
data_2 <- artificial  %>% filter(row_number() > 200)
data_zoho <- paste('{"data" : ', toJSON(data_1), '}')
data_zoho2 <- paste('{"data" : ', toJSON(data_2), '}')






#Zoho parameters ==================================================

refresh_token_create = "1000.6f489c820ba332e2d803f6fab93ef83a.dd8823b4d90bd2894707fb4bf25b701d"

#refresh zoho token --------------------------------------------------------------
new_token <- zohor::refresh_token(
  base_url = "https://accounts.zoho.com",
  client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
  client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
  refresh_token = refresh_token_create
)


base_url <- "https://creator.zoho.com"
account_owner_name = "araupontones"
app_link_name = "realiza"
form_link_name = "Emprendedoras"

post_url <- glue("{base_url}/api/v2/{account_owner_name}/{app_link_name}/form/{form_link_name}")

  
data_zoho
#post data
response_report <-  POST(post_url,
                          
                          body = data_zoho2,
                          add_headers(Authorization = glue('Zoho-oauthtoken {new_token}')),
                          #query = list(criteria = '"criteria": "ID!=0"'),
                          encode = "json"
)



response_report$status_code
#response_report$content
content(response_report, "text")
