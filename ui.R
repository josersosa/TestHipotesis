library(shiny)

# Definición de la interface gráfica (GUI)
shinyUI(fluidPage(withMathJax(),

  # Application title
  titlePanel("Ejemplo de una Prueba de Hipótesis"),
  
  # Barra lateral con los controles
  sidebarLayout(position = "right",
    sidebarPanel( withMathJax(
      helpText("El estadístico de prueba usado (la media muestral) se calculará sobre una muestra (evidencia estadística) de tamaño n."),
      sliderInput("n",
                  "Tamaño de la muestra (n):",
                  min = 10,
                  max = 150,
                  value = 50),
      helpText("El nivel de confianza de la prueba (\\(1-\\alpha\\)) suele ser alto, entre un 90% y un 99%. La significancia es el complemeno de este valor (\\(\\alpha\\).)"),
      sliderInput("alpha",
                  "Significancia (alpha):",
                  min = 0.01,
                  max = 0.5,
                  value = 0.05,
                  step= 0.005),
      helpText("La hipótesis alternativa contradice la hipótesis nula, proponiedo un nuevo valor para el parámetro de interes (\\(\\mu\\))."),
      sliderInput("mH1",
                  "Media, hipótesis Alternativa (mu_1):",
                  min = 4,
                  max = 14,
                  value = 8,
                  step= 0.2),
      checkboxInput('MostrarH1', 'Mostrar hipótesis Alternativa', TRUE),
      checkboxInput('AplicacionTest', 'Aplicación del test', FALSE),
      checkboxInput('MostrarParam', 'Otros parámetros', FALSE),
      conditionalPanel(condition = "input.MostrarParam == true",
                       sliderInput(inputId = "RangoX",
                                   label = "Rango de X:",
                                   min = -20, max = 20, value = c(0,14), step = 1),
                       sliderInput(inputId = "RangoY",
                                   label = "Rango de Y:",
                                   min = -0, max = 1, value = c(0,0.5), step = 0.01)
      )      
    )),

    # Paneles con las salidas
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Distribuciones", plotOutput("distPlot")), 
                  tabPanel("Curva de Potencia", plotOutput("Potencia")),
                  tabPanel("Curva ROC", plotOutput("curvaROC")),
                  tabPanel("Ecuaciones", uiOutput("Ecuaciones"))),
      conditionalPanel(condition = "input.AplicacionTest == true",
                       sliderInput(inputId = "EstPrueba",
                                   label = "Valor del estadístico de prueba:",
                                   min = 0, max = 14, value = 4, step = 0.02))
    )
  )
))
