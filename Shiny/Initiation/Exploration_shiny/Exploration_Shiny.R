#    https://shiny.posit.co/

library(shiny)
library(terra)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 100,
                        value = 10),
            
            sliderInput("bins2",
                        "Nombre d'entrée:",
                        min = 1,
                        max = 100,
                        value = 10)
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("hist"),
          plotOutput("plot"),
          dataTableOutput("tab")
           
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$hist <- renderPlot({
        # generate bins based on input$bins from ui.R
      candy <- read.csv2("candy.csv")
        x    <- as.numeric(candy[, 11])
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'green', border = 'white',
             xlab = 'Taux de sucre',
             main = 'Pourcentage de sucre par bonbon')
    })
    output$plot <- renderPlot({
    y <- as.numeric(candy[,13])
    bins2 <- seq(min(y), max(y), length.out = input$bins2 + 1)
    plot(y, col = 'gold',
         xlab = 'Pourcentage de victoire',
         main = 'victoire')
    })
    output$tab <- renderDataTable({
      candy_tab <- candy[,11:13]
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
