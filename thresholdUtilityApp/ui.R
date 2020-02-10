library(shiny)
library(dplyr)
library(ggplot2)
library(ROCR)


# ui ----
shinyUI(fluidPage( #describes page type
  
    # Application title
    titlePanel("Utility Function"),
      
      mainPanel(
        fluidPage(
          
          fluidRow(
            sliderInput('thresh', "Enter temperature threshold (F)",
                        min(dummy$temp),
                        max(dummy$temp),
                        value = 98.6,
                        step = 0.1)
            ),
          fluidRow(
            column(width = 6,
              fluidRow(
                numericInput('truePos','Enter benefit of true positive',
                             value = 1)
                )
              ),
            column(width = 6,
                   fluidRow(
                     numericInput('falsePos','Enter cost of false positive', 
                                  value = -1)
                   )
                   )
          
          ),
          fluidRow(
            column(width = 6,
                   fluidRow(
                     numericInput('falseNeg', 'Enter cost of false negative',
                                 value = -1)
                     )
                   ),
            column(width= 6,
                   fluidRow(numericInput('trueNeg', 'Enter benefit of true negative',
                                         value = 0)
                            )
                   )
            ),
          fluidRow(
            column(width = 6,
                   fluidRow(
                     plotOutput('utilityPlot')
                     )
                   ),
            column(
              width = 6,
             fluidRow(
               plotOutput('rocPlot')
               )
             )
            )
        )
    )
  )
  )
