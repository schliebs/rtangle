#' Parse CT Post List object
#'
#' Parses list of CT post objects(lists) into R data.frame
#'
#' @param postlist A list with CT post objects
#' @param ... Additional parameters to be specified.
#' @export
#' @examples
#' # Pull all posts from November 2020 by CNN containing the term "Trump"
#' library(dplyr)
#' cnn_postlist  <- posts_search(token = crowdtangle_token(),
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
#'
#' # Parse postlist to R data.frame
#' cnn_df <- cnn_postlist %>% parse_posts()
#'
parse_posts <- function(postlist,
                        ...
                         ){


  flat <- purrr::map(.x = postlist,
                     .f = function(inner){

                       inner["n_urls"] <-
                         purrr::map(.x = inner["expandedLinks"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[1]]))[[1]] %>% length()

                       inner["original_urls"] <-
                         purrr::map(.x = inner["expandedLinks"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[1]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["expanded_urls"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[2]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["expandedLinks"] <- NULL


                       inner["n_media"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[1]]))[[1]] %>% length()


                       inner["media_type"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[1]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["media_url"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[2]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["media_height"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[3]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["media_width"] <-
                         purrr::map(.x = inner["media"],
                             .f = ~ purrr::map(.x = .x,
                                        .f = ~ .x[[4]])
                         )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       # inner["media_full"] <-
                       #   purrr::map(.x = inner["media"],
                       #       .f = ~ purrr::map(.x = .x,
                       #                  .f = ~ .x[[5]])
                       #   )[[1]] %>% paste0(.,collapse = " ;;||;; ")

                       inner["media"] <- NULL


                       flattened <- rlist::list.flatten(x = inner)
                       return(flattened)
                     }



  ) %>% bind_rows()
  return(flat)
}

# xx <-
#   out %>%
#   parse_posts()
