/*
* 1.0.clean.do run all other cleaning do files then aggregate field level data to hh level
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: merge all intermediate datasets into a single one at the crop level
* steps taken in do-file:
		* run sub-do fles crop.do education.do hh_level.do
    * merge all subdatasets created by those do-files
    * drop some unused variables
* datasets used (intermediate datasets created by sub-dofiles): 
    *data_crop_ess_2013_2015_2018
    *data_hh_cons_ess_2013_2015_2018
    *data_education_2013_2015_2018
	*data_education_2013_2015_2018
	*data_hh_age_ess_2013_2015_2018
		
* datasets created: 
    * final_data_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
	
** Define file-paths
do "0.0-setup.do"


* run cleaning do'
local cleaning_dos crop education hh_cons mobile age
foreach file of local cleaning_dos {
	if "$`file'run" == "" {
			do "$prog\1.`file'.do"
			global `file'run 1
			* if any dataset as been altered mark that it has changed
			global merged "no"
	}
}

**** Clean individual datasets and prepare for merging

* Check if data has already been merged
if "$merged" == "yes" {
	exit
}

use "$out/data_crop_ess_2013_2015_2018", clear

* collapse crop data to the hh level, seperating wheat and non-wheat crops
* many interesting crop-related variables are lost so might be worth preserving later
* if they are going to be part of the final anaylsis
collapse (sum) crop_area_high crop_area_low h_quantity_kg, by(hh_wt household_id year wheat field_irrigated field_extension_program field_erosion_protected field_fallowed_in_10_years)

* overestimate the yield
gen yield_per_area_high = h_quantity_kg / crop_area_low
* underestimate the yield
gen yield_per_area_low = h_quantity_kg / crop_area_high

* label new variables
label var yield_per_area_high "Yield per Area - Upper Bound (Kg / Sq Meters)"
label var yield_per_area_low "Yield per Area - Lower Bound (Kg / Sq Meters)"
label var crop_area_high "Crop Area - Upper Bound (Sq Meters)"
label var crop_area_low "Crop Area - Lower Bound (Sq Meters)"
label var h_quantity_kg "Quantity Harvested (Kg)"


*** Merge Notes:
** Education / Consumption Merge
* for about 6.7k households we have education data but no crop data (merge == 2)
* 542 obseravtions have no matching hh_id (542)
** Mobile Merge
* about 8.7k have _merge value 2 (i.e. we have cell data but no crop data)
* 3 households have from 2018 have crop and all other data but no mobile ownership data
** Age merge
* about 8.7k have _merge value 2 (i.e. we have age data but no crop data)

foreach file in "$out/data_education_ess_2013_2015_2018" "$out/data_hh_cons_ess_2013_2015_2018" "$out/data_hh_mobile_ess_2013_2015_2018" "$out/data_hh_age_ess_2013_2015_2018"  {
		* drop results with _merge == 2 indicating we couldn't match them with a household:year pair in dataset
	    merge m:1 household_id year using "`file'"
		drop if _merge == 2
		drop _merge		
}

* post variable for running DiD regression
gen post = year == 2018
gen int_wheat_post = wheat * post
gen int_cell_post = own_cell * post
gen int_cell_wheat = own_cell * wheat
gen int_cell_wheat_post = post * wheat * own_cell


* generate interactions using cell share as cell alternative for robustness
gen int_cellshare_post = cell_share_kebele * post
gen int_cellshare_wheat = cell_share_kebele * wheat
gen int_cellshare_wheat_post = post * wheat * cell_share_kebele

* label for data cleanliness
label var year "Year"
label var wheat "Wheat"
label var post "Year == 2018"
label var int_wheat_post "Year * Wheat"
label var int_cell_post "Year * Cell"
label var int_cell_wheat "Cell * Wheat"
label var int_cell_wheat_post "Cell * Year * Wheat"
label var int_cellshare_post "Year * Cell Density"
label var int_cellshare_wheat "Cell Density * Wheat"
label var int_cellshare_wheat_post "Cell Density * Year * Wheat"

save "$out/final_data_ess_2013_2015_2018", replace

* mark that data has been cleaned succesfully to avoid redundant work
global cleaned "yes"