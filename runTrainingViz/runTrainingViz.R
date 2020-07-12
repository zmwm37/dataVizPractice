
# read in data

# LOAD LIBRARIES & DATA ---------------------------------------------------


library(dplyr)
library(lubridate)
library(ggplot2)
library(ggdark) # dark themes for ggplot
library(gganimate) # animate ggplots
library(forcats) # reodering factors in tidyverse
library(showtext) # enable google font usage
library(viridis)
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
run$avg.pace.clean <- ms(run$avg.pace)
run$avg.seconds <- as.numeric(seconds(run$avg.pace.clean))
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
               cum.distance = cumsum(distance)) 

        
}

# SUBSET TO RACES ---------------------------------------------------------
date.ranges <- list(c('2016-02-06','2016-04-25'),
                    c('2016-12-11','2017-04-25'),
                    c('2018-01-23','2018-04-14'),
                    c('2019-02-05','2019-04-03'),
                    c('2019-12-23','2020-06-06')
                    )
races <- c('C&O Marathon (26m)',
           'Ragnar Ultra (31m)',
           'Blue Ridge Half (13m)',
           'Cherry Blossom (10m)', 
           'Virtual Ragnar 2020 (24m/3 days)')

runMarathon <- subsetDate(df = run, date.range = date.ranges[[1]], race.name = races[1])
runRagnar <- subsetDate(df = run , date.range = date.ranges[[2]],race.name = races[2])
runBR <- subsetDate(df = run, date.range = date.ranges[[3]],race.name = races[3])
runCB19 <- subsetDate(df = run, date.range = date.ranges[[4]],race.name = races[4])
runVR <- subsetDate(df = run, date.range = date.ranges[[5]], race.name = races[5])


# COMBINE DATA ------------------------------------------------------------

runRaces <- rbind(runMarathon,runRagnar,runBR,runCB19,runVR) 

# reorder races
runRaces <- runRaces %>% 
    mutate(race = fct_relevel(race, 
                               races[1] , races[2], 
                               races[3], races[5],races[4]
                               )
           )

colnames(runRaces)[which(colnames(runRaces)=='race')]<- 'Race (Distance)'


# DATA VIZ ----------------------------------------------------------------

# create plot
a <- ggplot(data = runRaces, aes(x = day.index,y = cum.distance, color = `Race (Distance)`)) +
    geom_line(size = 2) +
    geom_point(data = . %>% 
                   group_by(`Race (Distance)`) %>% 
                   filter(day.index == max(day.index)), 
               shape = 21, 
               size = 4,
               aes(x = day.index, 
                   y = cum.distance,
                   fill = `Race (Distance)`
                   )
               ) +
    labs(x = 'Days Since Training Start',
         y = 'Cumulative Distance Run') +
    scale_color_viridis(option = 'viridis', begin = 0.35, end = 0.97,discrete = T) +
    scale_fill_viridis(option = 'viridis', begin = 0.35, end = 0.97,discrete = T)+
    dark_theme_light(base_size = 28) +
    theme(legend.title = element_text(size = 20),
          legend.text = element_text(size = 20),
          legend.position = c(.18,.85))+
    ggtitle("How Prepared Am I for the Virtual Ragnar?") +
    transition_reveal(day.index)



# animate
aGif<-animate(a, renderer = gifski_renderer(),width = 1280, height = 720)
aGif
# save as gif
anim_save('./Documents/R/dataVizPractice/runTrainingViz.gif', aGif)
