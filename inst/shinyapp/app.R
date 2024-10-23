library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(plotly)
library(Valentinetrend)
library(DT)
library(fresh)

# Define a custom pink theme
pink_theme <- create_theme(
  adminlte_color(
    light_blue = "#bc8f8f"  # Change main color
  ),
  adminlte_sidebar(
    dark_bg = "#bc8f8f",  # Sidebar background color
    dark_hover_bg = "#deb887",
    dark_color = "#FFFFFF"
  ),
  adminlte_global(
    content_bg = "#fffafa",  # Content background color
    box_bg = "#FFFFFF"
  )
)

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
    use_theme(pink_theme),
    tabItems(
      # Tab for Spending trends by Age/Gender
      tabItem(
        tabName = "age_gender",
        fluidRow(
          column(
            width = 4,
            box(
              title = "Filter Options", status = "primary", solidHeader = TRUE, width = 12,
              selectInput("dataset", "Select Dataset:",
                          choices = c("Spending by Age" = "age", "Spending by Gender" = "gender"),
                          selected = "age"),
              uiOutput("category_ui"),
              h4("Field Descriptions"),
              tags$ul(
                tags$li("Age: Age group of consumer"),
                tags$li("Gender: Gender of consumer"),
                tags$li("Gift Categories: Type of gifts purchased"),
                tags$li("Spending: Average percent spending on gift")
              )
            )
          ),
          column(
            width = 8,
            box(
              title = "Spending on Different Gifts Categories by Different Age Group/Gender", status = "primary", solidHeader = TRUE, width = 12,
              plotlyOutput("spendingPlotly"),
              helpText(em(
                "**Hover over bars to see the specific average percent spending on gifts."
              ))
            ),
            box(
              title = "Interpretation", status = "primary", width = 12,
              helpText("The bar chart shows the average percentage of spending by the selected age group or gender across different gift categories.
               For example, we can interpret that consumers in the 18-24 age group are more likely to purchase candy (70%), flowers (50%), and spend on an evening out (40%) during Valentine's Day.
               For gender-based spending, women tend to choose more budget-friendly options like greeting cards (43%) and candy (59%).")
            )
          )
        )
      ),

      # Tab for Historical Spending Trends
      tabItem(
        tabName = "historical",
        fluidRow(
          column(
            width = 4,
            box(
              title = "Info", status = "primary", solidHeader = TRUE, width = 12,
              helpText(
                "This chart shows Valentine's Day spending trends over the years, highlighting both average spending per person and total expected spending in billions."
              ),
              h4("Field Descriptions"),
              tags$ul(
                tags$li("Pink bars: Represent how much the average per person plans to spend on Valentine's Day gifts each year"),
                tags$li("Line and points: Represent the total expected spending in billions across the entire population."),
                tags$li("Table: The table below displays the percentage of consumers who bought specific gift categories in each year.")
              )
            ),
            box(
              title = "Interpretation for Valentine's Day Spending Trends", status = "primary", width = 12,
              helpText(
                "For example, we can interpret that spending on Valentine’s Day has increased from $14.1 billion in 2010 to $23.9 billion in 2022.
                Consumers expect to spend an average of $175.41 per person on Valentine’s Day gifts in 2022, up from $164.76 in 2021. "
              )
            )
          ),
          column(
            width = 8,
            box(
              status = "primary", width = 12,
              plotlyOutput("combined_spending_plot"),
              helpText(em(
                "**Hover over bars to see the specific average spending per person and points for total expected spending in billions."
              ))
            )
          )
        ),
        fluidRow(
          box(
            title = "Historical spending on gifts", status = "primary", solidHeader = TRUE, width = 12,
            DTOutput("giftTable"),
            helpText(
              strong("Interpretation: It helps identify changes in consumer preferences over time. As we can interpret that Candy (56%), greeting cards (40%) and flowers (37%) remain the most popular gift items this Valentine’s Day in 2022.
              Also, greeting cards were the most favored gift among consumers in 2010 (56%). However, that percentage dropped to 40% in 2022, indicating a trend towards more memorable and meaningful gifts rather than expensive items")
            )
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

  # Render the bar chart with hover information for spending by age/gender
  output$spendingPlotly <- renderPlotly({
    data <- if (input$dataset == "age") {
      gifts_age %>%
        filter(Age == input$category) %>%
        tidyr::pivot_longer(cols = -Age, names_to = "Category", values_to = "Spending")
    } else {
      gifts_gender %>%
        filter(Gender == input$category) %>%
        tidyr::pivot_longer(cols = -Gender, names_to = "Category", values_to = "Spending")
    }

    p <- ggplot(data, aes(x = Category, y = Spending, fill = Category,
                          text = paste("Category:", Category, "<br>Spending:", Spending, "%"))) +
      geom_bar(stat = "identity") +
      labs(
        title = paste("Spending Trends for", input$category),
        x = "Gift Category",
        y = "Spending (%)"
      ) +
      theme_minimal() +
      theme(legend.position = "none") +
      scale_fill_brewer(palette = "Accent")

    # Convert to Plotly object with hover info
    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = "closest"
      )
  })

  # Render the combined spending plot
  output$combined_spending_plot <- renderPlotly({
    p <- ggplot(historical_full_spending, aes(x = Year)) +
      geom_bar(
        aes(y = PerPerson, text = paste0("Year: ", Year, "<br>Per Person Spend: $", round(PerPerson, 2))),
        stat = "identity", fill = "hotpink", alpha = 0.7
      ) +
      geom_line(
        aes(y = total_expected_valentines_day_spending_in_billions * 10),
        color = "mediumvioletred", size = 1
      ) +
      geom_point(
        aes(y = total_expected_valentines_day_spending_in_billions * 10,
            text = paste0("Year: ", Year, "<br>Total Spend: $", total_expected_valentines_day_spending_in_billions, "B")),
        color = "mediumvioletred", size = 2
      ) +
      geom_text(
        aes(y = total_expected_valentines_day_spending_in_billions * 10 + 10,
            label = paste0("$", total_expected_valentines_day_spending_in_billions, "B")),
        size = 3, fontface = "bold"
      ) +
      labs(
        title = "Valentine's Day Spending Plans",
        x = "Year",
        y = "Spending ($)"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(hjust = 0.5, size = 16))

    ggplotly(p, tooltip = "text") %>%
      layout(
        hovermode = "closest"
      ) %>%
      style(hoverinfo = "none", traces = 4)
  })

  # Render the table with historical gifts percent buying data
  output$giftTable <- renderDT({
    datatable(historical_gift_trends_percent_buying, options = list(pageLength = 5))
  })
}

# Run the application
shinyApp(ui = ui, server = server)








