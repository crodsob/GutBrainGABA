#CMcNabb 2021
#data setup for GLM for dti analysis
setwd("/Volumes/GoogleDrive/My Drive/Pilot")#CHANGE THIS TO THE DIRECTORY CONTAINING MICROBIOLOGY DATA
library("Jmisc")
library(dplyr)

#read in demographic, Autism quotient and gut diversity data
pilot_raw <- read.csv("pilot_bacteria_mrs_lcms_GenusLevel.csv")# CHANGE THIS TO WHATEVER DATA FILE YOU ARE USING
diversity <- pilot_raw[c("age","faith_pd","shannon","observed_otus", "aq")]



#create dataframes for GLM, including diversity measures/Autism quotient, age and motion, then demean these values for use in FSL's randomise
shannon_GLM <- demean(cbind(diversity$shannon, diversity$age))
otus_GLM <- demean(cbind(diversity$observed_otus, diversity$age))
faith_GLM <- demean(cbind(diversity$faith_pd, diversity$age))
aq_GLM <- demean(cbind(diversity$aq, diversity$age))

# write GLMs to csv format without headers
write.table( shannon_GLM, "GBGABA_GLMshannon.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( otus_GLM, "GBGABA_GLMotus.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( faith_GLM, "GBGABA_GLMfaith.csv", sep=",", col.names=FALSE, row.names = FALSE)
write.table( aq_GLM, "GBGABA_GLMaq.csv", sep=",", col.names=FALSE, row.names = FALSE)

