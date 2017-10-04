/*
 * University: Universidad de Valladolid
 * Degree: Grado en Estadística
 * Subject: Regresión y ANOVA
 * Year: 2017/18
 * Author: Cuervo Fernández, Esther
 * Author: García Prado, Sergio
 * Author: Martín Villares, Pablo
 * Name: Práctica ANOVA 1F - Aquacultura
 *
 */


/**
 * Enunciado:
 * 
 * Se quiere estudiar el efecto de distintas dosis de un medicamento para 
 * combatir a los parásitos de peces criados en acuicultura. Para ello, se 
 * tomaron 60 peces al azar, y se dividieron en 5 grupos de 12 individuos cada
 * uno. El primer grupo no fue medicado, pero a los restantes se les suministró 
 * el medicamento en dosis crecientes. Tras una semana de tratamiento, se 
 * contabilizaron los parásitos existentes en cada individuo, obteniendo los 
 * resultados del conjunto de datos 'peces'.
 * 
 */

data peces;
	input Control m25mg	m50mg	m100mg	m125mg;
  cards;
		50 49 20 20 18
		65 47 59 23 30
		72 30 64 38 22
		46 62 61 31 26
		38 62 28 27 31
		29 60 47 16 11
		70 19 29 27 15
		85 28 41 18 12
		72 56 60 22  31
		40 62 57 12 36
		57 55 61 24 16
		59 40 38 11 13
	;
run;

proc print data=peces;
run;

DATA PECES_C;
SET PECES;
GRUPO='Control';
NIVELES=CONTROL;
RUN;

DATA PECES_25;
SET PECES;
GRUPO='25mg';
NIVELES=M25MG;
RUN;

DATA PECES_50;
SET PECES;
GRUPO='50mg';
NIVELES=M50MG;
RUN;

DATA PECES_100;
SET PECES;
GRUPO='100mg';
NIVELES=M100MG;
RUN;

DATA PECES_125;
SET PECES;
GRUPO='125mg';
NIVELES=M125MG;
RUN;

PROC APPEND BASE=PECES_C DATA=PECES_25;
RUN;


PROC APPEND BASE=PECES_C DATA=PECES_50;
RUN;


PROC APPEND BASE=PECES_C DATA=PECES_100;
RUN;


PROC APPEND BASE=PECES_C DATA=PECES_125;
RUN;

DATA PECES_F;
SET PECES_C;
KEEP GRUPO NIVELES;
RUN;

PROC PRINT DATA=PECES_F;RUN;

/**
 * 
 * a) Representa gráficamente los datos. ¿Te parece que el medicamento es 
 * efectivo contra los parásitos? Realiza un contraste de hipótesis para 
 * verificarlo
 * 
 */

PROC BOXPLOT DATA=peces_f;
PLOT NIVELES*GRUPO;
RUN;

PROC GLM;
CLASS GRUPO;
MODEL NIVELES=GRUPO/CLPARM;
CONTRAST 'Eficacia medicamento' GRUPO 0.25 0.25 0.25 0.25 -1/E;
ESTIMATE 'Eficacia medicamento' GRUPO 0.25 0.25 0.25 0.25 -1;
RUN;

/**
 * 
 * b) Obtén estimadores puntuales e intervalos de confianza para las medias de
 * los tratamientos, utilizando dos métodos distintos, y explica las ventajas e
 * inconvenientes de cada uno de ellos.
 * 
 */

PROC MEANS CLM;
CLASS GRUPO;
VAR NIVELES;
RUN;

PROC UNIVARIATE CIBASIC;
CLASS GRUPO;
VAR NIVELES;
RUN;

/**
 * 
 * c) Analiza las diferencias significativas entre pares de medias de los 5 
 * grupos utilizando diferentes métodos, comentando y comparando los 
 * resultados. ¿Cambian las conclusiones si utilizas alfa = 0.1?
 * 
 */

PROC ANOVA;
CLASS GRUPO;
MODEL NIVELES=GRUPO;
MEANS GRUPO/LSD DUNCAN SNK TUKEY BON SCHEFFE LINES ALPHA=0.1;run;
RUN;

/**
 * 
 * d) Realiza el test de Dunnett para comparar los efectos de las distintas 
 * dosis con el grupo “Control “ y comenta el resultado.
 * 
 */

PROC ANOVA;
CLASS GRUPO;
MODEL NIVELES=GRUPO;
MEANS GRUPO/DUNNETT('Control');
RUN;


/**
 * 
 * e) Se desea comparar el efecto de las dosis bajas del medicamento, -25-50 mg-
 * con el de las dosis altas, -100-125 mg.- Construye un intervalo de confianza
 * para la diferencia entre ambos efectos e interpreta el resultado obtenido.
 * 
 */

proc glm;
class GRUPO;
model NIVELES=GRUPO/clparm;* se obtiene I.C. para el contraste pedido;
contrast 'dosis bajas contra dosis altas' GRUPO .5 .5 -.5 -.5 0/E;
estimate 'dosis bajas contra dosis altas' GRUPO .5 .5 -.5 -.5 0;
run;


/**
 * 
 * f) Verifica las hipótesis del modelo con ayuda de gráficos de residuos.
 * 
 */

proc anova;
class grupo;
model niveles=grupo;
means grupo/hovtest ;
run;

proc glm;
class grupo;
model niveles=grupo;
output out= resal p=pred r=res student=rst;
proc print data=resal;run;

proc univariate plot normal data=resal;
var res;run;


/**
 * 
 * g) Suponiendo que los grupos de datos correspondieran a cinco medicamentos 
 * elegidos aleatoriamente entre todos los posibles en el mercado, ¿cómo 
 * cambiaría el modelo adecuado? ¿Podría afirmarse que existe variación 
 * significativa entre los efectos de los distintos medicamentos? Estima las 
 * componentes de la varianza bajo dicho supuesto.
 * 
 */

