#  K-means Clustering using RevoScaleR

# To perform k-means clustering with RevoScaleR, use the rxKmeans function.

# Clustering the Airline Data???

# We want to cluster the arrival delay and scheduled departure time in the airline data 7% subsample.

# Dataset is available in your Drive
# Download it and store it into your working file


# Load the package for big data "RevoScaleR"

library("RevoScaleR")



# Extract variables of interest into a new working data set  

## Define your big Data directory

bigDataDir <- "C:/Users/s.nyawa/Desktop/Big Data in Finance 2023/Courses 2023"

sampleAirData <- file.path(bigDataDir, "AirOnTime7Pct.xdf")


######################
## Important Remark ##
######################

# xdf is the native file format for persisted data in Machine Learning Server.
# when data sets are large or complex, xdf offers stability in the form of 
# persisted data under your control, plus the ability to subset and transform data for repeated analysis.
# An XDF file is much smaller than a CSV file because it is compressed.
# XDF file can be read and processed much faster than a CSV file.
# 

# To create an XDF file, use the rxImport function in RevoScaleR 
# to pipe external data to Machine Learning Server. 
# By default, rxImport loads data into an in-memory data frame, 
# but by specifying the outFile parameter, rxImport creates an XDF file.



########################################
### Example of loading a csv dataset ###
########################################

# Set the source file location using inData argument
mysourcedata <- file.path(bigDataDir, "mortDefault2000.csv")


# Set the xdf file location using the outFile argument
myNewXdf <- file.path(bigDataDir, "mortDefault2000.xdf")


# Create an XDF
rxImport(inData = mysourcedata, outFile = myNewXdf)


#####################################################
######## Coming back to our example #################
#####################################################


## Transform your data from an input data set to an output data set

rxDataStep(inData = sampleAirData, outFile = file.path(bigDataDir,"AirlineDataClusterVars.xdf"),
           varsToKeep=c("DayOfWeek", "ArrDelay", "CRSDepTime", "DepDelay"))

### Variables definition
# DayOfWeek: day of the week (stored as factor)
# ArrDelay:difference in minutes between scheduled and actual arrival time (stored as integer). Early arrivals show negative numbers.
# CRSDepTime: scheduled local departure time (stored as decimal float, for example, 12:45 is stored as 12.75).
# DepDelay: difference in minutes between scheduled and actual departure time (stored as integer). Early departures show negative numbers.


# Specify the variables to cluster as a formula, and specify the number of clusters we'd like. 
# Initial centers for these clusters are then chosen at random

kclusts1 <- rxKmeans(formula= ~ArrDelay + CRSDepTime, 
                     data = file.path(bigDataDir,"AirlineDataClusterVars.xdf"),
                     seed = 10,
                     outFile = file.path(bigDataDir,"AirlineDataClusterVars.xdf"), numClusters=5)
kclusts1


# cluster membership component: look at the var 5 

rxGetInfo(file.path(bigDataDir,"AirlineDataClusterVars.xdf"), getVarInfo=TRUE)


# Using the Cluster Membership Information to see whether a given model varies appreciably from cluster to cluster

clust1Lm <- rxLinMod(ArrDelay ~ DayOfWeek, file.path(bigDataDir,"AirlineDataClusterVars.xdf"),
                     rowSelection = .rxCluster == 1 )

clust5Lm <- rxLinMod(ArrDelay ~ DayOfWeek, file.path(bigDataDir,"AirlineDataClusterVars.xdf"), 
                     rowSelection = .rxCluster == 5)

summary(clust1Lm)


summary(clust5Lm)
