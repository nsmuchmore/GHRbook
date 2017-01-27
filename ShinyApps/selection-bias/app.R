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
library(DT)
library(plotly)



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

# function to change values ===================================================

vals <- function(pctBYes, pctBNo) {
  
  misclass.net <- subset(no.malaria.net, count>(110-pctBYes))
  misclass.no.net <- subset(no.malaria.no.net, count<=pctBNo)
  
  a <- round(5+pctBYes,0)
  b <- round(87-pctBYes, 0)
  c <- round(9+pctBNo, 0)
  d <- round(104-pctBNo, 0)
  
  
  # table of RR
  df <- data.frame(Cases=c(a,c,NA),
                   Controls=c(b,d,NA),
                   RR=c(a/b, c/d, (a/b)/(c/d)),
                   CIL=c(NA,NA, exp(log((a/b)/(c/d))-1.96*(sqrt(1/a+1/b+1/c+1/d)))),
                   CIU=c(NA, NA, exp(log((a/b)/(c/d))+1.96*(sqrt(1/a+1/b+1/c+1/d)))))
  
  rownames(df) <- c("Bednet", "No Bednet", "Odds of Malaria")
  colnames(df) <- c("Cases", "Controls", "RR", "95% CI Lower", "95% CI Upper")
  
  return(list(misclass.net, misclass.no.net, df))
  
}

misclass <- vals(0,0)

# Define UI for application ===================================================

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
          
          
          fluidRow(column(12, align="left",
                          
                          # instructions
                          h4("This Shiny app reproduces results from Webster et al. 
                             (2003), a case-control study of the effectiveness of 
                             insecticide treated nets for the prevention of malaria. 
                             The authors found that some people with malaria pretreat 
                             themselves with chloroquine before coming to the clinic, 
                             thus testing negative for malaria. This represents a 
                             misclassification of malaria cases as controls. Use the 
                             buttons below to see what happens when the rate of 
                             misclassification changes and is associated with reported bednet use."
                          ))),
          
          
          fluidRow(column(12, align="center", 
                          
 
               actionButton("one4", "1:4",
                            style="color: #fff; background-color: #E7A34D"),
               
               actionButton("two3", "2:3",
                            style="color: #fff; background-color: #E7A34D"),
               
               actionButton("fifty50", "1:1",
                            style="color: #fff; background-color: #337ab7"),
               
               actionButton("three2", "3:2",
                            style="color: #fff; background-color: #6781CF"),
               
               actionButton("four1", "4:1",
                            style="color: #fff; background-color: #6781CF"),
               
               actionButton("reset", "Ignore Bias", icon("undo"),
                            style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
               
               tags$style(type="text/css", "#noEffect { margin-left: 2px; }")
              )),
          
          
          fluidRow(align="center",
            splitLayout(cellWidths=c("50%", "50%"),
              plotOutput("forestPlot"),
              plotOutput("grid")))
                          
                          
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
                                  
                                  "It is based on the following article:"),
                                
                                
                                p("Webster, J., Chandramohan, D., Freeman, T., Greenwood, B., Kamawal, A.U., 
                                  Rahim, F., & Rowland, M. (",
                                  
                                  a("2003",
                                    href="http://onlinelibrary.wiley.com/doi/10.1046/j.1365-3156.2003.01013.x/full",
                                    target="_blank"),
                                  
                                  "). “A health facility based case–control study of effectiveness of 
                                  insecticide treated nets: Potential for selection bias due to 
                                  pre-treatment with chloroquine. Tropical Medicine & International Health, 
                                  8 (3), 196–201.")
                                
                            )
                                  
                                  
                          })
                          
          ))))))
)


# Define server logic to draw grid and table

server <- function(input, output) {
  
  # generic values
  values <- reactiveValues(misclass=misclass)
  
  observeEvent(input$reset, {
    
    values$misclass <- misclass
    
  })
  
  
  # 1:4
  observeEvent(input$one4, {
    
              values$misclass <- vals(6,24)
    
  })
  
  # 2:3
  observeEvent(input$two3, {
    
              values$misclass <- vals(12,18)
  
    })
  
  # 50:50
  observeEvent(input$fifty50, {
    
              values$misclass <- vals(15,15)
    })
  
  # 3:2
  observeEvent(input$three2, {
               
               values$misclass <- vals(18,12)
    })
  
  # 1:4
  observeEvent(input$four1, {
    
              values$misclass <- vals(24,6)
    
  })
  
    
  # in case you want to re-introduce the table
  output$t1 <- renderTable({
    values$misclass[[3]]
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
      geom_point(data=values$misclass[[1]], color="firebrick", size=5, shape=1, stroke=1) +
      geom_point(data=values$misclass[[2]], color="firebrick", size=5, shape=1, stroke=1) +
      
      labs(title="      Cases           Controls",
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
  
  output$forestPlot <- renderPlot({
    
    # original
    df <- data.frame(x=c(NA,NA,0.66,NA),
                     y=c("", "With\nMisclassification\nBias", "Original", ""))
    
    olimits <- data.frame(x1=c(NA,NA,0.21,NA),
                          xend=c(NA,NA,2.06, NA),
                          y1=rep("Original", 4),
                          yend=rep("Original", 4))
    
    # adjusted
    df2 <- data.frame(x=c(NA,values$misclass[[3]][3,3],NA,NA),
                      y=c("", "With\nMisclassification\nBias", "Original", ""))
    
    
    alimits <- data.frame(x1=c(NA,NA,values$misclass[[3]][3,4],NA),
                          xend=c(NA,NA,values$misclass[[3]][3,5], NA),
                          y1=rep("With\nMisclassification\nBias", 4),
                          yend=rep("With\nMisclassification\nBias", 4))
    
    
    ggplot(df, aes(x=x, y=y)) +
      geom_point(color="black") +
      
      # add adjusted
      geom_point(data=df2, color="#6781CF") +
      
      # line of no effect
      geom_vline(xintercept=1) +
      
      geom_segment(aes(x=x1, y=y1, xend=xend, yend=yend),
                   data=olimits) +
      
      geom_segment(aes(x=x1, y=y1, xend=xend, yend=yend,
                       colour="red"),
                   data=alimits) +
      
      # xlimits & labels
      xlim(0,8) +
      #xlim(0,ifelse(df2[2,1]+1>df[3,1]+1,df[2,1]+1,df[3,1]+1)) +
      labs(title="Odds of Malaria",
           x="Odds Ratio & 95% CI") +
      
      # theme stuff
      theme_bw() +
      theme(panel.grid=element_blank(),
            plot.margin=unit(c(2,2,0,2), "cm"),
            legend.position = "none",
            
            axis.text.y=element_text(face="bold", size=15),
            axis.text.x=element_text(face="bold", size=15),
            
            axis.ticks.y=element_blank(),
            axis.title.y=element_blank(),
            axis.title.x=element_text(face="bold", size=15),
            
            plot.title=element_text(face="bold", size=22, hjust=0.5))
    

    
    
  })
  

  
}

# Run the application
shinyApp(ui = ui, server = server)
