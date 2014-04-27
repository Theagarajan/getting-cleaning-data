features <- read.table('features.txt', col.names=c('id', 'name'))
interesting_features <- grep('mean\\(\\)|std\\(\\)', features$name)

act_labels <- read.table('activity_labels.txt', col.names=c('id', 'activity'))

read_data <- function(dir) {
  
  data <- read.table(sprintf('%s/X_%s.txt', dir, dir), col.names=features$name)
  data <- data[,interesting_features]
  
#  data$activity <- merge(act_labels, read.table(sprintf('%s/y_%s.txt', dir, dir), col.names='id'))$activity
  data$activity <- read.table(sprintf('%s/y_%s.txt', dir, dir))[,1]
  data$subject <- read.table(sprintf('%s/subject_%s.txt', dir, dir))[,1]
  data
}

library(plyr)

test_data <- read_data('test')
train_data <- read_data('train')

full_data <- rbind.fill(test_data, train_data)

agg_data <- aggregate(full_data, by=full_data[c("activity", "subject")], FUN=mean)