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

thematic::thematic_shiny(font = "auto")

# Define UI for application that draws a histogram
fluidPage(theme = bs_theme(
  version = 5,
  bootswatch="minty"
),

    # Application title
    titlePanel("Exploration des Diamands"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          radioButtons(
            inputId="rose",
            label="Cloriez les points en rose?",
            choices=c("oui","non")
          ),

            sliderInput(inputId="prix",
                        label="Prix maximum:",
                        min = 0,
                        max = 10000,
                        value = 5000), 
          selectInput(inputId="couleur",
                      label="Choisir une couleur à filtrer",c("D", "E","F","G","H","I","I"),selected = NULL, multiple = FALSE, selectize = TRUE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)
