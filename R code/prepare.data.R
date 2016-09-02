prepare.data <- function(df, summary, includeResults) {
  # init data frame columns using a placeholder row
  result.set <- data.frame(
      meany = 0.5, meanz = 0.5,miny=0.1,minz=0.1,maxy=0.1,maxz=0.1,
      Height = 1, Steps = 1, Distance = 0.5
    )
  result.set[,paste("x", 1:500, sep="")] <- NA
  result.set[,paste("y", 1:500, sep="")] <- NA
  result.set[,paste("z", 1:500, sep="")] <- NA
  result.set[,paste("changex", 0:2, sep="")] <- NA
  result.set[,paste("changey", 0:2, sep="")] <- NA
  result.set[,paste("changez", 0:2, sep="")] <- NA

  result.set[1,]$Height <- summary$Height
  if (includeResults) {
    result.set[1,]$Steps <- summary$StepsCounts
    result.set[1,]$Distance <- summary$DistanceCovered
  }
  df$epoch <- as.POSIXct(df$epoch)
  sessionStart <- as.POSIXct(as.POSIXct(summary$StartTime) - epochOffset)
  sessionEnd <- as.POSIXct(sessionStart + sessionLength)
  # ignore signals not part of the session
  df <- df[(df$epoch >= sessionStart & df$epoch <= sessionEnd),]
  #remove duplicates
  j <- 2
  while (j <= nrow(df)) {
    if (as.numeric(df[j,]$epoch - df[j - 1,]$epoch) * 1000 < 17) {
      df <- df[-j,]
    } else {
      j <- j + 1
    }
  }

  # add 500 signals as features (there are a bit more than 500 at this point because of noise)
  for (i in 1:500) {
    result.set[1,paste("x", i, sep = "")] <- df$load.txt.data.x[i]
    result.set[1,paste("y", i, sep = "")] <- df$load.txt.data.y[i]
    result.set[1,paste("z", i, sep = "")] <- df$load.txt.data.z[i]
  }

  # mean/min/max values
  result.set[1,]$meany <- mean(df$load.txt.data.y)
  result.set[1,]$meanz <- mean(df$load.txt.data.z)
  result.set[1,]$miny <- min(df$load.txt.data.y)
  result.set[1,]$minz <- min(df$load.txt.data.z)
  result.set[1,]$maxy <- max(df$load.txt.data.y)
  result.set[1,]$maxz <- max(df$load.txt.data.z)

  # discretization
  xdiff <- diff(as.numeric(cut(df$load.txt.data.x,5)))
  ydiff <- diff(as.numeric(cut(df$load.txt.data.y,5)))
  zdiff <- diff(as.numeric(cut(df$load.txt.data.z,5)))
  # count changes
  result.set[1,]$changex0 <- length(xdiff[xdiff == 0]) / length(xdiff)
  result.set[1,]$changex1 <- length(xdiff[xdiff == 1]) / length(xdiff)
  result.set[1,]$changex2 <- length(xdiff[xdiff >= 2]) / length(xdiff)
  result.set[1,]$changey0 <- length(ydiff[ydiff == 0]) / length(ydiff)
  result.set[1,]$changey1 <- length(ydiff[ydiff == 1]) / length(ydiff)
  result.set[1,]$changey2 <- length(ydiff[ydiff >= 2]) / length(ydiff)
  result.set[1,]$changez0 <- length(zdiff[zdiff == 0]) / length(zdiff)
  result.set[1,]$changez1 <- length(zdiff[zdiff == 1]) / length(zdiff)
  result.set[1,]$changez2 <- length(zdiff[zdiff >= 2]) / length(zdiff)

  return (result.set[1,])
}
