/*
* 1.5-age.do cleans age data to determine oldest male and female in an hh as well as dummies to see if there is a male/female in the age range (18-39)
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: create hh location and consumption data
* steps taken in do-file:
	* generate dummy of cell ownership based on asset ownershp question
	* append data from 2013-2018
    
* datasets used: 
	*2013-sect1_hh_w2
	*2015-sect1_hh_w3
	*2018-sect1_hh_w4
    	
* datasets created: 
    * data_hh_age_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/

do 0.0-setup.do

***** START Clean 2013
*Open the dataset
use "$in/2013-sect1_hh_w2", clear
gen year = 2013
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw2 hh_wt

* young_adult's (18-39) may be more likely to own/make use of cellphones so create
* dummy to test that
gen young_adult = hh_s1q04_a > 17 & hh_s1q04_a < 41
* gender dummy to have age variables grouped by gender
gen female = hh_s1q03 == 2
* some gender data is incorretly entered in one of the other variables so correct here
replace female = 1 if (hh_s1q04d == 2) & (hh_s1q04e == 1)

bysort household_id : egen oldest_female = max(hh_s1q04_a * female) 
bysort household_id : egen oldest_male = max(hh_s1q04_a * (female  == 0))

bysort household_id : egen hh_young_adult_female = max(young_adult * female) 
bysort household_id : egen hh_young_adult_male = max(young_adult * (female  == 0))

collapse (max) oldest_female oldest_male hh_young_adult_female hh_young_adult_male, by(household_id year)


save "$out/2013-hh_age", replace
***** END Clean 2013

***** START Clean 2015
*Open the dataset
use "$in/2015-sect1_hh_w3", clear
gen year = 2015
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw_w3 hh_wt

* young_adult's (18-39) may be more likely to own/make use of cellphones so create
* dummy to test that
gen young_adult = hh_s1q04a > 17 & hh_s1q04a < 41
* gender dummy to have age variables grouped by gender
gen female = hh_s1q03 == 2
* some gender data is incorretly entered in one of the other variables so correct here
replace female = 1 if (hh_s1q04d == 2) & (hh_s1q04e == 1)

bysort household_id : egen oldest_female = max(hh_s1q04a * female) 
bysort household_id : egen oldest_male = max(hh_s1q04a * (female  == 0))

bysort household_id : egen hh_young_adult_female = max(young_adult * female) 
bysort household_id : egen hh_young_adult_male = max(young_adult * (female  == 0))

collapse (max) oldest_female oldest_male hh_young_adult_female hh_young_adult_male, by(household_id year)

save "$out/2015-hh_age", replace
***** END Clean 2015


***** START Clean 2018
*Open the dataset
use "$in/2018-sect1_hh_w4", clear
gen year = 2018
* rename household weight variable to standardize across years
rename pw_w4 hh_wt

* young_adult's (18-39) may be more likely to own/make use of cellphones so create
* dummy to test that
gen young_adult = s1q03a > 17 & s1q03a < 41
* gender dummy to have age variables grouped by gender
gen female = s1q02 == 2

bysort household_id : egen oldest_female = max(s1q03a * female) 
bysort household_id : egen oldest_male = max(s1q03a * (female  == 0))

bysort household_id : egen hh_young_adult_female = max(young_adult * female) 
bysort household_id : egen hh_young_adult_male = max(young_adult * (female  == 0))

collapse (max) oldest_female oldest_male hh_young_adult_female hh_young_adult_male, by(household_id year)


save "$out/2018-hh_age", replace
***** END Clean 2018



use "$out/2013-hh_age", clear
append using "$out/2015-hh_age"
append using "$out/2018-hh_age"

label var oldest_female "Oldest Female Member in HH"
label var oldest_male "Oldest Male Member in HH"
label var hh_young_adult_female "Female Member of age 18-39 in HH"
label var hh_young_adult_male "Male Member of age 18-39 in HH"

save "$out/data_hh_age_ess_2013_2015_2018", replace
