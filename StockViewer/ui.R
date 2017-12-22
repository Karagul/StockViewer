library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)


fluidPage(theme = shinytheme("flatly"),

  pageWithSidebar(
  
  headerPanel("Stock Viewer"),
  
  sidebarPanel(
               textInput("symbol", label = h3("Ticker"), value = "", placeholder = "Enter ticker..."),
               hr(),
               fluidRow(column(3, verbatimTextOutput("value"))),
               
               dateRangeInput('dateRange',
               label = 'Date Range: Year - Month - Day',
               start = Sys.Date() - 366, end = Sys.Date() - 1, min = "2007-01-01", max = Sys.Date(), startview = "decade"),
               
               splitLayout(helpText("Download Quarterly Data"), helpText("Download Annual Data")),
               splitLayout(downloadButton("downloadISQ", "Income Statement"), downloadButton("downloadISA", "Income Statement")),
               splitLayout(downloadButton("downloadBSQ", "Balance Sheet"), downloadButton("downloadBSA", "Balance Sheet")),
               splitLayout(downloadButton("downloadCFQ", "Cash Flow"), downloadButton("downloadCFA", "Cash Flow")),
               
               helpText("Other Data"),
               splitLayout(downloadButton("dividends", "Dividends"), downloadButton("stock_price", "OHLC Prices"), downloadButton("splits", "Splits")),
               
               htmlOutput("historical_ratios"),
               
               helpText("Source: Yahoo Finance, MarketWatch")
               ),
  
  mainPanel(
    splitLayout(h3(textOutput("title")), tableOutput("performance")),
    plotOutput("plot"),
    tabsetPanel(
      tabPanel("Key Values", tableOutput("summary")),
      tabPanel("Valuation Ratios", tableOutput("val_rat")),
      tabPanel("Efficiency Ratios", tableOutput("eff_rat")),
      tabPanel("Liquidity Ratios", tableOutput("liq_rat")),
      tabPanel("Profitability Ratios", tableOutput("prof_rat")),
      tabPanel("Capital Structure", tableOutput("cap_str"))
    )
  )
))
