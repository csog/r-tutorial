library(rvest)
library(magrittr)
library(ggplot2)
library(plotly)
library(dplyr)
library(zoo)

url <- "https://cran.r-project.org/web/packages/available_packages_by_date.html"

page <- read_html(url)
page %>%
  html_node("table") %>%
  html_table() %>%
  mutate(count = rev(1:nrow(.))) %>%
  mutate(Date = as.Date(Date)) %>%
  mutate(Month = format(Date, format="%Y-%m")) %>%
  group_by(Month) %>%
  summarise(published = min(count)) %>%
  mutate(Date = as.Date(as.yearmon(Month))) -> pkgs

margins = list(l = 100, r = 100, b = 100, t = 100, pad = 4)

pkgs %>%
  plot_ly(x=Date, y=published, name="Published packages") %>%
  layout(title = "CRAN packages published ever since.", margin = margins)

plot(x=pkgs$Date, y=pkgs$published)


ggplot(pkgs, aes(x=Date, y=published)) + 
      geom_line() + 
      geom_point() +
      #geom_area(fill=alpha('slateblue',0.2)) +
    # scale_x_date( date_breaks="3 year") +
     ylab("number of packages") +
  xlab("year")
           )

