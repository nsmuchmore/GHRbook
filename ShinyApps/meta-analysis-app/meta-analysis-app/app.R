# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses analysis 1.6 from http://onlinelibrary.wiley.com/wol1/doi/10.1002/14651858.CD000169.pub3/figures
# to explore how a meta-analysis works
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




# setup =======================================================================

library(dplyr)
library(magrittr)
library(ggplot2)
library(shiny)
library(meta)

# default data ================================================================

study <- c("Fleming (1986)",
           "Greenwood (1989)",
           "Nahlen (1989)",
           "Parise I (1998)",
           "Parise II (1998)",
           "Shulman (1999)",
           "Njagi I (2003)",
           "Njagi II (2003)",
           "Challis (2004)",
           "Menendez (2008)")

# treatment - yes, no, N
Ty <- c(2, 4, 6, 34,
        22, 30, 28, 22,
        18, 18)
TN <- c(106, 21, 23, 348,
        327, 567, 172, 148,
        208, 133)


# control - yes, no, N
Cy <- c(5, 5, 6, 48,
        48, 199, 35, 45,
        40, 30)
CN <- c(22, 13, 22, 178,
        177, 564, 170, 134,
        203, 127)




default <- data.frame(
  study=study,
  Ty=as.numeric(Ty),
  TN=as.numeric(TN),
  Cy=as.numeric(Cy),
  CN=as.numeric(CN)
)


# set the study you want to manipulate with the app by name
toChange <- "Shulman (1999)"



# Define UI for application
ui <- fluidPage(


  # Application title
  titlePanel("Meta-Analysis"),

  # Show a forest plot and a table of included values
  fluidRow(column(12,

                  plotOutput("forestPlot", width="100%"),

                  # instructions
                  helpText("Use the buttons below to explore what happens to the meta-analysis
                            results when Shulman (1999) has no effect, when the intervention 
                            results favour the control and when the Shulman (1999) study has 
                            the same risk ratio but was a much smaller study."
                  )
  ),

  actionButton("noEffect", "No effect"),
  actionButton("favorsControl", "Favours Control"),
  actionButton("smallN", "Small Sample"),
  actionButton("reset", "Reset to original values."),
  tags$style(type="text/css", "#noEffect { margin-left: 25px; }"),
  tags$hr()


  )
                  )


# Define server logic to draw forestplot and table

server <- function(input, output) {
  
  values <- reactiveValues(default=default)
  
  observeEvent(input$reset, {

    values$default <- default
    
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
  
  observeEvent(input$smallN, {
    
    values$default$Ty[values$default$study==toChange] <- 3
    values$default$Cy[values$default$study==toChange] <- 20
    
    values$default$TN[values$default$study==toChange] <- 57
    values$default$CN[values$default$study==toChange] <- 56
    
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


# 
# 
# # :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# # this app uses analysis 1.6 from http://onlinelibrary.wiley.com/wol1/doi/10.1002/14651858.CD000169.pub3/figures
# # to explore how a meta-analysis works
# # created by: Amy Finnegan
# # :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# 
# 
# # try using
# 
# # setup =======================================================================
# 
# library(dplyr)
# library(magrittr)
# library(ggplot2)
# library(shiny)
# library(meta)
# library(miniUI)
# library(shinyjs)
# 
# # default data ================================================================
# 
# study <- c("Fleming (1986)",
#            "Greenwood (1989)",
#            "Nahlen (1989)",
#            "Parise I (1998)",
#            "Parise II (1998)",
#            "Shulman (1999)",
#            "Njagi I (2003)",
#            "Njagi II (2003)",
#            "Challis (2004)",
#            "Menendez (2008)")
# 
# # treatment - yes, no, N
# Ty <- c(2, 4, 6, 34,
#         22, 30, 28, 22,
#         18, 18)
# TN <- c(106, 21, 23, 348,
#         327, 567, 172, 148,
#         208, 133)
# 
# 
# # control - yes, no, N
# Cy <- c(5, 5, 6, 48,
#         48, 199, 35, 45,
#         40, 30)
# CN <- c(22, 13, 22, 178,
#         177, 564, 170, 134,
#         203, 127)
# 
# 
# 
# 
# default <- data.frame(
#   study=study,
#   Ty=as.numeric(Ty),
#   TN=as.numeric(TN),
#   Cy=as.numeric(Cy),
#   CN=as.numeric(CN)
# )
# 
# 
# # set the study you want to manipulate with the app by name
# toChange <- "Shulman (1999)"
# 
# 
# 
# 
# # Define UI for application
# ui <- miniPage(
# 
#   # Application title
#   miniTitleBar("Meta-Analysis"),
# 
#   # check boxes to select studies to exclude
# 
# 
#   miniTabstripPanel(
# 
#     miniTabPanel("Parameters", icon=icon("sliders"),
# 
#                  useShinyjs(),
#                  id="defaults",
# 
#     miniContentPanel(
# 
#       # Show a forest plot and a table of included values
#       fluidRow(column(12,
# 
#                       # instructions
#                       helpText("Shulman (1999), mentioned in the text, was the largest study of
#                                those in the meta-analysis.  The RR was 0.15 and the 95% confidence
#                                interval was relatively small (95% CI: 0.10, 0.22) due to the large
#                                number of individuals in the trial.  Use the sliders
#                                below to change the number of people in each group and the
#                                number of events in each group.",
# 
#                                "1. What happens to the RR for Shulman (1999)
#                                if 100 people in the Intervention group got Parasitaemia?",
#                                "Reset the study to the original values.",
#                                "2. What happens to the confidence interval if the risk ratio of the study
#                                 stays the same, but the study was smaller? (hint: reset the Intervention Event to
#                                 3, the Control Event to 20, the Intervention N to 57 and the Control N to 56).",
#                                 "If you forget the original values, scroll up in the book."
#                       )
# 
#                       ),
# 
#                actionButton("reset", "Reset to original values."),
#                tags$hr()
# 
# 
#                ),
# 
#       fluidRow(
# 
#         column(6,
#                  sliderInput("Tevent",
#                              label = "Intervention Event",
#                              min=1, max=max(default$TN),
#                              value=default$Ty[default$study==toChange],
#                              step=1, width="50%")),
# 
#         column(6,
#                  sliderInput("Cevent",
#                              label = "Control Event",
#                              min=1, max(default$CN),
#                              value=default$Cy[default$study==toChange],
#                              step=1, width="50%"))
# 
# 
#       ),
# 
#       fluidRow(
# 
#         column(6,
#                  sliderInput("TN",
#                              label = "Intervention N",
#                              min=1, max=max(default$TN),
#                              value=default$TN[default$study==toChange],
#                              step=1, width="50%")),
# 
#         column(6,
#                  sliderInput("CN",
#                              label = "Control N",
#                              min=1, max(default$CN),
#                              value=default$CN[default$study==toChange],
#                              step=1, width="50%"))
# 
#       )
#   )
#   ),
# 
#   miniTabPanel("Visualize", icon=icon("area-chart"),
# 
#                miniContentPanel(
# 
#                 plotOutput("forestPlot", width="100%")
# 
#                ))
# 
#   )
# 
# )
# 
# # Define server logic to draw forestplot and table
# 
# server <- function(input, output) {
# 
# 
#   observeEvent(input$reset, {
#     shinyjs::reset("defaults")
#   })
# 
# 
#   # group of studies to consider
#   toPlot <- reactive({
# 
#     a <- default
#     a$Ty[a$study==toChange] <- input$Tevent
#     a$Cy[a$study==toChange] <- input$Cevent
# 
#     a$TN[a$study==toChange] <- input$TN
#     a$CN[a$study==toChange] <- input$CN
# 
#     return(a)
#   })
# 
# 
#   output$forestPlot <- renderPlot({
# 
#     # plot
# 
#     mh<-  metabin(event.e=toPlot()$Ty, n.e=toPlot()$TN, event.c=toPlot()$Cy, n.c=toPlot()$CN)
#     mh$studlab <- as.character(toPlot()$study)
# 
#     forest(mh, studlab = T, comb.fixed=F,
#            col.square="blue",
#            col.diamond="black",
#            squaresize=0.5,
#            text.random="Summary",
#            plotwidth="4cm",
#            label.right="Favours control", col.label.right="black",
#            label.left="Favours chemoprevention", col.label.left="black",
#            lab.e="Intervention", lab.c="Control"
#     )
# 
# 
# 
#   })
# 
# 
# 
# }
# 
# # Run the application
# shinyApp(ui = ui, server = server)
