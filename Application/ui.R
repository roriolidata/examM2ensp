library(shiny)
library(ggplot2)
library(dplyr)
library(bslib)
library(DT)
library(plotly)

thematic::thematic_shiny(font = "auto")

# UI

ui<-fluidPage(theme = bs_theme(
              version = 5,
              bootswatch="minty"),
              
    
    titlePanel("Exploration des Diamants"), # Titre de mon application

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
          radioButtons(
            inputId="rose",
            label="Coloriez les points en rose?",
            choices=c("Oui","Non")
          ),
          
          selectInput(inputId="couleur",
                      label="Choisir une couleur à filtrer:",
                      choices = sort(unique(diamonds$color)), 
                      selected = "D"),
          
            sliderInput(inputId="prix",
                        label="Prix maximum:",
                        min = 300,
                        max = 20000,
                        value = 5000), 
          actionButton(inputId = "bouton", 
                       label = "Visualiser le graph")
          ),
        

        # Main
        mainPanel(
          plotlyOutput(outputId="diamondPlot"),
          DTOutput(outputId="diamondDT")
        )
    )
)

# Serveur

server <- function(input, output) {
  
  rv <- reactiveValues()
  
  observeEvent(input$bouton, {
    
    rv$df<-diamonds |>
      filter(color==input$couleur)|>  #couleur choisie par l'utilisateur
      filter(price<=input$prix) #prix max choisi par l'utilisateur
    
    graph<-rv$df |> 
      ggplot(aes(x=carat,y=price))+
      geom_point(color=ifelse(input$rose=="Oui", "pink","black"))+
      theme(
        axis.title = element_text(size = 16),
        axis.text  = element_text(size = 10),
        plot.title = element_text(size = 18)
      ) +
      labs(title=paste0("prix: ",input$prix," & color: ",input$couleur,"\n")) 
      
    rv$Plot<-ggplotly(graph)
    
    rv$DT<-rv$df[,1:7]
    
    
    })

  output$diamondPlot<-renderPlotly({rv$Plot
       })
  
  output$diamondDT<-renderDT({rv$DT})
  
}
  
# Run the application 
shinyApp(ui = ui, server = server)
