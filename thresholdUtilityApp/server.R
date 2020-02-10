library(shiny)
library(shiny)
library(dplyr)
library(ggplot2)
library(ROCR)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  
  utility <- reactive ({
  # loop across thresholds and create utility curve
  out.list <- list()
  for(i in 1:length(dummy$temp)){
    x <- c()
    y <- c()
    
    x <- dummy$temp[i]
    dummy$flag <- ifelse(dummy$temp > x,1,0)
    y <- (sum(dummy$flag == 1 & dummy$stat == 1) * input$truePos) +
      (sum(dummy$flag == 1 & dummy$stat == 0) * input$falsePos) +
      (sum(dummy$flag == 0 & dummy$stat == 0) * input$trueNeg) +
      (sum(dummy$flag == 0 & dummy$stat ==1 ) * input$falseNeg)
    xy <- c(x,y)
    out.list[[i]] <- xy
  }
  utility <- data.frame(do.call(rbind,out.list))
  colnames(utility) <- c('temperature.thresh','utility.score')
  
  utility
  })
  
  # create utility plot
   output$utilityPlot <-renderPlot({ 
     ggplot(data = utility(), aes(x = temperature.thresh, y = utility.score)) +
       geom_line()+
       geom_vline(xintercept = input$thresh)
   })
   
   # create ROC curve
   output$rocPlot <- renderPlot({
     pred <- prediction(dummy$temp, dummy$stat)
     perf <- performance(pred,"tpr","fpr")
     index <- which.min(abs(perf@alpha.values[[1]] - input$thresh))
     x.index <- perf@x.values[[1]][index]
     y.index <- perf@y.values[[1]][index]
     plot(perf) + 
       abline(0,1) +
       points(x = x.index, y = y.index, col ='red', pch = 19)
   })
   
})


