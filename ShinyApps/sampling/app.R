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

# data

dat <- readRDS("/users/amyfinnegan/GHRbook/ShinyApps/sampling/data/dat.rds")
dat$race <- as.factor(dat$race)

# colors
gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}
n = 4
cols <- gg_color_hue(n)


# Define UI for application that draws a histogram
ui <- miniPage(
  
  miniTitleBar("Simple Random Sampling"),
  
  miniContentPanel(
   
        align="center",
        
        h4("Use the slider below to select the number of observations to draw at random from
           the population of North Carolina surveyed in the 1880 Census.  How does the comprability
           of the sample compare to the population distribution as the number of observations drawn changes?"),
        
        #100 sample
        sliderInput("draw", "Select Size of Draw:",
                    value=500,
                    min=5, max=1000, step=1),
        
        # population
         plotOutput("agePop"),
         plotOutput("sexPop"),
         plotOutput("racePop")
))
        
                      

                                  
   



# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # I think I want to draw and then cbind them
  # maybe select the three variables first
  # then plot by group
  
  # N <- reactive({
  #   
  #   N <- as.numeric(input$draw)
  #   
  #   return(N)
  #   
  # })
  

  

  sample <- reactive({
    
    N <- as.numeric(input$draw)
    
    dat <- dat %>%
      select(ageN, race, sex) %>%
      mutate(type=rep("Population", length(dat$ageN)))
    
    set.seed(1)
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
            legend.title=element_blank())
    
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
            legend.title=element_blank())
    
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
            legend.title=element_blank())
    
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)

