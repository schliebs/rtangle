#' R Interface for CT Link Search
#'
#' Searches for link shares by public pages, groups, profiles on FB/IG
#'
#' @param token A valid CT API Token
#' @param count ...
#' @param endDate ...
#' @param includeHistory ...
#' @param link A URL
#' @param includeSummary ... (Defaults to "false")
#' @param offset ... (Usually you want to leave this at 0 and paginate via dates only)
#' @param platforms ...
#' @param searchField ...
#' @param startDate ...
#' @param sortBy ...
#' @param output_raw A boolean signifying whether to output raw CT output or parse into df. Defaulting to `TRUE`.
#' @examples
#' postlist <-
#' links(token = crowdtangle_token(),
#'       count = 1000,
#'       endDate = '2020-12-31',
#'       includeHistory = NULL,
#'       link = "rt.com",
#'       includeSummary= 'false',
#'       offset = 0,
#'       platforms = 'facebook',
#'       searchField = 'Include_query_strings',
#'       startDate = '2020-06-01T00:00:00',
#'       sortBy = 'date')
#' @export
links <- function(token,
                  count = 100,
                  endDate = ct_now(),
                  includeHistory = NULL,
                  link = NULL,
                  includeSummary = "false",
                  offset = 0,
                  platforms = NULL,
                  searchField = NULL,
                  startDate = NULL,
                  sortBy = "date",
                  output_raw = TRUE
                         ){

  print("collecting link shares")

  params <- list('token' = token,
                 'count' = count,
                 'endDate' = endDate,
                 'includeHistory' = includeHistory,
                 'link' = link,
                 'includeSummary' = includeSummary,
                 'offset' = offset,
                 'searchField' = searchField,
                 'startDate' = startDate,
                 'sortBy' = sortBy)

  "
  token <- rtangle::crowdtangle_token()
  link <- 'rt.com'
  params <-
    list('token' = token,
         'count' = 1000,
         'endDate' = '2020-07-10T11:59:59',
         'includeHistory' = NULL,
         'link' = link,
         'includeSummary' = 'false',
         'offset' = 9000,
         'platforms' = 'facebook',
         'searchField' = 'Include_query_strings',
         'startDate' = '2020-06-10T00:00:00',
         'sortBy' = 'date')
  "


  # Check if nothing is violated
    if(1==2) stop("Maximum range between startDate and endDate is 1 year.")

    if(count > 1000)stop("too high count requested")

    postlist <- list()
    firstcall <- TRUE
    result_content <- NULL

    while((firstcall == T)|
          (!is.null(result_content$pagination$nextPage))
          # ifelse(test = exists(x ="result_content"),
          #        yes = ,
          #        no = TRUE)
          ){

    #print(params)
      #print("lalala")
      #print(result_content$pagination)
      #print(firstcall)


      if(firstcall == FALSE){
        wait_till(from = lastpost,
                  seconds = 31)
        print("sleep 31 secs then next batch")
        #print(params$endDate)
      }

      #print(params)
      lastpost <- lubridate::now()
      result <- rtangle:::crowdtangle_multitry(endpoint = "links",
                      params = params,
                      timeout = 200,
                      n_tries = 10)

      result_content <- result$content$result
      postlist = append(postlist, result_content$posts)

      # new enddate
      if(length(result_content$posts) > 0){
        params$endDate <-
          result_content$posts[[length(result_content$posts)]]$date %>%
          stringr::str_replace_all(" ","T")
        print(paste0("resetting END DATE to ",as.character(params$endDate)))
      }else{
        print(paste0("0 results found for params:  ",paste0(params,collapse = "  |  ")))
      }

      firstcall <- FALSE

    }

    print(paste0("now collected ",length(postlist)," entries"))


  if(output_raw == TRUE){
    return(postlist)
  }
}


