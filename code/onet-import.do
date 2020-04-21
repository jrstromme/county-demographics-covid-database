 /*
 
	onet-import.do
	
	
    Repurposed quickly for this proj, just in case
	Only saved work activity and work requirement vars as does the Dingel Neiman paper
    Created: 8/28/18 -> Adapted 4/20/20
	Author: JStromme
	Original adapted from David Deming's Social Skills paper code repository
	
	Gathers only necessary onet variables that are also used in Dingel's 
	teleworkable index
	
	Output is occ1990dd rows, with onet variable columns normalized between 0-5
	
	*****
	
	ONET Codes Notes - 8 digits
	1   - Skill area (i.e. A = ability, B = basic skills)
	2,3 - Question Group
	4,5 - Measure (IM (importance) or LV (level) etc...)
	6,7 - Sequence number
	8   - statistic type (M = mean, P = percentage, etc..)

*/

clear all
set more off


**** Define macros ****

global homedir "/Users/John/Documents/Wisconsin/Research/county-demographics-covid-database"
global onetdir  "$homedir/onet/raw"
global xwalkdir "$homedir/xwalks"
global outdir   "$homedir/onet"

*/Users/John/Documents/Wisconsin/Research/county-demographics-covid-database/onet/raw/WorkContext.txt 


************************
****Import 1998 ONET****
************************

*** ORDER OF FILES REPRESENTS ORDER IN DATA DICTIONARY

**** Occupational Requirements

** Work Activity Variables

import delimited $onetdir/WorkActivity.txt, clear delimiter(comma)

rename	v1	onet98code
*Getting information needed to do the job (need to obtain information from sources)
rename	v2	G01FG00M
rename	v3	G01IM00M
rename	v4	G01LV00M
* Identifying objects, actions, and events
rename	v5	G02FG00M
rename	v6	G02IM00M
rename	v7	G02LV00M
* Monitor Processes, Material, Surroundings
rename	v8	G03FG00M
rename	v9	G03IM00M
rename	v10	G03LV00M
* Inspecting Equipment, Structures, Material
rename	v11	G04FG00M
rename	v12	G04IM00M
rename	v13	G04LV00M
* Estimating Needed Characteristics
rename	v14	G05FG00M
rename	v15	G05IM00M
rename	v16	G05LV00M
* Judging Qualtieis of Things, Services, People
rename	v17	G06FG00M
rename	v18	G06IM00M
rename	v19	G06LV00M
* Processing Information
rename	v20	G07FG00M
rename	v21	G07IM00M
rename	v22	G07LV00M
* Evaluating Information against a set of standards
rename	v23	G08FG00M
rename	v24	G08IM00M
rename	v25	G08LV00M
* Analyzing Data or Information
rename	v26	G09FG00M
rename	v27	G09IM00M
rename	v28	G09LV00M
* Making Decisions and Solving Problems
rename	v29	G10FG00M
rename	v30	G10IM00M
rename	v31	G10LV00M
* Thinking Creatively
rename	v32	G11FG00M
rename	v33	G11IM00M
rename	v34	G11LV00M
* Updating & Using Job-Relevant Knowledge
rename	v35	G12FG00M
rename	v36	G12IM00M
rename	v37	G12LV00M
* Developing Objectives and Strategies
rename	v38	G13FG00M
rename	v39	G13IM00M
rename	v40	G13LV00M
* Scheduling Work and Activities
rename	v41	G14FG00M
rename	v42	G14IM00M
rename	v43	G14LV00M
* Organizing Planning and Prioritizing
rename	v44	G15FG00M
rename	v45	G15IM00M
rename	v46	G15LV00M
* Performing General Physical Activities
rename	v47	G16FG00M
rename	v48	G16IM00M
rename	v49	G16LV00M
* Handling and Moving Objects
rename	v50	G17FG00M
rename	v51	G17IM00M
rename	v52	G17LV00M
* Controlling Machines and Processes
rename	v53	G18FG00M
rename	v54	G18IM00M
rename	v55	G18LV00M
* Operating Vehicles or Equipment
rename	v56	G19FG00M
rename	v57	G19IM00M
rename	v58	G19LV00M
* Interacting With Computers
rename	v59	G20FG00M
rename	v60	G20IM00M
rename	v61	G20LV00M
* Drafting and Specifying Technical Devices etc (inform others how things are made or used)
rename	v62	G21FG00M
rename	v63	G21IM00M
rename	v64	G21LV00M
* Implementing Ideas, Programs etc
rename	v65	G22FG00M
rename	v66	G22IM00M
rename	v67	G22LV00M
* Repairing and Maintaining Mechanical Equipment
rename	v68	G23FG00M
rename	v69	G23IM00M
rename	v70	G23LV00M
* Repairing and Maintaining Electrical Equipment
rename	v71	G24FG00M
rename	v72	G24IM00M
rename	v73	G24LV00M
* Documenting / Recording Information
rename	v74	G25FG00M
rename	v75	G25IM00M
rename	v76	G25LV00M
* Interpreting Meaning of Information to Others
rename	v77	G26FG00M
rename	v78	G26IM00M
rename	v79	G26LV00M
* Communicating with other workers
rename	v80	G27FG00M
rename	v81	G27IM00M
rename	v82	G27LV00M
* Communicating with persons outside organization
rename	v83	G28FG00M
rename	v84	G28IM00M
rename	v85	G28LV00M
* Establishing and Maintaining Relationships
rename	v86	G29FG00M
rename	v87	G29IM00M
rename	v88	G29LV00M
* Assisting and Caring for Others
rename	v89	G30FG00M
rename	v90	G30IM00M
rename	v91	G30LV00M
* Selling or Influencing Others
rename	v92	G31FG00M
rename	v93	G31IM00M
rename	v94	G31LV00M
* Resolving Conflict, Negotiating with Others
rename	v95	G32FG00M
rename	v96	G32IM00M
rename	v97	G32LV00M
* Performing for/Working with thePublic
rename	v98	    G33FG00M
rename	v99	    G33IM00M
rename	v100	G33LV00M
* Coordinating Work and Activities of Others
rename	v101	G34FG00M
rename	v102	G34IM00M
rename	v103	G34LV00M
* Developing and Building Teams
rename	v104	G35FG00M
rename	v105	G35IM00M
rename	v106	G35LV00M
* Teaching Others
rename	v107	G36FG00M
rename	v108	G36IM00M
rename	v109	G36LV00M
* Guiding Directing and Motivating Subordinates
rename	v110	G37FG00M
rename	v111	G37IM00M
rename	v112	G37LV00M
* Coaching and Developing Others
rename	v113	G38FG00M
rename	v114	G38IM00M
rename	v115	G38LV00M
* Provide Consultation and Advice to Others
rename	v116	G39FG00M
rename	v117	G39IM00M
rename	v118	G39LV00M
* Performing Administrative Activities
rename	v119	G40FG00M
rename	v120	G40IM00M
rename	v121	G40LV00M
* Staffing Organizational Units
rename	v122	G41FG00M
rename	v123	G41IM00M
rename	v124	G41LV00M
* Monitoring and Controlling Resources
rename	v125	G42FG00M
rename	v126	G42IM00M
rename	v127	G42LV00M

*merge 1:1 onet98code using "`onetdir'/onet1998.dta", keep(match) nogen
save $outdir/onet1998.dta, replace

** Work Context Variables

import delimited $onetdir/WorkContext.txt, clear delimiter(comma)

rename	v1	onet98code
*missing 1-12...???
* Objective or Subjective Information
rename	v2	W13OS00M
* Job-required social interaction
rename	v3	W14CN00M
* missing 15...
*Supervise, coach, train others
rename	v4	W16IJ00M
* Persuade Someone to a course of action
rename	v5	W17IJ00M
* Provide a service to others
rename	v6	W18IJ00M
* Take a position opposed to others
rename	v7	W19IJ00M
* missing 20
* deal with external customers
rename	v8	W21IJ00M
* Coordinate or Lead Others
rename	v9	W22IJ00M
* Responsible for Others' Health & Safety
rename	v10	W23HS00M
* Responsibility for outcomes and results
rename	v11	W24RE00M
* Frequency in conflict situations
rename	v12	W25CF00M
* Deal with unpleasant/angry people
rename	v13	W26CF00M
* Deal with physically aggressive people
rename	v14	W27CF00M
*missing 28-35 physical work settings lol
*Sounds, noise levels are distracting
rename	v15	W36FN00M
* Very Hot
rename	v16	W37FN00M
* Extremely Bright of Inadequate Lighting
rename	v17	W38FN00M
* Contaminants (pollutants gases odors etc)
rename	v18	W39FN00M
* Cramped Work Space, Awkward Positions
rename	v19	W40FN00M
* Whole Body Vibration
rename	v20	W41FN00M
* Radiation Frequency
rename	v21	W42DI00M
rename	v22	W42FN00M
rename	v23	W42LI00M
* Diseases/Infections-Frequency
rename	v24	W43DI00M
rename	v25	W43FN00M
rename	v26	W43LI00M
* High Places
rename	v27	W44DI00M
rename	v28	W44FN00M
rename	v29	W44LI00M
* Hazardous Conditions (electricity, explosives, chemicals)
rename	v30	W45DI00M
rename	v31	W45FN00M
rename	v32	W45LI00M
* Hazardous Equipment
rename	v33	W46DI00M
rename	v34	W46FN00M
rename	v35	W46LI00M
* Hazardous Situations (cuts bites stings burns)
rename	v36	W47DI00M
rename	v37	W47FN00M
rename	v38	W47LI00M
*no codes 48-59 in datadict either...
* Sitting Frequency
rename	v39	W60FN00M
* Standing Frequency
rename	v40	W61FN00M
* Climbing Ladders, Scaffolds, Poles, etcc...
rename	v41	W62FN00M
* Walking or Running
rename	v42	W63FN00M
* Kneeling, Crouching, or Crawling
rename	v43	W64FN00M
* Keeping or Regaining Balance
rename	v44	W65FN00M
* Using Hands on Objects, Tools, Controls
rename	v45	W66FN00M
* Bending or Twisting the Body
rename	v46	W67FN00M
* Making Repetitive Motions
rename	v47	W68FN00M
* no code 69 (business clothes attire frequency)
*Special uniform frequency
rename	v48	W70FN00M
*no code 71 (work clothing frequency)
* Common Protective or Safety Attire
rename	v49	W72FN00M
* Specialized Protective or Safety Attire
rename	v50	W73FN00M
* Consequence of Error (how serious)
rename	v51	W74SR00M
* missing 75-78 (criticality of position)
* Frustrating Circumstances (road blocks hindering accomplishment)
rename	v52	W79FC00M
* Degree of automation
rename	v53	W80AO00M
*missing 81 (Task clarity)
* Importance of being exact or accurate
rename	v54	W82IJ00M
* Importance of being sure all is done
rename	v55	W83IJ00M
* Importance of begin aware of new events
rename	v56	W84IJ00M
* Importance of repeating same tasks
rename	v57	W85IJ00M
*missing 86-89 
* Pace determine by speed of equipment
rename	v58	W90IJ00M
*missing 91-97 (schedules, shifts, overtime)
* Indoors frequency
rename	v59	W98FN00M
* Outdoors frequency
rename	v60	W99FN00M

merge 1:1 onet98code using $outdir/onet1998.dta, keep(match) nogen
save $outdir/onet1998.dta, replace

**** missing Occupation-specific tasks measures

** restrict to selected variables! These include whats needed to get teleworkable 
**    (although plenty more onet variables are available in onet)
keep G* W* onet98code

** Change variable numbers to lower case
rename *, lower
sort onet98code

*rescale to 0-5 scale
quietly describe, varlist
local allvars `r(varlist)'
local omit  onet98code
local onetcodes : list allvars - omit
foreach var in `onetcodes' {
	sum `var', meanonly
	replace `var'=`var'-r(min)
	sum `var', meanonly
	replace `var'=`var'/r(max)
	replace `var'=`var'*5
}

** Save data
save $outdir/onet1998.dta, replace


******************************************************
****Collapse ONET 1998 by Census Occupation 1990dd****
******************************************************

* ONET 1998 to Census 1990 Occupation crosswalk
import delimited $onetdir/Crosswalk.txt, clear delimiter(comma)
keep if v1=="CEN"
drop v1
rename v2 onet98code
rename v3 occ90
save $outdir/onet98_occ90_xwalk.dta, replace

* Merge ONET 1998 and occ90 crosswalk
use $outdir/onet1998.dta, clear
merge 1:m onet98code using $outdir/onet98_occ90_xwalk.dta, keep(match) nogen

* Collapse by occ90
collapse (mean) w13os00m-g42lv00m, by(occ90)
*collapse (mean) vagen01m-a52lv00m, by(occ90)
*collapse (mean) require_social_onet1998-interact_onet1998, by(occ90)

* Merge in occ90 to occ1990dd crosswalk
rename occ90 occ
merge 1:1 occ using $xwalkdir/occ1990_occ1990dd_update.dta, keep(match) nogen

* Collapse by occ1990dd
collapse (mean) w13os00m-g42lv00m, by(occ1990dd)
*collapse (mean) vagen01m-a52lv00m, by(occ1990dd)

* Re-scale again to 0-5
foreach var of varlist w13os00m-g42lv00m {
	sum `var', meanonly
	replace `var'=`var'-r(min)
	sum `var', meanonly
	replace `var'=`var'/r(max)
	replace `var'=`var'*5
}

* Save data
save $outdir/onet98_occ1990dd.dta, replace

