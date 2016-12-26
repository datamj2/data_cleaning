run_analysis<-function() {

# set the working directory to the folder where the UCI HAR dataset has been unzipped

dir_pre<-"./UCI HAR dataset/"
dir_train<-paste0(dir_pre,"train/")
dir_test<-paste0(dir_pre,"test/")

# ----------------------------------------------------
# -----------load packages --------------------------
# ----------------------------------------------------
library(dplyr)

# ----------------------------------------------------
# -----------load train data --------------------------
# ----------------------------------------------------
xtrain<-read.table(paste0(dir_train,"X_train.txt"),header=FALSE,sep="")
ytrain<-read.table(paste0(dir_train,"y_train.txt"),header=FALSE,sep="")
subject_train<-read.table(paste0(dir_train,"subject_train.txt"),header=FALSE,sep="")

train<-cbind(subject_train,ytrain,xtrain)


# ----------------------------------------------------
# -----------load test data --------------------------
# ----------------------------------------------------
xtest<-read.table(paste0(dir_test,"X_test.txt"),header=FALSE,sep="")
ytest<-read.table(paste0(dir_test,"y_test.txt"),header=FALSE,sep="")
subject_test<-read.table(paste0(dir_test,"subject_test.txt"),header=FALSE,sep="")

test<-cbind(subject_test,ytest,xtest)


# ----------------------------------------------------
# -----------combine train and test data --------------------------
# ----------------------------------------------------
data_all<-rbind(train,test)


# ----------------------------------------------------
# -----------extract mean and std cols from all_data --------------------------
# ----------------------------------------------------

# ----------------------------------------------------
# -----------load features  --------------------------
# ----------------------------------------------------
features<-read.table(paste0(dir_pre,"features.txt"),header=FALSE,sep="")
colnames<-features$V2 #there are duplicate feature names
colnames<-as.character(features$V2)
colnames<-c('subject','activity',colnames)

# find all colnames containing 'mean' or 'std'
indm<-grep("mean", colnames, ignore.case = TRUE) #this retains mean(), meanfreq() etc columns
inds<-grep("std", colnames, ignore.case = TRUE)
indsm<-sort(c(indm,inds)) 
#indsm<-sort(indsm)
indsm<-c(1,2,indsm) #also select subject  and activity columns
data_select<-data_all[,indsm] #select columns containing mean or std values


# ----------------------------------------------------
# ----------- add activity names --------------------------
# ----------------------------------------------------
activity_labels<-read.table(paste0(dir_pre,"activity_labels.txt"),header=FALSE,sep="")
for (i in 1:6) {
        ind<-which(data_select[,2]==activity_labels[i,1])
        data_select[ind,2]<-as.character(activity_labels[i,2])
}


# ----------------------------------------------------
# -----------rename variables (cols) --------------------------
# ----------------------------------------------------
colnames_select<-colnames[indsm]

colnames_select<-gsub('tB','time B',colnames_select)
colnames_select<-gsub('tG','time G',colnames_select)
colnames_select<-gsub('f','fft ',colnames_select)
names(data_select) <- colnames_select #rename columns


# ----------------------------------------------------
# ----------- get column averages --------------------------
# ----------------------------------------------------
data_final<-data_select %>% group_by(subject,activity) %>% summarise_each(funs(mean))
write.table(data_final,"data_final.txt", append = FALSE, quote=FALSE, sep = "\t",col.names = colnames_select,row.name=FALSE) #save to txt file in working directory
}