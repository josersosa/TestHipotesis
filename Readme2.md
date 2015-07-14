#TestHipostesis

##Descripción
Recurso digital para el aprendizaje del concepto de la prueba de hipótesis estadística.

## ¿Como ejecutar la aplicación?
Se requiere el paquete _Shiny_ para ejecutar esta aplicación. A continuación una ejemplo de como ejecutarlo desde el repositorio de **github.com**:

```{r}
#installpackages("shiny", dependencies=TRUE)
library(shiny)

# Forma rapida de ejecutar la aplicación
shiny::runGitHub('TestHipotesis', 'josersosa')

# O desde el zip o tar.gz
runUrl("https://github.com/josersosa/TestHipotesis/archive/master.zip")
runUrl("https://github.com/josersosa/TestHipotesis/archive/master.tar.gz")
```

Si desdea descargar el proyecto, puede ejecutarlo localmente, suponiendo que lo clonó en el directorio personal sería así:

```{r}
setwd("~/TestHipotesis")
runApp()
```


##Objetivo
Esta aplicación intenta representar gráficamente los fundamentos de la toma de decisiones basadas en las pruebas de hipótesis estadística. En particular se muestra la relación entre las distribuciones de probabilidad del _estadístico de prueba_ para la media de una población con una hipótesis alternativa de cola derecha, por ejemplo: Ho:"mu=4" y H1:"mu>4"

$$
\begin{aligned}
H_0 = "\mu = 0" \\
H_1 = "\mu > 0"
\end{aligned} 
$$

En este caso el _estadístico de prueba_ corresponde a la _Media Muestral_, que para una muestra de tamaño _n_ tiene la siguiente formula:

$$
\bar{X} = \frac{\sum_{i=1}^n x_i} {n} \sim Normal(\mu, \frac{\sigma}{\sqrt{n}}) 
$$

Sí n>>0, y aplicando el __Teorema Central del Límite__ podemos decir que el _estadístico de prueba_ sigue una distribución de probabilidad _normal_:

$$
\bar{X} \sim Normal(\mu, \frac{\sigma}{\sqrt{n}})  
$$

La región de rechazo (cola de la derecha) se cálcula en base al nivel de significancia de la prueba y asumiendo que la hipóstesis nula es verdadera, su punto crítico es:

$$
pc = F_z^{-1}(1-\alpha)\frac{\sigma}{\sqrt{n}} + \mu
$$

Los errores inferenciales dependen del verdadero estado de la Hipótesis Nula:

Error de tipo 1:

$$
P(Rechazar \ H_0 \ | \ H_0 \ es \ Verdadera) = \alpha \\ 
= P( \bar{X} > pc \ | \ \mu=4)
$$

Error de tipo 2:

$$
P(Aceptar \ H_0 \ | \ H_0 \ es \ Falsa) = \beta \\ 
= P( \bar{X} < pc \ | \ \mu=8)
$$
