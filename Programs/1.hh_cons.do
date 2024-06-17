/*
* 1.3-hh_cons.do aggregate HH education 
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: create hh location and consumption data
* steps taken in do-file:
		* change types and names of variabels to match in both 2015 and 2018 ess
    * merge with consumption data
    * append data from 2015 and 2018
* datasets used: 
	*2013-cons_agg_w2
    *2013-sect_cover_hh_w2
    *2015-cons_agg_w3
    *2015-sect_cover_hh_w3
    *2018-cons_agg_w4
    *2018-sect_cover_hh_w4
		
* datasets created: 
    * data_hh_cons_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
do 0.0-setup.do

***** START Clean 2015
*Open the dataset
use "$in/2013-sect_cover_hh_w2", clear
merge 1:1 household_id2 using "$in/2013-cons_agg_w2"
drop _merge
gen year = 2013
* drop dups of hhid and ea_id
drop saq07 saq08
* drop hh_size alternative since it already exists in consumption data
drop hh_saq09
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw2 hh_wt


* change variables types to match 2018 data for easy appending
rename saq02 saq02byte
tostring saq02byte, gen(saq02) format(%2.0f)
drop saq02byte

rename saq03 saq03byte
tostring saq03byte, gen(saq03) format(%2.0f)
drop saq03byte

rename saq06 saq06byte
tostring saq06byte, gen(saq06) format(%2.0f)
drop saq06byte

rename hh_saq11 saq11
rename hh_saq12 saq12

* we don't need variables related to interventions 
* they making appending complicated so drop them
rename hh_size size
local prefix "hh_"
foreach oldvar in `prefix'* {
  drop `oldvar'
}
rename size hh_size

save "$out/2013-hh_cons_ess", replace
***** END Clean 2013 dataset

***** START Clean 2015
*Open the dataset
use "$in/2015-sect_cover_hh_w3", clear
merge 1:1 household_id2 using "$in/2015-cons_agg_w3"
drop _merge
gen year = 2015
* drop dups of hhid and ea_id
drop saq07 saq08
* drop hh_size alternative since it already exists in consumption data
drop hh_saq09
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw_w3 hh_wt


* change variables types to match 2018 data for easy appending
rename saq02 saq02byte
tostring saq02byte, gen(saq02) format(%2.0f)
drop saq02byte

rename saq03 saq03byte
tostring saq03byte, gen(saq03) format(%2.0f)
drop saq03byte

rename saq06 saq06byte
tostring saq06byte, gen(saq06) format(%2.0f)
drop saq06byte

rename hh_saq11 saq11
rename hh_saq12 saq12

* we don't need variables related to interventions 
* they making appending complicated so drop them
rename hh_size size
local prefix "hh_"
foreach oldvar in `prefix'* {
  drop `oldvar'
}
rename size hh_size

save "$out/2015-hh_cons_ess", replace
***** END Clean 2015 dataset

use "$in/2018-sect_cover_hh_w4", clear
merge 1:1 household_id using "$in/2018-cons_agg_w4"
drop _merge
gen year = 2018
* rename household weight variable to standardize across years
rename pw_w4 hh_wt
* drop variables related to questionairre metadata
drop saq07 saq08 saq13 saq17 saq18 InterviewStart saq21
* drop hh_size variable already present in consumption data
drop saq09 

save "$out/2018-hh_cons_ess", replace

use "$out/2013-hh_cons_ess", clear
append using "$out/2015-hh_cons_ess"
append using "$out/2018-hh_cons_ess"

* variables are confidential so drop them
drop saq11 saq12

rename saq01 region
rename saq02 zone
rename saq03 woreda
rename saq04 city_code
rename saq05 sub_city_code
rename saq06 kebele

gen total_cons_ann_per_capita = total_cons_ann / hh_size
label var total_cons_ann_per_capita "Total annual per capita consumption"

destring region kebele woreda, replace


save "$out/data_hh_cons_ess_2013_2015_2018", replace
