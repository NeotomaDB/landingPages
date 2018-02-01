call_sql <- function(x, ds_id) {
  
  connection <- x
  
  interp <- function(x, con, ds_id) {
    x %>% 
      DBI::sqlInterpolate(con, 
                        sql = .,
                        ds_id = ds_id) %>% 
      DBI::dbGetQuery(con, .) %>% suppressWarnings()
  }
  
  con <- DBI::dbConnect(RPostgreSQL::PostgreSQL(), 
                        host = connection$host,
                        port = connection$port,
                        dbname = connection$database,
                        user = connection$user,
                        password = connection$password)
  
  default <- readr::read_file('sql_queries/data_citation.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  if(nrow(default) == 0) {
    
    DBI::dbDisconnect(conn = con)
    
    stop("Empty dataset ID.")
  }
    
  contacts <- readr::read_file('sql_queries/contact_ids.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  dates <- readr::read_file('sql_queries/call_dates.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  sitedesc <- readr::read_file('sql_queries/sitedesc.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  constdb <-  readr::read_file('sql_queries/const_db.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  geoloc <-   readr::read_file('sql_queries/geoloc.sql') %>% 
    interp(con = con, ds_id = ds_id) %>% as.character %>% 
    strsplit(., ' ')
  
  publn <-    readr::read_file('sql_queries/publicn.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  agerange <- readr::read_file('sql_queries/dsagerange.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  sharedds <- readr::read_file('sql_queries/sharedds.sql') %>% 
    interp(con = con, ds_id = ds_id)
  
  DBI::dbDisconnect(conn = con)
  
  return(list(defaults = default, 
              contacts = contacts, 
                 dates = dates, 
               descrip = sitedesc, 
           constituent = constdb, 
                  locs = geoloc[[1]],
                 range = agerange,
                 sites = sharedds,
                 publn = publn))
}