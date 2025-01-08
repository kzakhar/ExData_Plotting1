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
  filter(Date %in% analysis_dates) %>%
  # convert the date/time to a new column
  mutate(DateTime = strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"))

analysis_weekdays <- weekdays(as.Date(c(analysis_dates, "3/2/2007"), format="%d/%m/%Y"), abbreviate = TRUE)
DateTime_first = df$DateTime[[1]]
DateTime_second = df$DateTime[[which(df$Date == "2/2/2007")[1]]]
DateTime_last = df$DateTime[[nrow(df)]]

# open the png file/device. do not copy from screen, because it doesn't resize, and the image get "truncated"
png("plot4.png", width = 480, height = 480, units = "px")
par(mfrow = c(2, 2))

# plot 1 -- Global Active Power
with(df, 
     plot(
       DateTime, 
       Global_active_power,
       type = "l", 
       ylab = "Global Active Power", 
       xlab = "", 
       xaxt = "n"
     )
)
axis(1, 
     labels=analysis_weekdays, 
     at=as.numeric(c(DateTime_first, DateTime_second, DateTime_last)))

# plot 2 -- Voltage
with(df, 
     plot(
       DateTime, 
       Voltage,
       type = "l", 
       ylab = "Voltage", 
       xlab = "datetime", 
       xaxt = "n"
     )
)
axis(1, 
     labels=analysis_weekdays, 
     at=as.numeric(c(DateTime_first, DateTime_second, DateTime_last)))

# plot 3 -- Energy sub metering
with(df, {
  plot(
    DateTime, 
    Sub_metering_1,
    type = "l", 
    ylab = "Energy sub metering", 
    xlab = "", 
    xaxt = "n"
  )
  lines(DateTime, Sub_metering_2, col = "red")
  lines(DateTime, Sub_metering_3, col = "blue")
  legend("topright", 
         c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         col = c("black", "red", "blue"),
         lty = 1,
         bty = "n"
  )
})
axis(1, 
     labels=analysis_weekdays, 
     at=as.numeric(c(DateTime_first, DateTime_second, DateTime_last)))

# plot 4 -- Global reactive power
with(df, 
     plot(
       DateTime, 
       Global_reactive_power,
       type = "l", 
       ylab = "Global_reactive_power", 
       xlab = "datetime", 
       xaxt = "n"
     )
)
axis(1, 
     labels=analysis_weekdays, 
     at=as.numeric(c(DateTime_first, DateTime_second, DateTime_last)))

dev.off()