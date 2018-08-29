# StockViewer

A shiny app developed to view historical stock prices and retrieve other financial data.

![](https://raw.githubusercontent.com/Sankatt/StockViewer/master/Images/preview.png)

## Installation 

### Prerequisites

StockViewer needs the latest version of R and Rstudio in order to run properly. Also, the following R packages are needed (also updated to their latest versions):

```
xts
zoo
quantmod
shiny
ggplot2
shinythemes
shinycssloaders
dplyr
rvest
```

### Get it running

First, install both [R](https://cran.r-project.org/bin/windows/base/) and [Rstudio](https://www.rstudio.com/products/rstudio/download/). 

Then, install the required packages. To do so, open Rstudio and type the following lines in the console:

```
packages <- c("xts", "zoo", "quantmod", "shiny", "ggplot2", "shinythemes", "shinycssloaders", "dplyr", "rvest")
install.packages(packages)
```

Finally, download the repository and open both `ui.R` and `server.R` in Rstudio. After that, just click on `Run App` on the top right corner of either script window. To run in your browser, click on the `Open in Browser` option (top left corner) after running the app.

## Usage

Type whichever stock you want to get the data for in the `Stock` section, and select the date range you want to plot. To get the financial statements and other data, just click on the download buttons after typing the stock's ticker. If a stock has never paid any dividends or done a split, when downloading this data you'll get a blank `.csv` file. 

Historical prices only go up to 2007, even if the stock has existed for a longer time. This will affect OHLC Prices and the plot only.

## License

StockViewer is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
