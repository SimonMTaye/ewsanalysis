/*
* 2.0.summary-stats.do run some regressions and get basic results
* ECN 372 | Grinnell College
* Created 11/2023
* Written by Simon Taye

* purpose of this program: create basic summary stats and figures
* datasets used
    * final_data_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
do 0.0-setup.do
do 0.1-clean.do


**** Summary Statistics by Wheat
preserve
keep if wheat == 1
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann oldest_female oldest_male hh_young_adult_male hh_young_adult_female, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-wheat.rtf", cells("mean(label(Mean) fmt(a3)) p50(label(Median))  sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore

preserve
keep if wheat == 0

estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann oldest_female oldest_male hh_young_adult_male hh_young_adult_female, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-nonwheat.rtf", cells("mean(label(Mean) fmt(a3)) p50(label(Median))  sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore


preserve
keep if wheat == 0
drop if ea_id == "040409088801903" // drop outlier
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann oldest_female oldest_male hh_young_adult_male hh_young_adult_female, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-nonwheat-outlier-dropped.rtf", cells("mean(label(Mean) fmt(a3)) p50(label(Median))  sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore


**** Summary Statistics by Cell
preserve
keep if own_cell == 1
estpost summarize yield_per_area_high highest_education_in_hh total_cons_ann total_cons_ann_per_capita, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-cell.rtf", cells("mean(label(Mean) fmt(a3)) p50(label(Median))  sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore

preserve
keep if own_cell == 0
estpost summarize yield_per_area_high highest_education_in_hh total_cons_ann total_cons_ann_per_capita, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-nocell.rtf", cells("mean(label(Mean) fmt(a3)) p50(label(Median))  sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore

**** Summary Statistics by Year
preserve
keep if year == 2013
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann own_cell wheat, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-2013.rtf", cells("mean(label(Mean) fmt(a3))  sd(par fmt(a3) label(SE))") replace noobs label nonumber
restore

preserve
keep if year == 2015
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann own_cell wheat, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-2015.rtf", cells("mean(label(Mean) fmt(a3))  sd(par fmt(a3) label(SE))") replace noobs label nonumber
restore

preserve
keep if year == 2018
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann own_cell wheat, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-2018.rtf", cells("mean(label(Mean) fmt(a3))  sd(par fmt(a3) label(SE))") replace noobs label nonumber
restore

preserve
keep if year == 2018
drop if ea_id == "040409088801903" // drop outlier
estpost summarize crop_area_high yield_per_area_high highest_education_in_hh total_cons_ann own_cell wheat, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-2018-outlier-dropped.rtf", cells("mean(label(Mean) fmt(a3))  sd(par fmt(a3) label(SE))") replace noobs label nonumber
restore

preserve
keep if ea_id == "040409088801903" // drop outlier
estpost summarize crop_area_high crop_area_low yield_per_area_high yield_per_area_low highest_education_in_hh total_cons_ann own_cell wheat, detail

esttab, nonumber cells("mean(label(Mean) fmt(a3)) p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") noobs label

esttab . using "$fig/sum-statistics-outlier.rtf", cells("mean(label(Mean) fmt(a3))  p50(label(Median)) sd(par fmt(a3) label(SE)) count(label(Obs))") replace noobs label nonumber
restore


drop if ea_id == "040409088801903" // drop outlier


label values own_cell own_cell
label def own_cell 0 "No Cell", modify
label def own_cell 1 "HH Owns Cell", modify

label values wheat wheat
label def wheat 0 "Non-Wheat", modify
label def wheat 1 "Wheat", modify


**** Productivity of Wheat Crops by Year
preserve
drop if wheat == 0
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(year) ///
    title("Wheat") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)  ///
	
graph export "$fig\producitivity_wheat.jpg", replace
restore

**** Productivity of Non Wheat Crops by Year
preserve
drop if wheat == 1
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(year) ///
    title("Non-Wheat Crops") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)  ///

graph export "$fig\producitivity_nonwheat.jpg", replace
restore

**** Productivity of Wheat Crops by Year and Cell Ownership
preserve
drop if wheat == 0
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Wheat") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)  ///
	
graph export "$fig\producitivity_wheat_cell.jpg", replace
restore

**** Productivity of Non Wheat Crops by Year and Cell Ownership
preserve
drop if wheat == 1
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Non-Wheat Crops") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)  ///

graph export "$fig\producitivity_nonwheat_cell.jpg", replace
    
restore



**** Productivity of Wheat Crops by Year and Cell Ownership (2013, 2015)
preserve
drop if wheat == 0 | year == 2018
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Wheat") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)   ///
	
graph export "$fig\producitivity_wheat-no18.jpg", replace
restore


**** Productivity of Non Wheat Crops by Year and Cell Ownership (2013, 2015)
preserve
drop if wheat == 1 | year == 2018
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Non-Wheat Crops") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)   ///

graph export "$fig\producitivity_nonwheat-no18.jpg", replace
    
restore

**** Productivity of Wheat Crops by Year and Cell Ownership (2018, 2015)
preserve
drop if wheat == 0 | year == 2013
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Wheat") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)   ///
	
graph export "$fig\producitivity_wheat-no13.jpg", replace


restore
**** Productivity of Non Wheat Crops by Year and Cell Ownership (2018, 2015)
preserve
drop if wheat == 1 | year == 2013
// Set up the data for the graph
collapse (mean) yield_per_area_high, by(year own_cell)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) yield_per_area_high, over(own_cell) over(year) ///
    title("Non-Wheat Crops") ///
    ytitle("Yield (Kg / Sq Meter)") ///
	scheme(s1color) asyvars aspect(1)   ///

graph export "$fig\producitivity_nonwheat-no13.jpg", replace
    
restore

***** Cell Ownership by year and wheat
preserve
// Set up the data for the graph
collapse (mean) own_cell, by(year wheat)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) own_cell, over(wheat) over(year) ///
    ytitle("Cell Phone Ownership") ///
	scheme(s1color) asyvars aspect(1)   ///

graph export "$fig\cell_ownership.jpg", replace
    
restore

**** Wheat Growth Total
preserve
// Set up the data for the graph
collapse (mean) wheat, by(year)
// Create a bar graph with side-by-side bars and different colors
graph bar (asis) wheat, over(year) ///
    ytitle("Proportion of Farmers that Grow Wheat") ///
	scheme(s1color) asyvars aspect(1)   ///

graph export "$fig\wheat_proportion.jpg", replace
    
restore

**** Wheat Growth By Region
preserve
drop if region == .
// Set up the data for the graph
collapse (mean) wheat, by(year region)
reshape wide wheat, i(year) j(region)
// Setup labels using labels from the region code
label var wheat1 "Tigray"
label var wheat2 "Afar"
label var wheat3 "Amhara"
label var wheat4 "Oromia"
label var wheat5 "Somalie"
label var wheat6 "Benshagul Gumuz"
label var wheat7 "SNNP"
label var wheat12 "Gambelia"
label var wheat13 "Harari"
label var wheat15 "Diredwa"

local selected_years "2013 2015 2018"

line wheat1 wheat2 wheat3 wheat4 wheat5 wheat6 wheat7 wheat12 wheat13 wheat15 year if ((year == 2013) | (year == 2015) | (year == 2018)), title("Proportion of Farmers that grow Wheat") scheme(s1color)   
graph export "$fig\wheat_proportion_by_region.jpg", replace
restore
