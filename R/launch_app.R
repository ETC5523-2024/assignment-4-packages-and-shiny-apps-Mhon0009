#' @title Launch shiny app
#' @description
#' This function launches the Shiny app for interactive analysis of Valentine's Day data.
#'
#'
#' @usage
#' launch_app()
#'
#'
#'
#' @export
launch_app<- function() {
  app_dir <- system.file("shinyapp", package = "Valentinetrend")
  shiny::runApp(app_dir, display.mode = "normal")
}
