# StockViewer

A shiny app developed to view historical stock prices and retrieve other financial data.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

StockViewer needs the latest version of R and Rstudio in order to run. Also, the following R packages are needed:

```
xts
zoo
quantmod
shiny
ggplot2
shinythemes
```
### Get it running

First, you'll need to install both [R](https://cran.r-project.org/bin/windows/base/) and [Rstudio](https://www.rstudio.com/products/rstudio/download/). 

Then, you'll need to install the required packages. To do so, open Rstudio and type the following in the Console (or in a new script):
```
packages <- c("xts", "zoo", "quantmod", "shiny", "ggplot2", "shinythemes")
install.packages(packages)
```
Finally, you'll need to download the repository and open both `ui.R` and `server.R` in Rstudio. After that, just click on `Run App` on the top right corner of either script window. To run in your browser, click on the `Open in Browser` option (top left corner) after running the app.

## Usage

Type whichever stock you want to get the data for in the `Stock` section, and select a date range.

## License

StockViewer is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
