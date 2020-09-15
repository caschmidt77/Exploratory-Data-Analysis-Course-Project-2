#Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
#Which have seen increases in emissions from 1999–2008?
#Use the ggplot2 plotting system to make a plot answer this question.

library(data.table)
library(tidyverse)
library(ggplot2)

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
balt_by_type <- NEI[fips == "24510", .(type_total = sum(Emissions)), by = .(year, type)]
plot <- ggplot(data = balt_by_type, mapping = (aes(year, type_total)), color = year)
plot + geom_point() + geom_smooth(method = "lm", se = FALSE) + facet_wrap(.~type) +
        ggtitle("Baltimore City PM2.5 Emissions by Type") + xlab("Year") + ylab("PM2.5 Emissions (tons)") +
        scale_x_continuous(name = "Year", breaks = c(1999, 2002, 2005, 2008))

#Write png plot by copying above code
png(filename = "plot3.png")
plot <- ggplot(data = balt_by_type, mapping = (aes(year, type_total)), color = year)
plot + geom_point() + geom_smooth(method = "lm", se = FALSE) + facet_wrap(.~type) +
        ggtitle("Baltimore City PM2.5 Emissions by Type") + xlab("Year") + ylab("PM2.5 Emissions (tons)") +
        scale_x_continuous(name = "Year", breaks = c(1999, 2002, 2005, 2008))
dev.off()