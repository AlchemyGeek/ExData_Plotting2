##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## Have total emissions from PM2.5 decreased in the United States
## from 1999 to 2008? Using the base plotting system, make a plot 
## showing the total PM2.5 emission from all sources for each 
## of the years 1999, 2002, 2005, and 2008.
## 

library(dplyr)

## Check existence of data files
files <- list.files(".")
if( !("summarySCC_PM25.rds" %in% files) )
    stop("Cannot file data files")

## Read data
emissionData <- readRDS("summarySCC_PM25.rds")

## Calculate yearly emissions
emissionData <- emissionData %>%
    group_by(year) %>%
    summarise(yearEm = sum(Emissions))

## Convert to kilo tons
emissionData$yearEm = emissionData$yearEm / 1000

# Plot emissions over years and linear regression - save to png file
png("plot1.png")

plot(emissionData$year,emissionData$yearEm,
     ylab="PM2.5 (kilotons)",xlab="Years", cex=1.5,
     col="red",main="Emissions - USA")
abline(glm(emissionData$yearEm~emissionData$year),col="blue")

dev.off()
