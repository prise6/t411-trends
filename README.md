# Script test fonctions
François  
25 juillet 2016  

An example:


load fonction & library:

```r
library(plotly)
source("./script_test.R")
```

Fetch data:

```r
data = t411_trends(time = "today")
table(data$Type)
```

```
## 
##              app-linux            app-windows            audio-music 
##                      2                      3                     40 
##              ebook-bds            ebook-books           ebook-comics 
##                     17                     31                      9 
##           ebook-mangas            ebook-press         games-nintendo 
##                      6                     13                      2 
##             games-sony          games-windows                tv-show 
##                      1                     16                      9 
##        video-animation video-animation-series          video-concert 
##                      2                     16                      4 
##       video-documental            video-movie            video-sport 
##                     20                     36                      2 
##        video-tv-series 
##                     25
```

tables (max 6 rows) and plots:

__trend film torrents (today)__

Type          new_title                                                 Complet   Seeders   Leechers
------------  -------------------------------------------------------  --------  --------  ---------
video-movie   Rurouni Kenshin Kyoto Inferno                                 230       150         20
video-movie   La Trilogie Du Dollar                                         211       140         20
video-movie   Batman vs Superman                                            157        92         33
video-movie   Bernard Blier,Danielle Darrieux - La Maison Bonnad             96        58          1
video-movie   LE CAS MORRISON - MASSACRE AU TEXAS TVRip mkv                  72        42          0
video-movie   125 Years Memory                                               71        45          3


```r
plot_ly(data[Type == "video-movie"], x = Seeders, y = Leechers, size = Complet, mode = "markers",  text = new_title)
```

__trend film torrents (week)__

Type          new_title            Complet   Seeders   Leechers
------------  ------------------  --------  --------  ---------
video-movie   Batman V Superman      44210     15772        500
video-movie   Demolition              8855      3358         63
video-movie   Marseille               6563      2490         35
video-movie   Eye in the Sky          3733      1362         17
video-movie   Time Lapse              2964      1349         57
video-movie   Miles Ahead             2719      1047         11


```r
plot_ly(data[Type == "video-movie"], x = Seeders, y = Leechers, size = Complet, mode = "markers",  text = new_title)
```

__trend film torrents (month)__

Type          new_title            Complet   Seeders   Leechers
------------  ------------------  --------  --------  ---------
video-movie   Divergente 3           49058     12565        697
video-movie   Batman V Superman      44210     15772        500
video-movie   Allegiant              17360      4848        134
video-movie   Demolition              9253      3457         65
video-movie   Belgica                 8234      2054         14
video-movie   Dirty Grandpa           7534      2116         21


```r
plot_ly(data[Type == "video-movie"], x = Seeders, y = Leechers, size = Complet, mode = "markers",  text = new_title)
```


