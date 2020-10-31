#run_analysis.R
 # library(reshape2)
#    Download the dataset from web and unzip
	Fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(Fileurl,destfile="ANL.zip")
	unzip("ANL.ZIP",exdir=getwd())



 #   Merge the training and the test sets to create one data set.
	x_test<-read.table("UCI HAR Dataset/test/x_test.txt",sep="")
	y_test<-read.table("UCI HAR Dataset/test/y_test.txt",sep="")
	s_test<-read.table("UCI HAR Dataset/test/subject_test.txt",sep="")

	x_train<-read.table("UCI HAR Dataset/train/x_train.txt",sep="")
	y_train<-read.table("UCI HAR Dataset/train/y_train.txt",sep="")
	s_train<-read.table("UCI HAR Dataset/train/subject_train.txt",sep="")

	x_data<-rbind(x_train,x_test)
	y_data<-rbind(y_train,y_test)
	s_data<-rbind(s_train,s_test)

#  Load the data(x's) feature, activity info and extract columns named 'mean'(-mean) and 'standard'(-std). Also, modify column names to descriptive. (-mean to Mean, -std to Std, and remove symbols like -, (, ))
   	#features
	F<-read.table("UCI HAR Dataset/features.txt",sep="")
	names(F)<-c("id","Feature")
	Features<-grep("mean|std|Mean|Std",F$Feature)
	#clean variables
	FeatureNames <- F[Features, 2]
	FeatureNames <- gsub("-mean", "Mean", FeatureNames )
	FeatureNames <- gsub("-std", "Std", FeatureNames )
	FeatureNames <- gsub("[-()]", "", FeatureNames )	

	#activities
	ACT<-read.table("UCI HAR Dataset/activity_labels.txt",sep="")
	names(ACT)<-c("id","ACTIVITY")
	ACT[,2] <- as.character(ACT[,2])
# arrange all data in one table then mel;t it and arrange it again for subject and activity
 	x_data<-x_data[Features]

	allData<-cbind(s_data,y_data,x_data)

	colnames(allData)<-c("Subject","Activity",FeatureNames )

	allData$Subject <- as.factor(allData$Subject)
	allData$Activity <- factor(allData$Activity, levels = ACT[,1], labels = ACT[,2])

   #Generate 'Tidy Dataset' that consists of the average (mean) of each variable for each subject and each activity. The result is shown in the file tidy_dataset.txt.
	meltedData <- melt(allData, id = c("Subject", "Activity"))	
	tidyData <- cast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
