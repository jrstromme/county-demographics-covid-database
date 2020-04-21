# beds-process.R
#
# Processes the dataset on hospital beds 
#  Sums up to the county level
#  I believe there isn't double counting of hospital beds b/c systems
#   list bed counts as N/A, but would be worth another check
#

rm(list=ls())

library(tidyverse)
library(tidylog)
library(readstata13)

setwd("~/Documents/Wisconsin/Research/county-demographics-covid-database/hospital-beds/")


# load beds data
beds.df <- read.csv("./raw/Definitive-Healthcare-Bed-Locations_0.csv")

#collapse to the county level
beds.df <- beds.df %>% 
  group_by(FIPS) %>% 
  summarise(beds_licensed      = sum(X..of.Licensed.Beds,      na.rm=T),
            beds_staffed       = sum(X..of.Staffed.Beds,       na.rm=T),
            beds_ICU           = sum(X..of.ICU.Beds,           na.rm=T),
            beds_ICU_adult     = sum(X..of.Adult.ICU.Beds,     na.rm=T),
            beds_ICU_pediatric = sum(X..of.Pediatric.ICU.Beds, na.rm=T))

#remove puerto rico
beds.df <- beds.df %>% 
  rename(fips = FIPS) %>% 
  filter(!(fips > 72000 & fips < 72999),
         !is.na(fips))

write.csv(beds.df,"./county_bed_availability.csv")  
