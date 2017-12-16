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
    autoplot(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", as.character(format(input$dateRange[2])))])) + 
    theme(panel.background = element_rect(fill = "white", colour = "white"), panel.grid.major.y = element_line(colour = rgb(195/255, 195/255, 195/255, alpha = 0.5), 
    linetype = "solid"), plot.background = element_rect(fill = "white", colour = "white"), 
    text = element_text(size = 12, family = "Lato", color = rgb(44/255, 62/255, 80/255)), plot.title = element_text(face = "bold", size = 18)) + 
    labs(x = "", y = "Close Price (US$)") + geom_area(fill = "#0066B2", alpha = 0.3) + geom_line(size = 1, col = "#0066B2") + scale_y_continuous(position = "right") +
    ggtitle(paste0("Closing Prices for ", toupper(input$symbol), " from ", input$dateRange[1], " to ", input$dateRange[2]))
  })
})

