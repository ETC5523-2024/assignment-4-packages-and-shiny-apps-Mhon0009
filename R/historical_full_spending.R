#' Historical Valentine's Day Spending Data
#'
#' A dataset that combines historical consumer spending on Valentine's Day, including the percentage of people celebrating,
#' spending per person, and total expected spending across various categories from 2010 to 2022.All monetary amounts are in USD.
#'
#'
#' @format A data frame with 13 rows and 11 variables.
#' \describe{
#'   \item{Year}{Year of the recorded spending data}
#'   \item{PercentCelebrating}{Percent of people celebrating Valentines Day}
#'   \item{PerPerson}{Average amount each person is spendingD}
#'   \item{Candy}{Average amount spending on candy}
#'   \item{Flowers}{Average amount spending on flowers}
#'   \item{Jewelry}{Average amount spending on jewelry}
#'   \item{GreetingCards}{Average amount spending on greeting cards}
#'   \item{EveningOut}{Average amount spending on an evening out}
#'   \item{Clothing}{Average amount spending on clothing}
#'   \item{GiftCards}{Average amount spending on gift cards}
#'   \item{total_expected_valentines_day_spending_in_billions}{Total expected Valentine's Day spending in billions of USD}
#' }
#' @source \url{https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-02-13/historical_spending.csv}
#' @source \url{https://www.kaggle.com/datasets/infinator/happy-valentines-day-2022?select=historical_spending_total_expected_spending.csv}
"historical_full_spending"
