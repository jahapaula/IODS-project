library(dplyr)

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)

str(gii)
dim(gii)

# Rename the variables 
hd_uudet <- c("HDI_Rank", "Country", "HDI_Cap", "Life_Exp", "Exp_edu_years", "Mean_edu_years",
            "GNI_Cap", "GNI_HDI_Rank")
gii_uudet <- c("GII_Rank", "Country", "GII", "MatMor_Ratio", "Birth_Rate", "Parlament_rep", "Second_Edu_F",
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
