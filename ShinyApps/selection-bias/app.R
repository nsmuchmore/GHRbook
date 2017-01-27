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
          
          
          fluidRow(column(12, align="left",
                          
                          # instructions
                          h4("This Shiny app reproduces results from Webster et al. 
                             (2003), a case-control study of the effectiveness of 
                             insecticide treated nets for the prevention of malaria. 
                             The authors found that some people with malaria pretreat 
                             themselves with chloroquine before coming to the clinic, 
                             thus testing negative for malaria. This represents a 
                             misclassification of malaria cases as controls. Use the 
                             sliders below to see what happens when the rate of 
                             misclassification increases and is associated with reported bednet use."
                          ))),
          
          
          fluidRow(column(12, align="center", 
                          
 
                          
                          
               div(style="display:inline-block",sliderInput("s1", "Number of Misclassifed Cases",
                           min=0, max=30, value=0, step=2)),
              
              
               div(style="display:inline-block", sliderInput("s2", "- Direction of Bias +",
                           min=-1, max=1, value=0, step=.1, ticks=FALSE)))
              ),
          
          # fluidRow(column(12, align="center",
          #                 
          #     div(tableOutput("t1"), style="font-family: Verdana, Geneva, sans-serif"))),
          
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
  
  misclass <- reactive({
    
    if(input$s2==0) {
      pctBYes <- input$s1/2
      pctBNo <- input$s1/2
    }
    if(input$s2 > 0) {
      pctBYes <- input$s1*(abs(input$s2)) # number to circle in bednet yes
      pctBNo <- input$s1*(1-(abs(input$s2))) # number to circle in bednet no
    }
    if(input$s2 < 0) {
      pctBYes <- input$s1*(1-(abs(input$s2)))
      pctBNo <- input$s1*(abs(input$s2))
    }
      

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
    
  })
  
  output$t1 <- renderTable({
    misclass()[[3]]
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
    df2 <- data.frame(x=c(NA,misclass()[[3]][3,3],NA,NA),
                      y=c("", "With\nMisclassification\nBias", "Original", ""))
    
    
    alimits <- data.frame(x1=c(NA,NA,misclass()[[3]][3,4],NA),
                          xend=c(NA,NA,misclass()[[3]][3,5], NA),
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
      #xlim(0,4) +
      xlim(0,ifelse(df2[2,1]+1>df[3,1]+1,df[2,1]+1,df[3,1]+1)) +
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
    

    
    # # original estimate
    # plot(0.66, 2,
    #        pch=19,
    #      xlim=c(0,round(misclass()[[3]][3,5],2)+2.5),
    #      ylim=c(0,3),
    #      yaxt="n",
    #      main="Odds of Malaria given Bednet Use",
    #      xlab="Risk Ratio & 95% CI",
    #      ylab="")
    # segments(0.21, 2, 2.06, 2)
    # text(0.66, 2.2, labels=paste("OR ", "0.66", 
    #                                   "; 95% CI ", "0.21",
    #                                   "-", "2.06",
    #                                   sep=""))
    # text(0.66, 2.4, labels="Original Estimate:")
    # 
    # # estimate after bias
    # points(round(misclass()[[3]][3,3],2), 1, pch=19)
    # segments(round(misclass()[[3]][3,4],2), 1, round(misclass()[[3]][3,5],2), 1)
    # abline(v=1, lty=2)
    # legend(8,3, c("Favors Bednets", "Favors No Bednets"),
    #        pch=19, col=c("purple", "orange"))
    # text(misclass()[[3]][3,3], 1.2, labels=paste("OR ", round(misclass()[[3]][3,3],2), 
    #                                             "; 95% CI ", round(misclass()[[3]][3,4],2),
    #                                             "-", round(misclass()[[3]][3,5],2),
    #                                             sep=""))
    # text(misclass()[[3]][3,3], 1.4, labels="Estimate considering bias:")
    
  })
  

  
}

# Run the application
shinyApp(ui = ui, server = server)
