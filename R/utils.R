#' Obtain CT Token from system environment
#'
#' Allows to retrieve a CT API token that has been previously written to the
#' system environment.
#'
#' @return A string with a CT API Token.
#' @usage Warning: Never store your API token in plain text or print it in public scripts.
#' @export
#' @examples
#' # Set CT Token (Once per session)
#'
#'  # set_crowdtangle_token(option = 'enter')
#'
#' # Load token for use with CT API calls
#'
#' #crowdtangle_token()
crowdtangle_token <- function(tokenname = 'CT_TOKEN') {
  pat <- Sys.getenv('CT_TOKEN')
  if (identical(pat, "")) {
    stop('Please set env var CT_TOKEN to your github personal access token via

Sys.setenv(CT_TOKEN = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX")',
         call. = FALSE)
  }
  pat
}


#' Write CT Token to system environment
#'
#' Allows to write a CT API token to the
#' system environment.
#' @param option `enter` if token shall be entered in a prompted RStudio window, and `txt` if the token is provided as a txt file.
#' @param tokenpath Only required if `option == 'txt'`. Path where txt file with token is stored.
#' @param tokenname Name under which token shall be saved in system environment. Defaults to "CT_TOKEN".
#' @return A string with a CT API Token.
#' @usage Warning: Never store your API token in plain text within public or semi-public environments, or print it in public scripts.
#' @export
#' @examples
#' # Set CT Token (Once per session)
#' #set_crowdtangle_token(option = "enter")
set_crowdtangle_token <- function(option = "enter",
                                  tokenpath = NULL,
                                  tokenname = 'CT_TOKEN') {

  if(option == "enter"){
    token <- rstudioapi::askForPassword("Please enter your CT API Token")
  }else if(option == "txt"){
    token <- read.table(file = tokenpath) %>% as.character()
  }

  Sys.setenv(CT_TOKEN = token)
  print(paste0("Successfully set Token '",tokenname,"' to system environment."))

}





#' Planned sleep times
#'
#' Pause the execution of a script either until a certain time is reached,
#' or until a specified amount of time has passed.
#'
#' @param resume A datetime object, representing when the script shall resume.
#' @param from A datetime object, when the beginning of the sleep interval.
#' @param seconds An integer, representing the amount of seconds to wait.
#' @usage Takes either `resume` OR a combination of `from` and `seconds`.
#' @export
#' @examples
#' # Continue script after 20:30:34 on November 14th 2020
#'
#' continue_at <- lubridate::as_datetime("2020-11-14 20:30:34")
#' wait_till(resume = continue_at, seconds = 12)
#'
#' # Continue script 12 seconds after the last call was made
#'
#' last_timestamp <- lubridate::now()
#' wait_till(from = last_timestamp, seconds = 12)
wait_till <- function(from = NULL,
                       resume = NULL,
                       seconds = NULL){

  if(is.null(resume)) resume = from + lubridate::seconds(seconds)
  print(paste0("Pausing Scripts until ",resume))
  while(resume > lubridate::now()){
    Sys.sleep(1)
    }
}

