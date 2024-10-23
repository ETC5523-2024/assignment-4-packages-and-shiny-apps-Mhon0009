#' @title Launch shiny app
#'
#' @usage
#' launch_app()
#'
#' @return A detailed analysis of Valentine's Day spending trends presented with interactive plots in a dashboard.
#'
#'
#' @export
launch_app<- function() {
  app_dir <- system.file("shinyapp", package = "Valentinetrend")
  shiny::runApp(app_dir, display.mode = "normal")
}
