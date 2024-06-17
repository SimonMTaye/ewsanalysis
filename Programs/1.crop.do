/*
* 1.1-crop.do Clean crop data
* ECN 372 | Grinnell College
* Created 10/2023
* Written by Simon Taye

* purpose of this program: append crop data from 2013 to 2018 ESS.
* steps taken in do-file:
		* rename variables to common names for easy parsing as well as to align
		  when matching
		* change type of some variables to match in both datasets when appending
		* drop some unsed variables (either duplicates or data about decision making in hh)
* datasets used: 
		*2013-sect9_ph_w2
		*2013-sect3_pp_w2
		*2015-sect9_ph_w3
		*2015-sect3_pp_w3
		*2018-sect9_ph_w4
		*2018-sect3_pp_w4
		
* datasets created (intermediary): 
		* 2013-ess-harvest
		* 2015-ess-harvest
		* 2018-ess-harvest

* datasets created: 
		* data_crop_ess_2013-2018

*********************************************************************
*********************************************************************
*/
do 0.0-setup.do

*** Clean 2015 dataset
*Open the dataset
use "$in/2013-sect9_ph_w2", clear
* merge in to get data about field size
merge m:1 household_id2 holder_id parcel_id field_id using "$in/2013-sect3_pp_w2"
* 1 obs has _merge == 1 (i.e. we have some crop data but no field data)
* however, this obs is missing all info except for holder_id and crop_type so not much can be done
* about 10,100 obs have field data but no crop data so drop them since they are not very relevant for research question of interest
* Obs with field data but no crop data mostly consist of fields not being cultivated 
* about 250 obs were cultivated with the remaining 10k being used for other purposes (fallowing, pasture...)
drop if _merge != 3
drop _merge

* Generate Year Variable
gen year = 2013

* there are two HH ids in 2015 data. id2 uniquely identifies all HHs unlike id1
* manual mentions that split households would be tracked separetly which may explain discrepancy
* duplicate households are small (about 3 hhid1 were duplicates)
drop household_id
rename household_id2 household_id

rename saq01 region
rename saq03 woreda
rename saq06 kebele
destring region woreda kebele, replace

* drop duplicated identification variables
drop saq*
drop ph_saq07

rename pw2                      hh_wt
rename ph_s9q01                 crop_stand_type
rename ph_s9q02                 quantity_crop_field
rename ph_s9q03                 harvested
rename ph_s9q04_a               h_quantity_amount
rename ph_s9q04_b               h_quantity_unit
rename ph_s9q04_b_other         h_quantity_unit_other
rename ph_s9q05                 h_quantity_kg
rename ph_s9q06                 h_condition
rename ph_s9q06_other           h_condition_other
rename ph_s9q07_a               h_month_start
rename ph_s9q07_b               h_month_end
rename ph_s9q08                 h_area_less_planted
rename ph_s9q09                 h_area_percentage
rename ph_s9q10_a               h_area_less_reason
rename ph_s9q11                 crop_damage
rename ph_s9q12                 crop_damage_cause
rename ph_s9q13                 crop_damage_percentage

* rename variables from field data
rename pp_s3q02_a               field_area_self_quantity
rename pp_s3q02_c               field_area_self_unit
rename pp_s3q03                 field_status
rename pp_s3q03b                field_cropping_method

rename pp_s3q03c                field_fallowed_in_10_years
replace field_fallowed_in_10_years = 0 if field_fallowed_in_10_years == 2

rename pp_s3q04                 field_measured_gps
replace field_measured_gps = 0 if field_measured_gps == 2

rename pp_s3q05_a               field_area_gps_sq_meters

rename pp_s3q08_a               field_measured_rope_compass
replace field_measured_rope_compass = 0 if field_measured_rope_compass == 2

rename pp_s3q08_b               field_area_rope_sq_meters

* create field area variables to map with 2015 data
gen field_area_measured_sq_meters = field_area_gps_sq_meters 
replace field_area_measured_sq_meters = field_area_rope_sq_meters if (field_measured_gps == 0) & (field_measured_rope_compass == 1)
replace field_area_measured_sq_meters = . if (field_measured_gps == 0) & (field_measured_rope_compass == 0)


rename pp_s3q11                 field_extension_program
replace field_extension_program = 0 if field_extension_program == 2

rename pp_s3q12                 field_irrigated
replace field_irrigated = 0 if  field_irrigated == 2

rename pp_s3q32                 field_erosion_protected
replace field_erosion_protected = 0 if field_erosion_protected == 2


** Variables with typemismatch
tostring  ph_s9q10_b, gen(h_area_less_reason_ot) format(%43.0f)
drop ph_s9q10_b

save "$out/2013-ess-harvest", replace

******* END Clean 2013 dataset

*** Clean 2015 dataset
*Open the dataset
use "$in/2015-sect9_ph_w3", clear
* merge in to get data about field size
merge m:1 household_id2 holder_id parcel_id field_id using "$in/2015-sect3_pp_w3"
* 1 obs has _merge == 1 (i.e. we have some crop data but no field data)
* however, this obs is missing all info except for holder_id and crop_type so not much can be done
* about 10,100 obs have field data but no crop data so drop them since they are not very relevant for research question of interest
* Obs with field data but no crop data mostly consist of fields not being cultivated 
* about 250 obs were cultivated with the remaining 10k being used for other purposes (fallowing, pasture...)
drop if _merge != 3
drop _merge

* Generate Year Variable
gen year = 2015

* there are two HH ids in 2015 data. id2 uniquely identifies all HHs unlike id1
* manual mentions that split households would be tracked separetly which may explain discrepancy
* duplicate households are small (about 3 hhid1 were duplicates)
drop household_id
rename household_id2 household_id

rename saq01 region
rename saq03 woreda
rename saq06 kebele
destring region woreda kebele, replace

* drop duplicated identification variables
drop saq*
drop ph_saq07

rename pw_w3                    hh_wt
rename ph_s9q01                 crop_stand_type
rename ph_s9q02                 quantity_crop_field
rename ph_s9q03                 harvested
rename ph_s9q04_a               h_quantity_amount
rename ph_s9q04_b               h_quantity_unit
rename ph_s9qo4_b_other         h_quantity_unit_other
rename ph_s9q05                 h_quantity_kg
rename ph_s9q06                 h_condition
rename ph_s9qo6_other           h_condition_other
rename ph_s9q07_a               h_month_start
rename ph_s9q07_b               h_month_end
rename ph_s9q08                 h_area_less_planted
rename ph_s9q09                 h_area_percentage
rename ph_s9q10_a               h_area_less_reason
rename ph_s9q11                 crop_damage
rename ph_s9q12                 crop_damage_cause
rename ph_s9q13                 crop_damage_percentage

* rename variables from field data
rename pp_s3q02_a               field_area_self_quantity
rename pp_s3q02_c               field_area_self_unit
rename pp_s3q03                 field_status
rename pp_s3q03b                field_cropping_method

rename pp_s3q03c                field_fallowed_in_10_years
replace field_fallowed_in_10_years = 0 if field_fallowed_in_10_years == 2

rename pp_s3q04                 field_measured_gps
replace field_measured_gps = 0 if field_measured_gps == 2

rename pp_s3q05_a               field_area_gps_sq_meters

rename pp_s3q08_a               field_measured_rope_compass
replace field_measured_rope_compass = 0 if field_measured_rope_compass == 2

rename pp_s3q08_b               field_area_rope_sq_meters

* create field area variables to map with 2015 data
gen field_area_measured_sq_meters = field_area_gps_sq_meters 
replace field_area_measured_sq_meters = field_area_rope_sq_meters if (field_measured_gps == 0) & (field_measured_rope_compass == 1)
replace field_area_measured_sq_meters = . if (field_measured_gps == 0) & (field_measured_rope_compass == 0)


rename pp_s3q11                 field_extension_program
replace field_extension_program = 0 if field_extension_program == 2

rename pp_s3q12                 field_irrigated
replace field_irrigated = 0 if  field_irrigated == 2

rename pp_s3q32                 field_erosion_protected
replace field_erosion_protected = 0 if field_erosion_protected == 2


** Variables with typemismatch
tostring  ph_s9q10_b, gen(h_area_less_reason_ot) format(%43.0f)
drop ph_s9q10_b

save "$out/2015-ess-harvest", replace

*** Clean 2018 dataset
*Open the dataset
use "$in/2018-sect9_ph_w4", clear
merge m:1 household_id holder_id parcel_id field_id using "$in/2018-sect3_pp_w4"
* 1 obs has _merge == 7 (i.e. we have some crop data but no field data)
* obs do have data on crop as well as other fields from the harvest dataset but not sure how I can recover field information
* about 6,500 obs have field data but no crop data 
* Obs with field data but no crop data mostly consist of fields not being cultivated 
* 576 obs were cultivated with the remaining 6k being used for other purposes (fallowing, pasture...)
drop if _merge != 3
drop _merge

rename saq01 region
rename saq03 woreda
rename saq06 kebele
destring region woreda kebele, replace

* Generate Year Variable
gen year = 2018

drop saq*

rename pw_w4                 hh_wt
rename s9q00b                crop_code
rename s9q02                 crop_stand_type
rename s9q03                 quantity_crop_field
rename s9q04                 harvested
rename s9q05a                h_quantity_amount
rename s9q05b                h_quantity_unit
rename s9q05b_os             h_quantity_unit_other
rename s9q06                 h_quantity_kg
rename s9q07                 h_condition
rename s9q07_os              h_condition_other
rename s9q08a                h_month_start
rename s9q08b                h_month_end
rename s9q10                 h_area_less_planted
rename s9q11                 h_area_percentage
rename s9q12                 h_area_less_reason_1
rename s9q12_os              h_area_less_reason_ot
rename s9q13                 crop_damage
rename s9q14                 crop_damage_cause
rename s9q14_os              crop_damage_cause_ot
rename s9q15                 crop_damage_percentage
*
* rename variables from field data
rename s3q02a                   field_area_self_quantity
rename s3q02b                   field_area_self_unit
rename s3q2b_os                 field_area_self_unit_other
rename s3q03                    field_status
rename s3q04                    field_cropping_method

* question in 2018 survey is fallowed in past 5 years whereas in 2015 is in past 10
* survey has question on last fallowing so could use that to recode if necessary but will skip for now
rename s3q05                    field_fallowed_in_5_years
replace field_fallowed_in_5_years = 0 if field_fallowed_in_5_years == 2

/*
 * TODO
 * recoeded in a single variable, generate manually
rename s3q08                    field_measured_gps
replace field_measured_gps = 0 if field_measured_gps == 2

rename pp_s3q08_a               field_measured_rope_compass
replace field_measured_rope_compass = 0 if field_measured_rope_compass == 2

rename s3q05_a               field_area_gps_sq_meters
rename s3q08_b               field_area_rope_sq_meters
*/

** area variables are a bit different in 2018 survey. match them to the same kinds as 2015
rename s3q08                 field_area_measured_sq_meters
** area variables are a bit different in 2018 survey. match them to the same kinds as 2015
gen field_area_gps_sq_meters = field_area_measured_sq_meters if s3q07 == 1
gen field_area_rope_sq_meters = field_area_measured_sq_meters if s3q07 == 2

rename s3q16                 field_extension_program
replace field_extension_program = 0 if field_extension_program == 2

rename s3q17                 field_irrigated
replace field_irrigated = 0 if field_irrigated == 2

rename s3q38                    field_erosion_protected
replace field_erosion_protected = 0 if field_erosion_protected == 2



save "$out/2018-ess-harvest", replace

use "$out/2013-ess-harvest", clear
append using "$out/2015-ess-harvest"
append using "$out/2018-ess-harvest"

drop s9* ph*
* Analysis will exclusively use crop_code
drop crop_name
* there is a single observation with a mising HH ID so drop it
drop if household_id == ""
* recode harvested so 0 == no instead of 2
replace harvested = 0 if harvested == 2
* harvested_quantity is missing if not harvested, replace with 0 instead
replace h_quantity_kg = 0 if (harvested == 0) & (h_quantity_kg == .)

* some fields were used for multiple crops
* if crop_stand_type == 1, then it was a pure crop stand meaning only one type of crop in a field
* thus the whole field area was used for a single crop
* else:
** quantity_crop_field == 1 means 1/4- was used for a crop
** quantity_crop_field == 2 means 1/4 was used for a crop
** quantity_crop_field == 3 means 1/2 was used for a crop
** quantity_crop_field == 4 means 3/4 was used for a crop
** quantity_crop_field == 5 means 3/4+ was used for a crop
** to account for more/less than 3/4 and 1/4, create low and high bounds for the area multiplier
gen crop_field_area_multiplier_low = 1 if crop_stand_type == 1
gen crop_field_area_multiplier_high = 1 if crop_stand_type == 1

replace crop_field_area_multiplier_low = 0 if (crop_stand_type == 2) & (quantity_crop_field == 1)
replace crop_field_area_multiplier_low = 0.25 if (crop_stand_type == 2) & (quantity_crop_field == 2)
replace crop_field_area_multiplier_low = 0.5 if (crop_stand_type == 2) & (quantity_crop_field == 3)
replace crop_field_area_multiplier_low = 0.75 if (crop_stand_type == 2) & (quantity_crop_field == 4)
replace crop_field_area_multiplier_low = 0.75 if (crop_stand_type == 2) & (quantity_crop_field == 5)

replace crop_field_area_multiplier_high = 0.25 if (crop_stand_type == 2) & (quantity_crop_field == 1)
replace crop_field_area_multiplier_high = 0.25 if (crop_stand_type == 2) & (quantity_crop_field == 2)
replace crop_field_area_multiplier_high = 0.5 if (crop_stand_type == 2) & (quantity_crop_field == 3)
replace crop_field_area_multiplier_high = 0.75 if (crop_stand_type == 2) & (quantity_crop_field == 4)
replace crop_field_area_multiplier_high = 1 if (crop_stand_type == 2) & (quantity_crop_field == 5)

gen crop_area_high = field_area_measured_sq_meters * crop_field_area_multiplier_high
gen crop_area_low = field_area_measured_sq_meters * crop_field_area_multiplier_low

* create a dummy indicating whether the observation is for wheat or not
gen wheat = crop_code == 8
* one obs has incorrectly entered negative weight. other variables confirm weight is 350g, not -350kg
replace h_quantity_kg = 0.35 if household_id == "041606088800702008" & field_id == 6 & crop_code == 26


save "$out/data_crop_ess_2013_2015_2018", replace
