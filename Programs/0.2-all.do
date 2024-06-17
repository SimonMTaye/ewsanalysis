/*
* 0.2-all.do runs data cleaning and do files to generate regression results 
* ECN 372 | Grinnell College
* Created 12/2023
* Written by Simon Taye

* purpose of this program: run all do files and generate all needed files
* datasets used
    * final_data_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/
do 0.0-setup.do

do "$prog/0.1-clean.do"
do "$prog/2.analyze.do"
do "$prog/2.summary.do"
