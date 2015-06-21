# reading in all the tables

feature<-read.table('UCI HAR Dataset/features.txt')

x_train<-read.table('UCI HAR Dataset/train/X_train.txt')
y_train<-read.table('UCI HAR Dataset/train/y_train.txt')
subject_train<-read.table('UCI HAR Dataset/train/subject_train.txt')

x_test<-read.table('UCI HAR Dataset/test/X_test.txt')
y_test<-read.table('UCI HAR Dataset/test/y_test.txt')
subject_test<-read.table('UCI HAR Dataset/test/subject_test.txt')



# fixing the training table

colnames(x_train)<-feature$V2
colnames(y_train)<-'activity'
colnames(subject_train)<-'subject'
x_train_full<-cbind(subject_train, y_train, x_train)


# fixing the test table

colnames(x_test)<-feature$V2
colnames(y_test)<-'activity'
colnames(subject_test)<-'subject'
x_test_full<-cbind(subject_test, y_test, x_test)

# combining the test and training dataset

fullset<-rbind(x_test_full, x_train_full)

# extracting only mean and std (but also subject number and activity)

featuresplus<-colnames(fullset)

mean_set<-grep('mean\\(\\)', featuresplus, ignore.case=TRUE)
std_set<-grep('std\\(\\)', featuresplus, ignore.case=TRUE)
activity<-grep('activity', featuresplus, ignore.case=TRUE)
subject<-grep('subject', featuresplus, ignore.case=TRUE)

columns<-c(subject, activity, mean_set, std_set)

finalfull<-fullset[,columns][]

# renaming activities

finalfull[finalfull$activity==1,] [,2] <-'WALKING'
finalfull[finalfull$activity==2,] [,2] <-'WALKING_UPSTAIRS'
finalfull[finalfull$activity==3,] [,2] <-'WALKING_DOWNSTAIRS'
finalfull[finalfull$activity==4,] [,2] <-'SITTING'
finalfull[finalfull$activity==5,] [,2] <-'STANDING'
finalfull[finalfull$activity==6,] [,2] <-'LAYING'
finalfull$activity <- as.factor(finalfull$activity)

# averaging

library(dplyr)

df_mean <- as.data.frame(group_by(finalfull, subject, activity) %>% summarise_each(funs(mean)))


#write tidy data to txt file
write.table(df_mean,file="tidy.txt",row.names=FALSE)

# output tidy data
print(df_mean)
