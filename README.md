#TestHipotesis

##Objetivo
Recurso digital para el aprendizaje del concepto de la prueba de hipótesis estadística

##Descripción
Esta aplicación intenta representar gráficamente los fundamentos de la toma de decisiones basadas en las pruebas de hipótesis estadística. En particular se muestra la relación entre las distribuciones de probabilidad del _estadístico de prueba_ para la media de una población con una hipótesis alternativa de cola derecha, por ejemplo: 

$$
\begin{aligned}
H_0 = "\mu = 0" \\
H_1 = "\mu > 0"
\end{aligned} 
$$

En este caso el _estadístico de prueba_ corresponde a la _Media Muestral_, que para una muestra de tamaño _n_ tiene la siguiente formula:

$$
\bar{X} = \frac{\sum_{i=1}^n x_i} {n}  
$$

Sí n>>0, y aplicando el __Teorema Central del Límite__ podemos decir que el _estadístico de prueba_ sigue una distribución de probabilidad _normal_:

$$
\bar{X} \sim Normal(\mu, \frac{\sigma}{\sqrt{n}})  
$$

