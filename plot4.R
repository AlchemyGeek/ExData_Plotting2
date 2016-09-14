##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999–2008?
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

## Select coal combustion emission source 
sourceData <- filter(sourceData,regexpr("Coal",sourceData$EI.Sector) != -1)

## Summarize emissions per year for coal combustion sources
emissionData <- emissionData %>%
    filter(SCC %in% sourceData$SCC) %>%
    group_by(year) %>%
    summarize(yearEm = sum(Emissions))

# Convert emissions to kilotons
emissionData$yearEm <- emissionData$yearEm / 1000
    
## Do plot stuff
p <- qplot(year,yearEm,data=emissionData) +
    geom_smooth(method="lm",se=FALSE) + 
    xlab("Year") + ylab("PM2.5 (kilotons)") +
    ggtitle("Emissions from Coal Combustion Sources - USA") 

ggsave("plot4.png",plot = p, device="png")
