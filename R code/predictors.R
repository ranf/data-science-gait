get.step.count <- function(df, summary) {
  data <- prepare.data(df, summary, FALSE)
  data$Steps <- 1 # placeholder values
  data$Distance <- 1
  return (predict(step.count.model, data))
}
get.distance <- function(df, summary) {
  data <- prepare.data(df, summary, FALSE)
  data$Steps <- 1
  data$Distance <- 1
  return (predict(distance.model, data))
}
