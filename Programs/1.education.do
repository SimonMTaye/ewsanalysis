/*
* 1.2-education.do aggregate HH education 
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: aggregate education data to the hh level
* steps taken in do-file:
		* save maximum education level attained in a household
    * save literacy status in a household
* datasets used: 
	*2012-sect2_hh_w2
    *2015-sect2_hh_w3
    *2018-sect8_hh_w4
		
* datasets created: 
    * data_education_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
do 0.0-setup.do

***** START Clean 2013
*Open the dataset
use "$in/2013-sect2_hh_w2", clear
gen year = 2013
* drop old household_id and use new one
drop household_id
rename household_id2 household_id
* recode so variables work like dummies (in dataset "2" codes a "No" which we don't want)
replace hh_s2q02 = 0 if hh_s2q02 == 2
replace hh_s2q03 = 0 if hh_s2q03 == 2
* replace missing variables so no education is coded as 0
replace hh_s2q05 = 0 if hh_s2q03 == 0

** recode special values
** 21 = NC 9th grade
** 22 = NC 10th grade
** 23 = NC 11th grade
** 24 = NC 12th grade
** 25 = 10th grade + Techincal/Voational Training (1yr)
** 26 = 10th grade + Techincal/Voational Training (1yr) + Inc 2nd Year
** 27 = 10th grade + Techincal/Voational Training (2yr)
** 34+, 13-20 - Various Degrees, Certificates and Teacher Trainings
** 90+ = Illeterate, Basic Education
replace hh_s2q05 = 0 if hh_s2q05 >= 90
replace hh_s2q05 = 8 if hh_s2q05 == 21
replace hh_s2q05 = 8 if hh_s2q05 == 21
replace hh_s2q05 = 9 if hh_s2q05 == 22
replace hh_s2q05 = 10 if hh_s2q05 == 23
replace hh_s2q05 = 11 if hh_s2q05 == 24
replace hh_s2q05 = 10 if hh_s2q05 == 25
replace hh_s2q05 = 10 if hh_s2q05 == 26
replace hh_s2q05 = 10 if hh_s2q05 == 27
replace hh_s2q05 = 12 if hh_s2q05 >= 12

* aggregate education to hh level, keeping highest level attained
egen highest_education_in_hh = max(hh_s2q05), by(household_id)
egen read_write_in_hh = max(hh_s2q02), by(household_id)
* only keep education level variables
keep household_id highest_education_in_hh read_write_in_hh year
* keep 1 obs per household
duplicates drop household_id, force

save "$out/2013-ess-education_hh", replace
***** END Clean 2013 dataset


***** START Clean 2015
*Open the dataset
use "$in/2015-sect2_hh_w3", clear
gen year = 2015
* drop old household_id and use new one
drop household_id
rename household_id2 household_id
* recode so variables work like dummies (in dataset "2" codes a "No" which we don't want)
replace hh_s2q02 = 0 if hh_s2q02 == 2
replace hh_s2q03 = 0 if hh_s2q03 == 2
* replace missing variables so no education is coded as 0
replace hh_s2q05 = 0 if hh_s2q03 == 0

** recode special values
** NC = Not Complete
** 21 = NC 9th grade
** 22 = NC 10th grade
** 23 = NC 11th grade
** 24 = NC 12th grade
** 25 = 10th grade + Techincal/Voational Training (1yr)
** 26 = 10th grade + Techincal/Voational Training (1yr) + Inc 2nd Year
** 27 = 10th grade + Techincal/Voational Training (2yr)
** 34+, 13-20 - Various Degrees, Certificates and Teacher Trainings
** 90+ = Illeterate, Basic Education
replace hh_s2q05 = 0 if hh_s2q05 >= 90
replace hh_s2q05 = 8 if hh_s2q05 == 21
replace hh_s2q05 = 8 if hh_s2q05 == 21
replace hh_s2q05 = 9 if hh_s2q05 == 22
replace hh_s2q05 = 10 if hh_s2q05 == 23
replace hh_s2q05 = 11 if hh_s2q05 == 24
replace hh_s2q05 = 10 if hh_s2q05 == 25
replace hh_s2q05 = 10 if hh_s2q05 == 26
replace hh_s2q05 = 10 if hh_s2q05 == 27
replace hh_s2q05 = 12 if hh_s2q05 >= 12

* aggregate education to hh level, keeping highest level attained
egen highest_education_in_hh = max(hh_s2q05), by(household_id)
egen read_write_in_hh = max(hh_s2q02), by(household_id)
* only keep education level variables
keep household_id highest_education_in_hh read_write_in_hh year
* keep 1 obs per household
duplicates drop household_id, force

save "$out/2015-ess-education_hh", replace
***** END Clean 2015 dataset

*** 
*Open the dataset
use "$in/2018-sect2_hh_w4", clear
gen year = 2018
* recode so variables work like dummies (in dataset "2" codes a "No" which we don't want)
replace s2q03 = 0 if s2q03 == 2
replace s2q04 = 0 if s2q04 == 2
* replace missing variables so no education is coded as 0
replace s2q06 = 0 if s2q04 == 0

replace s2q06 = 0 if s2q06 >= 90
replace s2q06 = 8 if s2q06 == 21
replace s2q06 = 8 if s2q06 == 21
replace s2q06 = 9 if s2q06 == 22
replace s2q06 = 10 if s2q06 == 23
replace s2q06 = 11 if s2q06 == 24
replace s2q06 = 10 if s2q06 == 25
replace s2q06 = 10 if s2q06 == 26
replace s2q06 = 10 if s2q06 == 27
replace s2q06 = 12 if s2q06 >= 12
* aggregate education to hh level, keeping highest level attained
egen highest_education_in_hh = max(s2q06), by(household_id)
egen read_write_in_hh = max(s2q03), by(household_id)
* only keep education level variables
keep household_id highest_education_in_hh read_write_in_hh year
* keep 1 obs per household
duplicates drop household_id, force

save "$out/2018-ess-education_hh", replace

* append data
use "$out/2013-ess-education_hh", clear
append using "$out/2015-ess-education_hh"
append using "$out/2018-ess-education_hh"

label var highest_education_in_hh "Highest grade completed in HH"
label var read_write_in_hh        "HH has member who can read/write"

save "$out/data_education_ess_2013_2015_2018", replace

