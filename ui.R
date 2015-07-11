library(shiny)

# Definición de la interface gráfica (GUI)
shinyUI(fluidPage(withMathJax(),

  # Application title
  titlePanel("Ejemplo de una Prueba de Hipótesis"),
  
  # Barra lateral con los controles
  sidebarLayout(position = "right",
    sidebarPanel(
      sliderInput("n",
                  "Tamaño de la muestra (n):",
                  min = 10,
                  max = 150,
                  value = 50),
      sliderInput("alpha",
                  "Significancia (alpha):",
                  min = 0.01,
                  max = 0.5,
                  value = 0.05,
                  step= 0.005),
      sliderInput("mH1",
                  "Media, hipótesis Alternativa (mu_1):",
                  min = 4,
                  max = 14,
                  value = 8,
                  step= 0.2),
      checkboxInput('MostrarH1', 'Mostrar hipótesis Alternativa', TRUE)
      
    ),

    # Paneles con las salidas
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Distribuciones", plotOutput("distPlot")), 
                  tabPanel("Curva de Potencia", plotOutput("Potencia")),
                  tabPanel("Curva ROC", plotOutput("curvaROC")),
                  tabPanel("Ecuaciones", uiOutput("Ecuaciones"))
      )
    )
  )
))
