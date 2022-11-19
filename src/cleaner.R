# clean input files
library(tidyverse)

# run from project root directory

##### meter.csv
mt <- read_csv('./input/meter.csv')

# remove the kW lines 
# NOTE: if we want those lines later add this back
mt <- mt[which(mt$Units == 'kWh'),] 

# deal with bad data lines
mt <- mt %>% filter(!row_number() %in% c(82))
mt[79,3] <- mt[81,4]

print(mt, n=150)

mt <- mt %>% rename(
    date=Date,
    meter_num=`Meter #`,
    prev_read=`Previous Read`,
    curr_read=`Current Read`,
    num_days=`#of Days`,
    reading_type=`Type of Reading`,
    billed_usage=`Billed Usage`,
    units=Units
)

# NOTE: should we partition data after out measurement was added? 
# mt_new <- mt %>% filter(row_number() <= 80)
# mt_old <- mt %>% filter(!row_number() <= 80)

write.csv(mt, './input/clean_meter.csv', row.names=F)

###### billing.csv

# notes:
# solar panels installed in June 2019, 06/01/2019
# $8.35 is minimum payment for power
# - if at min, solar consumption makes up all consumption
# $0.11/kWh -> cost for grid power (in 2022, might have been different before)

bl <- read_csv('./input/billing.csv')
# NOTE: I don't think any cleaning is needed for this one out

###### daily.csv

dl <- read_csv('./input/daily.csv')
# NOTE: I don't think any cleaning is needed for this one

