library(rvest)
library(XML)
library(RJSONIO)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(RinR)

pushPATH("C:/Apps/R/R-3.4.3/bin")

setwd("C:/Temp")

REvaluate(version$version.string, REvaluator)


## Busca News do G1
#g1 <- read_html("http://www.g1.com.br")
url = "http://www.g1.com.br"
download.file(url, destfile = "C:/Temp/scrapedpage.html", quiet=TRUE)
g1 <- read_html("C:/Temp/scrapedpage.html", encoding="utf8")

news_g1 <- html_nodes(g1, ".feed-post-body-title")

# parse html
doc = htmlParse(news_g1, asText=TRUE)
plain.text <- xpathSApply(doc, "//p", xmlValue)

#html_attr(html_nodes(g1, ".feed-post-header"), "alt")

news_g1 <- iconv(plain.text, to="Windows-1252")

table_g1 <- data.frame(source = "g1",Sys.Date(),news = news_g1)

## Busca News da Folha
#folha <- read_html("http://www.folha.com.br")
url = "http://www.folha.com.br"
download.file(url, destfile = "C:/Temp/scrapedpage2.html", quiet=TRUE)
folha <- read_html("C:/Temp/scrapedpage2.html", encoding="utf8")

news_folha <- html_nodes(folha, ".row")

# parse html
doc2 = htmlParse(news_folha, asText=TRUE)
plain.text2 <- xpathSApply(doc2, "//p", xmlValue)

news_folha <- iconv(plain.text2, to="Windows-1252")

table_folha <- data.frame(source = "folha",Sys.Date(),news = news_folha)

## Busca News do Valor OnLine

#valor <- read_html("http://www.valor.com.br")
url = "http://www.valor.com.br"
download.file(url, destfile = "C:/Temp/scrapedpage3.html", quiet=TRUE)
valor <- read_html("C:/Temp/scrapedpage3.html", encoding="utf8")

news_valor <- html_nodes(valor, ".teaser-title")

# parse html
doc3 = htmlParse(news_valor, asText=TRUE)
plain.text3 <- xpathSApply(doc3, "//div[@class='teaser-title']", xmlValue)

news_valor <- iconv(plain.text3, to="Windows-1252")

table_valor <- data.frame(source = "valor",Sys.Date(),news = news_valor)

## Junta Tudo
newsTable <- bind_rows(table_folha,table_g1,table_valor)

## TM
docs <- Corpus(VectorSource(newsTable$news))

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
docs <- tm_map(docs, toSpace, "/")
docs <- tm_map(docs, toSpace, "@")
docs <- tm_map(docs, toSpace, "\\|")

# Convert the text to lower case
docs <- tm_map(docs, content_transformer(tolower))
# Remove numbers
docs <- tm_map(docs, removeNumbers)
# Remove english common stopwords
docs <- tm_map(docs, removeWords, stopwords("portuguese"))
# Remove your own stop word
# specify your stopwords as a character vector
docs <- tm_map(docs, removeWords, c("para", "com")) 
# Remove punctuations
docs <- tm_map(docs, removePunctuation)
# Eliminate extra white spaces
docs <- tm_map(docs, stripWhitespace)
# Text stemming
docs <- tm_map(docs, stemDocument)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m),decreasing=TRUE)
d <- data.frame(word = names(v),freq=v)

set.seed(1234)


img <- RGraph(print(wordcloud(words = d$word, freq = d$freq, min.freq = 1,
                              max.words=200, random.order=FALSE, rot.per=0.35, 
                              colors=brewer.pal(8, "Dark2"))),packages = "wordcloud",data = "d", 
              display = TRUE)
