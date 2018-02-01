library(dplyr)
#' @title Obtain existing Neotoma DOIs
#' @description Obtain all Neotoma DOIs from DataCite
#' @author Simon Goring
#' @details Function uses the \code{rdatacite} package to pull all existing
#' neotoma DOIs and place them into a \code{data.frame}.
#' @import dplyr
#' @mportFrom stringr str_detect 
#' @importFrom rdatacite dc_search
#' @export
#' @example validate_dois()

validate_dois <- function(x) {
  
  if (is.null(curl::nslookup("https://search.datacite.org/", error = FALSE))) {
    stop('No DataCite connection detected.')
  }
  
   test <- NA
  start <- 1
   rows <- 10
      
  while(!'try-error' %in% class(test) | length(test) == 0) {
    test <- try(rdatacite::dc_search(q = "publisher:Neotoma", 
                              rows = rows,
                             start = start))
    
    if (length(test) == 0) break
    
    if ('try-error' %in% class(test)) {
      
      while (all(stringr::str_detect(test, "50.{1}"))) {
        
        Sys.sleep(3)
        message('waiting for three seconds.\n')
        test <- try(rdatacite::dc_search(q = "publisher:Neotoma", 
                                         rows = rows,
                                         start = start))
      }
    }
     
    if (!'try-error' %in% class(test)) {
      if (start == 1) {
        output <- test
      } else {
        output <- output %>% dplyr::bind_rows(test)
      }
        
      start <- start + rows
    }
  }
  
   return(output)
}