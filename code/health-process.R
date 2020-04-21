# health-process.R
#
# Processes the dataset on disease prevalence by county
#  
#

rm(list=ls())

library(tidyverse)
library(tidylog)
library(readstata13)
library(readxl)

setwd("~/Documents/Wisconsin/Research/county-demographics-covid-database/disease_prevalence/")


# Smoking ----------------------
smoke.df <- read.csv("./raw/IHME_US_COUNTY_TOTAL_AND_DAILY_SMOKING_PREVALENCE_1996_2012/IHME_US_COUNTY_TOTAL_AND_DAILY_SMOKING_PREVALENCE_1996_2012.csv",
                     stringsAsFactors = F)

smoke.df <- smoke.df %>% 
  filter(sex=="Both",
         county != "",
         year == 2012) %>% 
  select(state, county, daily_mean)

# Drinking ----------------------
heavy.df <- read_excel("./raw/IHME_USA_COUNTY_ALCOHOL_USE_PREVALENCE_2002_2012_NATIONAL/IHME_USA_COUNTY_ALCOHOL_USE_PREVALENCE_2002_2012_NATIONAL_Y2015M04D23.XLSX",
                       sheet = 3)
heavy.df <- heavy.df %>% 
  select(State,Location,`2012 Both Sexes`) %>% 
  rename(state = State,
         county = Location,
         heavy_drinker = `2012 Both Sexes`)

binge.df <- read_excel("./raw/IHME_USA_COUNTY_ALCOHOL_USE_PREVALENCE_2002_2012_NATIONAL/IHME_USA_COUNTY_ALCOHOL_USE_PREVALENCE_2002_2012_NATIONAL_Y2015M04D23.XLSX",
                       sheet = 4)
binge.df <- binge.df %>% 
  select(State,Location,`2012 Both Sexes`) %>% 
  rename(state = State,
         county = Location,
         binge_drinker = `2012 Both Sexes`)

# Diabetes ----------------------
diabetes.df <- read_excel("./raw/IHME_USA_COUNTY_DIABETES_PREVALENCE_1999_2012/IHME_USA_COUNTY_DIABETES_PREVALENCE_1999_2012_NATIONAL_Y2016M08D23.XLSX",
                          sheet = 4, skip=1)
diabetes.df <- diabetes.df %>% 
  select(Location, FIPS, `Prevalence, 2012, Both Sexes`) %>% 
  rename(county = Location,
         diabetes = `Prevalence, 2012, Both Sexes`)

# Obesity ----------------------
obesity.df <- read.csv("./raw/IHME_USA_OBESITY_PHYSICAL_ACTIVITY_2001_2011.csv",
                       stringsAsFactors = F)
obesity.df <- obesity.df %>%
  select(fips, State, County, Sex, Outcome, `Prevalence.2011....`) %>% 
  rename(prevalence = `Prevalence.2011....`) %>% 
  pivot_wider(id_cols = 1:4, names_from = Outcome, values_from = prevalence) %>% 
  pivot_wider(id_cols = 1:3, names_from = Sex, values_from = 5:7)
#need share of gender to get county estimate (this is 2010 census data)
gender.df1 <- read.csv("./raw/stco-mr2010_al_mo.csv",
                      stringsAsFactors = F) %>% 
  select(STATE,COUNTY,STNAME,CTYNAME,SEX,RESPOP)
gender.df2 <- read.csv("./raw/stco-mr2010_mt_wy.csv",
                       stringsAsFactors = F) %>% 
  select(STATE,COUNTY,STNAME,CTYNAME,SEX,RESPOP)
gender.df <- rbind(gender.df1,gender.df2)
rm(gender.df1, gender.df2)

gender.df <- gender.df %>% 
  group_by(STATE,COUNTY,STNAME,CTYNAME,SEX) %>% 
  summarise(pop = sum(RESPOP)) %>% 
  pivot_wider(1:4, names_from=SEX, values_from=pop, names_prefix = "sex") %>% 
  mutate(male.share = sex1/(sex1+sex2),
         female.share = sex2/(sex1+sex2)) %>% 
  select(-sex1,-sex2)
#merge to obesity df 
gender.df <- gender.df %>% 
  mutate(fips = as.numeric(paste0(STATE, str_pad(COUNTY,3,"left","0"))))
obesity.df <- left_join(obesity.df, gender.df, by="fips") %>% 
  mutate(obesity = Obesity_Male * male.share + Obesity_Female * female.share,
         sufficient_phys_activity = `Sufficient PA_Male` * male.share + `Sufficient PA_Female` * female.share) %>% 
  select(fips, State, CTYNAME, obesity, sufficient_phys_activity)
rm(gender.df)

# Merge everything together and clean -------------------------------------
obesity.df <- obesity.df %>% 
  rename(state = State,
         county = CTYNAME) %>% 
  mutate(state  = tolower(state),
         county = tolower(enc2utf8(county))) %>% 
  filter(!is.na(fips)) %>% 
  filter(state != "alaska",
         state != "hawaii") %>% 
  mutate(county = case_when(county == 'do<f1>a ana county' ~ 'dona ana county',
                            TRUE ~ county))

binge.df <- binge.df %>% 
  filter(state != county,
         state != "National")
heavy.df <- heavy.df %>% 
  filter(state != county,
         state != "National")
drinking.df <- left_join(binge.df,heavy.df,by=c('state','county'))  
rm(binge.df,heavy.df)
drinking.df <- drinking.df %>% 
  mutate(state = tolower(state),
         county = tolower(county)) %>% 
  filter(state != "alaska",
         state != "hawaii")
#need to fix a few virginia counties, just apply # to both counties
tmp <- drinking.df %>% 
  filter(county %in% c('augusta county, waynesboro city',
                       'bedford county, bedford city',
                       'fairfax county, fairfax city',
                       'prince william county, manassas park city',
                       'southampton county, franklin city')) %>% 
  mutate(county = case_when(county == 'augusta county, waynesboro city' ~ 'augusta county',
                            county == 'bedford county, bedford city'    ~ 'bedford county',
                            county == 'fairfax county, fairfax city'    ~ 'fairfax county',
                            county == 'prince william county, manassas park city' ~ 'prince william county',
                            county == 'southampton county, franklin city' ~ 'southampton county',
                            TRUE ~ county))
drinking.df <- drinking.df %>% 
  mutate(county = case_when(county == 'augusta county, waynesboro city' ~ 'waynesboro city',
                            county == 'bedford county, bedford city'    ~ 'bedford city',
                            county == 'fairfax county, fairfax city'    ~ 'fairfax city',
                            county == 'prince william county, manassas park city' ~ 'manassas park city',
                            county == 'southampton county, franklin city' ~ 'franklin city',
                            TRUE ~ county))
drinking.df <- rbind(drinking.df, tmp)
# fix a few colorado counties
tmp <-  drinking.df %>% 
  filter(county=='adams county, boulder county, broomfield county, jefferson county, weld county') %>% 
  slice(rep(1:n(), each = 5))
tmp$county = c('adams county', 'boulder county', 'broomfield county', 'jefferson county', 'weld county')
drinking.df <- drinking.df %>% 
  filter(county!='adams county, boulder county, broomfield county, jefferson county, weld county')
drinking.df <- rbind(drinking.df,tmp)
rm(tmp)


smoke.df <- smoke.df %>% 
  mutate(state = tolower(state),
         county = tolower(county)) %>% 
  rename(smoke_daily = daily_mean) %>% 
  filter(state != 'hawaii',
         state != 'alaska')
#fix virginia
tmp <- smoke.df %>% 
  filter(county %in% c('augusta county/waynesboro city',
                       'bedford county/bedford city',
                       'fairfax county/fairfax city',
                       'prince william county/manassas park city',
                       'southampton county/franklin city')) %>% 
  mutate(county = case_when(county == 'augusta county/waynesboro city' ~ 'augusta county',
                            county == 'bedford county/bedford city'    ~ 'bedford county',
                            county == 'fairfax county/fairfax city'    ~ 'fairfax county',
                            county == 'prince william county/manassas park city' ~ 'prince william county',
                            county == 'southampton county/franklin city' ~ 'southampton county',
                            TRUE ~ county))
smoke.df <- smoke.df %>% 
  mutate(county = case_when(county == 'augusta county/waynesboro city' ~ 'waynesboro city',
                            county == 'bedford county/bedford city'    ~ 'bedford city',
                            county == 'fairfax county/fairfax city'    ~ 'fairfax city',
                            county == 'prince william county/manassas park city' ~ 'manassas park city',
                            county == 'southampton county/franklin city' ~ 'franklin city',
                            TRUE ~ county))
smoke.df <- rbind(smoke.df, tmp)
# now fix colorado
tmp <-  smoke.df %>% 
  filter(county=='adams county/boulder county/broomfield county/jefferson county/weld county') %>% 
  slice(rep(1:n(), each = 5))
tmp$county = c('adams county', 'boulder county', 'broomfield county', 'jefferson county', 'weld county')
smoke.df <- smoke.df %>% 
  filter(county!='adams county/boulder county/broomfield county/jefferson county/weld county')
smoke.df <- rbind(smoke.df,tmp)
rm(tmp)

diabetes.df <- diabetes.df %>% 
  rename(fips = FIPS) %>% 
  filter(!is.na(fips)) %>% 
  mutate(fips = case_when(fips == 46102 ~ 46113,
                          TRUE ~ fips)) %>% 
  select(-county)


out.df <- obesity.df
out.df <- left_join(out.df,drinking.df, by=c('state','county'))
out.df <- left_join(out.df,smoke.df, by=c('state','county'))
out.df <- left_join(out.df,diabetes.df, by="fips") #hawaii, alaska and state aggregates don't match as we want

rm(obesity.df,drinking.df, smoke.df, diabetes.df)

write.csv(out.df,'./disease_prevalence_county.csv')