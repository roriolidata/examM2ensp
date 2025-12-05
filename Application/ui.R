#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

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
                      label="Choisir une couleur à filtrer",
                      c("D", "E","F","G","H","I","J"), #on aurait pu utiliser levels(dimaonds$color) mais l'ordre n'aurait peut-être pas été le même que sur l'appli
                      selected = "D"),
          
            sliderInput(inputId="prix",
                        label="Prix maximum:",
                        min = 0,
                        max = 10000,
                        value = 5000), 
          actionButton(inputId = "bouton", 
                       label = "Visualiser le graph")
          ),
        

        # Main
        mainPanel(
          plotOutput(outputId="diamondPlot"),
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
    
    rv$Plot<-rv$df |> 
      ggplot(aes(x=carat,y=price))+
      geom_point(color=ifelse(input$rose=="Oui", "pink","black"))+
      theme_grey(base_size=12)+
      theme(
        panel.background = element_rect(fill = "#EBEBEB", color = NA),
        plot.background  = element_rect(fill = "white",   color = NA),
        panel.grid.major = element_line(color = "white", size = 0.5),
        axis.title = element_text(size = 16),
        axis.text  = element_text(size = 12),
        plot.title = element_text(size = 18)
      ) +
      labs(title=paste0("prix: ",input$prix," & color: ",input$couleur,"\n"))
      
    rv$DT<-rv$df[,1:7]
    
    
    })

  output$diamondPlot<-renderPlot({rv$Plot
       })
  
  output$diamondDT<-renderDT({rv$DT})
  
}
  
# Run the application 
shinyApp(ui = ui, server = server)
