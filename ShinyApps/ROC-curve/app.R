## Only run examples in interactive R sessions

library(ggplot2)
library(plotly)


BDI <- data.frame(cutoff=c(NA,11,12,13,14,15,16,17,18,19,20,NA),
                  specificity=c(0, 0.588, 0.638, 0.686,
                                0.739, 0.774, 0.794,
                                0.829, 0.866, 0.906, 0.930, 1),
                  sensitivity=c(1, 0.849, 0.830, 0.811,
                                0.774, 0.745, 0.679,
                                0.623, 0.575, 0.557, 0.500, 0),
                  PPV=c(0, 0.324, 0.348, 0.376, 0.408,
                        0.434, 0.434, 0.458, 0.500,
                        0.578, 0.624, 1),
                  NPV=c(1, 0.944, 0.942, 0.940, 0.934, 0.929,
                        0.914, 0.904, 0.898, 0.898, 0.889, 0))

CDI <- data.frame(cutoff=c(NA,47,48,50,52,53,54,56,57,58,NA),
                  specificity=c(0, 0.456, 0.474, 0.553,
                                0.662, 0.667, 0.735,
                                0.750, 0.785, 0.831, 1),
                  sensitivity=c(1, 0.868, 0.868, 0.792,
                                0.689, 0.689, 0.594,
                                0.594, 0.509,
                                0.472, 0))


  
  ui <- fluidPage(
    
    
            mainPanel(
              
              fluidRow(
                column(12, align="center",
                    plotlyOutput("ROC", width="700px", height="700px")
                       )
              )
                

                
            )
                
   )
  
  server <- function(input, output) {


    output$ROC <- renderPlotly({
      
      
print(
  ggplotly(
    
    ggplot(CDI, aes(x=1-specificity, y=sensitivity, text=cutoff)) +
      geom_line() +
      geom_line(aes(x=1-specificity, y=sensitivity), data=BDI,
                linetype="dashed") +
      xlim(0,1) +
      ylim(0,1) +
      labs(title="ROC Curves for Comparison",
           x="1-Specificity",
           y="Sensitivity") +
      geom_abline(intercept=0, slope=1) +
      annotate(geom="text", x=0.17, y=0.9, label="better than random", size=7) +
      annotate(geom="text", x=0.6, y=0.26, label="worse than random", size=7) +
      annotate(geom="text", x=0.75, y=0.70, label="no diagnostic benefit", size=7) +
      theme_bw() +
      theme(plot.title=element_text(hjust=0.5, size=rel(2)),
            axis.title=element_text(size=20),
            panel.grid.major=element_line(color="lightgrey"),
            panel.grid.minor=element_blank()) +
      coord_fixed(ratio=1)
    
  )
)

      
      
    })

    
    
  }
  
  shinyApp(ui, server)



