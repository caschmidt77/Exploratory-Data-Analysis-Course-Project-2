#Compare emissions from motor vehicle sources in Baltimore City with
#emissions from motor vehicle sources in Los Angeles County, California (fips == "06037")
#Which city has seen greater changes over time in motor vehicle emissions?

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
setDT(NEI)[SCC, Name := i.Short.Name, on = c(SCC = "SCC")] #add Short.Name column from SCC to NEI
comp_data <- NEI[fips %in% c("24510", "06037") & `type` == "ON-ROAD",] #subset data for Baltimore City & LA County
comp_data[, Fuel := NA_character_]
for(i in 1:nrow(comp_data)){
        if(comp_data[i, `fips`] == "24510"){
                comp_data[i, `fips` := "Baltimore City"]
        } else {
                comp_data[i, `fips` := "LA County"]
        }
        if(grepl("Gasoline", comp_data[i, `Name`])){
                comp_data[i, `Fuel` := "Gasoline"]
        }
        if(grepl("Diesel", comp_data[i, `Name`])){
                comp_data[i, `Fuel` := "Diesel"]
        }
}

setnames(comp_data, old = c("fips", "type", "year"), new = c("Area", "Type", "Year"))
agg_emiss <- comp_data[, .(`Total Emissions` = sum(Emissions)), by = .(Area, Year)]

#Create Desired Plot
j <- ggplot(data = comp_data, mapping = aes(x=Year, y = Emissions))
j + geom_col(mapping = aes(fill = Fuel)) + facet_wrap(Area~.) + 
        geom_smooth(data = agg_emiss, mapping = aes(x=Year, y = `Total Emissions`),
                method = "lm", se = FALSE) + 
        labs(title = "Comparative PM2.5 Emissions", subtitle = "Motor Vehicles") +
        ylab("PM2.5 Emissions (tons)") +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
        theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
              plot.subtitle = element_text(size = 12, hjust = 0.5))        

#Write png plot by copying above code
png(filename = "plot6.png")
j <- ggplot(data = comp_data, mapping = aes(x=Year, y = Emissions))
j + geom_col(mapping = aes(fill = Fuel)) + facet_wrap(Area~.) + 
        geom_smooth(data = agg_emiss, mapping = aes(x=Year, y = `Total Emissions`),
                    method = "lm", se = FALSE) + 
        labs(title = "Comparative PM2.5 Emissions", subtitle = "Motor Vehicles") +
        ylab("PM2.5 Emissions (tons)") +
        scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +
        theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
              plot.subtitle = element_text(size = 12, hjust = 0.5))
dev.off()
