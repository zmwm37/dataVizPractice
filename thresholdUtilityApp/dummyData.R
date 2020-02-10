# dummy data for threshold utility app
set.seed(303)
id <- 1:100
temp <- sort(round(runif(100, min = 92, max = 104),1))
stat <- c(sample(0:1,50,replace = T, prob = c(0.75,0.25)),
          sample(0:1,50,replace = T, prob = c(0.25,0.75)))

dummy <- as.data.frame(cbind(id, temp, stat))
