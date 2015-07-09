library(shiny)

# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Ejemplo de una Prueba de Hipótesis"),
  
  # Sidebar with a slider inputs
  sidebarLayout(
    sidebarPanel(
      sliderInput("n",
                  "Tamaño de la muestra:",
                  min = 10,
                  max = 150,
                  value = 50),
      sliderInput("mH1",
                  "Media, hipótesis Alternativa (m1):",
                  min = 4,
                  max = 14,
                  value = 8,
                  step= 0.2),
      sliderInput("alpha",
                  "Significancia (alpha):",
                  min = 0.01,
                  max = 0.5,
                  value = 0.05,
                  step= 0.005)     
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Distribuciones", plotOutput("distPlot")), 
                  tabPanel("Curva de Potencia", plotOutput("Potencia")),
                  tabPanel("Curva ROC", plotOutput("curvaROC"))
      )
    )
  )
))
