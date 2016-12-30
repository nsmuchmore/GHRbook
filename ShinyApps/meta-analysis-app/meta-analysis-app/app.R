# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses analysis 1.6 from http://onlinelibrary.wiley.com/wol1/doi/10.1002/14651858.CD000169.pub3/figures
# to explore how a meta-analysis works
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# try using 

# setup =======================================================================

library(dplyr)
library(magrittr)
library(ggplot2)
library(shiny)

# default data ================================================================


# default data set


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


year <- c(1986, 1989, 1989, 1998,
          1998, 1999, 2003, 2003,
          2004, 2008)

# treatment - yes, no, N
Ty <- c(2, 4, 6, 34, 
        22, 30, 28, 22, 
        18, 18)
TN <- c(106, 21, 23, 348, 
        327, 567, 172, 148, 
        208, 133)
Tno <- TN-Ty

# control - yes, no, N
Cy <- c(5, 5, 6, 48, 
        48, 199, 35, 45, 
        40, 30)
CN <- c(22, 13, 22, 178, 
        177, 564, 170, 134, 
        203, 127)
Cno <- CN-Cy

# weight
weight <- c(0.045, 0.067, 0.077, 0.12, 
            0.115, 0.122, 0.116, 0.116, 
            0.111, 0.11)



default <- data.frame(
  study=study,
  year=year,
  Ty=as.numeric(Ty),
  Tno=as.numeric(Tno),
  TN=as.numeric(TN),
  Cy=as.numeric(Cy),
  Cno=as.numeric(Cno),
  CN=as.numeric(CN),
  weight=as.numeric(weight)
)


# this does all the pieces needed for the plot --------------------------------
default <- 
  default %>%
  mutate(RR = round((Ty/TN)/(Cy/CN), 2),
         ciUpper=round(exp(log(RR)+1.96*(sqrt((Tno/(Ty*TN)) + ((Cno/(Cy*CN)))))), 2),
         ciLower=round(exp(log(RR)-1.96*(sqrt((Tno/(Ty*TN)) + ((Cno/(Cy*CN)))))), 2)
  )

# this calculates the summary -------------------------------------------------
# make a summary matrix that will be updated based on the default data frame
# when the default data frame changes, the summary value should change too
  summary <- as.data.frame(matrix(0, ncol=length(default), nrow=1))
  colnames(summary) <- colnames(default)
  summary$study <- c("Summary")
  summary$RR <- round(sum(default$RR*(default$Ty+default$CN))/sum(default$TN+default$CN), 2)
  
  # data frame of prior + summary
  toPlot <- as.data.frame(rbind(default, summary))


# Define UI for application that ddefaults a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Meta-Analysis"),
   
   # sliders for impact of each study
   
   sidebarLayout(
      sidebarPanel(
        
        # helpText("Use the dropdown menu and slider to change
        #          the risk ratio (RR) for a study.  The table
        #          and graphic will update with new values."),
        
        helpText("Use the check boxes to exclude a study a 
                 study from the meta-analysis.  Watch as the summary updates."),
        
        # # select a study
        # selectInput("study", "Choose study to exclude:",
        #             choices=c("Fleming (1986)", 
        #                       "Greenwood (1989)",
        #                       "Nahlen (1989)",
        #                       "Parise I (1998)",
        #                       "Parise II (1998)",
        #                       "Shulman (1999)",
        #                       "Njagi I (2003)",
        #                       "Njagi II (2003)",
        #                       "Challis (2004)",
        #                       "Menendez (2008)"),
        #             selected=NULL,
        #             selectize=TRUE),
        
        checkboxGroupInput("study",
                           label = "Check studies to exclude",
                           choices=levels(default$study),
                           selected=levels(default$study))
        
        # sliderInput("RR",
        #             "Change Risk Ratio (RR)",
        #             min = 0,
        #             max = 10,
        #             step = 0.01,
        #             value = 0.44),
        

        
      ),
      
      
      
      
      
      
      # Show a plot of the generated distribution
      mainPanel(
        
        plotOutput("forestPlot"),
        
        dataTableOutput("table")
        

         
      )
   )
)

# Define server logic to draw forestplot and table

server <- function(input, output) {
  
  
  # group of studies to consider
  toPlot <- reactive({
    a <- subset(default, default$study %in% input$study)
    a <- droplevels(a)
    return(a)
  })
  
  
  # recalculate summary w/excluded study

  
  output$table <- renderDataTable({
    
    
    toPlot() %>%
      select(study, weight, RR)
                  
    
  })
   
   output$forestPlot <- renderPlot({

     # plot
     
    toPlot() %>%
     ggplot(., aes(x=RR, y=factor(study, levels=toPlot()$study))) +
       geom_point(shape=15, size=(toPlot()$weight*20), color="blue") +
       
       # summary has 0 weight so this prints over it
       geom_point(aes(x=summary$RR, y=summary$study), shape=18, size=10, color="black") +
       
       geom_errorbarh(aes(xmax=toPlot()$ciUpper, xmin=toPlot()$ciLower, height=0)) +
       xlim(0,10) +
       labs(title=paste0("Risk Ratio & 95% CI\n",
                         "Outcome: Parasitaemia (mother)"),
            y="Study", 
            x="Risk Ratio") +
       
       
       theme_bw() +
       theme(
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         panel.background = element_blank(),
         plot.title = element_text(hjust=0.5)
       ) +
       geom_vline(xintercept=1)
     
   })
   
   

}

# Run the application 
shinyApp(ui = ui, server = server)

