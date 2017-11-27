library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)


shinyServer(function(input, output) {
  #Getting ticker data
  symbol <- reactive({
    if(input$symbol == 0)
    return(NULL)
  
  return(isolate({
    getSymbols(input$symbol, src = "yahoo", auto.assign = FALSE)
  }))
  })
  
  data <- reactive({diamonds})
  
  output$plot <- renderPlot({
    autoplot(symbol())
  })
})
