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

#set working directory to current File location
# setwd(getSrcDirectory()[1])
studentData<-read_csv("sur.zip")
glimpse(studentData)

#scale the data scale(A, center = TRUE, scale = TRUE)

# Bulgariascaled<-scale(
#   Bulgaria%>%
#     # filter(!is.na(YearsCodingProf)&!is.na(YearsCoding))%>%
#     mutate( YearsCodingProf = ifelse(is.na(YearsCodingProf),YearsCoding,YearsCodingProf))%>%
#     select(Salary,YearsCodingProf,YearsCoding)
# )

mean(Bulgaria$Salary)
ggplot(Bulgaria,aes(x=Salary))+
  geom_histogram(bins=15)+
  # scale_x_log10()+
  geom_vline(aes(xintercept = mean(Salary)),col='red',size=2) +
  geom_vline(aes(xintercept = median(Salary)),col='blue',size=2)+
  geom_vline(aes(xintercept = quantile(Bulgaria$Salary)[2]),col='yellow',size=2)+
  geom_vline(aes(xintercept = quantile(Bulgaria$Salary)[4]),col='yellow',size=2)

ggplot(Bulgaria,aes(x = 1,y=Salary))+
  geom_boxplot()
