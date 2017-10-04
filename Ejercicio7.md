Se realiza un experimento para estudiar la efectividad de un nuevo tipo de somnífero, para lo cual se administra el mismo a 6 pacientes, mientras que a otros 6 se les da un somnífero estándar y a 6 más un placebo, durante una semana. En la tabla 6.33 se recogen las medias del número de horas de
sueño en las 7 noches para los 18 pacientes. (a=placebo, b= estándar, c=nuevo). Analiza los datos y comenta los resultados.

Representamos los datos con un BOXPLOT para observar su distribución de manera gráfica. Podemos ver que la distribución de Nuevo y Estandar parece similar, con Placebo teniendo horas de sueño por debajo de las otras dos.

Respecto a un análisis de las medias, obtendremos la comparación de ambos tipos de somnífero contra el control que ofrece el Placebo.

    PROC ANOVA;
    CLASS TIPO;
    MODEL HSUENYO=TIPO;
    MEANS TIPO/DUNNETT('Placebo');

PROC ANOVA nos proporciona de paso con el resultado del test de la hipótesis nula de que las medias de los tres grupos es igual, con un valor Pr > F 0.0003 podemos descartar esta hipótesis.

El test de DUNNETT ofrece intervalos de confianza para las diferencias de medias $\mu_{Placebo} - \mu_{i}$ siendo $i$ Estándar y Nuevo.

Los resultados de este test nos permiten rechazar la hipótesis de que cualquiera de los somníferos no tienen ningún efecto, ya que hay diferencias significativas entre ambos y el placebo a un nivel de confianza del 95%.

Sabiendo esto, realizamos un test de la T para comprobar si existen diferencias significativas entre las medias del somnífero estándar y del nuevo. Haremos esto mediante un contraste $L=0\mu{Placebo} + \mu_{Nuevo} - \mu_{Estándar}$. Si este contraste tiene valor 0, implica que las medias son iguales. Obtenemos además el estimador de $L$, que nos permite conocer, en caso de no ser 0, si L es positivo (el nuevo somnífero es mejor) o negativo (peor). CLPARM nos permite además obtener un intervalo de confianza para el estimador.

    PROC GLM;
    CLASS TIPO;
    MODEL HSUENYO=TIPO/CLPARM;
    CONTRAST 'Eficacia de somnifero nuevo' TIPO -1 1 0;
    ESTIMATE 'Eficacia de somnifero nuevo' TIPO -1 1 0;

El resultado del test sobre el contraste da un Pr > F del 0.7665, por lo que no podemos rechazar la hipótesis de que los dos somníferos tienen la misma eficacia. Por tanto, con un nivel de confianza del 95% podemos afirmar que el nuevo somnífero no tiene un efecto significativo respecto a un somnífero estándar.

El estimador nos informa de que el somnífero nuevo produce 0.183 horas de sueño menos que el estándar, con un error de +/- 1.2921 horas. Esto coloca al efecto del nuevo somnífero entre 1.47 horas peor y 1.10 horas mejor que el estándar.
