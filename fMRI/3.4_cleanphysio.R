#Carolyn McNabb 2022
#Script to clean physiological data from LabChart7 in preparation for use in 
#FSL's PNM

bids_path <- "/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/"
derivative_path <- "/Volumes/gold/cinn/2020/gbgaba/GBGABA_BIDS/derivatives/fMRI/preprocessed/" 
sub <- "sub-W1001"
ses <- "ses-01"
filename <- paste(bids_path,sub,"/",ses,"/func/",sub,"_",ses,"_task-rest_physio.txt", sep="")
savename <- paste(derivative_path,sub,"/",ses,"/func/",sub,"_",ses,"_task-rest_physio_clean.txt", sep="")
df <- read.table(filename, sep="\t", header=FALSE)
colnames(df) <- c("channel1", "channel2", "channel3", "channel4",  "channel5")

#for participant number 1, the first TR was not correct and so the script has 
#been modified. It should work with any participant though, as the start is still TR2 - 2*TRs
# first <- as.numeric(rownames(df[df$channel5 > 1, ])[1])
numTRs <- as.numeric(nrow(df[df$channel5 > 1, ]))
last <- as.numeric(rownames(df[df$channel5 > 1, ])[numTRs])

TR <- as.numeric(rownames(df[df$channel5 > 1, ])[3]) - as.numeric(rownames(df[df$channel5 > 1, ])[2]) 
end <- last + 2*TR
start <- as.numeric(rownames(df[df$channel5 > 1, ])[2]) - 2*TR

trunc_df <- df[(start:end),]
physio_df <- trunc_df[,c("channel1", "channel4", "channel5")]


write.table(physio_df, savename, append = FALSE, sep = " ", dec = ".",
            row.names = F, col.names = FALSE)
