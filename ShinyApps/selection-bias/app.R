# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# This app uses the example from
# Webster, Jayne, Daniel Chandramohan, Tim Freeman, Brian Greenwood, Amin Ullah 
# Kamawal, Fazle Rahim, and Mark Rowland. 2003. “A Health Facility Based 
# Case–control Study of Effectiveness of Insecticide Treated Nets: Potential for 
# Selection Bias Due to Pre-Treatment with Chloroquine.” Tropical Medicine & 
#   International Health 8 (3): 196–201.
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




# setup =======================================================================

library(dplyr)
library(magrittr)
library(ggplot2)
library(shiny)
library(shinydashboard)

# default data ================================================================

ur <- data.frame(x=c(seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1), seq(1,10,1),
                     seq(1,10,1)),
                 y=c(rep(1,10), rep(2,10),
                     rep(3,10), rep(4,10),
                     rep(5,10), rep(6,10),
                     rep(7,10), rep(8,10),
                     rep(9,10), rep(10,10),
                     rep(11,10)),
                 count=seq(1,110,1))

ul <- ur
ul$x <- ul$x*-1

ll <- ul
ll$y <- ll$y*-1

lr <- ll
lr$x <- lr$x*-1

all <- rbind(ul, ur, ll, lr)



# now w/count, we can subset and add firebrick or grey points
malaria.net <- subset(ul, count>(110-5))
no.malaria.net <- subset(ur, count>(110-87))

malaria.no.net <- subset(ll, count<=9)
no.malaria.no.net <- subset(lr, count<=104)

# do the risk ratio using max from each
RR <- (length(malaria.net$count)/length(no.malaria.net$count))/
  (length(malaria.no.net$count)/length(no.malaria.no.net$count))






# Define UI for application

ui <- navbarPage(
  title=HTML("<a href=\"http://www.designsandmethods.com/book/\" target=_blank>
                            Global Health Research</a>"),
  
  # title=HTML("<img src=logo.png style=width:42px;height:42px;border:0;align:right;>
  #            <a href=\"http://www.designsandmethods.com/book/\" target="_blank">
  #            Global Health Research</a>"),
  
  id="nav",
  #theme="http://bootswatch.com/spacelab/bootstrap.css",
  #inverse=TRUE,
  windowTitle="Shiny GHR",
  collapsible=TRUE,
  
  tabPanel(
    title="Selection Bias App",
    dashboardPage(
      #header=dashboardHeader(title=tags$a(href='http://www.designsandmethods.com/',
      #tags$img(src='logo.png'))),
      header=dashboardHeader(disable=TRUE),
      sidebar=dashboardSidebar(disable = TRUE),
      body=dashboardBody(
        fluidPage(
          
          # Show a forest plot and a table of included values
          
          fluidRow(column(12, align="left",
                          
                          # instructions
                          h4("This Shiny app reproduces the results from the ARC
                             community in Webster, et al. (2003).  The user
                             can manipulate the sliders to increase or decrease
                             the percentage of cases that are misclassified as controls
                             because they had taken chloroquine before visiting the clinic
                             for a fever."
                          ))),
          
          
          fluidRow(column(12, align="center", 
                          
              div(style="display:inline-block",sliderInput("s1", "Number of Misclassifed Cases",
                          min=0, max=87, value=0, step=1)),
              
              
              div(style="display:inline-block", sliderInput("s2", "% of Bednet Group",
                          min=0, max=1, value=0, step=.1)),
                          
              plotOutput("grid")),
              textOutput("nums"))
                          
                          
          )
          
          
          
          )
        )),
  
  tabPanel(
    title="About",
    dashboardPage(
      header=dashboardHeader(disable=TRUE),
      sidebar=dashboardSidebar(disable = TRUE),
      body=dashboardBody(
        fluidPage(
          
          # about text
          fluidRow(column(12, align="left",
                          
                          # credits
                          img(src='logo.png', align = "left"),
                          
                          withTags({
                            
                            div(class="header",
                                
                                p("This app was created by ",
                                  
                                  a("Amy Finnegan",
                                    href="https://sites.google.com/site/amyfinnegan/home", target="_blank"),
                                  
                                  "and Eric Green for the online textbook" ,
                                  
                                  a("Global Health Research: Designs and Methods.",
                                    href="http://www.designsandmethods.com/book/", target="_blank"),
                                  
                                  "It is based on the following systematic review:"),
                                
                                
                                p("Webster, Jayne, Daniel Chandramohan, Tim Freeman, Brian Greenwood, Amin Ullah 
                                  Kamawal, Fazle Rahim, and Mark Rowland. (",
                                  
                                  a("2003",
                                    href="http://onlinelibrary.wiley.com/doi/10.1046/j.1365-3156.2003.01013.x/full",
                                    target="_blank"),
                                  
                                  "). “A Health Facility Based 
                                  Case–control Study of Effectiveness of Insecticide Treated Nets: Potential for 
                                  Selection Bias Due to Pre-Treatment with Chloroquine.” Tropical Medicine & 
                                  International Health 8 (3): 196–201.")
                                
                            )
                                  
                                  
                          })
                          
          ))))))
)


# Define server logic to draw grid and table

server <- function(input, output) {
  
  misclass <- reactive({
    
    pctBYes <- input$s1*input$s2 # number to circle in bednet yes

    pctBNo <- input$s1*(1-input$s2) # number to circle in bednet no

    misclass.net <- subset(no.malaria.net, count>(110-pctBYes))
    misclass.no.net <- subset(no.malaria.no.net, count<=pctBNo)
    
    return(list(misclass.net, misclass.no.net))
    
  })

  
  
  output$grid <- renderPlot({
    
    ggplot(all, aes(x=x, y=y)) +
      geom_point(colour="white", size=10) +
      
      # draw grid
      geom_hline(yintercept=0) +
      geom_vline(xintercept=0) +
      
      # color malaria points
      geom_point(data=malaria.net, color="firebrick", size=5, alpha=0.8) +
      geom_point(data=malaria.no.net, color="firebrick", size=5, alpha=0.8) +
      
      # color no-malaria points
      geom_point(data=no.malaria.net, color="grey25", size=5, alpha=0.5) +
      geom_point(data=no.malaria.no.net, color="grey25", size=5, alpha=0.5) +
      
      # color misclassed points - data in a misclass() reactive list
      geom_point(data=misclass()[[1]], color="firebrick", size=5, shape=1, stroke=1) +
      geom_point(data=misclass()[[2]], color="firebrick", size=5, shape=1, stroke=1) +
      
      labs(title="          Malaria              No Malaria",
           y="Bednet Use \n NO          YES") +
      theme_bw() +
      theme(panel.grid=element_blank(),
            plot.margin=unit(c(2,2,0,2), "cm"),
            legend.position = "none",
            axis.text.x=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.x=element_blank(),
            axis.ticks.y=element_blank(),
            axis.title.x=element_blank(),
            plot.title=element_text(face="bold", size=22),
            axis.title=element_text(face="bold", size=22)) +
      coord_fixed(ratio=1)
    
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
