library(ggvis)
library(shiny)
library(dplyr)
library(recommenderlab)
#
set.seed(1234)
#get anonymous ratings data from Jester Online Joke Recommender System
#it contains 100 joke ratings on a scale [-10, +10]
#all users rated 36+ jokes
data(Jester5k)
df <- as.data.frame(as.matrix(Jester5k@data))
df$names<-rownames(df)
#row.names(df) <- NULL
#df <- df %>% select(user, everything())
#write.table(, filef = "jester5k.csv",row.names=FALSE, na="",col.names=T, sep=",")
r <- sample(Jester5k, 1000)
nr <- as.data.frame(getRatings(normalize(r, method = 'Z-score')))
colnames(nr) <- c("rating")
nr %>% ggvis(~rating, fill := "#00c7fc") %>%
  layer_histograms(width = input_slider(min = 0.05, max = 0.5, value = 0.4, step = 0.01, label = 'Bin Width'),center=0) %>%
  add_axis("x", title = "Rating")
#
colMeans <- as.data.frame(colMeans(r))
colnames(colMeans) <- c("mv")
colMeans %>% ggvis(~mv, fill := "#00c7fc") %>%
  layer_histograms(width = input_slider(min = 0.5, max = 1, value = 0.7, step = 0.1, label = 'Bin Width'),center=0) %>%
  add_axis("x", title = "Mean User Rating")
#
rc <- Recommender(Jester5k[1:1000], method = 'POPULAR')
