# ipums-process.R
#
# Takes the ACS data downloaded from IPUMS, processes into county data
#    and converts to occ1990dd codes.

rm(list=ls())

library(tidyverse)
library(tidylog)
library(readstata13)

setwd("~/Documents/Wisconsin/Research/county-demographics-covid-database/ACS")


# load in census data from ipums
df <- read.csv("./raw/usa_00042.csv")

df <- df %>% rename(occ2010 = OCC)  
  
# Some extra code mapping changes to update the 2012 ACS xwalk to now 2018 codes
#    as well.
df$occ2010 <- recode(df$occ2010,
         `51`= 50L,
         `52`= 50L,
         `101` = 100L,
         `102` = 100L,
         `335` = 330L,
         `440` = 430L,
         `705` = 700L,
         `750` = 740L,
         `845` = 840L,
         `960` = 950L,
         `1021`= 1020L,
         `1022`= 1020L,
         `1031`= 1020L,
         `1032`= 1020L,
         `1065`= 1060L,
         `1108`= 1010L,
         `1305`= 1300L,
         `1306`= 1300L,
         `1541`= 1540L,
         `1545`= 1540L,
         `1551`= 1550L,
         `1555`= 1540L,
         `1745`= 1740L,
         `1750`= 1740L,
         `1821`= 1820L,
         `1822`= 1820L,
         `1825`= 1820L,
         `1935`= 1930L,
         `1970`= 1965L,
         `1980`= 1965L,
         `2001`= 2000L,
         `2002`= 2000L,
         `2003`= 2000L,
         `2004`= 2000L,
         `2005`= 2000L,
         `2006`= 2000L, 
         `2011`= 2010L, 
         `2012`= 2010L, 
         `2013`= 2010L, 
         `2014`= 2010L, 
         `2170`= 2160L, 
         `2180`= 2160L, 
         `2205`= 2200L, 
         `2350`= 2340L, 
         `2360`= 2340L, 
         `2435`= 2430L,
         `2545`= 2540L, 
         `2555`= 2550L, 
         `2631`= 2630L, 
         `2632`= 2630L, 
         `2633`= 2630L, 
         `2634`= 2630L, 
         `2635`= 2630L, 
         `2636`= 2630L, 
         `2640`= 2630L, 
         `2721`= 2720L, 
         `2722`= 2720L, 
         `2723`= 2720L, 
         `2751`= 2750L, 
         `2752`= 2750L, 
         `2755`= 2750L, 
         `2770`= 2760L, 
         `2805`= 2800L, 
         `2861`= 2860L, 
         `2862`= 2860L, 
         `2865`= 2860L, 
         `2905`= 2900L, 
         `3090`= 3060L, 
         `3100`= 3060L,
         `3261`= 3260L, 
         `3270`= 3260L, 
         `3321`= 3320L, 
         `3322`= 3320L, 
         `3323`= 3320L, 
         `3324`= 3320L, 
         `3330`= 3320L, 
         `3401`= 3400L, 
         `3402`= 3400L, 
         `3421`= 3420L, 
         `3422`= 3420L, 
         `3423`= 3420L, 
         `3424`= 3420L, 
         `3430`= 3535L, 
         `3515`= 3510L, 
         `3545`= 3535L, 
         `3550`= 3540L, 
         `3601`= 3600L, 
         `3602`= 3600L, 
         `3603`= 3600L, 
         `3605`= 3600L, 
         `3725`= 3730L, 
         `3801`= 3800L,
         `3802`= 3800L,
         `3870`= 3850L, 
         `3946`= 3945L, 
         `3960`= 3955L, 
         `4055`= 4050L, 
         `4160`= 4130L, 
         `4251`= 4250L, 
         `4252`= 4250L, 
         `4255`= 4250L, 
         `4330`= 4300L, 
         `4435`= 4430L, 
         `4461`= 4460L, 
         `4521`= 4520L, 
         `4522`= 4520L, 
         `4525`= 4520L, 
         `4621`= 4620L, 
         `4622`= 4620L, 
         `4655`= 4650L, 
         `5040`= 5030L, 
         `5521`= 5520L, 
         `5522`= 5520L, 
         `5710`= 5700L, 
         `5720`= 5700L,
         `5730`= 5700L, 
         `5740`= 5700L, 
         `6115`= 6100L, 
         `6305`= 6320L, 
         `6410`= 6420L, 
         `6441`= 6440L, 
         `6442`= 6440L, 
         `6540`= 6765L, 
         `6825`= 6840L, 
         `6835`= 6830L, 
         `6850`= 6840L, 
         `6950`= 6940L, 
         `7640`= 7630L, 
         `7905`= 7900L, 
         `7925`= 7920L, 
         `8025`= 7950L, 
         `8225`= 8220L, 
         `8335`= 8330L, 
         `8365`= 8400L, 
         `8465`= 8460L, 
         `8555`= 8550L, 
         `8990`= 8965L, 
         `9005`= 9000L,
         `9121`= 9120L, 
         `9122`= 9120L, 
         `9141`= 9140L, 
         `9142`= 9140L, 
         `9210`= 9200L, 
         `9265`= 9260L, 
         `9365`= 9360L, 
         `9430`= 9420L, 
         `9570`= 9520L, 
         `9645`= 9640L, 
         `9760`= 9750L, 
         `9825`= 9820L)
         


occ.xwalk <- read.dta13('../xwalks/occ2010_occ1990dd_update.dta')

df <- left_join(df,occ.xwalk, by = "occ2010")

#join in telework code (814, 905, 991, 999, don't have telework codes, military and nonemp)
onet.df <- read.csv("../onet/occ1990dd_teleworkable.csv")
df <- left_join(df, onet.df, by = "occ1990dd")
# change teleworok for military ppl and for some reason ambulence/bus drivers
df <- df %>% 
  mutate(teleworkable = ifelse(occ2010 %in% c(9110,9150,9800,9810,9820,9830), TRUE, teleworkable))

# process tranwork variable (pub trans is bus streetcar subway railroad ferryboat)
df <- df %>% 
  mutate(pubtrans = ifelse(TRANWORK %in% c(31,32,33,34,36), 1, 0))

# calculate statistics at the PUMA level (leaving weighted sums, will divide for means after allocation)
df.puma <- df %>% 
  group_by(PUMA,STATEFIP) %>% 
  mutate(teleavail = !is.na(teleworkable)) %>% 
  summarise(vehicles = sum(VEHICLES*PERWT),
            pubtrans = sum(pubtrans*PERWT),
            teleworkable = sum(teleworkable*PERWT,na.rm = T),
            perwt        = sum(PERWT),
            perwt.tele   = sum(PERWT*teleavail))


# get the puma->county link
puma.county.xwalk <- read.csv("./raw/geocorr2018.csv") %>% 
  rename(PUMA = puma12,
         STATEFIP = state,
         COUNTYFIP = county)

df.puma <- left_join(puma.county.xwalk, df.puma, by=c("PUMA","STATEFIP"))

# Use the allocation factors to make county means
df.puma <- df.puma %>% 
  group_by(STATEFIP, COUNTYFIP) %>% 
  summarise(vehicles     = sum(vehicles     * afact),
            pubtrans     = sum(pubtrans     * afact),
            teleworkable = sum(teleworkable * afact),
            perwt        = sum(perwt        * afact),
            perwt.tele   = sum(perwt.tele   * afact)) %>% 
  mutate(vehicles = vehicles / perwt,
         pubtrans = pubtrans / perwt,
         teleworkable = teleworkable / perwt.tele)

# now rename some things and save as rds
df.puma <- df.puma %>% 
  ungroup() %>% 
  rename(FIPS = COUNTYFIP) %>% 
  mutate(FIPS = str_pad(FIPS,width=5,side="left",pad="0")) %>% 
  select(FIPS,vehicles,pubtrans,teleworkable)
  
#note 1 na issue with zero afact, but its for hawaii so dropped anyways
write.csv(df.puma, file = './veh_pub_telework.csv')
