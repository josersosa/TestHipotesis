library(shiny)

# Definición de la aplicación servidor
shinyServer(function(input, output, clientData, session) {

  xlim <- c(0,14)
  ylim <- c(0,0.5)
  sigma <- 10
  alpha <- 0.05
  n <- 50
  mH0 <- 4
  sH0 <- sigma/sqrt(n)
  mH1 <- 8 
  sH1 <- sigma/sqrt(n)
  pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
  #pc <- 2.5
  err1 <- 1 -pnorm(pc, mean = mH0, sd = sH0)
  err2 <- pnorm(pc, mean = mH1, sd = sH1)
  
  # Gráfico de las distribuciones
  output$distPlot <- renderPlot({
    xlim <- input$RangoX
    ylim <- input$RangoY
    sigma <- 10
    alpha <- input$alpha
    n <- input$n
    mH0 <- 4
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    if(mH0 <= mH1 ){
      pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
      err1 <- 1 -pnorm(pc, mean = mH0, sd = sH0)
      err2 <- pnorm(pc, mean = mH1, sd = sH1)
    }
    else{
      pc <- qnorm(alpha, mean = mH0, sd = sH0)
      err1 <- pnorm(pc, mean = mH0, sd = sH0)
      err2 <- 1-pnorm(pc, mean = mH1, sd = sH1)
    }  
    mostrarH1 <- input$MostrarH1
    aplicTest <- input$AplicacionTest
    estPrueba <- input$EstPrueba
    
    par(mfrow = c(1,1))
    
    plot(function(x) dnorm(x, mean = mH0, sd = sH0), 
         xlim[1] , xlim[2], 
         main = "Prueba de Hipótesis",
         xlab = "Media muestral",
         ylab = "fdp",
         xlim = xlim, ylim = ylim, 
         col = "blue", 
         lwd = 2)
    lines(c(mH0, mH0), 
          c(0, dnorm(mH0, mean = mH0, sd = sH0)), 
          col="blue", lwd = 1, lty = "dashed")
    
    if(mostrarH1){
      curve(dnorm(x, mean = mH1, sd = sH1), 
            xlim[1] , xlim[2],
            col = "red", 
            lwd = 2, 
            add = TRUE)
      lines(c(mH1, mH1), 
            c(0, dnorm(mH1, mean = mH1, sd = sH1)), 
            col="red", lwd = 1, lty = "dashed")
      mtext("Hipótesis Alternativa verdadera", col = "red", adj = 1)
      text(xlim[2]-2, ylim[2]-0.04, 
           as.expression(substitute(m1==medy,list(medy=mH1))), col="red")
      text(xlim[2]-2, ylim[2]-0.12, 
           as.expression(substitute(beta==e2,list(e2=err2))), col="red")
      text(mH1, ylim[1]-0.01, "m1")
      if(mH0 <= mH1 ){
        x <- seq(xlim[1], pc, length.out = 50)
        y <- dnorm(x, mean = mH1, sd = sH1)
        x <- c(x[1],x,x[50])
        y <- c(0,y,0)
        polygon(x, y, density = 20, angle = -45, col = "red")
      }
      else{
        x <- seq( pc, xlim[2], length.out = 50)
        y <- dnorm(x, mean = mH1, sd = sH1)
        x <- c(x[1],x,x[50])
        y <- c(0,y,0)
        polygon(x, y, density = 20, angle = -45, col = "red")
      }
    }      
    mtext("Hipótesis Nula verdadera", col="blue", adj = 0)    
    text(xlim[2]-2, ylim[2]-0.0, 
         as.expression(substitute(m0==medx,list(medx=mH0))), col="blue")    
    text(xlim[2]-2, ylim[2]-0.08, 
         as.expression(substitute(alpha==e1,list(e1=err1))), col="blue")    
    text(xlim[2]-2, ylim[2]-0.16, 
         as.expression(substitute(pc==k,list(k=pc))))
    text(xlim[2]-2, ylim[2]-0.2, 
         as.expression(substitute(n==tam,list(tam=n))))
    
    text(mH0, ylim[1]-0.01, "m0")
    text(pc, ylim[1]-0.01, "pc")
    
    if(mH0 <= mH1 ){
      x <- seq(pc, xlim[2], length.out = 50)
      y <- dnorm(x, mean = mH0, sd = sH0)
      x <- c(x[1],x,x[50])
      y <- c(0,y,0)
      polygon(x, y, density = 20, angle = 45, col = "blue")
    }
    else{
      x <- seq(xlim[1], pc, length.out = 50)
      y <- dnorm(x, mean = mH0, sd = sH0)
      x <- c(x[1],x,x[50])
      y <- c(0,y,0)
      polygon(x, y, density = 20, angle = 45, col = "blue")
    }
    
    if(aplicTest){
      if(mH0 <= mH1 ){
        if(estPrueba>=pc){
          colPrueba <- "red"
          text(estPrueba, 0.15, "Se rechaza H0",col=colPrueba)
        } 
        else{
          colPrueba = "blue"
          text(estPrueba, 0.15, "No se rechaza H0",col=colPrueba)
        }
      }
      else{
        if(estPrueba<=pc){
          colPrueba <- "red"
          text(estPrueba, 0.15, "Se rechaza H0",col=colPrueba)
        } 
        else{
          colPrueba = "blue"
          text(estPrueba, 0.15, "No se rechaza H0",col=colPrueba)
        }
      } 
      lines(c(estPrueba, estPrueba), 
            c(0, 0.1), 
            col=colPrueba, lwd = 2, lty = "dashed")
      text(estPrueba, 0.12, "X",col=colPrueba)
    }

  })
  
  # Gráfico de la potencia de la prueba
  output$Potencia <- renderPlot({
    xlim <- input$RangoX
    alpha <- input$alpha
    n <- input$n
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    if(mH0 <= mH1 ){
      pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
      x <- seq(mH0, xlim[2], length.out = 100)
      y <- 1 - pnorm(pc, mean = x, sd = sH1) # 1-beta
      plot(x,y, 
           main = "Potencia de la Prueba Hipótesis",
           xlab = "Media según Hipótesis Alternativa",
           ylab = "1 - Error tipo II", 
           xlim = xlim, 
           col = "red", lwd = 2, type = "l")
    }
    else{
      pc <- qnorm(alpha, mean = mH0, sd = sH0)
      x <- seq(xlim[1], mH0, length.out = 100)
      y <- pnorm(pc, mean = x, sd = sH1) # 1-beta
      plot(x,y, 
           main = "Potencia de la Prueba Hipótesis",
           xlab = "Media según Hipótesis Alternativa",
           ylab = "1 - Error tipo II", 
           xlim = xlim, 
           col = "red", lwd = 2, type = "l")
    }
    
  })
  
  # Gráfico de la curva ROC
  output$curvaROC <- renderPlot({
    alpha <- input$alpha
    n <- input$n
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    #pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
    
    pc <- seq(xlim[1], xlim[2], length.out = 100)
    if(mH0 <= mH1 ){
      # Falsos positivos: Se rechaza H0 a favor de H1 cuando H0 es verdad 
      fp <- 1- pnorm(pc, mean = mH0, sd = sH0) #Error tipo 1
      # Verdaderos positivos: Se rechaza H0 a favor de H1 cuando H0 es falsa
      vp <- 1- pnorm(pc, mean = mH1, sd = sH1) #1 - Error tipo 2
    }
    else{
      # Falsos positivos: Se rechaza H0 a favor de H1 cuando H0 es verdad 
      fp <- pnorm(pc, mean = mH0, sd = sH0) #Error tipo 1
      # Verdaderos positivos: Se rechaza H0 a favor de H1 cuando H0 es falsa
      vp <- pnorm(pc, mean = mH1, sd = sH1) #1 - Error tipo 2
    }
        
    plot(fp,vp, 
         main = "Curva ROC de la Prueba Hipótesis",
         xlab = "Falsos Positivos",
         ylab = "Verdaderos Positivos", 
         xlim = c(0,1), 
         col = "blue", lwd = 2, type = "l")
  })
  
  # Despliegue de las ecuaciones
  output$Ecuaciones <- renderUI({
    sigma <- 10
    alpha <- input$alpha
    n <- input$n
    mH0 <- 4
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    if(mH0 <= mH1 ){
      pc <- round(qnorm(1-alpha, mean = mH0, sd = sH0), 2)
      err1 <- round(1 -pnorm(pc, mean = mH0, sd = sH0), 2)
      err2 <- round(pnorm(pc, mean = mH1, sd = sH1), 2)
      aplicTest <- input$AplicacionTest
      estPrueba <- input$EstPrueba
      if(aplicTest){
        pval <- 1-pnorm(estPrueba, mean = mH0, sd = sH0) 
        if(pval<=err1){
          withMathJax(
            sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu>%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
            sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
            sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
            sprintf('Punto crítico (pc) de la región de rechazo: $$pc = Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
            sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
            sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2),
            sprintf('P-valor: $$ p_{valor} = P( \\bar{X} \\geq %.02f \\ | \\ \\mu=%.02f) \\\\ = 1 - F_z(\\frac{%.02f-\\mu}{\\frac{\\sigma}{\\sqrt{n}}}) = %.02f \\\\ p_{valor} \\leq \\alpha $$', estPrueba, mH0, estPrueba, pval),
            sprintf('Resultado de la Prueba: $$ Hay \\ evidencia \\ muestral \\ suficiente \\ para \\ rechazar \\ H_0 $$')
          )
        }
        else {
          withMathJax(
            sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu>%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
            sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
            sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
            sprintf('Punto crítico (pc) de la región de rechazo: $$pc = Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
            sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
            sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2),
            sprintf('P-valor: $$ p_{valor} = P( \\bar{X} \\geq %.02f \\ | \\ \\mu=%.02f) \\\\ = 1 - F_z(\\frac{%.02f-\\mu}{\\frac{\\sigma}{\\sqrt{n}}}) = %.02f \\\\ p_{valor} > \\alpha $$', estPrueba, mH0, estPrueba, pval),
            sprintf('Resultado de la Prueba: $$ No \\ hay \\ evidencia \\ muestral \\ suficiente \\ para \\ rechazar \\ H_0 $$')
          )
        }
        
      }
      else{
        withMathJax(
          sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu>%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
          sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
          sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
          sprintf('Punto crítico (pc) de la región de rechazo: $$pc = Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
          sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
          sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2) 
        )
      }
    }
    else{
      pc <- round(qnorm(alpha, mean = mH0, sd = sH0), 2)
      err1 <- round(pnorm(pc, mean = mH0, sd = sH0), 2)
      err2 <- round(1-pnorm(pc, mean = mH1, sd = sH1), 2)
      aplicTest <- input$AplicacionTest
      estPrueba <- input$EstPrueba
      if(aplicTest){
        pval <- pnorm(estPrueba, mean = mH0, sd = sH0) 
        if(pval<=err1){
          withMathJax(
            sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu<%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
            sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
            sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
            sprintf('Punto crítico (pc) de la región de rechazo: $$pc = -Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
            sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
            sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2),
            sprintf('P-valor: $$ p_{valor} = P( \\bar{X} \\geq %.02f \\ | \\ \\mu=%.02f) \\\\ = F_z(\\frac{%.02f-\\mu}{\\frac{\\sigma}{\\sqrt{n}}}) = %.02f \\\\ p_{valor} \\leq \\alpha $$', estPrueba, mH0, estPrueba, pval),
            sprintf('Resultado de la Prueba: $$ Hay \\ evidencia \\ muestral \\ suficiente \\ para \\ rechazar \\ H_0 $$')
          )
        }
        else {
          withMathJax(
            sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu<%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
            sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
            sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
            sprintf('Punto crítico (pc) de la región de rechazo: $$pc = -Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
            sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
            sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2),
            sprintf('P-valor: $$ p_{valor} = P( \\bar{X} \\leq %.02f \\ | \\ \\mu=%.02f) \\\\ = F_z(\\frac{%.02f-\\mu}{\\frac{\\sigma}{\\sqrt{n}}}) = %.02f \\\\ p_{valor} > \\alpha $$', estPrueba, mH0, estPrueba, pval),
            sprintf('Resultado de la Prueba: $$ No \\ hay \\ evidencia \\ muestral \\ suficiente \\ para \\ rechazar \\ H_0 $$')
          )
        }
        
      }
      else{
        withMathJax(
          sprintf('Definición de las Hipótesis: $$H_0:"\\mu=%.02f"\\\\H_1:"\\mu<%.02f" \\\\ \\sigma = 10$$', mH0, mH0),
          sprintf('Nivel de confianza: $$1-\\alpha = %.02f$$', 1-alpha),
          sprintf('Estadístico de prueba: $$\\bar{X} = \\frac{\\sum_{i=1}^n x_i}{n} \\sim Normal(\\mu,\\frac{\\sigma}{\\sqrt{n}})$$'),
          sprintf('Punto crítico (pc) de la región de rechazo: $$pc = -Z_{1-\\alpha}\\frac{\\sigma}{\\sqrt{n}} + \\mu = %.02f $$',pc),
          sprintf('Error Tipo I: $$P(Rechazar \\ H_0 \\ | \\ H_0 \\ es \\ Verdadera) = \\alpha \\\\ = P( \\bar{X} < %.02f \\ | \\ \\mu=%.02f) = %.02f $$', pc, mH0,  err1),
          sprintf('Error Tipo II: $$ P(Aceptar \\ H_0 \\ | \\ H_0 \\ es \\ Falsa) = \\beta \\\\ = P( \\bar{X} > %.02f \\ | \\ \\mu=%.02f)= %.02f $$', pc, mH1, err2),
        )
      }
    }  
  })
  
  observe({
    RangoX <- input$RangoX
    updateSliderInput(session, "mH1",
                      min = RangoX[1])
    updateSliderInput(session, "EstPrueba",
                      min = RangoX[1])
  })

})
