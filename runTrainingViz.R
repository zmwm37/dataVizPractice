
# read in data

library(dplyr)
library(lubridate)
library(ggplot2)
run <- read.csv('./Documents/R/dataVizPractice/runningData.csv', 
                stringsAsFactors = F,
                check.names = F)




# CLEAN DATA --------------------------------------------------------------

# clean names
old.names <- names(run)
clean.names <- tolower(gsub(' ','.', old.names))
clean.names[20] <- 'training.stress.score'
clean.names

names(run) <- clean.names
run <- run[-19] # remove duplicate avg.cadence
str(run)
run$date.time.clean <- mdy_hm(run$date)
run$date.clean  <- date(run$date.time.clean)
run$week <- week(run$date.time.clean)
run$year <- year(run$date.time.clean)
head(run)


# DATE SUBSET FUNCTION ----------------------------------------------------

subsetDate <- function(df, date.range, race.name){
    
    # filter to date range 
    df2 <- df %>% 
        filter(date.clean >= date.range[1],
                   date.clean <= date.range[2]
               ) %>%
        
        # sort by earliest date to latest date
        arrange(date.clean) %>%
    
        # calculate relative days and add race name
        mutate(day.index = date.clean - min(date.clean),
               race = race.name,
               cum.distance = cumsum(distance)) %>%
        
        # select variables of interest
        select(race, date.clean, day.index, distance, cum.distance)
    
    

        
}

# SUBSET TO RACES ---------------------------------------------------------
date.ranges <- list(c('2016-02-06','2016-04-25'),
                    c('2016-12-11','2017-04-25'),
                    c('2018-01-23','2018-04-14'),
                    c('2019-02-05','2019-04-03'),
                    c('2019-12-23','2020-06-06')
                    )
races <- c('C&O Marathon',
           'Ragnar Ultra',
           'Blue Ridge Half',
           'Cherry Blossom 2019', 
           'Virtual Ragnar 2020')

runMarathon <- subsetDate(df = run, date.range = date.ranges[[1]], race.name = races[1])
runRagnar <- subsetDate(df = run , date.range = date.ranges[[2]],race.name = races[2])
runBR <- subsetDate(df = run, date.range = date.ranges[[3]],race.name = races[3])
runCB19 <- subsetDate(df = run, date.range = date.ranges[[4]],race.name = races[4])
runVR <- subsetDate(df = run, date.range = date.ranges[[5]], race.name = races[5])


# COMBINE DATA ------------------------------------------------------------

runRaces <- rbind(runMarathon,runRagnar,runBR,runCB19,runVR)



# DATA VIZ ----------------------------------------------------------------

ggplot(data = runRaces, aes(x = day.index,y = cum.distance, color = race)) +
    geom_line()
