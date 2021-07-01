#' R Interface for
#'
#' Pulls posts
#'
#' @param token A valid CT API Token
#' @param accountTypes ...
#' @param and ...
#' @param brandedContent ...
#' @param count ...
#' @param endDate ...
#' @param includeHistory ...
#' @param inAccountIds ...
#' @param inListIds ...
#' @param language ...
#' @param minInteractions ...
#' @param minSubscriberCount ...
#' @param not ...
#' @param notInAccountIds ...
#' @param notInLstIds ...
#' @param notInTitle ...
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
#' @param verifiedOnly ...
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
posts_search <- function(token,
                         accountTypes = NULL,
                         and = NULL,
                         brandedContent = "no_filter",
                         count = 10,
                         endDate = ct_now(),
                         includeHistory = NULL,
                         inAccountIds = NULL,
                         inListIds = NULL,
                         language = NULL,
                         minInteractions = 0,
                         minSubscriberCount = 0,
                         not = NULL,
                         notInAccountIds = NULL,
                         notInLstIds = NULL,
                         notInTitle = NULL,
                         offset = 0,
                         pageAdminTopCountry = NULL,
                         platforms = NULL,
                         searchField = "text_fields_and_image_text",
                         searchTerm = "",
                         startDate = NULL,
                         sortBy = 'date',
                         timeframe = NULL,
                         types = NULL,
                         verified = "no_filter",
                         verifiedOnly = "false",
                         search10k = FALSE,
                         boolean_allowed = FALSE,
                         output_raw = TRUE,
                         error_wrapper = T
                         ){

  print("collecting posts")

  params <- list('token' = token,
                 'accountTypes' = accountTypes,
                 'and' = and,
                 'brandedContent' = brandedContent,
                 'count' = count,
                 'endDate' = endDate,
                 'includeHistory' = includeHistory,
                 'inAccountIds' = inAccountIds,
                 'inListIds' = inListIds,
                 'language' = language,
                 'minInteractions' = minInteractions,
                 'minSubscriberCount' = minSubscriberCount,
                 'not' = not,
                 'notInAccountIds' = notInAccountIds,
                 'notInLstIds' = notInLstIds,
                 'notInTitle' = notInTitle,
                 'offset' = offset,
                 'pageAdminTopCountry' = pageAdminTopCountry,
                 'platforms' = platforms,
                 'searchField' = searchField,
                 'searchTerm' =searchTerm,
                 'startDate' = startDate,
                 'sortBy' = 'date',
                 'timeframe' = timeframe,
                 'types' = types,
                 'verified' = verified,
                 'verifiedOnly' = verifiedOnly)


  # Check if nothing is violated
  if(1==2) stop("Maximum range between startDate and endDate is 1 year.")

  params$offset = NULL

  if(search10k == FALSE){

    if(count > 100)stop("too high count requested")

  }


  if(search10k == TRUE){


    if(count > 10000)stop("too high count requested")

  }

  postlist <- list()
  firstcall <- TRUE

  while((firstcall == T)|
        ifelse(test = exists(x ="result_content"),
               #yes
               yes = (length(result_content$pagination) != 0) &
                     ifelse(test = exists(x ="result_content$pagination"),
                            yes = (as.numeric(str_extract(result_content$pagination$nextPage,
                                             "(?<=count=)[0-9]*"))
                      >
                      as.numeric(str_extract(result_content$pagination$nextPage,
                                             "(?<=offset=)[0-9]*"))
                      ),
                      no = TRUE),
               #no
               no = TRUE)){

  #print(params)



    if(firstcall == FALSE){
      wait_till(from = lastpost,
                seconds = 11)
      print("sleep 12 secs then next batch")
      #print(params$endDate)
    }

    lastpost <- lubridate::now()
    result <- crowdtangle_multitry(endpoint = "posts/search",
                    params = params,
                    timeout = 200,
                    n_tries = 10,
                    possibly_wrapper = error_wrapper)

    result_content <- result$content$result

    print(result_content$pagination)

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




  if(output_raw == TRUE){
    return(postlist)
  }
}

# system.time({
#   out <-
#     posts_search(token = crowdtangle_token(),
#                  inAccountIds = "8323", #CNN example
#                  searchTerm = "Trump",
#                  startDate = "2013-12-21T00:00:00",
#                  endDate = "2013-12-31T23:59:59",
#                  count = 10000,
#                  sortBy = 'date',
#                  platforms = 'facebook',
#                  search10k = T,
#                  boolean_allowed = T,
#                  output_raw = TRUE)
# })
