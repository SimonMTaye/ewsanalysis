# Cellphone Impact in Crop Loss Prevention due to Wheat Rust

*Abstract From Paper*:

> Wheat is one of the primary crops grown in Ethiopia. Amongst the main challenges for smallholder wheat farmers is wheat rust – a devastating disease that has been responsible for massive losses. To combat the disease the Early Warning System alerts farmers in high-risk areas and provides information on how to combat the disease through a hotline and SMS texts. I examine whether the EWS had an impact on wheat productivity using a triple difference-in-difference approach that examines if cellphone-owning wheat farmers had increased yields after the implementation of the program. My findings indicate that the program had no impact on productivity suggesting that cellphone-based programs alone cannot overcome the various structural issues faced by smallholder farmers. 

## Acknowledgements

Thank you to Professor Tamara McGavock for the significant amount of guidance and support you provided. My paper has significantly from the continued discussions and feedback from peers: Elias Eichner, Elina Keswani, Jada Fife, Jandry Garcia, Kaleb Shah and Trung Le. All remaining mistakes and omissions are my own.

## Replication

***Requirements***:
- Python (tested on 3.9 but all 3.0+ should work)
    - Python is used for extracting the requried datasets from zipped data archives provided by the World Bank
- Stata (tested on Stata 16)

All the code for reproducing all results and figures in the paper are available in this repository. To use them, simply download the required datasets (described below) and put them in the "In" folder. Then, run `0.2-all.do` to run the cleaning and analysis code

Certain figures were sourced from other sources and those can be find in the cited papers / resources

## Getting the Data

This project uses the Ethiopia Rural Socioeconomic Survey, later renamed to the Ethiopian Socioeconomic Survey (ESS) conducted by the Central Statistics Agency in Ethiopia in collaboration with the World Bank. For this the project, the waves 2-4 which were conducted in 2012/2014, 2015/16 and 2018/19 are used. Links to all three datasets are provided below. Accessing them might require a World Bank research account (easy to create!).

Head over to the websites linked below and download the *Stata* zipped archive for the ESS surveys

[ESS 2013](https://microdata.worldbank.org/index.php/catalog/2247)
[ESS 2015](https://microdata.worldbank.org/index.php/catalog/2783)
[ESS 2018](https://microdata.worldbank.org/index.php/catalog/3823)

*Citation for the Data*
- Primary Investigator: Simon Taye
- Title: Call Me Maybe: Impact assessment of the cell phone based Early Warning System for Wheat Rust in Ethiopia
- Survey Reference Number:
 - ETH_2013_ESS_v03_M 
 - ETH_2015_ESS_v03_M
 - ETH_2018_ESS_v03_M
- Source: from the World Banks microdata website (link above) on September 2023
