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





# Define UI for application 
ui <- fluidPage(
  
  # Application title
  titlePanel("Meta-Analysis"),

  
    
    
    # Show a forest plot and a table of included values
    mainPanel(
      plotOutput("forestPlot", width="100%"),
      
      helpText("Using the check boxes, exclude a study from the meta-analysis by unchecking it.  
               Watch as the summary updates.  
               How does the overall summary Risk Ratio depend on the included studies?"),
      
      checkboxGroupInput("study",
                         label = "Check studies to exclude",
                         choices=levels(default$study),
                         selected=levels(default$study))
      
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
  

  
  output$forestPlot <- renderPlot({
    
    # plot
    
    mh<-  metabin(event.e=toPlot()$Ty, n.e=toPlot()$TN, event.c=toPlot()$Cy, n.c=toPlot()$CN)
    mh$studlab <- as.character(toPlot()$study)
    
    forest(mh, studlab = T, comb.fixed=F, 
           col.square="blue",
           col.diamond="black",
           squaresize=0.5
             )

    
  }, height = 400, width = 700)
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)