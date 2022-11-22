#
# return on investment calculations
#

library(tidyverse)
library(lubridate)
library(ggplot2)

bi <- read_csv('./input/billing.csv')
mt <- read_csv('./input/clean_meter.csv')

bi$`Bill Date` <- mdy(bi$`Bill Date`)
mt$date <- mdy(mt$date)
mt_new <- mt %>% filter(row_number() <= 80)

# checks if entry is in a production or usage row
mt_sort <- function (x) {
    if (x %% 2 == 0) {
        return('cons')
    } else {
        return('prod')
    }
}

# create new entry_type column and pivot wider on it 
mt_new$entry_type <- sapply(1:length(mt_new$units), mt_sort)
mt_new <- mt_new %>% pivot_wider(names_from=entry_type, 
        names_glue='{entry_type}_{.value}',
        values_from=c(curr_read, prev_read, billed_usage))

# calculate the difference in production and consumption monthly
mt_new$diff_usage <- mt_new$prod_billed_usage + mt_new$cons_billed_usage

# add new monthly net cost column
mt_new$usage_cost <- 0.11 * mt_new$diff_usage

# TODO: make fill better
ggplot(mt_new, aes(x=date, y=usage_cost, group=1)) +
    geom_line(color='red') + geom_point() +
    geom_area()

# NOTE: make sure to match dates between files - mt_new only goes back to 07/2019

