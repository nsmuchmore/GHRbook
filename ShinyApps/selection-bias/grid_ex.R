library(ggplot2)

ur <- data.frame(x=c(seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1)),
                 y=c(rep(1,10), rep(2,10),
                     rep(3,10), rep(4,10),
                     rep(5,10), rep(6,10),
                     rep(7,10), rep(8,10),
                     rep(9,10), rep(10,10)),
                 count=seq(1,100,1))

ul <- ur
ul$x <- ul$x*-1

ll <- ul
ll$y <- ll$y*-1

lr <- ll
lr$x <- lr$x*-1

all <- rbind(ul, ur, ll, lr)



# now w/count, we can subset and add firebrick or grey points
malaria.net <- subset(ul, count>=(100-15))
no.malaria.net <- subset(ur, count>=(100-50))

malaria.no.net <- subset(ll, count<=50)
no.malaria.no.net <- subset(lr, count<=50)

# do the risk ratio using max from each
RR <- (length(malaria.net$count)/length(no.malaria.net$count))/
  (length(malaria.no.net$count)/length(no.malaria.no.net$count))

#misclass.net <- subset(no.malaria.net, count<=20)
misclass.no.net <- subset(no.malaria.no.net, count>=20 & count<=50)
misclass.no.net.move <- subset(ll, count>=50 & count<=80)

#set width around plot


ggplot(all, aes(x=x, y=y)) +
  geom_point(colour="white", size=10) +
  
  # draw grid
  geom_hline(yintercept=0) +
  geom_vline(xintercept=0) +
  
  # color malaria points
  geom_point(data=malaria.net, color="firebrick", size=5) +
  geom_point(data=malaria.no.net, color="firebrick", size=5) +
  
  # color no-malaria points
  geom_point(data=no.malaria.net, color="grey50", size=5) +
  geom_point(data=no.malaria.no.net, color="grey50", size=5) +
  
  # color misclassed points
  #geom_point(data=misclass.net, color="firebrick", size=5, shape=1, stroke=1) +
  geom_point(data=misclass.no.net, color="white", size=5) +
  geom_point(data=misclass.no.net, color="firebrick", size=5, shape=1, stroke=1) +
  geom_point(data=misclass.no.net.move, color="grey50", size=5) +
  geom_point(data=misclass.no.net.move, color="firebrick", size=5, shape=1, stroke=1) +

  labs(title="          Malaria           No Malaria",
       y="Bednet Use \n NO          YES") +
  theme_bw() +
  theme(panel.grid=element_blank(),
        plot.margin=unit(c(2,2,2,2), "cm"),
        legend.position = "none",
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.x=element_blank(),
        axis.ticks.y=element_blank(),
        axis.title.x=element_blank(),
        plot.title=element_text(face="bold", size=22),
        axis.title=element_text(face="bold", size=22))




