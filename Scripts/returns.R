library(scales)
library(tidyverse)
library(quantmod)

share <- getSymbols("SNAP", auto.assign = F) 

returns <- share[,6] # Get adjusted prices
returns <- ((returns[,1] - returns[[1]]) / returns[[1]])

autoplot(returns) + 
  theme(panel.background = element_rect(fill = "white", colour = "white"), 
        panel.grid.major.y = element_line(colour = rgb(195/255, 195/255, 195/255, alpha = 0.5), linetype = "solid"), 
        plot.background = element_rect(fill = "white", colour = "white"), 
        text = element_text(size = 12, family = "Lato", color = rgb(44/255, 62/255, 80/255)), 
        plot.title = element_text(face = "bold", size = 18),
        axis.ticks.y = element_blank()) + 
  labs(x = "", y = "") + geom_area(fill = "#0066B2", alpha = 0.3) + geom_line(size = 1, col = "#0066B2") + 
  scale_y_continuous(position = "right",
                     labels = percent)


