
# Valentinetrend

<!-- badges: start -->
<!-- badges: end -->

## Overview

This package contains comprehensive data on Valentine's Day spending trends over the past decade, provided by the National Retail Federation(NRF), which has surveyed consumers annually on how they plan to celebrate Valentine’s Day. It includes datasets that capture total expected spending, average spending per person, spending by gift type, and consumer-preferred gifts, broken down by age and gender. This package is designed to help users, especially retailers, analyze consumer behavior and spending patterns during Valentine’s Day.

This package provides the following datasets:

- `?gift_age`:  Shows the percentage of spending on different gift categories, broken down by age groups.

- `?gift_gender`: Shows the percentage of spending on different gift categories, broken down by gender.

- `?historical_full_spending`: Provides total expected spending, average spending per person and average spending per person on different gifts from 2010 to 2022.

- `?historical_gift_trends_percent_buying`: Tracks consumer trends in gift-buying, showing the percentage of people buying specific gift categories over the years.

## Installation

You can install the development version of Valentinetrend directly from [GitHub](https://github.com/) using the `remotes` package with:

``` r
# install.packages("remotes")
remotes::install_github("ETC5523-2024/assignment-4-packages-and-shiny-apps-Mhon0009")
```

To take a deeper dive into the data from the last 10 years, we use the interactive charts to explore a demographic breakdown of total spending, average spending and spending per type of gift. 
You can explore these insights by using `Valentinetrend::launch_app()`to launch the Shiny app, which offers a range of interactive plots for detailed analysis.

You can see the pkgdown site through the following link [Valentinetrend](https://etc5523-2024.github.io/assignment-4-packages-and-shiny-apps-Mhon0009/), where you can find more detailed information about this package."







