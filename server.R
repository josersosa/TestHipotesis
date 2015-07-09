library(shiny)


shinyServer(function(input, output) {

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
  
  output$distPlot <- renderPlot({
    xlim <- c(0,14)
    ylim <- c(0,0.5)
    sigma <- 10
    alpha <- input$alpha
    n <- input$n
    mH0 <- 4
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
    #pc <- 2.5
    err1 <- 1 -pnorm(pc, mean = mH0, sd = sH0)
    err2 <- pnorm(pc, mean = mH1, sd = sH1)
    
    par(mfrow = c(1,1))
    
    plot(function(x) dnorm(x, mean = mH0, sd = sH0), 
         xlim[1] , xlim[2], 
         main = "Prueba de Hipótesis",
         xlab = "Media muestral",
         ylab = "fdp",
         xlim = xlim, ylim = ylim, 
         col = "blue", 
         lwd = 2)
    
    curve(dnorm(x, mean = mH1, sd = sH1), 
          xlim[1] , xlim[2],
          col = "red", 
          lwd = 2, 
          add = TRUE)
    
    lines(c(mH0, mH0), 
          c(0, dnorm(mH0, mean = mH0, sd = sH0)), 
          col="blue", lwd = 1, lty = "dashed")
    lines(c(mH1, mH1), 
          c(0, dnorm(mH1, mean = mH1, sd = sH1)), 
          col="red", lwd = 1, lty = "dashed")
    
    mtext("Hipótesis Nula verdadera", col="blue", adj = 0)
    mtext("Hipótesis Alternativa verdadera", col = "red", adj = 1)
    text(xlim[2]-2, ylim[2]-0.0, 
         as.expression(substitute(m0==medx,list(medx=mH0))), col="blue")
    text(xlim[2]-2, ylim[2]-0.04, 
         as.expression(substitute(m1==medy,list(medy=mH1))), col="red")
    text(xlim[2]-2, ylim[2]-0.08, 
         as.expression(substitute(alpha==e1,list(e1=err1))), col="blue")
    text(xlim[2]-2, ylim[2]-0.12, 
         as.expression(substitute(beta==e2,list(e2=err2))), col="red")
    text(xlim[2]-2, ylim[2]-0.16, 
         as.expression(substitute(pc==k,list(k=pc))))
    text(xlim[2]-2, ylim[2]-0.2, 
         as.expression(substitute(n==tam,list(tam=n))))
    
    text(mH0, ylim[1]-0.01, "m0")
    text(mH1, ylim[1]-0.01, "m1")
    text(pc, ylim[1]-0.01, "pc")
    
    x <- seq(pc, xlim[2], length.out = 50)
    y <- dnorm(x, mean = mH0, sd = sH0)
    x <- c(x[1],x,x[50])
    y <- c(0,y,0)
    polygon(x, y, density = 20, angle = 45, col = "blue")
    #polygon(x, y, col = "light blue")
    
    x <- seq(xlim[1], pc, length.out = 50)
    y <- dnorm(x, mean = mH1, sd = sH1)
    x <- c(x[1],x,x[50])
    y <- c(0,y,0)
    polygon(x, y, density = 20, angle = -45, col = "red")
    
    withMathJax(helpText('Dynamic output 1:  $$\\alpha^2$$'))
  })
  
  output$Potencia <- renderPlot({
    alpha <- input$alpha
    n <- input$n
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
    
    x <- seq(mH0, xlim[2], length.out = 100)
    y <- 1 - pnorm(pc, mean = x, sd = sH1) # 1-beta
    plot(x,y, 
         main = "Potencia de la Prueba Hipótesis",
         xlab = "Media según Hipótesis Alternativa",
         ylab = "1 - Error tipo II", 
         xlim = xlim, 
         col = "red", lwd = 2, type = "l")
  })
  
  output$curvaROC <- renderPlot({
    alpha <- input$alpha
    n <- input$n
    sH0 <- sigma/sqrt(n)
    mH1 <- input$mH1 
    sH1 <- sigma/sqrt(n)
    #pc <- qnorm(1-alpha, mean = mH0, sd = sH0)
    
    pc <- seq(xlim[1], xlim[2], length.out = 100)
    
    # Falsos positivos: Se rechaza H0 a favor de H1 cuando H0 es verdad 
    fp <- 1- pnorm(pc, mean = mH0, sd = sH0) #Error tipo 1
    # Verdaderos positivos: Se rechaza H0 a favor de H1 cuando H0 es falsa
    vp <- 1- pnorm(pc, mean = mH1, sd = sH1) #1 - Error tipo 2 
    
    plot(fp,vp, 
         main = "Curva ROC de la Prueba Hipótesis",
         xlab = "Falsos Positivos",
         ylab = "Verdaderos Positivos", 
         xlim = c(0,1), 
         col = "blue", lwd = 2, type = "l")
  })

})
