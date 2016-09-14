##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## Have total emissions from PM2.5 decreased in the Baltimore City, 
## Maryland (𝚏𝚒𝚙𝚜 == "𝟸𝟺𝟻𝟷𝟶") from 1999 to 2008? Use the base
## plotting system to make a plot answering this question.
## 

library(dplyr)

## Check existence of data files
files <- list.files(".")
if( !("summarySCC_PM25.rds" %in% files ) )
    stop("Cannot find data file")

## Read data
emissionData <- readRDS("summarySCC_PM25.rds")

## Calculate yearly emissions for Baltimore
emissionData <- emissionData %>%
    filter(fips == "24510") %>%
    group_by(year) %>%
    summarise(yearEm = sum(Emissions))

# Plot emissions over years and linear regression - save to png file
png("plot2.png")

plot(emissionData$year, emissionData$yearEm,
     ylab="PM2.5 (tons)", xlab="Years", cex=1.5,
     col="red",main="Emissions - Baltimore (MD)")
abline(glm(emissionData$yearEm~emissionData$year),col="blue")

dev.off()

