#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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
setDT(NEI)[SCC, Name := i.Short.Name, on = c(SCC = "SCC")]
baltimore_data <- NEI[fips == "24510" & type == "ON-ROAD"]
baltimore_data[, `Fuel` := NA_character_]
baltimore_data[, `Vehicle Type` := NA_character_]
for(i in 1:nrow(baltimore_data)){
        if (grepl("Gasoline", baltimore_data[i, `Name`])){
                baltimore_data[i, `Fuel` := "Gaosline"]
        }
        if(grepl("Diesel", baltimore_data[i, `Name`])){
                baltimore_data[i, `Fuel` := "Diesel"]
        }
        if(grepl("Light Duty", baltimore_data[i, `Name`])){
                baltimore_data[i, `Vehicle Type` := "Light Duty Vehicles"]
        }
        if(grepl("Truck", baltimore_data[i, `Name`])){
                baltimore_data[i, `Vehicle Type` := "Trucks"]
        }
        if(grepl("Heavy Duty", baltimore_data[i, `Name`])){
                baltimore_data[i, `Vehicle Type` := "Heavy Duty Vehicles"]
        }
        if(grepl("Motorcycles", baltimore_data[i, `Name`])){
                baltimore_data[i, `Vehicle Type` := "Motorcycles"]
        }
}

#Create Desired Plot
h <- ggplot(data = baltimore_data)
h + geom_col(mapping = aes(x=year, y = Emissions, fill = Fuel)) + facet_wrap(.~`Vehicle Type`) +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + ggtitle("Baltimore Vehicle Emissions") +
        xlab("Year") + ylab("PM2.5 Emissions (tons)") + 
        theme(plot.title = element_text(face = "bold", hjust = 0.5))

#Write png plot by copying above code
png(filename = "plot5.png")
h <- ggplot(data = baltimore_data)
h + geom_col(mapping = aes(x=year, y = Emissions, fill = Fuel)) + facet_wrap(.~`Vehicle Type`) +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + ggtitle("Baltimore Vehicle Emissions") +
        xlab("Year") + ylab("PM2.5 Emissions (tons)") + 
        theme(plot.title = element_text(face = "bold", hjust = 0.5))
dev.off()


