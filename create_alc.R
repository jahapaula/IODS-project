# Salla-Maaria Laaksonen 10.2.2017
# A script for pre-processing dataset "STUDENT ALCOHOL CONSUMPTION Data Set" from https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

library(dplyr)

# Read both student-mat.csv and student-por.csv to project
alc_math <- read.table("data/student-mat.csv", sep=";", header=TRUE)
alc_por <- read.table("data/student-por.csv", sep=";", header=TRUE)

# explore the structure and dimensions of the data.
str(alc_math)
str(alc_por)
dim(alc_math)
dim(alc_por)

# Join the two data sets using the variables as identifiers
# inner_join only keeps the rows that are in both datasets
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
alc_data <- inner_join(alc_math, alc_por, by = join_by, suffix = c(".math", ".por"))

# Explore the structure and dimensions of the joined data.
str(alc_data)
dim(alc_data)

# combine the 'duplicated' answers in the joined data
alc <- select(alc_data, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(alc_math)[!colnames(alc_math) %in% join_by]

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(alc_data, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# Take the average of the answers related to weekday and weekend alcohol consumption
# to create a new column 'alc_use' to the joined data. 
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# use 'alc_use' to create a new logical column 'high_use' which is TRUE for
# students for which 'alc_use' is greater than 2 (and FALSE otherwise).
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse at the joined and modified data to make sure everything is in order.
glimpse(alc)

# Save the joined and modified data set to the ‘data’ folder,
write.csv(alc, file = "data/alc_final.csv")




