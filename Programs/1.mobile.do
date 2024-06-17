/*
* 1.4-mobile.do cleans asset ownership data to get phone ownership
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: create hh location and consumption data
* steps taken in do-file:
	* generate dummy of cell ownership based on asset ownershp question
	* append data from 2013-2018
    
* datasets used: 
	*2013-sect10_hh_w2
	*2015-sect10_hh_w3
	*2018-sect11b1_hh_w4
    	
* datasets created: 
    * data_hh_mobile_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/

do 0.0-setup.do

***** START Clean 2013
*Open the dataset
use "$in/2013-sect10_hh_w2", clear
gen year = 2013
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw2 hh_wt

rename saq01 region
rename saq03 woreda
rename saq06 kebele


* hh_s10q00 indicates item being asked about. 8 is the code for mobile phones which is what this paper is concerned about
keep if hh_s10q00 == 8
gen own_cell = hh_s10q01 >= 1
label var own_cell "HH has individual with a cellphone"

destring kebele woreda, replace

keep household_id hh_wt ea_id own_cell year region woreda kebele
save "$out/2013-hh_cell", replace
***** END Clean 2013

***** START Clean 2015
*Open the dataset
use "$in/2015-sect10_hh_w3", clear
gen year = 2015
* drop old household ids and enumearation area id and use new ones
drop household_id ea_id
rename household_id2 household_id
rename ea_id2 ea_id
* rename household weight variable to standardize across years
rename pw_w3 hh_wt

rename saq01 region
rename saq03 woreda
rename saq06 kebele

destring kebele woreda, replace

* hh_s10q00 indicates item being asked about. 8 is the code for mobile phones which is what this paper is concerned about
keep if hh_s10q00 == 8
gen own_cell = hh_s10q01 >= 1
label var own_cell "HH has individual with a cellphone"

keep household_id hh_wt ea_id own_cell year region woreda kebele
save "$out/2015-hh_cell", replace
***** END Clean 2015


***** START Clean 2018
*Open the dataset
use "$in/2018-sect11b1_hh_w4", clear
gen year = 2018
* rename household weight variable to standardize across years
rename pw_w4 hh_wt

gen own_cell = s11b_ind_01 == 1

rename saq01 region
rename saq03 woreda
rename saq06 kebele

destring region kebele woreda, replace

collapse (sum) own_cell, by(household_id ea_id hh_wt year region woreda kebele)
label var own_cell "HH owns Cell"

replace own_cell = 1 if own_cell >= 1



keep household_id hh_wt ea_id own_cell year region woreda kebele
save "$out/2018-hh_cell", replace
***** END Clean 2018


use "$out/2013-hh_cell", clear
append using "$out/2015-hh_cell"
append using "$out/2018-hh_cell"

egen cell_share_kebele = mean(own_cell), by(kebele woreda year region)
label var cell_share_kebele "Proportion of HH that have cell in the same Kebele"

save "$out/data_hh_mobile_ess_2013_2015_2018", replace
