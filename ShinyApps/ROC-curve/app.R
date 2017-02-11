## Only run examples in interactive R sessions

library(ggplot2)
library(plotly)


BDI <- data.frame(scale=rep("BDI", 12),
                  cutoff=c("max",11,12,13,14,15,16,17,18,19,20,"min"),
                  specificity=c(0, 0.588, 0.638, 0.686,
                                0.739, 0.774, 0.794,
                                0.829, 0.866, 0.906, 0.930, 1),
                  sensitivity=c(1, 0.849, 0.830, 0.811,
                                0.774, 0.745, 0.679,
                                0.623, 0.575, 0.557, 0.500, 0))
rownames(BDI) <- BDI$cutoff


CDI <- data.frame(scale=rep("CDI", 11),
                  cutoff=c("max",47,48,50,52,53,54,56,57,58,"min"),
                  specificity=c(0, 0.456, 0.474, 0.553,
                                0.662, 0.667, 0.735,
                                0.750, 0.785, 0.831, 1),
                  sensitivity=c(1, 0.868, 0.868, 0.792,
                                0.689, 0.689, 0.594,
                                0.594, 0.509,
                                0.472, 0))
rownames(CDI) <- CDI$cutoff


  
  ui <- fluidPage(
    
    
            mainPanel(
              
              fluidRow(
                column(12, align="center",
                    plotlyOutput("ROC", width="900px", height="700px")
                       )
              )
                

                
            )
                
   )
  
  server <- function(input, output) {

    #http://stackoverflow.com/questions/38733403/edit-labels-in-tooltip-for-plotly-maps-using-ggplot2-in-r
    output$ROC <- renderPlotly({
      
         
         gg <-
         ggplot(CDI, aes(x=1-specificity, y=sensitivity, group=scale, color=scale, text = paste("Cut Point:", cutoff))) +
           geom_line() +
           geom_point() +
           geom_line(aes(x=1-specificity, y=sensitivity), data=BDI,
                     linetype="dashed") +
           geom_point(aes(1-specificity, y=sensitivity), data=BDI) +
           xlim(0,1) +
           ylim(0,1) +
           labs(title="ROC Curves for Comparison",
                x="1-Specificity",
                y="Sensitivity") +
           geom_abline(intercept=0, slope=1) +
           annotate(geom="text", x=0.17, y=0.9, label="better than random", size=7) +
           annotate(geom="text", x=0.7, y=0.28, label="worse than random", size=7) +
           annotate(geom="text", x=0.75, y=0.70, label="no diagnostic benefit", size=7) +
           theme_bw() +
           scale_colour_manual(values=c("black", "black")) +
           theme(plot.title=element_text(hjust=0.5, size=rel(2)),
                 axis.title=element_text(size=20),
                 panel.grid.major=element_line(color="lightgrey"),
                 panel.grid.minor=element_blank(),
                 legend.position="bottom")
         
         
          ggplotly(gg, tooltip=c("text"))
      

    

    

      
      
    })
    
    

    
    
  }
  
  shinyApp(ui, server)



