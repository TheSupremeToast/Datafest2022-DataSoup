# importing dependencies
library(ggplot2)
library(tidyverse)
library(lubridate)

# set up working directory
setwd('C:/Users/Lilyb/Downloads/DatafestFall2022/Datafest2022-DataSoup')
test <- read.csv('./input/clean_meter.csv')

# test plot to check if csv has been imported correctly
plot(test$meter_num, test$billed_usage)

# parse date objects
test$date <- mdy(test$date)
class(test$date)

# plot date vs. billed usage
ggplot(data=test, aes(x=date, y=billed_usage, group=1)) +
  geom_line()+
  geom_point()

# plot billed usage by month
buckets <- c()
for(i in 0:12) {
  buckets[i] <- mean(test$billed_usage[which(month(test$date) == i)])
}
monthData <- data.frame(c(1:12), buckets)
colnames(monthData) <- c('month', 'average')
suppressWarnings(ggplot(data=monthData, aes(x=month, y=average)) +
  geom_bar(stat="identity") + 
  ggtitle("Meter Data: Average Billed Usage By Month") +
  scale_x_discrete(name="Month", limits=c(1:12)))
