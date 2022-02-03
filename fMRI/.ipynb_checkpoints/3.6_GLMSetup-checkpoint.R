#CMcNabb 2021
#data setup for GLM for dti analysis
setwd("/Volumes/GoogleDrive/My Drive/Pilot") #CHANGE THIS PATH TO THE MICROBIOLOGY DATA FOLDER FOR THE GBGABA STUDY
library("Jmisc")
library(dplyr)

#read in demographic, Autism quotient and gut diversity data
pilot_raw <- read.csv("pilot_bacteria_mrs_lcms_GenusLevel.csv", header = TRUE, na.strings=c("N.D")) # CHANGE THIS FILE AND THE INFORMATION BELOW TO MEET YOUR REQUIREMENTS
LCMS <- pilot_raw[c("age","GABA","Glutamate", "Glutamine")]


#create dataframes for GLM, including diversity measures/Autism quotient, age and motion, then demean these values for use in FSL's randomise
LCMS <- demean(LCMS)

# write GLMs to csv format without headers
write.table(LCMS, "GLM_faecalLCMS.csv", sep=",", col.names=FALSE, row.names = FALSE)

# write GLMs to csv format with headers
write.table( LCMS, "/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/fMRI/analysis/GLMs/GLM_faecalLCMS.csv", sep=",", col.names=TRUE, row.names = FALSE)
