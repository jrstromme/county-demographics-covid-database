# onet-process.R
#
# Takes the onet-occ1990dd file, and creates a teleworkable variable
#   based on Dingel & Neiman

rm(list=ls())

library(tidyverse)
library(tidylog)
library(readstata13)

setwd("~/Documents/Wisconsin/Research/county-demographics-covid-database/onet/")


## First get our ONET ducks in a row -----------------------

onet.df <- read.dta13("./onet98_occ1990dd.dta")

# Work Activities
# g16im00m
onet.df <- onet.df %>% 
  mutate(physical_activities = case_when(g16im00m > 4 ~ 1,
                                         TRUE ~ 0 ))
#bys onetsoccode: egen byte physical_activities = max(elementid=="4.A.3.a.1" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable physical_activities "Performing General Physical Activities is very important (4.0+ of 5)"

# g17im00m
onet.df <- onet.df %>% 
  mutate(handlingobjects = case_when(g17im00m > 4 ~ 1,
                                     TRUE ~ 0))
#bys onetsoccode: egen byte handlingobjects = max(elementid=="4.A.3.a.2" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable handlingobjects "Handling and Moving Objects is very important (4.0+ of 5)"

# g18im00m
onet.df <- onet.df %>% 
  mutate(control_machines = case_when(g18im00m > 4 ~ 1,
                                      TRUE ~ 0))
#bys onetsoccode: egen byte control_machines = max(elementid=="4.A.3.a.3" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable control_machines "Controlling Machines and Processes [not computers nor vehicles] is very important (4.0+ of 5)"

#G19im00M
onet.df <- onet.df %>% 
  mutate(operate_equipment = case_when(g19im00m > 4 ~ 1,
                                       TRUE ~ 0))
#bys onetsoccode: egen byte operate_equipment = max(elementid=="4.A.3.a.4" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable operate_equipment "Operating Vehicles, Mechanized Devices, or Equipment is very important (4.0+ of 5)"

# G33IM00M
onet.df <- onet.df %>% 
  mutate(dealwithpublic = case_when(g33im00m > 4 ~ 1,
                                    TRUE ~ 0))
#bys onetsoccode: egen byte dealwithpublic = max(elementid=="4.A.4.a.8" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable dealwithpublic "Performing for or Working Directly with the Public is very important (4.0+ of 5)"

# G23IM00M
onet.df <- onet.df %>% 
  mutate(repair_mechequip = case_when(g23im00m > 4 ~ 1,
                                      TRUE ~ 0))
#bys onetsoccode: egen byte repair_mechequip = max(elementid=="4.A.3.b.4" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable repair_mechequip "Repairing and Maintaining Mechanical Equipment is very important (4.0+ of 5)"

# G24IM00M
onet.df <- onet.df %>% 
  mutate(repair_elecequip = case_when(g24im00m > 4 ~ 1,
                                      TRUE ~ 0))
#bys onetsoccode: egen byte repair_elecequip = max(elementid=="4.A.3.b.5" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable repair_elecequip "Repairing and Maintaining Electronic Equipment is very important (4.0+ of 5)"

#G04IM00M
onet.df <- onet.df %>% 
  mutate(inspect_equip = case_when(g04im00m > 4 ~ 1,
                                   TRUE ~ 0))
#bys onetsoccode: egen byte inspect_equip = max(elementid=="4.A.1.b.2" & scaleid=="IM" & inrange(datavalue,4.0,5.0)==1)
#label variable inspect_equip "Inspecting Equipment, Structures, or Materials is very important (4.0+ of 5)"

# Work Context
# (substituting computer interaction) G19IM00M
onet.df <- onet.df %>% 
  mutate(email_lessthanmonthly = case_when(g19im00m < 1 ~ 1,
                                           TRUE ~ 0))
#bys onetsoccode: egen byte email_lessthanmonthly = max(elementid=="4.C.1.a.2.h" & inrange(datavalue,1.0,2.0)==1)
#label variable email_lessthanmonthly "Average respondent says they use email less than once per month"

# W99FN00M
onet.df <- onet.df %>% 
  mutate(outdoors_everyday = case_when(w99fn00m > 4.5 ~ 1,
                                       TRUE ~ 0))
#bys onetsoccode: egen byte outdoors_everyday = max(inlist(elementid,"4.C.2.a.1.c","4.C.2.a.1.d") & inrange(datavalue,4.5,5.0)==1)
#label variable outdoors_everyday "Majority of respondents say outdoors every day"

#W27CF00M
onet.df <- onet.df %>% 
  mutate(violentpeople_atleastweekly = case_when(w27cf00m > 4 ~ 1,
                                                 TRUE ~ 0))
#bys onetsoccode: egen byte violentpeople_atleastweekly = max(elementid=="4.C.1.d.3" & inrange(datavalue,4.0,5.0)==1)
#label variable violentpeople_atleastweekly "Average respondent says they deal with violent people at least once a week"

# w72fn00m
onet.df <- onet.df %>% 
  mutate(safetyequip_majority = case_when(w72fn00m > 3.5 ~ 1,
                                          TRUE ~ 0))
#bys onetsoccode: egen byte safetyequip_majority = max(inlist(elementid,"4.C.2.e.1.d","4.C.2.e.1.e") & inrange(datavalue,3.5,5.0)==1)
#label variable safetyequip_majority "Average respondent says they spent majority of time wearing common or specialized protective or safety equipment"

#W47FN00M
onet.df <- onet.df %>% 
  mutate(minorhurt_atleastweekly = case_when(w47fn00m > 4 ~ 1,
                                             TRUE ~ 0))
#bys onetsoccode: egen byte minorhurt_atleastweekly = max(elementid=="4.C.2.c.1.f" & inrange(datavalue,4.0,5.0)==1)
#label variable minorhurt_atleastweekly "Average respondent says they are exposed to minor burns, cuts, bites, or stings at least once a week"

# W43FN00M
onet.df <- onet.df %>% 
  mutate(disease_atleastweekly = case_when(w43fn00m > 4 ~ 1,
                                           TRUE ~ 0))
#bys onetsoccode: egen byte disease_atleastweekly = max(elementid=="4.C.2.c.1.b" & inrange(datavalue,4.0,5.0)==1)
#label variable disease_atleastweekly "Average respondent says they are exposed to diseases or infection at least once a week"

#W63FN00M
onet.df <- onet.df %>% 
  mutate(walking_majority = case_when(w63fn00m > 3.5 ~ 1,
                                      TRUE ~ 0))
#bys onetsoccode: egen byte walking_majority = max(elementid=="4.C.2.d.1.d" & inrange(datavalue,3.5,5.0)==1)
#label variable walking_majority "Average respondent says they spent majority of time walking or running"



# creating the overall variable
onet.df <- onet.df %>% 
  mutate(teleworkable = email_lessthanmonthly==0 & 
           outdoors_everyday==0 & 
           violentpeople_atleastweekly==0 & 
           safetyequip_majority == 0 & 
           minorhurt_atleastweekly==0 &
           physical_activities==0 & 
           handlingobjects==0 & 
           control_machines==0 & 
           operate_equipment==0 & 
           dealwithpublic==0 & 
           repair_mechequip==0 & 
           repair_elecequip==0 &
           inspect_equip==0 & 
           disease_atleastweekly==0 & 
           walking_majority==0) %>% 
  select(occ1990dd, teleworkable)

write.csv(onet.df,"./occ1990dd_teleworkable.csv")