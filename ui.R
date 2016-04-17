# This is the user-interface definition of a Shiny web application.
# Author: Enrique Reveron
# Date: 2016-04-17
# Content: This Shiny Apps make Geographical Maps using GoogleVis 
#         library and ITU-T Data. 
#

#library(shiny)
#library(googleVis)
require(googleVis)
require(shiny)


shinyUI(
  pageWithSidebar(
  
  headerPanel("ITU-T World Data Geophaphic Map (GoogleVis)"),
    
  sidebarPanel(
      
      helpText(paste("This app create demographic maps with information from ITU-T 2000-2014.",
                     "This apps use the GoogleVis library to make the plots.")),
               
      helpText(paste("Please select the variable to display (Fixed, Mobile) and the",
                     "years Range of interest.")),
      helpText(paste("If you want to plot the total amount of subscriptions in a specific",
                     "year, please select the same year from beginning to end.")),
      helpText(paste("When is selected a year range, the Apps will show the diff (Year2 - Year1).")),
      
      selectInput("var", 
                  label = "Select variable type to display:",
                  choices = c("Fixed Phones Lines" = 1, 
                              "Mobile Phones Subscriptions" = 2)),
      
      sliderInput("range",
                  label = "Date Range of Interest:",
                  min = 2000, max = 2014,
                  value = c(2005,2005))
      ),
    
    mainPanel(
      h3(textOutput("var")),
      htmlOutput("gvis"),
      htmlOutput("table")  
    )
      
  )
) 
