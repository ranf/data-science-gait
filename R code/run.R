epochOffset = 3 * 60 * 60 # +3 hours
sessionLength = 10 # 10 seconds

# working directory must be "R code" folder
source("prepare.data.R")
source("train.R")
source("predictors.R")
source("test.R")
