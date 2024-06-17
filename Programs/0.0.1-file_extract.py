import zipfile
import os

def extract_and_rename(zip_file_path, target_filename, new_filename):
    """Extracts a file from a zip archive, renames it, and checks for duplicates."""
    # Check if the renamed file already exists
    if os.path.exists(new_filename):
        print(f"File '{new_filename}' already exists. Skipping extraction.")
        return
    # Open the zip archive
    with zipfile.ZipFile(zip_file_path, 'r') as zip_ref:
        for file_info in zip_ref.infolist():  # Iterate through all files
            if file_info.filename.endswith(target_filename):  # Check filename match
                # Extract the file to a temporary location (to preserve directory structure)
                temp_filename = file_info.filename  # Use the full path from the archive
                zip_ref.extract(temp_filename)

                # Move and rename the file to the desired location
                os.replace(temp_filename, new_filename)
                print(f"File '{temp_filename}' extracted and renamed to '{new_filename}'")
                return  # Stop after the first match
        else:
            print(f"File '{target_filename}' not found in the archive.")

# List of data sets to be extracted from 2013 ESS
datasets_2013 = ["cons_agg_w2.dta", 
                 "sect_cover_hh_w2.dta", 
                 "sect1_hh_w2.dta", 
                 "sect2_hh_w2.dta", 
                 "sect3_pp_w2.dta",
                 "sect9_ph_w2.dta", 
                 "sect10_hh_w2.dta"]

# List of data sets to be extracted from 2015 ESS (same as 2013 with different suffix)
datasets_2015 = [name.replace("w2.dta", "w3.dta") for name in datasets_2013]

# List of data sets to be extracted from 2018 ESS (same as 2013 with different suffix and sect11b instead of 10)
datasets_2018 = [name.replace("w2.dta", "w4.dta") for name in datasets_2013]
# Sect 10 is not used in 2018 do to changes in survey design, instead use sect11b1
datasets_2018.remove("sect10_hh_w4.dta")
datasets_2018.append("sect11b1_hh_w4.dta")

# Names of the zip files
zipname_2013 = "ETH_2013_ESS_v03_M_STATA.zip" 
zipname_2015 = "ETH_2015_ESS_v03_M_STATA.zip" 
zipname_2018 = "ETH_2018_ESS_v03_M_Stata.zip" 


if __name__ == "__main__":
    print("Beginning Extraction")
    # Extract all data and append year to file
    [extract_and_rename(f"../In/{zipname_2013}", dataset, f"../In/2013-{dataset}") for dataset in datasets_2013]
    [extract_and_rename(f"../In/{zipname_2015}", dataset, f"../In/2015-{dataset}") for dataset in datasets_2015]
    [extract_and_rename(f"../In/{zipname_2018}", dataset, f"../In/2018-{dataset}") for dataset in datasets_2018]