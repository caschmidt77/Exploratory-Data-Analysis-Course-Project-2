#Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510")
#from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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
baltimore_emiss <- NEI[fips == "24510", .(Total = sum(Emissions)), by = year]
baltimore_emiss
with(baltimore_emiss, barplot(Total, names.arg = year, xlab = "Year", ylab = "Total PM2.5 Emissions (tons)",
        main = "Balitmore City PM2.5 Emissions by Year"))

#Write png plot by copying above code
png(filename = "plot2.png")
with(baltimore_emiss, barplot(Total, names.arg = year, xlab = "Year", ylab = "Total PM2.5 Emissions (tons)",
                              main = "Balitmore City PM2.5 Emissions by Year"))
dev.off()