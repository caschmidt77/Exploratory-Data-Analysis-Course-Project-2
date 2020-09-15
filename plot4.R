#Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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

#Extract desired data
NEI <- NEI[SCC, on = .(SCC)] #join data.tables on value of SCC column
coal <- grep("Coal", NEI[["EI.Sector"]], value = FALSE) #create index of rows with "Coal' in EI.Sector column
coal_data <- NEI[coal, .(fips, year, Emissions, EI.Sector)] #extract coal data and only desired columns
coal_by_source <- coal_data[, .(`Source Total` = sum(Emissions, na.rm = TRUE)), by = .(EI.Sector, year)]
#remove prefix from EI.Sector column to make legend more readable below
coal_by_source[, `EI.Sector` := gsub("Fuel Comb - ", "", coal_by_source[["EI.Sector"]])]

#Create desired plot
g <- ggplot(data = coal_by_source)
g + geom_col(mapping = aes(x = year, y = `Source Total`/10^3, fill = EI.Sector)) +
        ggtitle("US PM2.5 Emissions from Coal") + xlab("Year") + ylab("Emissions ('000s of tons)") +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
        theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5), legend.position = "bottom", 
              legend.title = element_text(size=7))

#Write png plot by copying above code
png(filename = "plot4.png")
g <- ggplot(data = coal_by_source)
g + geom_col(mapping = aes(x = year, y = `Source Total`/10^3, fill = EI.Sector)) +
        ggtitle("US PM2.5 Emissions from Coal") + xlab("Year") + ylab("Emissions ('000s of tons)") +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
        theme(plot.title = element_text(face = "bold", size = 18, hjust = 0.5), legend.position = "bottom", 
              legend.title = element_text(size=7))
dev.off()
