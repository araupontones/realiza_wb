#get record
library(zohor)


##get new token get report
refresh_token_update = "1000.b11df28b89daaeb2df10fa2c43178db6.6f953944b607f0ff366915cb9a770edc"

#refresh zoho token --------------------------------------------------------------
new_token <- zohor::refresh_token(
  base_url = "https://accounts.zoho.com",
  client_id = "1000.V0FA571ML6VV7YFWRC4Q7OKQ32U5PZ",
  client_secret = "c551969c7d49a7a945ac2da12d1a3fe5f241b8dae6",
  refresh_token = refresh_token_update
)



url_app = "https://creator.zoho.com"
account_owner_name = "araupontones"
app_link_name = "rct"
report_link_name = "All_Students"
access_token = new_token
criteria = 'ID_realiza == "RCT001"'


query_report <- glue("{url_app}/api/v2/{account_owner_name}/{app_link_name}/report/{report_link_name}")


response_report <-  GET(query_report,
                        add_headers(Authorization = glue('Zoho-oauthtoken {access_token}')),
                        query = list(criteria = criteria,
                                     limit = 200,
                                     from = 1))


raw_report <- fromJSON(content(response_report, 'text'))$data

View(raw_report)
