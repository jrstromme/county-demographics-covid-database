* wrangle_together.do 
* created 3/28/20
* author: JSTROMME
* 
* Takes county level+ data and wrangles together
* 
*

clear
capture restore, not

macro drop _all

global home "~/Documents/Wisconsin/Research/county-demographics-covid-database"

**** pres voting and county demographics (note NO ALASKA DATA) ****

import delimited $home/MIT/raw/election-context-2018.csv, delimiter(comma) varnames(1) numericcols(3/39)
*  keep only what we need for now (some removed include gov/house/rep, 2014 elec data, foreignborn collegexwhite, unemp ruralurban continnuum codes)
keep state county fips trump16 clinton16 otherpres16 total_population cvap white_pct black_pct hispanic_pct nonwhite_pct female_pct age29andunder_pct age65andolder_pct median_hh_inc lesshs_pct lesscollege_pct rural_pct 
*generate election variables and drop fluff
gen totvotes = trump16+clinton16+otherpres16
gen trumpshare = trump16 / totvotes
gen voter_participation = totvotes / cvap
drop trump16 clinton16 otherpres16 cvap totvotes
rename fips county_fips
rename total_population county_population
* shannon county renamed to ogalala lakota county
replace county_fips = 46102 if county_fips == 46113 

*create statefips variable
gen FIPS_str = string(county_fips,"%05.0f")
gen state_fips = substr(FIPS_str, 1,2)
destring state_fips, replace
drop FIPS_str

*also drop hawaii
drop if county_fips >= 15000 & county_fips <= 15999

* one weird observation 'kansas city', seems like it shouldn't be there
drop if county_fips == 36000


preserve

**** merge in restriction order dataset ****

* note missingness means no stay at home order has thus been enacted
clear
import delimited $home/stay-at-home/stay_at_home.csv, delimiter(comma) varnames(1)
drop if state == "Alaska" | state == "Hawaii"
drop if effectivedate == ""
* don't care about cities for now....
drop if city != ""
drop city

gen stataeffdate = date(effectivedate,"MDY")
rename countyfips county_fips
rename statefips state_fips

replace state_fips = . if county_fips != "NA"
replace county_fips = "" if county_fips == "NA"
destring county_fips, replace

save $home/temp.dta, replace

keep if county_fips != . 
keep county_fips stataeffdate
rename stataeffdate county_effectivedate
save $home/temp2, replace 

use $home/temp.dta, clear
keep if state_fips != .
keep state_fips stataeffdate
rename stataeffdate state_effectivedate
save $home/temp, replace

restore
merge 1:1 county_fips using $home/temp2
drop _merge
merge m:1 state_fips using $home/temp
drop _merge

gen effectivedate = min(county_effectivedate,state_effectivedate)
drop county_effectivedate

gen effectivedate_MDY =  string(month(effectivedate),"%02.0f")+"/"+string(day(effectivedate),"%02.0f")+"/"+string(year(effectivedate),"%04.0f")
gen stateeffectivedate_MDY =  string(month(state_effectivedate),"%02.0f")+"/"+string(day(state_effectivedate),"%02.0f")+"/"+string(year(state_effectivedate),"%04.0f")

preserve

**** merge in density data ****

* from american fact finder, county level 2010 census. 
clear
import delimited $home/census/raw/density.csv, delimiter(comma) varnames(1)
drop if county_fips >= 2000 & county_fips <= 2999
drop if county_fips >= 15000 & county_fips <= 15999
keep county_fips density_pop density_housing_units 
sort county_fips
* shannon county renamed to ogalala lakota county
replace county_fips = 46102 if county_fips == 46113 
save $home/temp.dta, replace

restore
sort county_fips
merge 1:1 county_fips using $home/temp.dta
*  one in master can't match, kansas city 36000 
*  using has state level vars not matching which we don't want anyway
keep if _merge == 3
drop _merge

preserve




**** merge in vehicle, pubtrans commute, and teleworkable data

clear
import delimited $home/ACS/veh_pub_telework.csv, delimiter(comma) varnames(1)
drop v1
destring , replace
destring , replace
rename fips county_fips
sort county_fips
drop if county_fips > 2000 & county_fips < 2999
drop if county_fips > 15000 & county_fips < 15999
save $home/temp.dta, replace

restore
sort county_fips
merge 1:1 county_fips using $home/temp.dta
keep if _merge == 3 
drop _merge

preserve


**** merge in hospital beds ****
clear
import delimited $home/hospital-beds/county_bed_availability.csv
drop v1
rename fips county_fips
drop if county_fips > 2000 & county_fips < 2999
drop if county_fips > 15000 & county_fips < 15999
save $home/temp.dta, replace

restore
merge 1:1 county_fips using $home/temp
*won't have beds in every county so master unmerge ok. o.w. 46102 isn't pulled from using
drop _merge

preserve

**** merge in disease prevalence ****
clear
import delimited $home/disease_prevalence/disease_prevalence_county.csv

drop v1 state county
rename fips county_fips
*fix and destring diabetes variable
replace diabetes = "" if diabetes == "NA"
destring diabetes, replace
* shannon county renamed to ogalala lakota county
replace county_fips = 46102 if county_fips == 46113 
save $home/temp.dta, replace

restore
merge 1:1 county_fips using $home/temp
drop _merge

*save as oglala lakota fips, that's more consistent anyways
replace county_fips = 46113 if county_fips == 46102


*save stata version
save $home/county_panel.dta, replace
*drop stata specific date variables and also save as csv
drop effectivedate state_effectivedate
export delimited * using $home/county_panel.csv, replace


