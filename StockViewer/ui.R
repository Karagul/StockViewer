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
               textInput("symbol", label = h3("Stock"), value = "", placeholder = "Enter ticker..."),
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
               splitLayout(downloadButton("dividends", "Dividends"), downloadButton("stock_price", "Prices"), downloadButton("splits", "Splits")),
               
               helpText("Source: Yahoo Finance")
               
               ),
  
  mainPanel(
    plotOutput("plot")
  )
))
