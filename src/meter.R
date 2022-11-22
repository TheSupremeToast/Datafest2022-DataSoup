library(ggplot2)
library(tidyverse)
library(lubridate)

mt <- read_csv('./input/clean_meter.csv')
mt$date <- mdy(mt$date)

# partition meter data based on before/after new usage meter was added
mt_old <- mt %>% filter(!row_number() <= 80)
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

# graph production versus consumption
ggplot(mt_new) +
    geom_line(aes(y=prod_curr_read, x=date), color='green') +
    geom_line(aes(y=cons_curr_read, x=date), color='red') +
    ggtitle('Gramacy: Production vs Consumption')

# plot of difference of production - consumption
mt_new$diff_read <- mt_new$prod_curr_read - mt_new$cons_curr_read
ggplot(mt_new) +
    geom_line(aes(y=diff_read, x=date), color='blue') +
    geom_line(aes(y=0, x=date))
    ggtitle('Gramacy: Difference in Production vs Consumption')

# monthly difference in billed usage
mt_new$diff_usage <- mt_new$prod_billed_usage + mt_new$cons_billed_usage
ggplot(mt_new) +
    geom_line(aes(y=diff_usage, x=date), color='orange') +
    geom_line(aes(y=0, x=date), color='black') +
    ggtitle('Gramacy: Billed Usage Difference vs Time')



