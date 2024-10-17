## code to prepare `historical_full_spending` dataset goes here

library(janitor)
library(dplyr)

historical_spending_total_expected_spending <- read_csv("data-raw/historical_spending_total_expected_spending.csv")
historical_spending <- read_csv("data-raw/historical_spending.csv")

historical_spending_total_expected_spending <- historical_spending_total_expected_spending %>%
  clean_names() %>%
  rename(Year = x1) %>%
  mutate(total_expected_valentines_day_spending_in_billions =
           as.numeric(gsub("[\\$,B]", "", total_expected_valentines_day_spending_in_billions)))


historical_full_spending <- left_join(historical_spending, historical_spending_total_expected_spending, by = "Year")

write_csv(historical_full_spending, "data-raw/historical_full_spending.csv")

usethis::use_data(historical_full_spending, overwrite = TRUE)
