library(datasets)
library(dplyr)

chicks <- ChickWeight

  weight Time Chick Diet
1     42    0     1    1
2     51    2     1    1
3     59    4     1    1
4     64    6     1    1
5     76    8     1    1
6     93   10     1    1

wideCW <- dcast(chicks, Diet + Chick ~ Time, value.var = "weight")

names(wideCW)[-(1:2)] <- paste("time", names(wideCW)[-(1:2)], sep = "")

wideCW <- mutate(wideCW, gain = time21 - time0)

wideCW14 <- subset(wideCW, Diet %in% c(1,4))

t.test(gain ~ Diet, paired = FALSE, var.equal = TRUE, data = wideCW14)