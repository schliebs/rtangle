# token = crowdtangle_token()
#
# #link = "cgtn.com"
# #link = "http://german.people.com.cn/"
# link = "cgtn.com"
#
#
#
# endpoint = "links"
#
#
# system.time({
#   outt <-
#     links(token,
#           count = 1000,
#           endDate = '2020-07-09T23:59:59',
#           includeHistory = NULL,
#           link = link,
#           includeSummary= 'false',
#           offset = 0,
#           platforms = 'facebook',
#           searchField = 'Include_query_strings',
#           startDate = '2020-06-10T00:00:00',
#           sortBy = 'date'
#     )
# })
#
#
#
# system.time({
#   xx <-
#     rtangle:::crowdtangle_api(endpoint = endpoint,
#                               params = params,
#                               timeout = 200)
# })
