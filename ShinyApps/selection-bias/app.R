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

mNet <- 15
mNoNet <-36
  
noMNet <- 77
noMNoNet <- 77

RR <- round((mNet/noMNet)/(mNoNet/noMNoNet), 2)

se <- sqrt(1/mNet + 1/mNoNet + 1/noMNet + 1/noMNoNet)

ciUpper <- round(exp(log(RR)+(1.96*se)), 2)
ciLower <- round(exp(log(RR)-(1.96*se)), 2)
  




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
                          min=0, max=35, value=0, step=1)),
              
              
              div(style="display:inline-block", sliderInput("s2", "Favors Treatment or Control",
                          min=-1, max=1, value=0, step=.1)),
                          
              plotOutput("RRPlot")),
              tableOutput("nums"))
                          
                          
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


# Define server logic to draw forestplot and table

server <- function(input, output) {
  
  
  
  RR.bias <- reactive({
    
    mNet <- mNet
    mNoNet <- mNoNet
    
    # favors control (input$s2 > 0), subtract from no malaria group and add to malaria group
    # favors treatment (input$s2 < 0), subtract from malaria group and add to no malaria group
    
    mNoNet <- ifelse(input$s2 > 0, mNoNet-(input$s1*abs(input$s2)), mNoNet+(input$s1*abs(input$s2)))
    noMNoNet <- ifelse(input$s2 > 0, noMNoNet+(input$s1*abs(input$s2)), noMNoNet-(input$s1*abs(input$s2)))
    
    # old w/2 sliders
    # netBias <- noMNet*input$s1
    # noNetBias <- noMNoNet*input$s2
    # 
    # mNet <- 5 + netBias
    # mNoNet <- 9 + noNetBias
    # 
    # noMNet <- 87 - netBias
    # noMNoNet <- 104 - noNetBias
    # 
    RR <- round((mNet/noMNet)/(mNoNet/noMNoNet), 2)
    
    se <- sqrt(1/mNet + 1/mNoNet + 1/noMNet + 1/noMNoNet)
    
    ciUpper <- round(exp(log(RR)+(1.96*se)), 2)
    ciLower <- round(exp(log(RR)-(1.96*se)), 2)
    
    df <- data.frame(RR=RR,
                    ciUpper=ciUpper,
                    ciLower=ciLower)
    
    return(df)
    
  })
  
  
  

  output$RRPlot <- renderPlot({
    
    # adjusted estimate
    plot(RR.bias()$RR, 1,
         xlim=c(0,ifelse(RR.bias()$ciUpper < 10, 10, RR.bias()$ciUpper+1)),
         ylim=c(0,3),
         yaxt="n",
         main="Risk of Malaria given Bednet Use",
         xlab="Risk Ratio",
         ylab="",
         pch=19,
         col=ifelse(RR.bias()$ciUpper < 1, "purple", 
                    ifelse(RR.bias()$ciLower > 1, "orange", "black")))
    segments(RR.bias()$ciLower, 1, RR.bias()$ciUpper, 1)
    abline(v=1, lty=2)
    legend(8,3, c("Favors Bednets", "Favors No Bednets"),
           pch=19, col=c("purple", "orange"))
    text(RR.bias()$ciUpper+1, 1.2, labels=paste("OR ", RR.bias()$RR, 
                           "; 95% CI ", RR.bias()$ciLower,
                           "-", RR.bias()$ciUpper,
                           sep=""))
    text(RR.bias()$ciUpper+1, 1.4, labels="Estimate considering bias:")
    
    # original estimate
    points(RR, 2,
           pch=19)
    segments(ciLower, 2, ciUpper, 2)
    text(ciUpper+1, 2.2, labels=paste("OR ", RR, 
                                                "; 95% CI ", ciLower,
                                                "-", ciUpper,
                                                sep=""))
    text(ciUpper+1, 2.4, labels="Original Estimate:")
    
  })
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
