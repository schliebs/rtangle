
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rtangle

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ggecon)](https://CRAN.R-project.org/package=ggecon)
<!-- badges: end -->

## Installation and Loading

``` r
devtools::install_github("schliebs/rtangle")
```

``` r
library(rtangle)
library(dplyr)
library(purrr)
```

## API Authentication

There are two options to set a CT API token and save it in the system
environment. The first one is to trigger an RStudio window opening, and
entering the token.

``` r
set_crowdtangle_token(option = "enter")
```

The second option is to store the CT token as a txt file in a secure
local location that is not synched with git or shared with other users.

``` r
set_crowdtangle_token(option = "txt",
                      tokenpath = "./nogit/confidential/CT_token.txt")
```

Now, when calling a function that uses the API, the token can be passed
by using `crowdtangle_token()` as an argument to the function.

``` r
crowdtangle_token()
```

## CT Post Search

With the `posts_search` wrapper, you can search posts, either globally
within the whole CT database, or within a limited set of `AccountIds` or
`ListIds`. Note that this endpoint is not available to all customers and
needs to be requested and approved by the CT team.

Currently, the following parameters are available withint post\_search

``` r
posts_search(
  token,
  accountTypes = NULL,
  and = NULL,
  brandedContent = "no_filter",
  count = 10,
  endDate = rtangle:::ct_now(),
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
  sortBy = "date",
  timeframe = NULL,
  types = NULL,
  verified = "no_filter",
  verifiedOnly = "false",
  search10k = FALSE,
  boolean_allowed = FALSE,
  output_raw = TRUE
)
```

See further `help(posts_search)` for additional infomation on available
options and parameters.

As an example, we query the API for all posts made by CNN’s Facebook
page in November 2020 which contained the term ‘Trump’. We also limit
the results to posts on Facebook, and specify that our accoun has
elevated search priviledges, allowing us to pull 10,000 posts at a time.

``` r
cnn_postlist <- 
  posts_search(token = crowdtangle_token(),
               inAccountIds = "8323", #CNN CT ID obtained via `list_details()`
               searchTerm = "Trump",
               startDate = "2020-11-01T00:00:00",
               endDate = "2020-11-30T23:59:59",
               count = 10000,
               sortBy = 'date',
               platforms = 'facebook',
               search10k = T,
               boolean_allowed = T,
               output_raw = TRUE)
#> [1] "collecting posts"
#> [1] "try for the 1th time."
#> [1] "now collected 272 entries"
```

``` r
class(cnn_postlist)
#> [1] "list"
```

``` r
length(cnn_postlist)
#> [1] 272
```

``` r
cnn_postlist[[1]] %>% str()
#> List of 18
#>  $ platformId     : chr "5550296508_10161518326346509"
#>  $ platform       : chr "Facebook"
#>  $ date           : chr "2020-11-30 21:30:37"
#>  $ updated        : chr "2020-12-07 16:34:29"
#>  $ type           : chr "link"
#>  $ title          : chr "Trump said the stock market would crash if Biden won. The Dow is having its best month since 1987."
#>  $ caption        : chr "cnn.com"
#>  $ message        : chr "President Donald J. Trump repeatedly warned Americans that if they failed to reelect him, the stock market woul"| __truncated__
#>  $ expandedLinks  :List of 1
#>   ..$ :List of 2
#>   .. ..$ original: chr "https://cnn.it/3fS1yIP"
#>   .. ..$ expanded: chr "https://www.cnn.com/2020/11/30/business/stock-market-dow-jones-trump-biden/index.html?utm_medium=social&utm_sou"| __truncated__
#>  $ link           : chr "https://cnn.it/3fS1yIP"
#>  $ postUrl        : chr "https://www.facebook.com/cnn/posts/10161518326346509"
#>  $ subscriberCount: int 34026501
#>  $ score          : num 17.1
#>  $ media          :List of 1
#>   ..$ :List of 5
#>   .. ..$ type  : chr "photo"
#>   .. ..$ url   : chr "https://external-sea1-1.xx.fbcdn.net/safe_image.php?d=AQBLnCLBTxgZBFRx&w=619&h=619&url=https%3A%2F%2Fcdn.cnn.co"| __truncated__
#>   .. ..$ height: int 619
#>   .. ..$ width : int 619
#>   .. ..$ full  : chr "https://external-sea1-1.xx.fbcdn.net/safe_image.php?d=AQBdtsImuhon9qEa&url=https%3A%2F%2Fcdn.cnn.com%2Fcnnnext%"| __truncated__
#>  $ statistics     :List of 2
#>   ..$ actual  :List of 10
#>   .. ..$ likeCount    : int 52914
#>   .. ..$ shareCount   : int 7828
#>   .. ..$ commentCount : int 22180
#>   .. ..$ loveCount    : int 9397
#>   .. ..$ wowCount     : int 468
#>   .. ..$ hahaCount    : int 27454
#>   .. ..$ sadCount     : int 65
#>   .. ..$ angryCount   : int 171
#>   .. ..$ thankfulCount: int 0
#>   .. ..$ careCount    : int 240
#>   ..$ expected:List of 10
#>   .. ..$ likeCount    : int 4129
#>   .. ..$ shareCount   : int 514
#>   .. ..$ commentCount : int 1492
#>   .. ..$ loveCount    : int 212
#>   .. ..$ wowCount     : int 149
#>   .. ..$ hahaCount    : int 232
#>   .. ..$ sadCount     : int 175
#>   .. ..$ angryCount   : int 152
#>   .. ..$ thankfulCount: int 0
#>   .. ..$ careCount    : int 61
#>  $ account        :List of 11
#>   ..$ id                 : int 8323
#>   ..$ name               : chr "CNN"
#>   ..$ handle             : chr "cnn"
#>   ..$ profileImage       : chr "https://scontent-sjc3-1.xx.fbcdn.net/v/t31.0-1/p200x200/12304053_10154246192721509_1897912583584847639_o.png?_n"| __truncated__
#>   ..$ subscriberCount    : int 34036958
#>   ..$ url                : chr "https://www.facebook.com/5550296508"
#>   ..$ platform           : chr "Facebook"
#>   ..$ platformId         : chr "5550296508"
#>   ..$ accountType        : chr "facebook_page"
#>   ..$ pageAdminTopCountry: chr "US"
#>   ..$ verified           : logi TRUE
#>  $ newId          : chr "8323|10161518326346509"
#>  $ id             : num 1.12e+11
```

## Parsing Posts

We can now parse the list of `CT Post` objects into an R data.frame:

``` r
cnn_df <- cnn_postlist %>% parse_posts()
```

``` r
names(cnn_df)
#>  [1] "platformId"                        "platform"                         
#>  [3] "date"                              "updated"                          
#>  [5] "type"                              "title"                            
#>  [7] "caption"                           "message"                          
#>  [9] "link"                              "postUrl"                          
#> [11] "subscriberCount"                   "score"                            
#> [13] "statistics.actual.likeCount"       "statistics.actual.shareCount"     
#> [15] "statistics.actual.commentCount"    "statistics.actual.loveCount"      
#> [17] "statistics.actual.wowCount"        "statistics.actual.hahaCount"      
#> [19] "statistics.actual.sadCount"        "statistics.actual.angryCount"     
#> [21] "statistics.actual.thankfulCount"   "statistics.actual.careCount"      
#> [23] "statistics.expected.likeCount"     "statistics.expected.shareCount"   
#> [25] "statistics.expected.commentCount"  "statistics.expected.loveCount"    
#> [27] "statistics.expected.wowCount"      "statistics.expected.hahaCount"    
#> [29] "statistics.expected.sadCount"      "statistics.expected.angryCount"   
#> [31] "statistics.expected.thankfulCount" "statistics.expected.careCount"    
#> [33] "account.id"                        "account.name"                     
#> [35] "account.handle"                    "account.profileImage"             
#> [37] "account.subscriberCount"           "account.url"                      
#> [39] "account.platform"                  "account.platformId"               
#> [41] "account.accountType"               "account.pageAdminTopCountry"      
#> [43] "account.verified"                  "newId"                            
#> [45] "id"                                "n_urls"                           
#> [47] "original_urls"                     "expanded_urls"                    
#> [49] "n_media"                           "media_type"                       
#> [51] "media_url"                         "media_height"                     
#> [53] "media_width"                       "description"                      
#> [55] "videoLengthMS"                     "liveVideoStatus"                  
#> [57] "imageText"
```

``` r
library(ggplot2)

cnn_by_day <- 
  cnn_df %>% 
  mutate(day = date %>% 
           lubridate::as_datetime() %>% 
           lubridate::round_date(unit = "day")) %>% 
  group_by(day) %>% 
  summarise(n = n())

ggplot(cnn_by_day,
       aes(x = day,
           y = n)) + 
  geom_line() + 
  geom_point() +
  labs(x = "Day",
       y = "CNN Posts mentioning 'Trump'")
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

## Link Search

Search all link shares of “rt.com” on December 7th, 2020

``` r
rt_postlist <-
 links(token = crowdtangle_token(),
       count = 1000,
       endDate = '2020-12-07T23:59:59',
       includeHistory = NULL,
       link = "rt.com",
       includeSummary= 'false',
       offset = 0,
       platforms = 'facebook',
       searchField = 'Include_query_strings',
       startDate = '2020-12-07T00:00:00',
       sortBy = 'date')
#> [1] "collecting link shares"
#> [1] "try for the 1th time."
#> [1] "resetting END DATE to 2020-12-07T17:33:57"
#> [1] "Pausing Scripts until 2020-12-08 10:43:28"
#> [1] "sleep 31 secs then next batch"
#> [1] "try for the 1th time."
#> [1] "resetting END DATE to 2020-12-07T09:18:21"
#> [1] "Pausing Scripts until 2020-12-08 10:44:00"
#> [1] "sleep 31 secs then next batch"
#> [1] "try for the 1th time."
#> [1] "resetting END DATE to 2020-12-07T00:00:00"
#> [1] "now collected 2558 entries"
```

``` r
rt_df <- 
  rt_postlist %>% 
  parse_posts()
```

``` r
rt_df %>% 
  arrange(desc(statistics.actual.likeCount)) %>% 
  select(date,link,subscriberCount,statistics.actual.likeCount,title) %>% 
  mutate(title = title %>% stringr::str_sub(1,50))%>%
  mutate(link = link %>% stringr::str_sub(1,50))%>%
  head()
#> # A tibble: 6 x 5
#>   date      link             subscriberCount statistics.actual~ title           
#>   <chr>     <chr>                      <int>              <int> <chr>           
#> 1 2020-12-~ https://arabic.~        16218229              17491 "<U+0627><U+0644><U+062C><U+0632><U+0627><U+0626><U+0631> <U+062A><U+062D><U+062C><U+0632> <U+0637>~
#> 2 2020-12-~ https://www.fac~          416724              10580  <NA>           
#> 3 2020-12-~ https://arabic.~          783377               8768 "<U+0635><U+0644><U+0627><U+062D> <U+064A><U+0648><U+0627><U+0635><U+0644> <U+0647><U+064A><U+0645>~
#> 4 2020-12-~ https://arabic.~        16218229               8288 "<U+062E><U+0628><U+064A><U+0631> <U+0625><U+0633><U+0631><U+0627><U+0626><U+064A><U+0644><U+064A>:~
#> 5 2020-12-~ https://arabic.~        16218229               7180 "<U+0643><U+064A><U+0641> <U+0631><U+062F> <U+0635><U+062F><U+0627><U+0645> <U+062D><U+0633>~
#> 6 2020-12-~ https://arabic.~        16218229               6662 "<U+0637><U+0647><U+0631><U+0627><U+0646> <U+062A><U+0631><U+062F> <U+0639><U+0644><U+0649> ~
```

``` r
rt_df %>% 
  group_by(link) %>% 
  summarise(likes = sum(statistics.actual.likeCount,na.rm = T),
            audience = sum(subscriberCount,na.rm = T)) %>% 
  arrange(desc(likes)) %>% 
  mutate(link = link %>% stringr::str_sub(1,70))%>%
  head(20)
#> `summarise()` ungrouping output (override with `.groups` argument)
#> # A tibble: 20 x 3
#>    link                                                           likes audience
#>    <chr>                                                          <int>    <int>
#>  1 https://arabic.rt.com/press/1180616-%D8%A7%D9%84%D8%AC%D8%B2%~ 17613 16863919
#>  2 https://www.facebook.com/environman.th/photos/a.1745027465625~ 11351  1109358
#>  3 https://arabic.rt.com/sport/1180604-%D8%B5%D9%84%D8%A7%D8%AD-~  9040 17033130
#>  4 https://arabic.rt.com/world/1180580-%D9%83%D8%B4%D9%81-%D8%A7~  8288 16218229
#>  5 https://arabic.rt.com/middle_east/1180637-%D8%A7%D8%AE%D8%AA%~  7492 41671880
#>  6 https://arabic.rt.com/middle_east/1180588-%D9%83%D9%8A%D9%81-~  7187 16249241
#>  7 https://arabic.rt.com/world/1180662-%D8%A7%D9%84%D8%AE%D8%A7%~  6662 16218229
#>  8 https://arabic.rt.com/world/1180612-%D9%85%D9%88%D9%82%D8%B9-~  5029 16218229
#>  9 https://arabic.rt.com/middle_east/1180904-%D8%AC%D9%8A%D9%81%~  4912 16218229
#> 10 https://actualidad.rt.com/actualidad/376020-chavismo-lidera-e~  4832 18588103
#> 11 https://arabic.rt.com/russia/1180897-%D8%B3%D9%8A%D9%86%D8%A7~  4707 16333114
#> 12 https://actualidad.rt.com/actualidad/376048-farmaco-oral-moln~  4475 16949999
#> 13 https://arabic.rt.com/world/1180607-%D8%A7%D8%AC%D8%AA%D9%81%~  4368 16334659
#> 14 https://arabic.rt.com/world/1180896-%D8%A7%D9%84%D9%85%D9%82%~  3579 16218229
#> 15 https://arabic.rt.com/middle_east/1180772-%D9%85%D8%A7%D9%83%~  3558 17790087
#> 16 https://arabic.rt.com/middle_east/1180788-%D9%85%D8%A7%D9%83%~  3541 16235318
#> 17 https://arabic.rt.com/technology/1180729-%D8%AF%D8%B1%D9%88%D~  2950 16223035
#> 18 https://arabic.rt.com/middle_east/1180834-%D8%A7%D8%AD%D8%AA%~  2827 16244435
#> 19 https://arabic.rt.com/middle_east/1180765-%D9%85%D8%A7%D9%83%~  2572 16218229
#> 20 https://arabic.rt.com/world/1180609-%D9%88%D9%81%D8%A7%D8%A9-~  2471 16218229
```

## Adaptive Time-Frame adjustment and Pagination

t.b.c.

## Additional Helper Functions made available via Namespace Export

### Adaptive Waiting and Sleeping to Respect API Limits

Continue script after 20:30:34 on November 14th 2020

``` r
continue_at <- lubridate::as_datetime("2020-11-14 20:30:34")
wait_till(resume = continue_at, seconds = 12)
```

Continue script 60 seconds after the last call was made:

``` r
last_timestamp <- lubridate::now()
# ... (Some function is executed)
wait_till(from = last_timestamp, seconds = 60)
```
