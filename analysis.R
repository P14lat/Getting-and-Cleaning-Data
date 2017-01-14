          #needed library
          install.packages("reshape2")
          library(reshape2)

          #unzip
          dataset <- "Dataset.zip"
          unzip(dataset)

          #download the dataset:
          fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
          download.file(fileurl, "Z:/Git/pga_3/dataset.csv")

          #load activity labels, features
          labels_activity <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/activity_labels.txt")
          labels_activity[,2] <- as.character(labels_activity[,2])
          features <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/features.txt")
          features[,2] <- as.character(features[,2])
          

#extract mean, standard deviation
features_wanted <- grep(".*mean.*|.*std.*", features[,2])
features_wanted.names <- features[features_wanted,2]
features_wanted.names = gsub('-mean', 'Mean', features_wanted.names)
features_wanted.names = gsub('-std', 'Std', features_wanted.names)
features_wanted.names <- gsub('[-()]', '', features_wanted.names)

#load train dataset
train <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/train/X_train.txt")[features_wanted]
train_activities <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/train/Y_train.txt")
train_subjects <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)

#load test dataset
test <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/test/X_test.txt")[features_wanted]
test_activities <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/test/Y_test.txt")
test_subjects <- read.table("Z:/Git/pga_3/UCI_HAR_Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)


          #merge train and test datasets
          mergeddata <- rbind(train, test)
          
          #add labels
          colnames(mergeddata) <- c("subject", "activity", features_wanted.names)

          #factor activities, subjects
          mergeddata$activity <- factor(mergeddata$activity, levels = labels_activity[,1], labels = labels_activity[,2])
          mergeddata$subject <- as.factor(mergeddata$subject)
          
          #mean on mergeddata
          mergeddata.melted <- melt(mergeddata, id = c("subject", "activity"))
          mergeddata.mean <- dcast(mergeddata.melted, subject + activity ~ variable, mean)
          
          
#export table as "c_dataset.text
write.table(mergeddata.mean, "c_dataset.txt", row.names = FALSE, quote = FALSE)
