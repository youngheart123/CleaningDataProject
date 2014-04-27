dirname <- "./UCI HAR Dataset/"
subdir  <- c("test","train")
features <- read.table(paste0(dirname,"features.txt"),colClass=c("integer","character"))
ColNum <- sort(c(grep("mean[(][)]",features[,2]),grep("std[(][)]", features[,2])))
VarName <- features[ColNum,2]

combinedata <- function(dirname,subdirname,ColNum,VarName) {
  file_subj     <- paste0(dirname,subdirname,"/subject_",subdirname,".txt")
  file_actv     <- paste0(dirname,subdirname,"/Y_",subdirname,".txt")
  file_features <- paste0(dirname,subdirname,"/X_",subdirname,".txt")
  ID_subj <- read.table(file_subj,colClass=c("integer"),col.names=c("ID_subject"))
  ID_actv <- read.table(file_actv,colClass=c("integer"),col.names=c("ID_activity"))
  
  d0 <- read.table(file_features)
  d1 <- d0[,ColNum]
  colnames(d1) <- VarName

  dfinal <- cbind(ID_subj,ID_actv, d1)

}

tidy_data1 <- rbind(combinedata(dirname, subdir[1],ColNum,VarName),
                    combinedata(dirname, subdir[2],ColNum,VarName))
write.csv(tidy_data1,file="tidy_data1.csv")

ncol_tidy_data1 <-ncol(tidy_data1)

s1 <- tapply(tidy_data1[,3],as.factor(tidy_data1[,1]):as.factor(tidy_data1[,2]),mean)
for (i in 4:ncol_tidy_data1) {
  s2 <- tapply(tidy_data1[,i],as.factor(tidy_data1[,1]):as.factor(tidy_data1[,2]),mean)
  s1 <- cbind(s1,s2)
}
colnames(s1) <- VarName
