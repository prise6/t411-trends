
if(!isNamespaceLoaded("data.table"))
  library(data.table)
if(!isNamespaceLoaded("rvest"))
  library(rvest)
if(!isNamespaceLoaded("httr"))
  library(httr)

t411_trends = function(time){

  if(!time %in% c("today", "week", "month"))
    stop("Invalid time period")
    
  request = paste0("http://www.t411.ch/top/", time)
  
  # trends page
  trends = httr::GET(request) %>% read_html() %>% html_nodes(css = ".results")

  # calculate type in one shot
  type_col = sub(
    pattern     = "categories-icons category-spline-",
    replacement =   "",
    x           = html_attr(html_nodes(trends, "i[class~=\"categories-icons\"]"), "class"))
  
  # rbind trends
  trend = rbindlist(lapply(trends, function(trend_table){
    data.table(html_table(trend_table)[, c(2, 7, 8, 9)])
  }))
  
  # clean trend dt
  trend[, Type := type_col]

  #
  # function to clean torrent title (for series/movies but...)
  # 
  find_title = function(torrent_title, type){
    torrent_title = strsplit(x = torrent_title, split = "\n")[[1]][1]
    torrent_title = gsub(pattern = "^(\\[|\\{|\\().*?(\\]|\\}|\\))", "", x = torrent_title)
    if(type %like% "video"){
      torrent_title = strsplit(x = torrent_title, split = "(\\[|\\(|(DVDRIP|H264|720|BDRIP|HDTV)|[0-9]{4})")[[1]][1]
    }
    if(type %like% "series"){
      torrent_title = gsub(pattern = "S[[:digit:]]+", "", x = torrent_title)
      torrent_title = gsub(pattern = "E[[:digit:]]+", "", x = torrent_title)
    }
    torrent_title = gsub(pattern = "-[[:blank:]]*$", "", x = torrent_title)
    torrent_title = gsub(pattern = "\\.", " ", x = torrent_title)
    torrent_title = gsub(pattern = "^[[:blank:]]+|[[:blank:]]+$", "", x = torrent_title)
    return(torrent_title)
  }
  # tmp = copy(trend)
  # trend = copy(tmp)
  trend[, c("title", "Nom") := list(mapply(find_title, Nom, Type, SIMPLIFY = TRUE, USE.NAMES = FALSE), NULL)]

  # suppress if title is empty (hope not)
  trend = trend[title != ""]  
  
  # re order dt by nchar of title (usefull for agrep)
  trend[, "nchar" := nchar(title)]
  setorder(trend, Type, nchar)
  
  # group similar title
  trend$new_title = unlist(tapply(trend$title, trend$Type, function(stitles){
    sapply(stitles, function(stitle){
      stitles[sapply(stitles, function(title_pattern){
        agrepl(pattern     = title_pattern,
               x           = stitle,
               max         = list(substitutions = 0),
               ignore.case = TRUE)
      })][1]
    }, USE.NAMES = FALSE)
  }, simplify = TRUE), use.names = FALSE)
  
  # resumé des films --------------------------------------------------------

  trend = trend[, .(Complet = sum(Complété), Seeders = sum(Seeders), Leechers = sum(Leechers)), by = c("Type", "new_title")]
  
  setorder(trend, Type, -Complet)
  trend
}




