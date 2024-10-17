## code to prepare `historical_gift_trends_percent_buying` dataset goes here


historical_gift_trends_percent_buying <- read_csv("data-raw/historical_gift_trends_percent_buying.csv")

historical_gift_trends_percent_buying <- historical_gift_trends_percent_buying %>%
  rename(Year = ...1)

usethis::use_data(historical_gift_trends_percent_buying, overwrite = TRUE)
