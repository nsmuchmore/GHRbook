# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses analysis 1.6 from http://onlinelibrary.wiley.com/wol1/doi/10.1002/14651858.CD000169.pub3/figures
# to explore how a meta-analysis works
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# try using 

# setup =======================================================================

require(dplyr)
require(magrittr)
require(ggplot2)
library(shiny)


# default data ================================================================


#study <- rep(LETTERS[1:10], length=10)
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

In <- c(2, 4, 6, 34, 22, 30, 28, 22, 18, 18)
IN <- c(106, 21, 23, 348, 327, 567, 172, 148, 208, 133)
Cn <- c(5, 5, 6, 48, 48, 199, 35, 45, 40, 30)
CN <- c(22, 13, 22, 178, 177, 564, 170, 134, 203, 127)
weight <- c(0.045, 0.067, 0.077, 0.12, 0.115, 0.122, 0.116, 0.116, 0.111, 0.11)

raw <- data.frame(
  study=study,
  In=as.numeric(In),
  IN=as.numeric(IN),
  Cn=as.numeric(Cn),
  CN=as.numeric(CN),
  weight=as.numeric(weight)
)

raw$IOR <- raw$In/raw$IN
raw$COR <- raw$Cn/raw$CN
raw$RR <- round(raw$IOR/raw$COR, 2)




# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Meta-Analysis"),
   
   # sliders for impact of each study
   
   sidebarLayout(
      sidebarPanel(
        
        helpText("Use the dropdown menu and slider to change
                 the risk ratio (RR) for a study.  The table
                 and graphic will update with new values."),
        
        # select a study
        selectInput("study", "Choose study::",
                    choices=levels(raw$study),
                    selectize=TRUE,
                    selected=NULL),
        
        sliderInput("RR",
                    "Change Risk Ratio (RR)",
                    min = 0,
                    max = 10,
                    step = 0.01,
                    value = 0.08),
        
        actionButton("update", "Update")
        
      ),
      
      
      
      
      
      
      # Show a plot of the generated distribution
      mainPanel(
        
        plotOutput("forestPlot"),
        
        dataTableOutput("table")
        

         
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$table <- renderDataTable({
    
    raw %>%
      select(study, weight, RR)
    
  })
   
   output$forestPlot <- renderPlot({

     # plot
     ggplot(raw, aes(x=RR, y=reorder(study, -weight))) +
       geom_point(shape=15, size=(weight*100)/2, color="blue") +
       xlim(0,2.5) +
       labs(title=paste0("Risk Ratio & 95% CI\n",
            "Outcome: Parasitaemia (mother)"),
            y="Study", 
            x="Risk Ratio") +
       theme_bw() +
       theme(
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         panel.background = element_blank()
       ) +
       geom_vline(xintercept=1)
     
   })
   
   

}

# Run the application 
shinyApp(ui = ui, server = server)

