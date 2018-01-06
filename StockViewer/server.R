library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)
library(rvest)

shinyServer(function(input, output) {
  symbol <- reactive({
    
    validate(
      need(input$symbol != "", " ")
    )
    
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
  
  title <- reactive({
    
    validate(
      need(input$symbol != "", "Please select a valid ticker")
    )
    
    url <- paste0("https://www.marketwatch.com/investing/Stock/", tolower(input$symbol))
    dat <- read_html(url)
    name_long <- dat %>% html_node(".company__name") %>% html_text()
    name_long <- strsplit(name_long, "[.]")[[1]][1]
    price <- dat %>% html_node(".value") %>% html_text
    paste0(name_long, " - $",price)
  })
  
  name_long <- reactive({
    url <- paste0("https://www.marketwatch.com/investing/Stock/", tolower(input$symbol))
    dat <- read_html(url)
    name_long <- dat %>% html_node(".company__name") %>% html_text()
    name_long <- strsplit(name_long, "[.]")[[1]][1]
  })
  
  dividends <- reactive({
    getDividends(input$symbol, auto.assign = FALSE)
  })
  
  splits <- reactive({
    getSplits(input$symbol, auto.assign = FALSE)
  })
  
  summary <- reactive({
    validate(
      need(input$symbol != "", " ")
    )
    url <- paste0("https://www.marketwatch.com/investing/Stock/", tolower(input$symbol))
    dat <- read_html(url)
    summary_data <- dat %>% html_nodes(".kv__label") %>% html_text() %>% data.frame()
    names(summary_data) <- "Key Data"
    summary_value <- dat %>% html_nodes(".kv__primary") %>% html_text() %>% data.frame()
    names(summary_value) <- " "
    cbind(summary_data, summary_value)
  })

  performance <- reactive({
    url <- paste0("https://www.marketwatch.com/investing/Stock/", tolower(input$symbol))
    dat <- read_html(url) 
    performance_period <- dat %>% html_nodes(".c2 .table__cell:nth-child(1)") %>% html_text() %>% data.frame()
    names(performance_period) <- "Period"
    performance_return <- dat %>% html_nodes(".value.ignore-color") %>% html_text() %>% data.frame()
    names(performance_return) <- "Return"
    perf <- cbind(performance_period, performance_return)
  })
  
  val_rat <- reactive({
    url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(input$symbol), "/profile")
    dat2 <- read_html(url2)
    ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
    names(ratios_name) <- "Ratio"
    ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
    names(ratios_value) <- "Value"
    ratios <- cbind(ratios_name, ratios_value)
    valuation <- ratios$Ratio %in% c("P/E Current", "P/E Ratio (with extraordinary items)", "P/E Ratio (without extraordinary items)", 
                                     "Price to Sales Ratio", "Price to Book Ratio", "Price to Cash Flow Ratio", "Enterprise Value to EBITDA", 
                                     "Enterprise Value to Sales", "Total Debt to Enterprise Value")
    ratios[valuation,]
  })
  
  eff_rat <- reactive({
      url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(input$symbol), "/profile")
      dat2 <- read_html(url2)
      ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
      names(ratios_name) <- "Ratio"
      ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
      names(ratios_value) <- "Value"
      ratios <- cbind(ratios_name, ratios_value)
      efficiency <- ratios$Ratio %in% c("Revenue/Employee", "Income Per Employee", "Receivables Turnover", "Total Asset Turnover")
      ratios[efficiency,]
    })
  
  liq_rat <- reactive({
    url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(input$symbol), "/profile")
    dat2 <- read_html(url2)
    ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
    names(ratios_name) <- "Ratio"
    ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
    names(ratios_value) <- "Value"
    ratios <- cbind(ratios_name, ratios_value)
    liquidity <- ratios$Ratio %in% c("Current Ratio", "Quick Ratio", "Cash Ratio")
    ratios[liquidity,]
  })
  
  prof_rat <- reactive({
    url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(input$symbol), "/profile")
    dat2 <- read_html(url2)
    ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
    names(ratios_name) <- "Ratio"
    ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
    names(ratios_value) <- "Value"
    ratios <- cbind(ratios_name, ratios_value)
    profitability <- ratios$Ratio %in% c("Gross Margin", "Operating Margin", "Pretax Margin", "Net Margin", "Return on Assets", "Return on Equity", 
                                         "Return on Total Capital", "Return on Invested Capital")
    ratios[profitability,]
  })
  
  cap_str <- reactive({
    url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(input$symbol), "/profile")
    dat2 <- read_html(url2)
    ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
    names(ratios_name) <- "Ratio"
    ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
    names(ratios_value) <- "Value"
    ratios <- cbind(ratios_name, ratios_value)
    capital_structure <- ratios$Ratio %in% c("Total Debt to Total Equity", "Total Debt to Total Capital", "Total Debt to Total Assets", "Long-Term Debt to Equity",
                                             "Long-Term Debt to Total Capital")
    ratios[capital_structure,]
  })
  
  output$title <- renderText({
    title()
  })
  
  fin_q <- reactive({
    try <- as.numeric(input$fin)
    financial()[[try]][[1]]
  })
  
  fin_a <- reactive({
    try <- as.numeric(input$fin)
    financial()[[try]][[2]]
  })
  
  statement <- reactive({
    if(as.numeric(input$fin) == 1){
      "Income Statement"
    } else if(as.numeric(input$fin == 2)){
      "Balance Sheet"
    } else {
      "Cash Flows"
    }
  })
  
  output$quarterly <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Quarterly ", statement(), ".csv")
    },
    content = function(file){
      write.csv(fin_q(), file, row.names = TRUE, col.names = TRUE)
    })
  
  output$annualy <- downloadHandler(
    filename = function(){
      paste0(toupper(input$symbol),  " Annual ", statement(), ".csv")
    },
    content = function(file){
      write.csv(fin_a(), file, row.names = TRUE, col.names = TRUE)
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
  
  output$historical_ratios <- renderUI({
    tags$a(href = paste0("http://financials.morningstar.com/ajax/exportKR2CSV.html?t=", input$symbol), 
           class = "btn btn-default shiny-download-link  shiny-bound-output", 
           style = "width:200px", 
           icon("download") ,"Historical Ratios", target = "_blank")
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
      ggtitle(paste0("Close Prices from ", input$dateRange[1], " to ", input$dateRange[2]))
  })
  
  output$summary <- renderTable({
    summary()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$performance <- renderTable({
    performance()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$val_rat <- renderTable({
    val_rat()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$eff_rat <- renderTable({
    eff_rat()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$liq_rat <- renderTable({
    liq_rat()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$prof_rat <- renderTable({
    prof_rat()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  output$cap_str <- renderTable({
    cap_str()
  }, striped = TRUE, hover = TRUE, width = '100%', colnames = FALSE)
  
  lapply(c("summary", "performance", "val_rat", "eff_rat", "liq_rat", "prof_rat", "cap_str"),
         function(x) outputOptions(output, x, suspendWhenHidden = FALSE))
})





