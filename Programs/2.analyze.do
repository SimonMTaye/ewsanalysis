/*
* 2.1-analyze.do run some regressions and get basic results
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: run basic regression
* datasets used
    * final_data_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
** setup all file path macros and make sure data is cleaned
do 0.0-setup.do
do 0.1-clean.do

use "$out/final_data_ess_2013_2015_2018", clear

/* 
Various parts of the code will have the line:
	drop if ea_id == "040409088801903" // drop outlier

ea_id's map to a speific enumeration area. I discovered that hh with that ea_id had massive yields (1000x more than mean)
even though there were only ~60 hh in that ea, the huge numbers were driving the regression results, especially since none of 
the hh's with the massive yields grew wheat. dropping the ea changes the result so it is more inline with theory. furthermore
the massive yields seem more like a data error than anything. i include results include the outlier in my paper's appendix but not 
in the main result
*/

*** Assumption Test by running regression for 2013 - 2015
preserve
drop if year == 2018
replace post = 1 if year == 2015
label var post "Year == 2015"
* recalculate variables after changing post
replace int_wheat_post = post * wheat
replace int_wheat_post = wheat * post
replace int_cell_post = own_cell * post
replace int_cell_wheat = own_cell * wheat
replace int_cell_wheat_post = post * wheat * own_cell
eststo clear
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/assumption-test.rtf", se ar2 label title(Effects on Yield per Area) not replace
restore


**** Main Regression 
preserve
drop if year == 2013
eststo clear
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
* with controls
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)

esttab using "$fig/main-results.rtf", se ar2 label title(Effects on Yield per Area) replace
restore

**** Main Regression - Outlier Dropped
preserve
drop if year == 2013
drop if ea_id == "040409088801903" // drop outlier
eststo clear
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post [pw=hh_wt], robust cluster(woreda)
* with controls
eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/main-results-outlier-dropped.rtf", se ar2 label title(Effects on Yield per Area) replace
restore


**** Regression with Cell Share
preserve
drop if year == 2013
eststo clear
eststo: reg yield_per_area_high wheat post cell_share_kebele int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post cell_share int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_high wheat post cell_share int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post cell_share int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/results-cell-share.rtf", se ar2 label title(Effects on Yield per Area) replace
eststo clear
restore

**** Basic Regression with Cell Share - outlier dropped
preserve
drop if year == 2013
drop if ea_id == "040409088801903" // drop outlier
eststo clear
eststo: reg yield_per_area_high wheat post cell_share_kebele int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
eststo: reg yield_per_area_low wheat post cell_share int_wheat_post int_cellshare_post int_cellshare_wheat int_cellshare_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/results-cell-share-outlier-dropped.rtf", se ar2 label title(Effects on Yield per Area) replace
eststo clear
restore	

**** Heterogeneity By Region
preserve
drop if ea_id == "040409088801903" // drop outlier
eststo clear
keep if region < 5
bysort region: eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/results-region-1.rtf", keep(wheat post own_cell int_cell_wheat_post) se ar2 nonumber nodepvars label title(Effects on Yield per Area)  replace

restore

preserve
eststo clear
drop if ea_id == "040409088801903" // drop outlier
keep if region > 5 & region < 15
bysort region: eststo: reg yield_per_area_high wheat post own_cell int_wheat_post int_cell_post int_cell_wheat int_cell_wheat_post highest_education_in_hh total_cons_ann_per_capita [pw=hh_wt], robust cluster(woreda)
esttab using "$fig/results-region-2.rtf", keep(wheat post own_cell int_cell_wheat_post) se ar2 nonumber nodepvars label title(Effects on Yield per Area)  replace

restore

