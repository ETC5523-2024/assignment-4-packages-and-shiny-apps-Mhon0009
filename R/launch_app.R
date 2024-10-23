#' @export
launch_app<- function() {
  app_dir <- system.file("shinyapp", package = "Valentinetrend")
  shiny::runApp(app_dir, display.mode = "normal")
}
