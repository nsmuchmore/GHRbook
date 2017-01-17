# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses the example from
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
                          h4("This Shiny app reproduces..."
                          ))),
          
          
          fluidRow(column(12, align="center",
                          
                          actionButton("smallN", "Small Sample",
                                       style="color: #fff; background-color: #E7A34D"),
                          
                          actionButton("noEffect", "No effect",
                                       style="color: #fff; background-color: #6781CF"),
                          
                          actionButton("favorsControl", "Favours Control",
                                       style="color: #fff; background-color: #6781CF"),
                          
                          actionButton("reset", "Reset to original values", icon("undo"),
                                       style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                          
                          tags$style(type="text/css", "#noEffect { margin-left: 2px; }"),
                          
                          plotOutput("forestPlot", width="100%")
                          
                          
          )
          
          
          
          )
        )))),
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
  
  values <- reactiveValues(default=default)
  
  observeEvent(input$reset, {
    
    values$default <- default
    
  })
  
  observeEvent(input$smallN, {
    
    values$default$Ty[values$default$study==toChange] <- 3
    values$default$Cy[values$default$study==toChange] <- 20
    
    values$default$TN[values$default$study==toChange] <- 57
    values$default$CN[values$default$study==toChange] <- 56
    
    
  })
  
  
  observeEvent(input$noEffect, {
    
    values$default$Ty[values$default$study==toChange] <- 200
    values$default$Cy[values$default$study==toChange] <- 199
    
    values$default$TN[values$default$study==toChange] <- 567
    values$default$CN[values$default$study==toChange] <- 564
    
  })
  
  observeEvent(input$favorsControl, {
    
    values$default$Ty[values$default$study==toChange] <- 500
    values$default$Cy[values$default$study==toChange] <- 50
    
    values$default$TN[values$default$study==toChange] <- 567
    values$default$CN[values$default$study==toChange] <- 564
    
  })
  
  
  output$forestPlot <- renderPlot({
    
    # plot
    
    mh<-  metabin(event.e=values$default$Ty, n.e=values$default$TN, event.c=values$default$Cy, n.c=values$default$CN)
    mh$studlab <- as.character(values$default$study)
    
    forest(mh, studlab = T, comb.fixed=F,
           col.square=ifelse(mh$studlab=="Shulman (1999)", "orange", "blue"),
           col.diamond="black",
           squaresize=0.5,
           text.random="Summary",
           plotwidth="4cm",
           label.right="Favours control", col.label.right="black",
           label.left="Favours chemoprevention", col.label.left="black",
           lab.e="Intervention", lab.c="Control"
    )
    
    
  })
  
  
  
}

# Run the application
shinyApp(ui = ui, server = server)
