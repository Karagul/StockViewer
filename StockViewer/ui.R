library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)


navbarPage("Stock Viewer", theme = shinytheme("flatly"),
  
  tabPanel("Main",
      sidebarPanel(
                div(
                textInput("symbol", label = h3("Ticker"), value = "", placeholder = "Enter ticker..."),
                hr(),
                fluidRow(column(3, verbatimTextOutput("value")))),
                
                div(
                selectInput("fin", label = h3("Download Financial Statements"),
                choices = list("Income Statement" = as.integer(1), "Balance Sheet" = 2, "Cash Flow" = 3),
                selected = 1)),
                
                splitLayout(downloadButton("quarterly", "Quarterly", style = "Width:200px;display:block;margin:0 auto;margin-top:0px;margin-bot:5px"), 
                            downloadButton("annualy", "Annualy", style = "Width:200px;display:block;margin:0 auto;margin-top:0px;margin-bot:5px")),
               
                helpText(h3(" Download Other Data"), style = "margin-top:15px;margin-bot:5px;color:#2C3E50"),
                splitLayout(downloadButton("stock_price", "OHLC Prices", style = "Width:200px;display:block;margin:0 auto;margin-top:5px;margin-bot:5px"), downloadButton("splits", "Splits", style = "Width:200px;display:block;margin:0 auto;margin-top:5px;margin-bot:5px")),
               
                splitLayout(downloadButton("dividends", "Dividends", style = "Width:200px;display:block;margin:0 auto;margin-top:5px;margin-bot:5px"), uiOutput("historical_ratios", style = "Width:200px;display:block;margin:0 auto;margin-top:5px;margin-bot:5px"))
                
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
  tabPanel("About",
           mainPanel(
             helpText(h3("Sources:")),
             helpText("Yahoo Finance"),
             helpText("MarketWatch"),
             helpText("Morning Star")
           ))
)

