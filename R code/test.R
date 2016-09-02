# read test files
test.sessions.summary <- read.csv("../Testing Files/SessionsSummary.csv")
test.sessions.list = lapply(
  paste(
    "../Testing Files/",
    test.sessions.summary$FileName,".csv", sep = ""
  ), read.csv
)
# prepare data frames for the results
step.count.results <- data.frame(prediction = numeric(), actual = integer())
distance.results <- data.frame(prediction = numeric(), actual = numeric())

# get results for all test set
for (i in 1:length(test.sessions.list)) {
  summary <- test.sessions.summary[i,]
  step.count.results[i,]$actual <- summary$StepsCount
  distance.results[i,]$actual <- summary$DistanceCovered
  summary$StepsCount <- NULL # no cheating
  summary$DistanceCovered <- NULL
  step.count.results[i,]$prediction <- get.step.count(test.sessions.list[[i]], summary)
  distance.results[i,]$prediction <- get.distance(test.sessions.list[[i]], summary)
}
#print results and calculate the mse
print(step.count.results)
print(distance.results)
step.count.mse <- mean((step.count.results[,1]-step.count.results[,2])^2)
distance.mse <- mean((distance.results[,1]-distance.results[,2])^2)
mse <- (distance.mse+step.count.mse) / 2
print(mse)
