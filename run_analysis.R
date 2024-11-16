file_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(file_url, destfile = "dataset.zip")
unzip("dataset.zip")

features = read.table("UCI HAR Dataset/features.txt", col.names = c("index", "feature"))
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))

x_train = read.table("UCI HAR Dataset/train/X_train.txt")
y_train = read.table("UCI HAR Dataset/train/y_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")

x_test = read.table("UCI HAR Dataset/test/X_test.txt")
y_test = read.table("UCI HAR Dataset/test/y_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")

features = read.table('UCI HAR Dataset/features.txt')
activityLabels = read.table('UCI HAR Dataset/activity_labels.txt')

colnames(x_train) = features[,2]
colnames(y_train) ="activityId"
colnames(subject_train) = "subjectId"

colnames(x_test) = features[,2]
colnames(y_test) = "activityId"
colnames(subject_test) = "subjectId"
colnames(activityLabels) = c('activityId','activityType')

mrg_train = cbind(y_train, subject_train, x_train)
mrg_test = cbind(y_test, subject_test, x_test)
OneDataSet = rbind(mrg_train, mrg_test)

MrgColNames = colnames(OneDataSet)

mean_and_std = (grepl("activityId" , MrgColNames) | 
                   grepl("subjectId" , MrgColNames) | 
                   grepl("mean.." , MrgColNames) | 
                   grepl("std.." , MrgColNames) 
)

ExtractMeanAndStd = OneDataSet[ , mean_and_std == TRUE]

DescriptiveActivityNames = merge(ExtractMeanAndStd, activityLabels,
                                  by='activityId',
                                  all.x=TRUE)

Tidy_Data = aggregate(. ~subjectId + activityId, DescriptiveActivityNames, mean)
Tidy_Data = Tidy_Data[order(Tidy_Data$subjectId, Tidy_Data$activityId),]

write.table(Tidy_Data, "Tidy_Data.txt", row.name=FALSE)