library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)


shinyServer(function(input, output) {
  # Getting ticker data
  symbol <- reactive({
    if(input$symbol == 0)
    return(NULL)
  
  return(isolate({
    getSymbols(input$symbol, src = "yahoo", auto.assign = FALSE)
    
  }))
  })
  
  
  financial <- reactive({
    if(input$symbol == 0)
      return(NULL)
    
    return(isolate({
      getFinancials(input$symbol, auto.assign = FALSE)
    }))
  })
  
  dividends <- reactive({
    getDividends(input$symbol, auto.assign = FALSE)
  })
  
  splits <- reactive({
    getSplits(input$symbol, auto.assign = FALSE)
  })
  
  output$downloadISQ <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Quarterly ", "Income Statement", ".csv")
    },
    content = function(file){
      write.csv(financial()$IS$Q, file, row.names = TRUE, col.names = TRUE)
  })
  
  output$downloadBSQ <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Quarterly ", "Balance Sheet", ".csv")
    },
    content = function(file){
      write.csv(financial()$BS$Q, file, row.names = TRUE, col.names = TRUE)
    })
  
  output$downloadCFQ <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Quarterly ", "Cash Flows", ".csv")
    },
    content = function(file){
      write.csv(financial()$CF$Q, file, row.names = TRUE, col.names = TRUE)
    })
  
  output$downloadISA <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Annual ", "Income Statement", ".csv")
    },
    content = function(file){
      write.csv(financial()$IS$A, file, row.names = TRUE, col.names = TRUE)
    })
  
  output$downloadBSA <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Annual ", "Balance Sheet", ".csv")
    },
    content = function(file){
      write.csv(financial()$BS$A, file, row.names = TRUE, col.names = TRUE)
    })
  
  output$downloadCFA <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Annual ", "Cash Flows", ".csv")
    },
    content = function(file){
      write.csv(financial()$CF$A, file, row.names = TRUE, col.names = TRUE)
    })
  
  output$dividends <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Historical Dividends ", ".csv")
    },
    content = function(file){
      write.zoo(dividends(), file, row.names = FALSE, sep = ",")
    })
  
  output$stock_price <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " OHLC Prices ", ".csv")
    },
    content = function(file){
      write.zoo(symbol(), file, row.names = FALSE, sep = ",")
    })
  
  output$splits <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Splits ", ".csv")
    },
    content = function(file){
      write.zoo(splits(), file, row.names = FALSE, sep = ",")
    })

  output$plot <- renderPlot({
      autoplot(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", as.character(format(input$dateRange[2])))])) + 
      theme(panel.background = element_rect(fill = "white", colour = "white"), panel.grid.major.y = element_line(colour = rgb(195/255, 195/255, 195/255, alpha = 0.5), 
      linetype = "solid"), plot.background = element_rect(fill = "white", colour = "white"), 
      text = element_text(size = 12, family = "Lato", color = rgb(44/255, 62/255, 80/255)), plot.title = element_text(face = "bold", size = 18)) + 
      labs(x = "", y = "Close Price (US$)") + geom_area(fill = "#0066B2", alpha = 0.3) + geom_line(size = 1, col = "#0066B2") + 
      scale_y_continuous(position = "right", limits = c(0, min(max(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", 
      as.character(format(input$dateRange[2])))])) + (max(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", 
      as.character(format(input$dateRange[2])))])) - min(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", 
      as.character(format(input$dateRange[2])))]))), max(Cl(symbol()[paste0(as.character(format(input$dateRange[1])), "/", 
      as.character(format(input$dateRange[2])))])) + 20))) +
      ggtitle(paste0("Closing Prices for ", toupper(input$symbol), " from ", input$dateRange[1], " to ", input$dateRange[2]))
  })
})

