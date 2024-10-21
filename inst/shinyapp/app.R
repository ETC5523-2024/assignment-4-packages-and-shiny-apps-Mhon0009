library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(ValentineTrend)

# Define UI for the Shiny App
ui <- dashboardPage(
  dashboardHeader(title = "Valentine's Day Spending Trend"),

  # Sidebar layout
  dashboardSidebar(
    sidebarMenu(
      menuItem("Spending by Age/Gender", tabName = "age_gender", icon = icon("chart-bar")),
      menuItem("Historical Spending Trends", tabName = "historical", icon = icon("line-chart"))
    )
  ),

  # Main body
  dashboardBody(
    tabItems(
      # Tab for Spending by Age/Gender
      tabItem(
        tabName = "age_gender",
        fluidRow(
          box(
            title = "Filter Options", status = "primary", solidHeader = TRUE, width = 4,
            selectInput("dataset", "Select Dataset:",
                        choices = c("Spending by Age" = "age", "Spending by Gender" = "gender"),
                        selected = "age"),
            uiOutput("category_ui"),
            h4("Field Descriptions"),
            tags$ul(
              tags$li("Age: Age group of individuals"),
              tags$li("Gender: Gender of individuals"),
              tags$li("Gift Categories: Type of gifts purchased"),
              tags$li("Spending: Average percent spending on gift")
            ),
            helpText("Interpretation: The bar chart shows the total spending by the selected age group or gender across different gift categories.")
          ),
          box(
            title = "Spending by Age/Gender", status = "primary", solidHeader = TRUE, width = 8,
            plotOutput("spendingPlot")
          )
        )
      ),

      # Tab for Historical Spending Trends
      tabItem(
        tabName = "historical",
        fluidRow(
          box(
            title = "Info", status = "primary", solidHeader = TRUE, width = 4,
            helpText("This chart shows Valentine's Day spending trends over the years."),
            helpText("Pink bars represent 'Per Person Spend', while the line and points represent 'Total Expected Spend' in billions."),
            helpText("Hover over the points to see 'Year' and 'Total Spend'.")
          ),
          box(
            title = "Valentine's Spending Trends", status = "primary", solidHeader = TRUE, width = 8,
            plotlyOutput("combined_spending_plot")
          )
        )
      )
    )
  )
)

# Define server logic for the Shiny App
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
        select(-SpendingCelebrating) %>%
        tidyr::pivot_longer(cols = -Age, names_to = "Category", values_to = "Spending")
    } else {
      data <- gifts_gender %>%
        filter(Gender == input$category) %>%
        select(-SpendingCelebrating) %>%
        tidyr::pivot_longer(cols = -Gender, names_to = "Category", values_to = "Spending")
    }

    ggplot(data, aes(x = Category, y = Spending, fill = Category)) +
      geom_bar(stat = "identity") +
      labs(
        title = paste("Spending Trends for", input$category),
        x = "Gift Category",
        y = "Spending"
      ) +
      theme_minimal() +
      theme(legend.position = "none") +
      scale_fill_brewer(palette = "Accent")
  })

  # Render the combined spending plot
  output$combined_spending_plot <- renderPlotly({
    # Create a ggplot with both "Per Person Spend" and "Total Expected Spend"
    p <- ggplot(historical_full_spending, aes(x = Year)) +
      geom_bar(
        aes(y = PerPerson, text = paste0("Year: ", Year,
                                         "<br>Per Person Spend: $", round(PerPerson, 2))),
        stat = "identity", fill = "hotpink", alpha = 0.7
      ) +
      geom_line(
        aes(y = total_expected_valentines_day_spending_in_billions * 10),
        color = "mediumvioletred", size = 1
      ) +
      geom_point(
        aes(y = total_expected_valentines_day_spending_in_billions * 10,
            text = paste0("Year: ", Year,
                          "<br>Total Spend: $", total_expected_valentines_day_spending_in_billions, "B")),
        color = "mediumvioletred", size = 2
      ) +
      geom_text(aes(
          y = total_expected_valentines_day_spending_in_billions * 10 + 10,
          label = paste0("$", total_expected_valentines_day_spending_in_billions, "B")
        ),
        size = 3, fontface = "bold"
      ) +
      labs(
        title = "Valentine's Day Spending Trends",
        x = "Year",
        y = "Spending ($)"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, size = 16))

    # Convert to plotly object with separate hover info for bars and points
    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = "closest"
      ) %>%
      style(hoverinfo = "none", traces = 4)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
