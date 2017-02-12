# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses Kim (2014)
# to plot a confusion matrix
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




# setup =======================================================================

library(dplyr)
library(magrittr)
library(shiny)
library(shinydashboard)
  
layoutPct <- c("10%", "20%", "20%", "20%", "25%")

# app =========================================================================


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
    title="Confusion Matrix",
    dashboardPage(
      #header=dashboardHeader(title=tags$a(href='http://www.designsandmethods.com/',
      #tags$img(src='logo.png'))),
      header=dashboardHeader(disable=TRUE),
      sidebar=dashboardSidebar(disable = TRUE),
      body=dashboardBody(
  
         fluidPage( 
           
           fluidRow(column(12, align="left",
                           
                           h4("This Shiny app displays a confusion matrix.")
                           )),
           
           fluidRow(
    
    hr(),
    
    # headings - row 1
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                
                #1. nothing
                h3(""),
                
                #2. Depression Dx
                h4("Depression Dx"),
                
                #3. No Depression Dx
                h4("No Depression Dx"),
                
                #4. Nothing
                h3(""),
                
                #5. Nothing
                h3("")),
    
    hr(),
    
    #headings - row 2
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                
                #1. POS
                h3("Pos"),
                
                #2. True Pos
                h5("True Positive (a)"),
                
                #3. False Pos
                h5("False Positive (b)"),
                
                #4. PPV
                h5("Positive Predictive", br(), "Value (PPV)", br(),
                   "a/(a+b)"),
                
                #5. FDR
                h5("False Discovery", br(), 
                   "Rate (FDR)", br(), 
                   "1-PPV")),
    
    
    # values - row 2
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                
                #1. POS
                h3(""),
                
                #2. True Pos
                numericInput("a", label=NULL, 79, min=0, max=182),
                
                #3. False Pos
                numericInput("b", label=NULL, 103, min=0, max=182),
                
                #4. PPV
                verbatimTextOutput("PPV"),
                
                #5. FDR
                verbatimTextOutput("FDR")),
    
    hr(),
    
    # headings - row 3
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                
                #1. NEG
                h3("Neg"),
                
                #2. False Neg
                h5("False Negative (c)"),
                
                #3. True Neg
                h5("True Negative (d)"),
                
                #4. NPV
                h5("Negative Predictive", br(), 
                   "Value (NPV)", br(),
                   "c/(c+d)"),
                
                #5. FOR
                h5("False Omission", br(), 
                   "Rate (FOR)", br(),
                   "1-NPV")),
    
    # values - row 3
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                
                #1. NEG
                h3(""),
                
                #2. False Neg
                numericInput("c", label=NULL, 27, min=0, max=380),
                
                #3. True Neg
                numericInput("d", label=NULL, 353, min=0, max=380),
                
                #4. NPV
                verbatimTextOutput("NPV"),
                
                #5. FOR
                verbatimTextOutput("FOR")), 
    
    hr(),
    
    # headings - row 4
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                #1. nothing
                h3(""),
                
                #2. TPR
                h5("Sensitivity", br(), "True Positive Rate (TPR)", br(),
                   "a/(a+c)"),
                
                #3. TNR
                h5("Specificity", br(), "True Negative Rate (TNR)", br(),
                   "d/(b+d)"),
                
                #4. Prevalence
                h5("Prevalence", br(),
                   "(a+c)/(b+d)"),
                
                #5. LR+
                h5("Pos Likelihood", br(), 
                   "Ratio (LR+)", br(),
                   "TPR/FPR")),
    
    # values - row 4
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                #1. nothing
                h3(""),
                
                #2. TPR
                verbatimTextOutput("TPR"),
                
                #3. TNR
                verbatimTextOutput("TNR"),
                
                #4. Prevalence
                verbatimTextOutput("prevalence"),
                
                #5. LR+
                verbatimTextOutput("PLR")),
    
    hr(),
    
    # headings - row 5
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                #1. nothing
                h3(""),
                
                #2. FNR
                h5("False Negative Rate (FNR)", br(),
                   "1-sensitivity"),
                
                #3. FPR
                h5("False Positive Rate (FPR)", br(),
                   "1-specificity"),
                
                #4. Accuracy
                h5("Accuracy", br(),
                   "(a+c)/(b+d)"),
                
                #5. LR-
                h5("Neg Likelihood Ratio (LR-)", br(),
                   "FNR/TNR")),
    
    # values - row 5
    splitLayout(cellWidths=layoutPct,
                
                align="center",
                
                #1. nothing
                h3(""),
                
                #2. FNR
                verbatimTextOutput("FNR"),
                
                #3. FPR
                verbatimTextOutput("FPR"),
                
                #4. Accuracy
                verbatimTextOutput("accuracy"),
                
                #5. LR-
                verbatimTextOutput("NLR")),
    
    hr()
                
                
                
  ))
      ))),
  
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
                                
                                
                                
                                p("Kim, et al. (",
                                  
                                  a("2014",
                                    href="http://jiasociety.org/index.php/jias/article/view/18965/3868",
                                    target="_blank"),
                                  
                                  "). Prevalence of Depression and Validation of the Beck Depression 
                                  Inventory-Ii and the Children’s Depression Inventory-Short Amongst 
                                  Hiv-Positive Adolescents in Malawi.” Journal of the International AIDS Society 17 (1).")
                                
                                
                                )
                          })
                          
          ))))))
  )

    

  
  
  server <- function(input, output) {

    # column 1
    output$TPR <- renderText({ round(input$a/(input$a+input$c), 2) })
    output$FNR <- renderText({ round(1-(input$a/(input$a+input$c)), 2) })
    
    # column 2
    output$TNR <- renderText({ round(input$d/(input$b+input$d), 2) })
    output$FPR <- renderText({ round(1-(input$d/(input$b+input$d)), 2) })
    
    # column 3
    output$PPV <- renderText({ round(input$a/(input$a+input$b), 2)  })
    output$NPV <- renderText({  round(input$c/(input$c+input$d), 2) })
    
    output$prevalence <- renderText({ round((input$a+input$c)/(input$b+input$d), 2)  })
    output$accuracy <- renderText({ round((input$a+input$d)/(input$a+input$b+input$c+input$d), 2)  })
    
    # column 4
    output$FDR <- renderText({ 1-round(input$a/(input$a+input$b), 2) })
    output$FOR <- renderText({ 1-round(input$c/(input$c+input$d), 2) })
    
    output$PLR <- renderText({  round((input$a/(input$a+input$c))/(1-(input$d/(input$b+input$d))), 2) })
    output$NLR <- renderText({  round(round(1-(input$a/(input$a+input$c)), 2)/round(input$d/(input$b+input$d), 2), 2) })
    
    
  }
  
  shinyApp(ui, server)



