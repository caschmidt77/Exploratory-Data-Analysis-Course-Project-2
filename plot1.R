#Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 emission from all sources
#for each of the years 1999, 2002, 2005, and 2008.

library(data.table)
library(tidyverse)

#Download and unzip raw data files
if(!file.exists("./raw_data.zip")){
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "./raw_data.zip",
                      mode = "wb")
}
unzip("./raw_data.zip", exdir = "./data")

#Read files and convert to data.table format
NEI <- setDT(readRDS("./data/summarySCC_PM25.rds"))
SCC <- setDT(readRDS("./data/Source_Classification_code.rds"))

#Extract desired data and create plot to screen graphics device
total_emissions <- NEI[, .(Total = sum(Emissions)), by = year]
print(total_emissions) #check of suitability of data for plotting
with(total_emissions, barplot(Total/10^6, names.arg = year, xlab = "Year", 
        ylab = "Total Emissions (millions of tons)"))
title(main = "US PM2.5 Emissions by Year")

#Write png plot by copying above code
png(filename = "plot1.png")
with(total_emissions, barplot(Total/10^6, names.arg = year, xlab = "Year", 
                              ylab = "Total Emissions (millions of tons)"))
title(main = "US PM2.5 Emissions by Year")
dev.off()
