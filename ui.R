#
# This is the user-interface definition of a Shiny web application.
#
# For app usage information, see the documentation in the README file.
#

library(shiny)

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Exploring Airline Passenger Data"),
  
  # Create select1 and checkbox1 widgets for first plot, select2 and checkbox2 widgets for second plot
  sidebarLayout(
    sidebarPanel(
      selectInput("select1", label = h4("Upper Plot: Select Year(s)"), 
                  choices = as.list(1949:1960), multiple=TRUE), 
      checkboxInput("checkbox1", label = "Add Mean Value Line to Year Plot", value = FALSE),
      selectInput("select2", label = h4("Lower Plot: Select Month(s)"), 
                  choices = as.list(month.abb), multiple=TRUE),
      checkboxInput("checkbox2", label = "Add Trend Line to Month Plot", value = FALSE)
    ),
    
    # Create tabs and plot,table layout
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", 
                     plotOutput("yearPlot"),
                     plotOutput("monthPlot")
                ),
        tabPanel("Original Dataset", 
                      plotOutput("originalPlot"),
                      tableOutput("originalTable")
                )
      )
    )
  )
))
