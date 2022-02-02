bids_path <- "/Volumes/gold/cinn/2020/gbgaba/pilot_BIDS/"
derivative_path <- "/Volumes/gold/cinn/2020/gbgaba/pilot_BIDS/derivatives/fMRI/preprocessed/" 
sub <- "sub-W0001"
ses <- "ses-01"
filename <- paste(bids_path,sub,"/",ses,"/func/",sub,"_",ses,"_task-rest_physio.txt", sep="")
savename <- paste(derivative_path,sub,"/",ses,"/func/",sub,"_",ses,"_task-rest_physio_clean.txt")
df <- read.table(filename, sep="\t", header=FALSE)
colnames(df) <- c("time(s)", "date", "channel1", "channel2", "channel3", "channel4")

first <- as.numeric(rownames(df[df$channel4 > 10, ])[1])
numTRs <- as.numeric(nrow(df[df$channel4 > 10, ]))
last <- as.numeric(rownames(df[df$channel4 > 10, ])[numTRs])

TR <- as.numeric(rownames(df[df$channel4 > 10, ])[2]) - first
end <- last + 2*TR
start <- first - 2*TR

trunc_df <- df[(start:end),]
physio_df <- trunc_df[,c("channel1", "channel4")]


write.table(physio_df, savename, append = FALSE, sep = " ", dec = ".",
            row.names = F, col.names = FALSE)
