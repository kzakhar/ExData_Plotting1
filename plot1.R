library(dplyr)

# we will only be using data from the dates 2007-02-01 and 2007-02-02
# below the dates are in the format used in the raw data
analysis_dates <- c("1/2/2007", "2/2/2007")

df <- read.table(
  unz("exdata_data_household_power_consumption.zip", "household_power_consumption.txt"), 
  sep = ";", 
  header = TRUE, 
  na.strings = "?") %>%
  # filter the dates
  filter(Date %in% analysis_dates) 

hist(df$Global_active_power, main="Global Active Power", col="red", xlab="Global Active Power (kilowatts)")
dev.copy(device = png, filename = 'plot1.png', width = 480, height = 480) 
dev.off()