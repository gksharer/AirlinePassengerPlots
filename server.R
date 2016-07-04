#
# This is the server logic of a Shiny web application.
#
# For app usage information, see the documentation in the README file.
#

library(shiny)
library(datasets)
library(ggplot2)
library(dplyr)
library(tidyr)
library(xtable)

# Define server logic
shinyServer(function(input, output) {
  
  # manipulate dataset
  x <- as.data.frame(t(matrix(AirPassengers,12,dimnames=list(month.abb,seq(1949,1960)))))
  x$year <- rownames(x)
  x <- gather(x,months,count,-year)
  x$months <- factor(x$months, month.abb)
  
  # create plot and table for Tab 2
  output$originalTable <- renderTable(AirPassengers)
  output$originalPlot <- renderPlot(plot(AirPassengers,type='l',ylab="Number of Air Passengers",main="Air Passenger Data Set"))
  
  # create plots for Tab 1
  output$yearPlot <- renderPlot({
    if(is.null(input$select1)) {
      p1 <- ggplot(x,aes(x=months,y=count, col=year))+geom_blank()
      p1 + ylim(0,700) + ylab("Number of Air Passengers") + ggtitle("AirPassengers by Year")
    } else {
      newX1 <- filter(x, year %in% input$select1)
      summary <- group_by(newX1,year) %>% summarise(mean=mean(count))
      p1 <- ggplot(newX1,aes(x=months,y=count, col=year))+geom_point(size=3)
      p1 <- p1 + ylim(0,700) + xlab("Month") + ylab("Number of Air Passengers") + ggtitle("AirPassengers by Year")
      if (input$checkbox1) {
        p1 <- p1 + geom_hline(data=summary, aes(yintercept=mean,col=year))
      }
      p1
    }
  })
  
  output$monthPlot <- renderPlot({
    if(is.null(input$select2)) {
      p2 <- ggplot(x,aes(x=year,y=count, col=months))+geom_blank()
      p2 + ylim(0,700) + ylab("Number of Air Passengers") + ggtitle("AirPassengers by Month")
    } else {
      newX2 <- filter(x, months %in% input$select2)
      newX2$year <- as.numeric(newX2$year)
      p2 <- ggplot(newX2,aes(x=year,y=count, col=months))+geom_point(size=3)
      p2 <- p2 + ylim(0,700) + xlab("Year") + ylab("Number of Air Passengers") + ggtitle("AirPassengers by Month")
      if (input$checkbox2) {
          p2 <-p2 + geom_smooth(method="lm",se=FALSE)
      }
      p2
    }
  })
  
})
