###################################
# Exercise 1 
# 1. Load rCharts (first install it if you haven't yet)
# 3. Transform the ChickWeight dataset (base R) so that time is "fuzzy": 
# ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 1)
# 4. Using Highcharts library build a "scatter" plot to show the growth pattern of 
# chickens: weight over Time, depending on their diet type (group it by Diet), and 
# use a relevant title, for example "Chicken Weight over Time"
# 5. Rename the y-axis and x-axis default values to be descriptive and consistent
# 6. Change the width of the chart to be 700px and height - 450px

library(rCharts)
ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 1)

chickPlot <- hPlot(weight ~ Time, type="scatter", group = "Diet", data=ChickWeight, 
                   title = "Chicken Weight over Time")
chickPlot$xAxis(title = list(text = "Time (Days)"))
chickPlot$yAxis(title = list(text = "Weight"))
chickPlot$chart(width = 700, height = 450)
chickPlot

###################################
# Example with rCharts (Exercise 2)
# Create these two separate files in a new folder (name it arbitrary)
# And to run the files, have at least one open in the RStudio and click "RunApp" button
# Or if the folder is in your working directory, use R command: runApp("Name of Your App Folder")


# ui.R
library(rCharts)
shinyUI(fluidPage(
  h2("rCharts Example"),
  showOutput("myChart", "highcharts")))


# server.R
library(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 1)
    
    chickPlot <- hPlot(weight ~ Time, type="scatter", group = "Diet", data=ChickWeight, 
                       title = "Chicken Weight over Time")
    chickPlot$xAxis(title = list(text = "Time (Days)"))
    chickPlot$yAxis(title = list(text = "Weight"))
    chickPlot$chart(width = 700, height = 450)
    chickPlot$addParams(dom = "myChart")
    return(chickPlot)    
  })})


###################################
# Exercise 3
# 0. Make the chart in your shiny app from exe 2 smaller: 390x320
# 1. Add the grister function to the ui.R file in your shiny app, within the fluidPage() 
# function. To look up an example, type:
#   ```
# library(shinyGridster)
# ?gridster
# ```
# 2. Specify gridster width of 400 and height of 330.
# 3. Create 3 gridsterItem's: 2 for 1st row and 1 for second row.
# 4. Your chart should be in the top left element, add the following in the second on 
# top element: create another output element in server.R, similar to mychart, but using 
# renderTable({}) function and put this inside:
# ```
# aggregate(weight ~ feed, data = chickwts, mean)
# ```
# Call this in your ui.R gridsterItem using tableOutput() function and passing it the 
# name of your output from server.R
# 
# 5. Remove the h2() text element; add your own conclusion using p() function in the lower element. 


# ui.R
library(rCharts)
library(shiny)

shinyUI(fluidPage(
  gridster(width = 400, height = 330,
           gridsterItem(col = 1, row = 1, sizex = 1, sizey = 1,
                        showOutput("myChart", "highcharts")
           ),
           gridsterItem(col = 2, row = 1, sizex = 1, sizey = 1,
                        tableOutput("myTable")
           ),
           gridsterItem(col = 1, row = 2, sizex = 1, sizey = 1,
                        p("Diet 1 is the worst, Diet 3 is the best.
                        Sunflower diet is the most efficient")
           )
  )
)
)

# server.R
library(rCharts)
library(shiny)

shinyServer(function(input, output) {
  
  output$myChart <- renderChart({
    ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 1)
    chickPlot <- hPlot(weight ~ Time, type="scatter", group = "Diet", data=ChickWeight, 
                       title = "Chicken Weight over Time")
    chickPlot$xAxis(title = list(text = "Time (Days)"))
    chickPlot$yAxis(title = list(text = "Weight"))
    chickPlot$chart(width = 390, height = 320)
    chickPlot$addParams(dom = "myChart")
    return(chickPlot) 
  })
  
  output$myTable <- renderTable({
    aggregate(weight ~ feed, data = chickwts, mean)
  })
})