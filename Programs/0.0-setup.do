/*
****** THIS FILE SHOULD RUN BEFORE ALL DO-FILES
* 0.1-define_path.do defines the path used by all subsequent do-files
* ECN 372 | Grinnell College
* Created 06/2024
* Written by Simon Taye

* purpose of this program: reduce repeated boilerplate code in do-files 
		
* datasets created: 
    * final_data_ess_2013_2015_2018

*********************************************************************
*********************************************************************
*/

clear
set more off
set graphics off

*** Set the global file path to be root folder
local cwd = c(pwd)
global path = "`cwd'\.."
global in "$path/In"
global out "$path/Out"
global prog "$path/Programs"
global fig "$path/Figures"
