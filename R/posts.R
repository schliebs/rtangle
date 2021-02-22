#' R Interface for
#'
#' Pulls posts
#'
#' @param token A valid CT API Token
#' @param accounts ...
#' @param brandedContent ...
#' @param count ...
#' @param endDate ...
#' @param includeHistory ...
#' @param language ...
#' @param listIds ...
#' @param offset ...
#' @param pageAdminTopCountry ...
#' @param platforms ...
#' @param searchField ...
#' @param searchTerm ...
#' @param startDate ...
#' @param sortBy ...
#' @param timeframe ...
#' @param types ...
#' @param verified ...
#' @param weights Not yet implemented
#' @param search10k A boolean signifying whether you have elavated access for higher count numbers.
#' @param boolean_allowed A boolean signifying whether you have boolean term search enabled.
#' @param output_raw A boolean signifying whether to output raw CT output or parse into df. Defaulting to `TRUE`.
#' @export
#' @examples
#' # Pull all posts from November 2020 by CNN containing the term "Trump"
#' postlist <- posts_search(token = crowdtangle_token(),
#'                     inAccountIds = "8323", #CNN example
#'                     searchTerm = "Trump",
#'                     startDate = "2020-11-01T00:00:00",
#'                     endDate = "2020-11-30T23:59:59",
#'                     count = 10000,
#'                     sortBy = 'date',
#'                     platforms = 'facebook',
#'                     search10k = T,
#'                     boolean_allowed = T,
#'                     output_raw = TRUE)
posts <- function(token,
                         accounts = NULL,
                         brandedContent = "no_filter",
                         count = 10,
                         endDate = ct_now(),
                         includeHistory = NULL,
                         language = NULL,
                         listIds = NULL,
                         minInteractions = 0,
                         offset = 0,
                         pageAdminTopCountry = NULL,
                         searchTerm = "",
                         startDate = NULL,
                         sortBy = 'date',
                         timeframe = NULL,
                         types = NULL,
                         verified = "no_filter",
                         search10k = FALSE,
                         boolean_allowed = FALSE,
                         output_raw = TRUE,
                error_wrapper = T
){

  print("collecting posts")

  params <- list('token' = token,
                 'accounts' = accounts,
                 'brandedContent' = brandedContent,
                 'count' = count,
                 'endDate' = endDate,
                 'includeHistory' = includeHistory,
                 'language' = language,
                 'listIds' = listIds,
                 'minInteractions' = minInteractions,
                 'offset' = offset,
                 'pageAdminTopCountry' = pageAdminTopCountry,
                 'searchTerm' =searchTerm,
                 'startDate' = startDate,
                 'sortBy' = 'date',
                 'timeframe' = timeframe,
                 'types' = types,
                 'verified' = verified)


  # Check if nothing is violated
  if(

    (lubridate::fast_strptime(endDate,format = "%Y-%m-%dT%H:%M:%S") -
     lubridate::fast_strptime(startDate,format = "%Y-%m-%dT%H:%M:%S")
    ) >= lubridate::years(1)

  ) stop("Maximum range between startDate and endDate is 1 year.")


  if(search10k == FALSE){
    1+1
  }


  if(search10k == TRUE){

    params$offset = NULL

    if(count > 10000)stop("too high count requested")

    postlist <- list()
    firstcall <- TRUE

    while((firstcall == T)|
          ifelse(test = exists(x ="result_content"),
                 yes = length(result_content$pagination) != 0,
                 no = TRUE)){

      #print(params)


      if(firstcall == FALSE){
        wait_till(from = lastpost,
                  seconds = 11)
        print("sleep 12 secs then next batch")
        #print(params$endDate)
      }

      lastpost <- lubridate::now()
      result <- crowdtangle_multitry(endpoint = "posts",
                                     params = params,
                                     timeout = 200,
                                     n_tries = 10,
                                     possibly_wrapper = error_wrapper)

      result_content <- result$content$result
      postlist = append(postlist, result_content$posts)

      # new enddate
      if(length(result_content$posts) > 0){
        params$endDate <-
          result_content$posts[[length(result_content$posts)]]$date %>%
          stringr::str_replace_all(" ","T")
      }else{
        print(paste0("0 results found for params:  ",paste0(params,collapse = "  |  ")))
      }

      firstcall <- FALSE

    }

    print(paste0("now collected ",length(postlist)," entries"))


  }

  if(output_raw == TRUE){
    return(postlist)
  }
}

token <- "JNmeGpGGpptF0C7jyHtoblI2F8NEP8awZ5ne99YE"

# system.time({
#   out <-
#     posts(token = token,
#          accounts = "199676426877938", #TRT World
#          searchTerm = NULL,
#          startDate = "2019-02-20T00:00:00",
#          endDate = "2021-02-19T23:59:59",
#          count = 10000,
#          sortBy = 'date',
#          search10k = T,
#          boolean_allowed = T,
#          output_raw = TRUE,
#           error_wrapper = FALSE)
# })


#
# params <-
#   list(token = token,
#        accounts = "199676426877938", #TRT World
#                  searchTerm = NULL,
#                  startDate = "2019-02-20T00:00:00",
#                  endDate = "2021-02-19T23:59:59",
#                  count = 10000,
#                  sortBy = 'date')
#
# endpoint <- "posts"
# timeout = 200
#   url <- httr::modify_url("https://api.crowdtangle.com", path = endpoint)
#
#   resp <- httr::GET(url = url,
#                     query = params,
#                     httr::timeout(timeout))
#
#   if (httr::http_type(resp) != "application/json") {
#     print(resp)
#     stop("API did not return json", call. = TRUE)
#   }
#
#   parsed <- jsonlite::fromJSON(httr::content(resp, "text"), simplifyVector = FALSE)
#
#   structure(
#     list(
#       content = parsed,
#       path = endpoint,
#       response = resp
#     ),
#     class = "crowdtangle_api"
#   )

