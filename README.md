# county-demographics-covid-database
This repository contains a county-level dataset of publicly available data that may be pertinent to Covid-19 analyses. The source code is also contained here.


## Overview

The county-level dataset is stored in two formats: 
1. Stata: county_panel.dta
2. CSV: county_panel.csv

These should be identical, except stata-date-format variables are dropped for the csv.  The string version of date variables remain

Data cover 3,109 counties, but exclude Alaska and Hawaii due to limited data availability.

All variables are 'time-invariant'. Can easily be matched with other county-level variables using FIPS code, such as COVID case or mobility data.

## Codebook 
(with description if necessary, also see section below for more details on source/construction)

1. state: State Name
2. county: County Name
3. fips: 5-digit fips code, numeric
4. county_population
5. white_pct
6. black_pct
7. hispanic_pct
8. nonwhite_pct
9. female_pct
10. age29andunder_pct
11. age65andolder_pct
12. median_hh_inc
13. less_hs_pct
14. lesscollege_pct
15. rural_pct
16. trumpshare: Share of voters voting for Trump in 2016 Presidential election
17. voter_participation: share of voting population participating in 2016 general election vote
18. state_fips: 2 digit fips code for state
19. effectivedate_MDY: first date county is under any stay-at-home order (whether county or state declared), in MM/DD/YYYY format
20. effectivedate: same as prev, but statadate format (only in .dta file)
21. stateeffectivedate_MDY: first date under a STATE stay-at-home order, in MM/DD/YYYY format
22. state_effectivedate: same as prev, but statadate format (only in .dta file)
23. density_pop: county population per 
24. density_housing_units: 
25. vehicles: avg number of vehicles in household
26. pubtrans: share of pop taking public transit to work
27. teleworkable: share of occupations in county that are 'teleworkable'
28. beds_licensed: number of hospital beds in county
29. beds_staffed:  number of 'staffed' hospital beds in county
30. beds_icu: number of icu beds in county
31. beds_icu_adult
32. beds_icu_pediatric
33. obesity: obesity rate in county
34. sufficient_phys_activity: share of population getting 'sufficient physical activity'
35. binge_drinker: share of pop binge-drinking at least once in last 30 days
36. heavy_drinker: share of pop having on avg more than 2 drinks per day over past 30 days
37. smoke_daily: share of pop who smoke daily
38. diabetes: share of pop with diabetes



## Detailed Data Source Information

### MEDSL - MIT Election Data + Science Lab
Source for variables 4&ndash;17. 
Info on primary sources can be found here: https://github.com/MEDSL/2018-elections-unoffical/blob/master/election-context-2018.md


### NYT stay-at-home tracker
Source for variables 19&ndash;22.
methodology/references: https://github.com/jrstromme/covid-stay-at-home-orders

### 2010 Census
Source for variables 23 and 24. 

### 2018 5 year ACS
Source for variables 25&ndash;26.
Obtained from IPUMS USA. Source file omitted here because it is too large.
Variables: STATEFIP, COUNTYFIP, PUMA, VEHICLES, PERNUM, PERWT, OCC, TRANWORK

A crosswalk from PUMA to county was obtained from the Missouri Census Data Center's Geocorr tool: http://mcdc.missouri.edu/applications/geocorr2018.html
This creates allocations from PUMA's to counties. This file is saved as ACS/raw/geocorr2018.csv

### O*NET 
Source for variable 27.
A teleworkable index was constructed from O*NET data based on Dingel and Neiman's methodology.
https://github.com/jdingel/DingelNeiman-workathome

### Definitive Healthcare: Hospital Bed Availability 
Source for variables 28&ndash;32.
Hospital bed availability by county is available at:
https://www.arcgis.com/home/item.html?id=1044bb19da8d4dbfb6a96eb1b4ebf629

### GHDx Health Data
Source for variables 33&ndash;38
Prevalence of various diseases is available at:
http://ghdx.healthdata.org/us-data

## Misc Notes:
All source data, except for ACS data, are included in repository. Please see makefile for order in which .do and .R codes should be run. Some directories in .R and .do files will need to be adjusted if you try to run them on your own. 'make all' will run all code start to finish (But ACS must be downloaded on your own and some paths changed).

Comments and contributions welcome. Please acknowledge source if used.




