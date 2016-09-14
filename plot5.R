##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## How have emissions from motor vehicle 
## sources changed from 1999–2008 in Baltimore City?
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
emissionData <- emissionData %>%
    filter(fips == "24510") %>%
    filter(SCC %in% sourceData$SCC) %>%
    group_by(year) %>%
    summarize(yearEm = sum(Emissions))
    
## Do plot stuff
p <- qplot(year,yearEm,data=emissionData) +
    geom_smooth(method="lm",se=FALSE) + 
    xlab("Year") + ylab("PM2.5 (tons)") +
    ggtitle("Motor Vehicle Emissions - Baltimore (MD)") 

ggsave("plot5.png",plot = p, device="png")

