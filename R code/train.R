train.sessions.summary <- read.csv("../Training Files/SessionsSummary.csv")
train.sessions.list = lapply(
  paste(
    "../Training Files/",
    train.sessions.summary$FileName,".csv", sep = ""
  ), read.csv
)
# init data frame columns using a placeholder row
train.set <-
  data.frame(
    meany = 0.5, meanz = 0.5,miny=0.1,minz=0.1,maxy=0.1,maxz=0.1,
    Height = 1, Steps = 1,Distance = 0.5
  )
train.set[,paste("x", 1:500, sep="")] <- NA
train.set[,paste("y", 1:500, sep="")] <- NA
train.set[,paste("z", 1:500, sep="")] <- NA
train.set[,paste("changex", 0:2, sep="")] <- NA
train.set[,paste("changey", 0:2, sep="")] <- NA
train.set[,paste("changez", 0:2, sep="")] <- NA
# iterate the sessions
for (i in 1:length(train.sessions.list)) {
  train.set[i,] <- prepare.data(train.sessions.list[[i]], train.sessions.summary[i,], TRUE)
}

req <- function(name) {
  if (require(name, character.only = TRUE) == FALSE) {
    install.packages(name)
    library(name, character.only = TRUE)
  }
}
req("caret")
req("kernlab")

step.count.model <-
  train(
    Steps ~ . - Distance,
    method = "svmRadial", data = train.set, trControl = trainControl("LOOCV")
  )
distance.model <-
  train(
    Distance ~ miny + minz + maxy + maxz + changey2 + changez2,
    method = "svmLinear",  data = train.set, trControl = trainControl("LOOCV")
  )
