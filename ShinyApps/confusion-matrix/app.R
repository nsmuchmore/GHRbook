## Only run examples in interactive R sessions
  
  ui <- fluidPage(
    
    
            mainPanel(
              
              fluidRow(
                
                       
                
                column(3,
              
              
              h3("Depression Dx"),
                 
              div(style="display:vertical-align:top; width: 150px;",
                  numericInput("a", "True Positive", 79, min=0, max=106)),
             
              div(style="display:vertical-align:top; width: 150px;",
              numericInput("c", "False Negative", 27, min=0, max=106)),
             
              h4("Sensitivity"),
               h4("True Positive Rate (TPR)"),
             
             div(style="display:vertical-align:top; width: 150px;",
                 verbatimTextOutput("TPR")),
            
              h4("False Negative Rate (FNR)"),
              h4("1-sensitivity ="),
            
              div(style="display:vertical-align:top; width: 150px;",
                  verbatimTextOutput("FNR"))
                ),
             
             column(3,
                    
                    h3("No Depression Dx"),
                    
                    numericInput("b", "False Positive", 103, min=0, max=456),
                    
                    numericInput("d", "True Negative", 353, min=0, max=456),
                    
                    h4("Specificity"),
                    h4("True Negative Rate (TNR)"),
                    
                    verbatimTextOutput("TNR"),
                    
                    h4("False Positive Rate (FPR)"),
                    h4("1-specificity ="),
                    
                    verbatimTextOutput("FPR")
                    
                    ),
             
             column(3,
                    
                    #h3("x"),
                    
                    h4("Positive Predictive Value (PPV)"),
                    verbatimTextOutput("PPV"),
                    
                    h4("Negative Predictive Value (NPV)"),
                    verbatimTextOutput("NPV"),
                    
                    h4("Prevalence"),
                    verbatimTextOutput("prevalence"),
                    
                    h4("Accuracy"),
                    verbatimTextOutput("accuracy")
             
             ),
             
             column(3,
                    
                    h4("False Discovery Rate (FDR)"),
                    h4("1-PPV ="),
                    
                    verbatimTextOutput("FDR"),
                    
                    h4("False Omission Rate (FOR)"),
                    h4("1-NPV ="),
                    
                    verbatimTextOutput("FOR"),
                    
                    h4("Pos Likelihood Ratio (LR+)"),
                    h4("TRP/FPR"),
                    
                    verbatimTextOutput("PLR"),
                    
                    h4("Neg Likelihood Ratio (LR-)"),
                    h4("FNR/TNR"),
                    
                    verbatimTextOutput("NLR")
                    
                    )
             
             
             
             
    )

  )
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
    
    output$PLR <- renderText({  round(input$a/(input$a+input$c)/(1-(input$d/(input$b+input$d))), 2) })
    output$NLR <- renderText({  round(round(1-(input$a/(input$a+input$c)), 2)/round(input$d/(input$b+input$d), 2), 2) })
    
    
  }
  
  shinyApp(ui, server)



