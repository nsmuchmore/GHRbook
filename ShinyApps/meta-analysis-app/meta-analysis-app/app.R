# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# this app uses analysis 1.6 from http://onlinelibrary.wiley.com/wol1/doi/10.1002/14651858.CD000169.pub3/figures
# to explore how a meta-analysis works
# created by: Amy Finnegan
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# try using 

# setup =======================================================================

require(dplyr)
require(magrittr)
require(xlsx)
require(reshape2)
require(ggplot2)
require(RColorBrewer)
library(shiny)
library(data.table)


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
        
         # Fleming 
         sliderInput("A",
                     "Fleming (1986)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.08),
         
         # Greenwood
         sliderInput("B",
                     "Greenwood (1989)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.50),
         
         # Nahlen 
         sliderInput("C",
                     "Nahlen (1989)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.96),
         
         # Parise I
         sliderInput("D",
                     "Parise I (1998)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.36),
         
         # Parise II 
         sliderInput("E",
                     "Parise II (1998)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.25),
         
         # Shulman 
         sliderInput("F",
                     "Shulman (1999)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.15),
         
         # Njagi I
         sliderInput("G",
                     "Njagi I (2003)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.79),
         
         # Njagi II
         sliderInput("H",
                     "Njagi II (2003)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.44),
         
         # Challis 
         sliderInput("I",
                     "Challis (2004)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.44),
         
         # Menendez 
         sliderInput("J",
                     "Menendez (2008)",
                     min = 0,
                     max = 10,
                     step = 0.01,
                     value = 0.57)
         
         
         
      ),
      
      
      
      
      
      
      # Show a plot of the generated distribution
      mainPanel(
        
        dataTableOutput("table"),
        
         plotOutput("forestPlot")
         
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
       labs(title="Risk Ratio for Change in Parasitaemia (mother)",
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

