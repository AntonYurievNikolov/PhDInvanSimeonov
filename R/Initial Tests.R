# Libraries
library(tidyverse)
library(Hmisc)
library(ggthemes)
library(stringr)
library(GGally)
library(stringr)
library(hrbrthemes)
# install.packages('hrbrthemes')
Data<-read_csv("data.csv")
BestJumper<-Data[Data$`Broad Jump`>1.96*sd(Data$`Broad Jump`)+mean(Data$`Broad Jump`)  ,]
BestJumper$Name

DataScaled<-Data%>%
            mutate_if(is.numeric, scale )%>% 
            mutate(
              `30m sprint` = -1* `30m sprint`,
              `4x10m shuttle` = -1*`4x10m shuttle`,
              `Box Drill` = -1*`Box Drill`,
              `Dribble strong`  = -1*`Dribble strong` ,
              `Dribble weak`  = -1*`Dribble weak` ,
            )%>%
            mutate(
              TotalScore = 
                (
                  `Broad Jump` +
                  `Pushing Medicine ball` +
                  `30m sprint`+
                  `Box Drill` +
                  `4x10m shuttle` +
                  `Dribble-Shooting` +
                  `Dribble strong`+
                  `Dribble weak` +
                  `First touch(strong)-Shoot(weak)` +
                  `First Touch(weak)-Shoot(strong)` 
                )/10
            )

#Invesrse the Score for Metrics where less is better 
TheBest<-DataScaled[DataScaled$TotalScore>1.96*sd(DataScaled$TotalScore)+mean(DataScaled$TotalScore)  ,]
TheBest$Name

TheBest<-DataScaled[DataScaled$TotalScore>1.645*sd(DataScaled$TotalScore)+mean(DataScaled$TotalScore)  ,]
TheBest$Name

TheBest<-DataScaled[DataScaled$TotalScore>1.282*sd(DataScaled$TotalScore)+mean(DataScaled$TotalScore)  ,]
TheBest$Name
# plot
p <- Data %>%
  ggplot( aes(x=`Broad Jump`, col = priceExp)) +
  geom_histogram( binwidth=10, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  ggtitle("Bin size = 3") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )

p

DataScaled %>%
  ggplot( aes(x=TotalScore)) +
  geom_histogram(  bins =20, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
  ggtitle("Bins = 20") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )

DataScaled[35,]
DataScaled[35,7:12]
DataScaled[35,]$TotalScore
ggplot(DataScaled,aes(x=TotalScore))+
  geom_histogram(bins=15)+
  # scale_x_log10()+
  geom_vline(aes(xintercept = mean(TotalScore)),col='red',size=2) +
  geom_vline(aes(xintercept = median(TotalScore)),col='blue',size=2)+
  geom_vline(aes(xintercept = quantile(DataScaled$TotalScore)[2]),col='yellow',size=2)+
  geom_vline(aes(xintercept = quantile(DataScaled$TotalScore)[4]),col='yellow',size=2)

ggplot(DataScaled,aes(x = 1,y=TotalScore))+
  geom_boxplot()
#Correlation Analisis
# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
# matrix of the p-value of the correlation
p.mat <- cor.mtest(DataScaled[,getcharCols!=T])
getcharCols <- map_chr(DataScaled,is.character)
M<-cor(DataScaled[,getcharCols!=T])
corrplot(M, method="circle")

corrplot(M, type="upper", order="hclust", 
         p.mat = p.mat, sig.level = 0.05)
