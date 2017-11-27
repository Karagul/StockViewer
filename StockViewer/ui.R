library(xts)
library(zoo)
library(quantmod)
library(shiny)
library(ggplot2)

shinyUI(pageWithSidebar(
  
  headerPanel("Stock Viewer"),
  
  sidebarPanel(
               textInput("symbol", label = h3("Stock"), value = "",placeholder = "Enter ticker..."),
               hr(),
               fluidRow(column(3, verbatimTextOutput("value"))),
               
               dateRangeInput('dateRange',
               label = 'Date Range: Year - Month - Day',
               start = Sys.Date() - 366, end = Sys.Date() - 1),
               
               helpText("Source: Yahoo Finance")
               
               ),
  
  mainPanel(
    plotOutput("plot")
  )
))
