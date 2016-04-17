# This is the server logic for a Shiny web application.
# Author: Enrique Reveron
# Date: 2016-04-17
# Content: This Shiny Apps make Geographical Maps using GoogleVis 
#         library and ITU-T Data. 
#

library(shiny)
library(googleVis)
require(googleVis)
require(shiny)

dt_colnames <- c("country","2000","2001","2002","2003","2004","2005","2006","2007",
               "2008","2009","2010","2011","2012","2013","2014")
dt_colClasses=c("character",rep("numeric",15))

Fixed_dt <- read.csv("Fixed_tel_2000-2014.csv",sep=";", header = TRUE, skip = 1, check.names=FALSE,
                     col.names = dt_colnames, stringsAsFactors = FALSE)
Mobile_dt <- read.csv("Mobile_cellular_2000-2014.csv",sep=";", header = TRUE, skip = 1, check.names=FALSE,
                      col.names = dt_colnames,stringsAsFactors = FALSE)

Fixed_dt$country <- tolower(Fixed_dt$country)
Mobile_dt$country <- tolower(Mobile_dt$country)

shinyServer(function(input, output) {

  # For reactive purposes
  myVar <- reactive({
    input$var
  })
  
  # For reactive purposes
  myYear1 <- reactive({
    input$range[1]
  })
  
  # For reactive purposes
  myYear2 <- reactive({
    input$range[2]
  })
  
  # This function will create the Tittle
  output$var <- renderText({
    
    if (input$var == 1) { myvariable <- "Fixed Phone Lines"
    } else { myvariable <- "Mobile Phone Subscriptions" } 
    
    if (input$range[1] == input$range[2]) {
      title_map <- paste(myYear1()," Total Worldwide ITU ",
                         myvariable," (thousands)")
    } else {
      title_map <- paste(myYear1(),"-",myYear2()," Increment Worldwide ITU ",
                         myvariable, " (thousands)")
    }
    title_map
  })
  
  # This function will create the plot (Map)
  output$gvis <- renderGvis({
    
    if (input$var == 1) {
      # Fixed Phone was selected
      myds <- Fixed_dt
      myvariable <- "Fixed Phone Lines"
    } else {
      # Mobile Subscriptions was selected
      myds <- Mobile_dt
      myvariable <- "Mobile Phone Subscriptions"
    } 
    
    if (input$range[1] == input$range[2]) {
      # A plot for a specific year
      mycolumns <- c("country",input$range[1])
      myds <- myds[mycolumns] 
      colnames(myds) <- c("region","value")
      myds$value <- as.numeric(myds$value) / 1000
    } else {
      # A plot for a date range, we calculate the difference between 
      # input$range[1] and input$range[2]
      mycolumns <- c("country",input$range[1],input$range[2])
      myds <- myds[mycolumns]
      colnames(myds) <- c("region","year1","year2")
      myds$year2 <- as.numeric(myds$year2) / 1000
      myds$year1 <- as.numeric(myds$year1) / 1000
      myds$value <- as.numeric(as.numeric(myds$year2) - as.numeric(myds$year1))
    }
    myds <<- myds
    
    gvisGeoChart(myds, locationvar = "region", colorvar="value",
                 
                 options=list(displayMode="Markers", 
                              colorAxis="{colors:['red','pink','orange','yellow','green','blue']}",
                              backgroundColor="lightblue")
                 )
  })
  
  
  # This function will create the table 
  output$table <- renderGvis({
    data <- myds
    if (input$var == 1) {
      NULL
    }
    if (input$range[1] == input$range[2]) {
      colnames(data) <- c("country",c(input$range[1]))
    }
    else { 
      colnames(data) <- c("country",input$range[1],input$range[2],"diff")
    }
    gvisTable(data, 
              options=list(page='enable',
                           height='automatic',
                           width='automatic')
              )
  })
  

})
