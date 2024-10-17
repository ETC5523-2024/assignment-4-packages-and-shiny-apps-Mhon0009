## code to prepare `spendingdatasets` dataset goes here

historical_spending <- read_csv("data-raw/historical_spending.csv")
historical_expectedspending <- read_csv("data-raw/historical_spending_total_expected_spending.csv")
historical_gifttrends <- read_csv("data-raw/historical_gift_trends_percent_buying.csv")
gifts_age <- read_csv("data-raw/gifts_age.csv")
gifts_gender <- read_csv("data-raw/gifts_gender.csv")


# Combine the datasets
spendingdatasets <- list(
  historical_spending = historical_spending,
  historical_expectedspending = historical_expectedspending,
  historical_gifttrends = historical_gifttrends,
  gifts_age = gifts_age,
  gifts_gender = gifts_gender
)

usethis::use_data(spendingdatasets, overwrite = TRUE)


