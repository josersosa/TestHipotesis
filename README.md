
Recurso digital para el aprendizaje del concepto de la prueba de hipótesis estadística.

Esta aplicación intenta representar gráficamente los fundamentos de la toma de decisiones basadas en las pruebas de hipótesis estadística. En particular se muestra la relación entre las distribuciones de probabilidad del _estadístico de prueba_ para la media de una población con una hipótesis alternativa de cola derecha, por ejemplo: **Ho:"mu=4"** y **H1:"mu>4"**


**¿Como ejecutar la aplicación?**
Se requiere el paquete _Shiny_ para ejecutar esta aplicación. A continuación una ejemplo de como ejecutarlo desde el repositorio de **github.com**:

```{r}
#install.packages("shiny")
library(shiny)
shiny::runGitHub('TestHipotesis', 'josersosa')
```

Para ver adecuadamente las ecuaciones, presione el botón **"Open in Browser"** en la parte superior de la aplicación.
