
**Descripción**

Recurso digital para el aprendizaje del concepto de la prueba de hipótesis estadística.

**Objetivo**

Esta aplicación intenta representar gráficamente los fundamentos de la toma de decisiones basadas en las pruebas de hipótesis estadística. En particular se muestra la relación entre las distribuciones de probabilidad del _estadístico de prueba_ para la media de una población con una hipótesis alternativa de cola derecha, por ejemplo: **Ho:"mu=4"** y **H1:"mu>4"**

**Requisitos**

La aplicación está desarrollada en R, por lo que se requiere para su ejecución, tener instalado este lenguaje ([www.r-project.org](https://cran.rstudio.com/)) y [RStudio](https://www.rstudio.com/products/RStudio/#Desktop). Adicionalmente se requiere lo paquete _Shiny_ , un ejemplo de como instalarlo:

```{r}
install.packages("shiny",dependencies=TRUE)
```

**¿Como ejecutar la aplicación?**

A continuación una ejemplo de como ejecutarlo desde el repositorio de _github.com_:

```{r}
library(shiny)
shiny::runGitHub('TestHipotesis', 'josersosa')
```

Para ver adecuadamente las ecuaciones, presione el botón **"Open in Browser"** en la parte superior de la aplicación.
