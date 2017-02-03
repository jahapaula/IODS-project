library(dplyr)
library(ggplot2)
library(GGally)

# reads the full data set fro the given url to R project
students2014 <- read.csv("data/lrn14_final.csv", row.names = 1, header=TRUE)

# The dataset includes 166 rows of data with 7 variables. Doing diagnostics with str and dim functions.
str(students2014)
dim(students2014)

#let's draw a graphical overview of the relations between variables with ggplot2
pic <- ggpairs(students2014, mapping = aes(col = gender, alpha = 0.3), lower = list(combo = wrap("facethist", bins = 20)))
pic
# other more basic options for this would be 
#pairs(students2014[-1], col = learning2014$gender)
#pairs(students2014[-1])

# summary provides the descriptive statistics of the dataset (see table 1)
summary(students2014)
# n = 166, 110 female, 56 male, Age M = 25.51)

# create a regression model with three explanatory variables to explain the variation of the variable Points.
model1 <- lm(Points ~ Attitude + stra + surf, data = students2014)
summary(model1)

# create a better model
model2 <- lm(Points ~ Attitude + stra, data = students2014)
summary(model2)

# try once more with attitude + surf
model3 <- lm(Points ~ Attitude + surf, data = students2014)
summary(model3)

# print diagnostic plots: Residuals vs Fitted values, Normal QQ-plot and Residuals vs Leverage.
plot(model2, which = c(1, 2, 5))
# btw this seems like a legit prettier option https://rpubs.com/therimalaya/43190