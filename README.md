# Spotfire-WordCloud
On this project, I create a Data Function to generate a word cloud in Spotfire. There are two versions, one using the Open R engine that I used to plot the word cloud in RStudio and another one I used to plot the word cloud in Spotfire using TERR.

# Explaining the Data Function
The main concept is a web scraping. Ive made a connection to 3 big news portal in Brazil and extract the most written words on generic news.
For this case i intentionaly want to use a webscraping but you can parse a XML or JSON provided by the portals and things will be easier.

After scraping the news, i parsed it to XML, perform some text mining and then generate a data frame to be consumed by Spotfire.
