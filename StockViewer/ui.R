library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)
library(shinythemes)
library(shinycssloaders)
library(dplyr)



navbarPage("Stock Viewer", theme = shinytheme("flatly"), 
          
           
  tabPanel("Main", 
           
      sidebarPanel(tags$style(type="text/css",
                              ".recalculating {opacity: 1.0;}
                              body    {overflow-y:scroll;}"),
                div( 
                  textInput("symbol", label = h3("Ticker"), value = "", placeholder = "Enter ticker..."),
                  hr(),
                  fluidRow(column(3, verbatimTextOutput("value")))
                  ),
                
                div(
                  selectInput("fin", label = h3("Download Financial Statements"),
                  choices = list("Income Statement" = as.integer(1), "Balance Sheet" = 2, "Cash Flow" = 3),
                  selected = 1)),
                
                  splitLayout(downloadButton("quarterly", "Quarterly", style = "Width:200px;
                                                                                display:block;
                                                                                margin:0 auto;
                                                                                margin-top:0px;
                                                                                margin-bot:5px"), 
                              downloadButton("annualy", "Annualy", style = "Width:200px;
                                                                            display:block;
                                                                            margin:0 auto;
                                                                            margin-top:0px;
                                                                            margin-bot:5px")),
               
                  helpText(h3("Download Other Data"), style = "margin-top:15px;
                                                               margin-bot:5px;
                                                               color:#2C3E50;
                                                               font-weight:bold"),
                
                  splitLayout(downloadButton("stock_price", "OHLC Prices", style = "Width:200px;
                                                                                    display:block;
                                                                                    margin:0 auto;
                                                                                    margin-top:5px;
                                                                                   margin-bot:5px"), 
                              downloadButton("splits", "Splits", style = "Width:200px;
                                                                          display:block;
                                                                          margin:0 auto;
                                                                          margin-top:5px;
                                                                          margin-bot:5px")),
               
                  splitLayout(downloadButton("dividends", "Dividends", style = "Width:200px;
                                                                                display:block;
                                                                                margin:0 auto;
                                                                                margin-top:5px;
                                                                                margin-bot:5px"), 
                              uiOutput("historical_ratios", style = "Width:200px;
                                                                     display:block;
                                                                     margin:0 auto;
                                                                     margin-top:5px;
                                                                     margin-bot:5px"))
                ),
    
    mainPanel(
      splitLayout(h3(htmlOutput("title", style = "white-space: normal !important")), 
                     dateRangeInput('dateRange', label = 'Date Range: Year - Month - Day', start = Sys.Date() - 366, end = Sys.Date() - 1, min = "2007-01-01", 
                                    max = Sys.Date(), startview = "decade", width = "100%")),
      
      plotOutput("plot") %>% withSpinner(1, color = "#2C3E50"),
      
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
             helpText(h3("About", style = "color:#2C3E50")),
             helpText("Stock Viewer is meant to be a fast and easy platform for anyone to download free stock market data. 
                      All information can be downloaded as a CSV file, which can easily be opened in Excel or any other platform."),
             
             helpText(h3("Sources", style = "color:#2C3E50")),
             helpText("Historical stock data (prices, dividends, splits) is retrieved from Yahoo Finance, current ratios and key values from Market Watch, 
                      and historical ratios from Morning Star."),
             
             helpText(h3("Contact", style = "color:#2C3E50")),
             helpText("This app is developed and mantained by Martin Rodriguez, any questions or comments should be sent to: m.rodriguezf@alum.up.edu.pe"),
             
             actionButton(inputId = "", label = "" , style = "background:#ffffff;
                                                              color:#2C3E50;
                                                              border-color:#2C3E50" , 
                          icon = icon("linkedin"), onclick ="window.open('https://www.linkedin.com/in/mart%C3%ADn-rodr%C3%ADguez-frumento-19773b149/', '_blank')"),
             
             actionButton(inputId = "", label = "" , style = "background:#ffffff;
                                                              color:#2C3E50;
                                                              border-color:#2C3E50" , 
                          icon = icon("github"), onclick ="window.open('https://github.com/Sankatt', '_blank')")
           ))
)

