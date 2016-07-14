#

# Setting workdirectory

path_wd <- "C:/Users/amutter/UCI HAR Dataset"
setwd(path_wd)

# Loading packages
library(dplyr)
library(reshape2)

# Reading data sets

train <- read.table("./train/X_train.txt", header = FALSE)
#dim = 7352 561
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
#dim = 7352 1
label_train <- read.table("./train/Y_train.txt", header = FALSE)
#dim = 7352 1


test <- read.table("./test/X_test.txt", header = FALSE)
#dim = 2947 561
subject_test <- read.table("./test/subject_test.txt", header = FALSE)
#dim = 2947 1
label_test <- read.table("./test/Y_test.txt", header = FALSE)
#dim = 2947 1


# Merging files (data, label, subject) : train + test
data_global <- rbind(train, test)
#dim = 10299 561
subject_global <- rbind(subject_train, subject_test)
#dim = 10299 1
label_global <- rbind(label_train, label_test)
#dim = 10299 1


# Getting measurements names and naming variables in global file
features <- read.table("features.txt", header = FALSE)
list_var <- as.character(features[, 2])

names(data_global) <- list_var


# Selecting mean et std measurements 
list_mean <- grep("\\b[mM]ean()\\b", names(data_global))
list_std <- grep("\\b[sS]td()\\b", names(data_global))


# Global vector of measurements with order
list_var_select <- sort(c(list_mean, list_std))


# Extracting mean and std measurements
data_global2 <- data_global[, list_var_select]


# Factorisation of activities and subjects and merging with data
names(subject_global) <- c("subject")
names(label_global) <- c("activity")

label_global$activity <- factor(label_global$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

subject_global$subject <- as.factor(subject_global$subject)

data_global3 <- cbind(data_global2, subject_global, label_global)


# Tidy data

# Narrow data according to subject x activity
narrow_data <- melt(data_global3, id=c("subject", "activity"))

# Wide data with mean for each subject, activity couple
wide_data <- dcast(narrow_data, subject + activity ~ variable, mean)










