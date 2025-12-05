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

fluidPage(theme = bs_theme(
  version = 5,
  bootswatch="minty"
),

    # Application title
    titlePanel("Exploration des Diamands"),

    # Sidebar 
    sidebarLayout(
        sidebarPanel(
          radioButtons(
            inputId="rose",
            label="Cloriez les points en rose?",
            choices=c("oui","non")
          ),
          actionButton(inputId = "bouton", 
                       label = "Visualiser le graph"),

            sliderInput(inputId="prix",
                        label="Prix maximum:",
                        min = 0,
                        max = 10000,
                        value = 5000), 
          selectInput(inputId="couleur",
                      label="Choisir une couleur à filtrer",c("D", "E","F","G","H","I","J"), #on aurait pu utiliser levels(dimaonds$color) mais l'ordre n'aurait peut-être pas été le même que sur l'appli
                      selected = "D", multiple = FALSE, selectize = TRUE)),
        

        # Main
        mainPanel(
          textOutput(outputId = "nbtext"),
          plotOutput(outputId="diamondPlot"),
          DTOutput(outputId="diamondDT")
        )
    )
)

# Serveur

server <- function(input, output) {
  
  rv <- reactiveValues(df = NULL)
  
  observeEvent(input$bouton, {
    rv$df<-diamonds |>
      filter(color==input$couleur & prix==input$prix)
    colorisation<-ifelse(input$rose=="Oui", "pink","black")
    rv$Dplot<-ggplot(rv$df,
                     aes(x=carat,y=price))+
              geom_point(couleur=colorisation)+
              theme_minimal()+
              labs(titre=paste0("prix: ",{input$prix}," & color: ",{input$couleur}))+
              plotl
    rv$DDT<-  
      })

  output$plot<-renderPlot({rv$Dplot})
  output$DT<-renderDT({rv$DDT})
  
}
  

