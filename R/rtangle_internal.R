#' @importFrom magrittr "%>%"

.onAttach <-
  function(libname, pkgname) {
    packageStartupMessage("\nPlease cite as: \n")
    packageStartupMessage(" Schliebs, Marcel (2020). rtangle: R Interface for CrowdTangle Facebook API.")
    packageStartupMessage(" R package version 0.9.0.0 schliebs.github.io/rtangle")
  }

# ct_datetime <- function(datetime,format = "%Y-%m-%d %H:%M:%S"){
#
#   lubri <- lubridate::fast_strptime(x = datetime,format = format)
#  # lubri %>% format("%Y")
# }

#lubridate::now() %>% ct_datetime()

ct_now <- function(){
  ct_time <- lubridate::now() %>% format("%Y-%m-%dT%H:%M:%S")
  ct_time
}

ct_today <- function(){
  ct_time <- lubridate::now() %>% format("%Y-%m-%d")
  ct_time
}



crowdtangle_api <- function(endpoint,params = list(),timeout = 200) {
  url <- httr::modify_url("https://api.crowdtangle.com", path = endpoint)

  resp <- httr::GET(url = url,
                    query = params,
                    httr::timeout(timeout))

  if (httr::http_type(resp) != "application/json") {
    print(resp)
    stop("API did not return json", call. = TRUE)
  }

  parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE)

  if(parsed$status != 200){
    print("error occured: ")
    print(parsed)
  }

  structure(
    list(
      content = parsed,
      path = endpoint,
      response = resp
    ),
    class = "crowdtangle_api"
  )
}

print.crowdtangle_api <- function(x, ...) {
  cat("<CrowdTangle ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}

# crowdtangle_api(endpoint = "posts/search",
#                 params = list(token = crowdtangle_token()))

crowdtangle_multitry <- function(endpoint,
                                 params = list(),
                                 timeout = 200,
                                 n_tries = 5,
                                 possibly_wrapper = TRUE){

  tries = 0

  # check if BOTH tries are not exeeded AND a response object does either not
  # exist or is not 200.
  while((tries < n_tries) &
        ifelse(test = exists(x ="res"), # fix if user has this in environment
               yes = (res$content$status != "200"),
               no = TRUE)
  ){

    # conservative sleeping to prevent 504 error
    if(tries > 0){
      print("lol erstmal schlafen damit vlt scheiss fehler weg geht")
      Sys.sleep(30)
    }

    tries = tries+1
    print(paste0("try for the ",tries,"th time."))

    if(possibly_wrapper == T){
      ct_api_safe <- purrr::possibly(
        .f = crowdtangle_api,
        otherwise = list(content = list(status = "6666"))
      )
    }else{
      print("heyy")
      ct_api_safe <- crowdtangle_api
    }


    res <- ct_api_safe(endpoint = endpoint,
                        params = params,
                        timeout = timeout)

  }
  if(tries == n_tries){
    paste0("too many errors, tried 5 times")
    stop("error")
  }

  return(res)

}

 # xxx <- crowdtangle_multitry(endpoint = "posts/search",
 #                 params = list(token = crowdtangle_token()),
 #                 timeout = 200,
 #                 n_tries = 5)


