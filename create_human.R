library(dplyr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)

str(gii)
dim(gii)

# Rename the variables 
hd_uudet <- c("HDI_Rank", "Country", "HDI_Cap", "Life_Exp", "Edu_exp", "Mean_edu",
              "GNI_Cap", "GNI_HDI_Rank")
gii_uudet <- c("GII_Rank", "Country", "GII", "MatMor", "Ado.Birth", "Parlament_rep_F", "Second_Edu_F",
               "Second_Edu_M", "Labour_Part_F", "Labour_Part_M")

colnames(hd) <- hd_uudet
colnames(gii) <- gii_uudet

# new variables for gender inequality
# the ratio of Female and Male populations with secondary education
gii <- mutate(gii, FM_Ratio_Edu = Second_Edu_F / Second_Edu_M )
# the ratio of labour force participation of females and males in each country
gii <- mutate(gii, FM_Ratio_Lab = Labour_Part_F / Labour_Part_M)

# common columns to use as identifiers
# join_by <- c("Country")

# join the two datasets by the country
HD_GII <- inner_join(hd, gii, by = "Country") #, suffix = c(".hd", ".gii"))

# just to check
colnames(HD_GII)
dim(HD_GII)

# from here onwards chap5 related stuff:

# Mutate the data: transform the Gross National Income (GNI) variable to numeric 
library(stringr)
HD_GII$GNI_Cap <- str_replace(HD_GII$GNI_Cap, pattern=",", replace ="") %>% as.numeric()

# Exclude unneeded variables: keep only selected columns
keep <- c("Country", "FM_Ratio_Edu", "FM_Ratio_Lab", "Life_Exp", "Edu_exp", "GNI_Cap", "MatMor", "Ado.Birth", "Parlament_rep_F")
HD_GII <- select(HD_GII, one_of(keep))

# Remove all rows with missing values:
# print out the data along with a completeness indicator as the last column
data.frame(HD_GII[-1], comp = complete.cases(HD_GII))

# filter out all rows with NA values
HD_GII_ <- filter(HD_GII, complete.cases(HD_GII))

# Remove the observations which relate to regions instead of countries

#tail(HD_GII_, n=10) # look at the last 10 observations of human
last <- nrow(HD_GII_) - 7 # define the last indice we want to keep
HD_GII_ <- HD_GII_[1:last,] # choose everything until the last 7 observations

# Define the row names of the data by the country names and remove the country column

# add countries as rownames
rownames(HD_GII_) <- HD_GII_$Country
# remove the Country variable
HD_GII_ <- select(HD_GII_, -Country)

dim(HD_GII_) # for diagnostics

write.csv(HD_GII_, file = "data/human.csv", row.names = TRUE) #vissiin oletuksena jo true

