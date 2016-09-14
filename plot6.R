##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## Compare emissions from motor vehicle sources in Baltimore City 
## from motor vehicle sources in Los Angeles County, CA. Which city
## has seen greater changes over time in motor vehicle emissions?
## 

library(ggplot2)
library(dplyr)

## Check existence of data files
files <- list.files(".")
if( !("summarySCC_PM25.rds" %in% files & 
      "Source_Classification_Code.rds" %in% files ) )
    stop("Cannot find data files")

## Read data
sourceData <- readRDS("Source_Classification_Code.rds")
emissionData <- readRDS("summarySCC_PM25.rds")

## Select motor vehicle emission source SCCs
sourceData <- filter(sourceData,regexpr("Highway Veh",sourceData$Short.Name) != -1)

## Summarize emissions per year
baltimoreData <- emissionData %>%
    filter(fips == "24510") %>%
    filter(SCC %in% sourceData$SCC) %>%
    group_by(year) %>%
    summarize(yearEm = sum(Emissions)) %>%
    mutate(City="Baltimore")

laData <- emissionData %>%
    filter(fips == "06037") %>%
    filter(SCC %in% sourceData$SCC) %>%
    group_by(year) %>%
    summarize(yearEm = sum(Emissions)) %>%
    mutate(City="Los Angeles")

## Normalize the data using 1999 as the baseline
laData$yearEm <- laData$yearEm / laData$yearEm[1]
baltimoreData$yearEm <- baltimoreData$yearEm / baltimoreData$yearEm[1]

# Combine tables
emissionData <- rbind(baltimoreData,laData)

## Normalize the data using 1999 as the baseline
emissionData$yearEm <- emissionData$yearEm / emissionData$yearEm[1]

## Do plot stuff
p <- ggplot(emissionData, aes(x = year, y = yearEm, shape = City, color = City))+
    geom_point(size = 3) +
    geom_smooth(method="gam",se=FALSE) +
    xlab("Year") + ylab("% PM2.5 Change Compared to 1999") +
    ggtitle("Motor Vehicle Emission Changes (1999-2008)")
 

ggsave("plot6.png",plot = p, device="png")

