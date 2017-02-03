library(dplyr)
library(ggplot2)
library(GGally)

# reads the full data set fro the given url to R project
students2014 <- read.csv("data/lrn14_final.csv", row.names = 1, header=TRUE)

# The dataset includes 166 rows of data with 7 variables. 
str(students2014)
dim(students2014)

#let's draw a graphical overview of the relations between variables with ggplot2
pic <- ggpairs(students2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
pic
# other more basic options for this would be 
#pairs(students2014[-1], col = learning2014$gender)
#pairs(students2014[-1])

# summary provides the descriptive statistics of the dataset
summary(students2014)
# n = 166, 110 female, 56 male, Age M = 25.51)

#examine the structure to check if everything is ok
str(lrn14_final)

# save the output to csv file 
write.csv(lrn14_final, file = "data/lrn14_final.csv")

# open the file
nwedata <- read.csv("data/lrn14_final.csv", row.names = 1)

# for diagnostics
str(nwedata)
head(nwedata, 10)
