##
## Coursera: Exploratory Data Analysis, Project 2
## Data
## - PM2.5 Emissions Data (summarySCC_PM25.rds) and
## - Source Classification Code Table (Source_Classification_Code.rds)
## 
## Of the four types of sources indicated by the type
## (point, nonpoint, onroad, nonroad) variable, which of these four sources
## have seen decreases in emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 1999–2008? 
## Use the ggplot2 plotting system to make a plot answer this question.
## 

library(ggplot2)
library(dplyr)

## Check existence of data files
files <- list.files(".")
if( !("summarySCC_PM25.rds" %in% files) )
    stop("Cannot find data files")

## Read data
emissionData <- readRDS("summarySCC_PM25.rds")

# Plot emissions over years and linear regression - save to png file

## Sumarize data per year and type
emissionData <- emissionData %>% 
    filter(fips == "24510") %>%
    group_by(year,type) %>%
    summarize(yearEm = sum(Emissions) )


q <- qplot(year,yearEm,data=emissionData,facets = .~type) +
    geom_smooth(method="lm",se=FALSE) + 
    xlab("Year") + ylab("PM2.5 (tons)") +
    ggtitle("Emissions per Source Type - Baltimore (MD)") +
    theme( axis.text.x = element_text(size=6) )

ggsave("plot3.png",plot = q, device="png")


