### Zander Weight Loss ###

# load data and libraries
library(dplyr)
library(ggplot2)
library(lubridate)
library(viridis)
library(ggridges)
raw <- read.csv(file = '~/Documents/Medical/postSurgeryWeight11092019.csv') %>%
    select(-Notes)


# clean data
newNames <- tolower(names(raw))
colnames(raw) <- newNames
weight.original = raw$weight[[1]]

raw$date <- as.Date(as.character(raw$date), "%m/%d/%y")
surgery.date <- as.Date(min(raw$date),'%m/%d/%Y')

# add the week, weeks out form surgery, and pounds lost
df <- raw %>% 
    mutate(week = week(date),
           weeks.after = floor((date-surgery.date)/7),
           pounds.lost = weight.original - weight)

# plot data
ggplot(data = df, aes(x = pounds.lost, y = reorder(as.factor(weeks.after),-week), fill = ..x.. )) +
    geom_vline(xintercept = 0) +
    geom_density_ridges_gradient(scale = 1.5, rel_min_height = .001) +
    scale_fill_viridis(name = 'Pounds Lost', option = "D") +
    labs(title = "Pounds Lost After Jaw Surgery") +
    xlab("Pounds Lost") +
    ylab("Weeks After Surgery")

# duplicate data frame and label week as all so first density plot is of all data
df.a <- df %>% select(-weeks.after) %>% mutate(weeks.after = 'All Weeks')
df.all  <- rbind(df.a,df)
df.all$weeks.after <-factor(df.all$weeks.after, levels = c('6','5','4','3','2','1','0','All Weeks'))

# arrows for annotations
curved.arrows <- tibble(
    x1 = c(-2),
    x2 = c(-.2),
    y1 = c(4.7),
    y2 = c(4.2)
)

straight.arrows <- tibble(
    x1 = c(4),
    x2 = c(5.5),
    y1 = c(0.65),
    y2 = c(0.65)
)

# plot data with aggregate of all weeks
ggplot(data = df.all, aes(x = pounds.lost, 
                          y = weeks.after, 
                          fill = ..x.. )) +
    geom_vline(xintercept = 0) +
    geom_density_ridges_gradient(scale = 1.5, rel_min_height = .001) +
    scale_fill_viridis(name = 'Pounds Lost', option = "D") +
    annotate('text',x = -2, y = 5, size = 2.7, color = "gray20",
             label = "Pre-surgery baseline") +
    annotate('text',x = 2, y = 0.65, size = 2.7, color = 'gray20',
             label = 'Pounds below baseline') +
    geom_curve(data = curved.arrows, aes(x = x1, y = y1, xend = x2, yend = y2),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.4,
               color = "gray20", curvature = 0.2) +
    geom_curve(data = straight.arrows, aes(x = x1, y = y1, xend = x2, yend = y2),
               arrow = arrow(length = unit(0.07, "inch")), size = 0.4,
               color = "gray20", curvature = 0) +
    labs(title = "Pounds Lost After Jaw Surgery") +
    xlab("Pounds Lost") +
    ylab("Weeks After Surgery")


# example plot
ggplot(lincoln_weather, aes(x = `Mean Temperature [F]`, y = `Month`, fill = ..x..)) +
    geom_density_ridges_gradient(scale = 1.25, rel_min_height = 0.01) +
    scale_fill_viridis(name = "Temp. [F]", option = "C") +
    labs(title = 'Temperatures in Lincoln NE in 2016')

