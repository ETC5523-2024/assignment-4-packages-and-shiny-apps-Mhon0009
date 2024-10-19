library(shiny)
library(dplyr)
library(ggplot2)
library(ValentineTrend)  # Load your package

data("gift_age", package = "ValentineTrend")
data("gifts_gender", package = "ValentineTrend")

# UI
ui <- fluidPage(
  # Add some styling
  tags$head(
    tags$style(HTML("
      body {background-color: #f9f9f9;}
      .well {background-color: #dff0d8;}
      h2 {color: #31708f;}
    "))
  ),

  titlePanel("Explore Valentine's Day Spending Trends"),
  sidebarLayout(
    sidebarPanel(
      # Interactivity: Dropdown for selecting dataset
      selectInput("dataset", "Select Dataset:",
                  choices = c("Spending by Age" = "age", "Spending by Gender" = "gender"),
                  selected = "age"),

      # Interactivity: Dropdown for selecting a category
      uiOutput("category_ui"),

      # Descriptions
      h4("Field Descriptions"),
      tags$ul(
        tags$li("Age: Age group of individuals"),
        tags$li("Gender: Gender of individuals"),
        tags$li("Gift Categories: Type of gifts purchased"),
        tags$li("Spending: Amount of spending in US Dollars")
      )
    ),

    mainPanel(
      h2("Interactive Plots"),
      plotOutput("spendingPlot"),

      # Interpretation of outputs
      h4("How to Interpret the Plots"),
      p("The bar chart shows the total spending by selected age group or gender across different gift categories.")
    )
  )
)

# Server
server <- function(input, output, session) {
  # UI for category selection based on dataset
  output$category_ui <- renderUI({
    if (input$dataset == "age") {
      selectInput("category", "Select Age Group:",
                  choices = unique(gifts_age$Age))
    } else {
      selectInput("category", "Select Gender:",
                  choices = unique(gifts_gender$Gender))
    }
  })

  # Render the spending plot based on selected dataset and category
  output$spendingPlot <- renderPlot({
    if (input$dataset == "age") {
      data <- gifts_age %>%
        filter(Age == input$category) %>%
        tidyr::pivot_longer(cols = -Age, names_to = "Category", values_to = "Spending")
    } else {
      data <- gifts_gender %>%
        filter(Gender == input$category) %>%
        tidyr::pivot_longer(cols = -Gender, names_to = "Category", values_to = "Spending")
    }

    ggplot(data, aes(x = Category, y = Spending, fill = Category)) +
      geom_bar(stat = "identity") +
      labs(
        title = paste("Spending Trends for", input$category),
        x = "Gift Category",
        y = "Total Spending (US Dollars)"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
  })
}

# Run the application
shinyApp(ui = ui, server = server)
