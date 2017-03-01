#
# This app illustrates how a simple random sample
# keeps the same distribution of factors in your population
# confidence bands decrease as the size of the sample increases.
#

library(shiny)
library(ggplot2)
library(dplyr)
library(magrittr)
library(miniUI)
library(reshape2)

# data ------------------------------------------------------------------------

dat <- readRDS("data/dat.rds")
dat$race <- as.factor(dat$race)
levels(dat$race)[levels(dat$race)=="American Indian or Alaska Native"] <- "Other"
levels(dat$race)[levels(dat$race)=="Black/Negro"] <- "Black"


# grid ------------------------------------------------------------------------

# get the x
x <- seq(1, 317, 1)
x <- rep(x, 317)

# get the y - repping 1, 2, 3... 317 times
y <- NULL
for (i in 1:317) {
  temp <- rep(i,317)
  y <- rbind(y, temp)
}

y <- melt(y)

grid <- data.frame(x=x, y=y$Var2)


# colors
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
n = 4
cols <- gg_color_hue(n)


# Define UI for application 
ui <- miniPage(
  
  miniTitleBar("Simple Random Sampling"),
  
  miniContentPanel(
    
   
        align="center",
        
        h4("Use the slider below to select the number of observations to draw at random from
           the population of North Carolina surveyed in the 1880 Census.  How does the distribution
           of the sample compare to the population distribution as the number of observations drawn changes?"),
        
        #100 sample
        sliderInput("draw", "Select Size of Draw:",
                    value=500,
                    min=5, max=1000, step=1),
    
    splitLayout(cellWidths="100%",
        
        # population
         plotOutput("grid")),
    
    splitLayout(cellWidths = c("30%", "30%", "30%"),
         plotOutput("agePop"),
         plotOutput("sexPop"),
         plotOutput("racePop"))
))
        
                      

                                  
   



# Define server logic 
server <- function(input, output) {
  

  

  

  sample <- reactive({
    
    N <- as.numeric(input$draw)
    
    dat <- dat %>%
      select(ageN, race, sex) %>%
      mutate(type=rep("Population", length(dat$ageN)))
    
    #set.seed(1)
    samp <- dat
    samp <- samp[base::sample(1:nrow(dat), N, replace=FALSE),]
    samp <- samp %>%
      select(ageN, race, sex) %>%
      mutate(type=rep("Sample", length(samp$ageN)))
    
    new <- rbind(dat, samp)
    
    race <- new %>%
      count(type, race) %>%
      mutate(Proportion = prop.table(n))
    
    sex <- new %>%
      count(type, sex) %>%
      mutate(Proportion=prop.table(n))
      
    
    return(list(age=new,
                  race=race,
                  sex=sex))
    
    
    
  })
  
  # population
  output$agePop <- renderPlot({
    
    
    
    ggplot(sample()$age, aes(ageN, group=type, fill=type)) +
      geom_density(aes(colour=type), alpha=0.8) +
      geom_vline(xintercept=mean(sample()$age$ageN[sample()$age$type=="Population"]), col=cols[1]) +
      geom_vline(xintercept=mean(sample()$age$ageN[sample()$age$type=="Sample"]), col=cols[3]) +
      theme_bw() +
      labs(title="Distribution of Age") +
      theme(plot.title=element_text(hjust=0.5, size=18),
            axis.text=element_text(size=12),
            axis.title.x=element_blank(),
            legend.title=element_blank(),
            legend.position="top")
    
  })
  
  output$sexPop <- renderPlot({
    
    ggplot(sample()$sex, aes(x=sex, y=Proportion, fill=type, group=type)) +
      geom_bar(stat="identity", position="dodge") +
      #facet_wrap(~type) +
      theme_bw() +
      labs(title="Distribution of Sex") +
      theme(plot.title=element_text(hjust=0.5, size=18),
            axis.text=element_text(size=12),
            axis.title.x=element_blank(),
            legend.title=element_blank(),
            legend.position="top")
    
  })
  
  output$racePop <- renderPlot({
    
    ggplot(sample()$race, aes(x=race, y=Proportion, fill=type, group=type)) +
      geom_bar(stat="identity", position="dodge") +
      #facet_wrap(~type) +
      theme_bw() +
      labs(title="Distribution of Race") +
      theme(plot.title=element_text( hjust=0.5, size=18),
            axis.text=element_text(size=12),
            axis.title.x=element_blank(),
            legend.title=element_blank(),
            legend.position="top")
    
  })
  
  output$grid <- renderPlot({
    
    samp <- grid[base::sample(1:nrow(grid), input$draw, replace=FALSE),]
    
    ggplot(grid, aes(x=x, y=y)) +
      geom_point(col=cols[1], size=0.005) +
      geom_point(data=samp, col=cols[3]) +
      labs(title="Population & Sample") +
      theme_bw() +
      theme(plot.title=element_text(hjust=0.5, size=18),
            axis.text=element_blank(),
            axis.title=element_blank())

    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

