library(rvest)
library(dplyr)

# TSLA as an example

stock <- getSymbols("TSLA", auto.assign = FALSE)
ticker <- strsplit(names(stock)[1],".Open") # Might need to be changed for StockViewer

url <- paste0("https://www.marketwatch.com/investing/Stock/", tolower(ticker))
url2 <- paste0("https://www.marketwatch.com/investing/stock/", tolower(ticker), "/profile")

dat <- read_html(url)
dat2 <- read_html(url2)

# Get full name

name <- dat %>% html_node(".company__name") %>% html_text()

# Get Quote

price <- dat %>% html_node(".value") %>% html_text
price <- paste0("$",price)

# Get update time

updated <- dat %>% html_node(".timestamp__time , .kv__item:nth-child(1) .kv__primary") %>% html_text()

# Get Summary data

summary_data <- dat %>% html_nodes(".kv__label") %>% html_text() %>% data.frame()
names(summary_data) <- "Data"
summary_value <- dat %>% html_nodes(".kv__primary") %>% html_text() %>% data.frame()
names(summary_value) <- "Value"
summary <- cbind(summary_data, summary_value)

# Get performance data

performance_period <- dat %>% html_nodes(".c2 .table__cell:nth-child(1)") %>% html_text() %>% data.frame()
names(performance_period) <- "Period"
performance_return <- dat %>% html_nodes(".value.ignore-color") %>% html_text() %>% data.frame()
names(performance_return) <- "Return"
performance <- cbind(performance_period, performance_return)


# Get ratios
# Maybe it would be better to divide the ratios by type.

ratios_name <- dat2 %>% html_nodes("#maincontent .column") %>% html_text() %>% data.frame()
names(ratios_name) <- "Ratio"
ratios_value <- dat2 %>% html_nodes("#maincontent .lastcolumn") %>% html_text() %>% data.frame()
names(ratios_value) <- "Value"
ratios <- cbind(ratios_name, ratios_value)
