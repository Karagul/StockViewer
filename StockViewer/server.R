library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)
library(shinydashboard)

shinyServer(function(input, output) {
  # Getting ticker data
  symbol <- reactive({
    if(input$symbol == 0)
    return(NULL)
  
  return(isolate({
    getSymbols(input$symbol, src = "yahoo", auto.assign = FALSE)
    
  }))
  })

  output$plot <- renderPlot({
    autoplot(Cl(symbol())) + theme(panel.background = element_rect(fill = "white", colour = "white"), panel.grid.major.y = element_line(colour = rgb(195/255, 195/255, 195/255, alpha = 0.5), linetype = "solid"), plot.background = element_rect(fill = "white", colour = "white")) + 
    labs(x = "", y = "Close Price (US$)") + geom_area(fill = "#0066B2", alpha = 0.3) + geom_line(size = 1, col = "#0066B2") + scale_y_continuous(position = "right")
  })
})
