
source("./t411_trends.R")

# Test fonction + graph ---------------------------------------------------

tmp = t411_trends(time = "month")

table(tmp$Type)
plot_ly(tmp[Type=="video-sport"], x = Seeders, y = Leechers, size = Complet, mode = "markers",  text = new_title)
