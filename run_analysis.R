## first Question :: Merges the training and the test sets to create one data set.
## We can merge many method. Such as using cbind or merge etc.
library(data.table)
sub_test<-read.table('subject_test.txt')
sub_train<-read.table('subject_train.txt')
total_subject<-rbind(sub_test,sub_train)

x_test<-read.table('X_test.txt')
x_train<-read.table('X_train.txt')
total_X <- rbind(x_test,x_train)

y_test<-read.table('y_test.txt')
y_train<-read.table('y_train.txt')
total_Y <-rbind(y_test,y_train)

features<-read.table('features.txt')
##set colnames because see the value and if i use merge, it is must set.
colnames(sub_train) = "Subject"
colnames(x_train) = features[,2]
colnames(y_train) = "Y_Value"
colnames(sub_test) = "Subject"
colnames(x_test) = features[,2]
colnames(y_test) = "Y_Value"
train_total <- cbind(sub_train,x_train,y_train)
test_total<-cbind(sub_test,x_test,y_test)
total<-rbind(train_total,test_total)

##Second :: Extracts only the measurements on the mean and standard deviation for each measurement. 


features_m_s <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]
colnames(x_train) = features_m_s[,2]
colnames(x_test) = features_m_s[,2]
train_total_m_s <- cbind(sub_train,x_train,y_train)
test_total_m_s<-cbind(sub_test,x_test,y_test)
total_m_s<-rbind(train_total,test_total)
##it means catch the "mean" and "std" in V2 feature function

##Third :: Uses descriptive activity names to name the activities in the data set
active_labels <- read.table("activity_labels.txt")
##and I want to merge active_labels and total_m_s.
t_total = merge(total_m_s,active_labels)
##use merge because i want mix the mean,std and activity_labels

##Fourth :: Appropriately labels the data set with descriptive variable names. 
##it means (i think) change the label in data. So I use gsub for change this.
colm<-colnames(t_total) ##this function to show the colname change.
names(t_total)<-gsub('angle','Angle',names(t_total))

##Fifth :: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
t_total_dat <- data.table(t_total)
##to make datatable documents
tidy<-aggregate(. ~Subject + Y_Value, t_total_dat, mean)
write.table(tidy, file = "tidy.txt",row.name=FALSE)
