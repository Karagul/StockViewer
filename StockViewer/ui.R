library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)


navbarPage("Stock Viewer", theme = shinytheme("flatly"),
  
  tabPanel("Main",
      sidebarPanel(
                textInput("symbol", label = h3("Ticker"), value = "", placeholder = "Enter ticker..."),
                hr(),
                fluidRow(column(3, verbatimTextOutput("value"))),
               
                
                
                selectInput("fin", label = h3("Download Financial Statements"),
                            choices = list("Income Statement" = as.integer(1), "Balance Sheet" = 2, "Cash Flow" = 3),
                            selected = 1),
                
                splitLayout(downloadButton("quarterly", "Quarterly", style = "Width:200px;display:block;margin:0 auto;margin-top:0px;margin-bot:5px"), 
                            downloadButton("annualy", "Annualy", style = "Width:200px;display:block;margin:0 auto;margin-top:0px;margin-bot:5px")),
               
                helpText("Other Data", style = "margin-top:15px;margin-bot:5px"),
                splitLayout(downloadButton("dividends", "Dividends", style = "Width:140px"), downloadButton("stock_price", "OHLC Prices", style = "Width:140px"), downloadButton("splits", "Splits", style = "Width:140px")),
               
                htmlOutput("historical_ratios"),
               
                helpText("Source: Yahoo Finance, MarketWatch", style = "text-align:right")
                
                ),
  
    mainPanel(
      splitLayout(h3(textOutput("title")), dateRangeInput('dateRange',
                                           label = 'Date Range: Year - Month - Day',
                                           start = Sys.Date() - 366, end = Sys.Date() - 1, min = "2007-01-01", max = Sys.Date(), startview = "decade", width = "100%")),
      plotOutput("plot"),
      tabsetPanel(
        tabPanel("Key Values", tableOutput("summary")),
        tabPanel("Valuation Ratios", tableOutput("val_rat")),
        tabPanel("Efficiency Ratios", tableOutput("eff_rat")),
        tabPanel("Liquidity Ratios", tableOutput("liq_rat")),
        tabPanel("Profitability Ratios", tableOutput("prof_rat")),
        tabPanel("Capital Structure", tableOutput("cap_str")),
        tabPanel("Returns", tableOutput("performance"))
              ))
    ),
  tabPanel("About")
)

