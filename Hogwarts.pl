/* ------------------------------------- 
                    PARTE 1
            SOMBRERO SELECCIONADOR
   ------------------------------------- 

Base de conocimiento */
casa(gryffindor).
casa(slytherin).
casa(hufflepuff).
casa(ravenclaw).

sangre(harry, mestiza).
sangre(draco, pura).
sangre(hermione, impura).

mago(Mago):-
    sangre(Mago, _).  % es mago si al menos conozco su sangre
 
 /* Punto 1
    Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura. */

    permiteEntrar(Casa, Mago):-
        casa(Casa),
        mago(Mago),
        Casa \= slytherin.
    permiteEntrar(slytherin, Mago):-
        sangre(Mago, TipoDeSangre),
        TipoDeSangre \= impura.

/* Punto 2
    Saber si un mago tiene el carácter apropiado para una casa, lo cual se cumple para cualquier mago si sus características incluyen todo lo que se busca para los integrantes de esa casa, independientemente de si la casa le permite la entrada.    */

    caracteristicaBuscada(gryffindor, coraje).
    caracteristicaBuscada(slytherin, orgullo).
    caracteristicaBuscada(slytherin, inteligencia).
    caracteristicaBuscada(ravenclaw, inteligencia).
    caracteristicaBuscada(ravenclaw, responsabilidad).
    caracteristicaBuscada(hufflepuff, amistad).

% OPCION A - usando Listas
    /* 
    caracteristicas(Mago, ListaDeCaracteristicas)
    caracteristica(harry, [coraje, amistad, orgullo, inteligencia]).
    caracteristica(draco, [inteligencia, orgullo]).
    caracteristica(hermione, [inteligencia, orgullo, responsabilidad]).

    % Forma 1
    tieneCaracterApropiado(Mago, Casa):-
        casa(Casa),
        caracteristica(Mago, Caracteristicas),
        forall(caracteristicaBuscada(Casa, Caracteristica), member(Caracteristica, Caracteristicas)).
  
    % Forma 2
    tieneCaracteristica(Mago, Caracteristica):-
        caracteristica(Mago, Caracteristicas),
        member(Caracteristica, Caracteristicas).
    */ 

% OPCION B - Caracteristicas como predicados
    /*
    corajudo(harry).
    amistoso(harry).
    orgulloso(harry).
    inteligente(harry).

    inteligente(hermione).
    orgulloso(hermione).
    responsable(hermione).

    inteligente(draco).
    orgulloso(draco).


    tieneCaracterApropiado(Mago, gryffindor):-
        corajudo(Mago).
    tieneCaracterApropiado(Mago, slytherin):-
        orgulloso(Mago),
        inteligente(Mago).
    tieneCaracterApropiado(Mago, ravenclaw):-
        inteligente(Mago),
        responsable(Mago).
    tieneCaracterApropiado(Mago, hufflepuff):-
        amistoso(Mago).
    */

% OPCION C - Caracteristicas Independientes (SOLUCION OFICIAL)

    % tieneCaracteristica(Mago, Caracteristica)
    tieneCaracteristica(harry, coraje).
    tieneCaracteristica(harry, orgullo).
    tieneCaracteristica(harry, amistad).
    tieneCaracteristica(harry, inteligencia).

    tieneCaracteristica(draco, inteligencia).
    tieneCaracteristica(draco, orgullo).

    tieneCaracteristica(hermione, inteligencia).
    tieneCaracteristica(hermione, orgullo).
    tieneCaracteristica(hermione, responsabilidad).

    tieneCaracteristica(neville, responsabilidad).
    tieneCaracteristica(neville, coraje).
    tieneCaracteristica(neville, amistad).

    tieneCaracteristica(luna, amistad).
    tieneCaracteristica(luna, inteligencia).
    tieneCaracteristica(luna, responsabilidad).



    tieneCaracterApropiado(Mago, Casa):-
        casa(Casa),
        mago(Mago),
        forall(caracteristicaBuscada(Casa, Caracteristica), tieneCaracteristica(Mago, Caracteristica)).


/* Punto 3 
    Determinar en qué casa podría quedar seleccionado un mago sabiendo que tiene que tener el carácter adecuado para la casa, la casa permite su entrada y además el mago no odiaría que lo manden a esa casa. Además Hermione puede quedar seleccionada en Gryffindor, porque al parecer encontró una forma de hackear al sombrero.*/

    odiariaEntrar(harry, slytherin).
    odiariaEntrar(draco, hufflepuff).

    puedeQuedarSeleccionadoPara(Mago, Casa):-
    tieneCaracterApropiado(Mago, Casa),
    permiteEntrar(Casa, Mago),
    not(odiariaEntrar(Mago, Casa)).
    puedeQuedarSeleccionadoPara(hermione, gryffindor).

/* Punto 4
    Definir un predicado cadenaDeAmistades/1 que se cumple para una lista de magos si todos ellos se caracterizan por ser amistosos y cada uno podría estar en la misma casa que el siguiente. No hace falta que sea inversible, se consultará de forma individual. */
    
    cadenaDeAmistades(Magos):-
        todosAmistosos(Magos),
        cadenaDeCasas(Magos).
      
      todosAmistosos(Magos):-
        forall(member(Mago, Magos), amistoso(Mago)).
      
      amistoso(Mago):-
        tieneCaracteristica(Mago, amistad).
      
      % cadenaDeCasas(Magos)
      /*
      cadenaDeCasas([Mago1, Mago2 | MagosSiguientes]):-
        puedeQuedarSeleccionadoPara(Mago1, Casa),
        puedeQuedarSeleccionadoPara(Mago2, Casa),
        cadenaDeCasas([Mago2 | MagosSiguientes]).
      cadenaDeCasas([_]).
      cadenaDeCasas([]).
      */
      
      cadenaDeCasas(Magos):-
        forall(consecutivos(Mago1, Mago2, Magos),
               puedenQuedarEnLaMismaCasa(Mago1, Mago2, _)).
      
      consecutivos(Anterior, Siguiente, Lista):-
        nth1(IndiceAnterior, Lista, Anterior),
        IndiceSiguiente is IndiceAnterior + 1,
        nth1(IndiceSiguiente, Lista, Siguiente).
      
      puedenQuedarEnLaMismaCasa(Mago1, Mago2, Casa):-
        puedeQuedarSeleccionadoPara(Mago1, Casa),
        puedeQuedarSeleccionadoPara(Mago2, Casa),
        Mago1 \= Mago2.


/* ------------------------------------- 
                    PARTE 2
            LA COPA DE LAS CASAS
   ------------------------------------- */

/* Punto 1
    a. Saber si un mago es buen alumno, que se cumple si hizo alguna acción y ninguna de las cosas que hizo se considera una mala acción (que son aquellas que provocan un puntaje negativo). */

% OPCION 1 - ACCIONES COMO PREDICADOS
/*  Base de conocimiento 
    fueraDeCama(harry).
    fueA(hermione, tercerPiso).
    fueA(hermione, seccionRestringida).
    fueA(harry, bosque).
    fueA(harry, tercerPiso).
    fueA(draco, mazmorras).
    buenaAccion(ron, 50, ganarAlAjedrezMagico).
    buenaAccion(hermione, 50, salvarASusAmigos).
    buenaAccion(harry, 60, ganarleAVoldemort).

    lugarProhibido(bosque, 50).
    lugarProhibido(seccionRestringida, 10).
    lugarProhibido(tercerPiso, 75).   
    hizoAlgunaAccion(Mago):-
    fueraDeCama(Mago).
    hizoAlgunaAccion(Mago):-
    fueA(Mago, _).
    hizoAlgunaAccion(Mago):-
    buenaAccion(Mago, _, _).

    hizoAlgoMalo(Mago):-
    hizoAlgoQueDioPuntos(Mago, Puntos),
    Puntos < 0.

    hizoAlgoQueDioPuntos(Mago, -50):-
    fueraDeCama(Mago).
    hizoAlgoQueDioPuntos(Mago, PuntosQueResta):-
    fueA(Mago, Lugar),
    lugarProhibido(Lugar, PuntosPorLugar),
    PuntosQueResta is PuntosPorLugar * -1.
    hizoAlgoQueDioPuntos(Mago, Puntos):-
    buenaAccion(Mago, Puntos, _).

    esBuenAlumno(Mago):-
    hizoAlgunaAccion(Mago),
    not(hizoAlgoMalo(Mago)).
*/
    /*
    hizoAlgoMalo(Mago):-
    fueraDeCama(Mago).
    hizoAlgoMalo(Mago):-
    fueA(Mago, Lugar),
    lugarProhibido(Lugar, _).
    */


% OPCION 2 - ACCIONES COMO INDIVIDUOS

    hizo(harry, fueraDeCama).
    hizo(hermione, irA(tercerPiso)).
    hizo(hermione, irA(seccionRestringida)).
    hizo(harry, irA(bosque)).
    hizo(harry, irA(tercerPiso)).
    hizo(draco, irA(mazmorras)).
    hizo(ron, buenaAccion(50, ganarAlAjedrezMagico)).
    hizo(hermione, buenaAccion(50, salvarASusAmigos)).
    hizo(harry, buenaAccion(60, ganarleAVoldemort)).
    hizo(cedric, buenaAccion(100, ganarAlQuidditch)).
    hizo(hermione, responderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).
    hizo(hermione, responderPregunta(comoHacerLevitarUnaPluma, 25, flitwick)).

    hizoAlgunaAccion(Mago):-
        hizo(Mago, _).
    
    hizoAlgoMalo(Mago):-
        hizo(Mago, Accion),
        puntajeQueGenera(Accion, Puntaje),
        Puntaje < 0.

    % POLIMORFISMO: se encarga de manejar el comportamiento de las acciones
    puntajeQueGenera(fueraDeCama, -50).
    puntajeQueGenera(irA(Lugar), PuntajeQueResta):-
        lugarProhibido(Lugar, Puntos),
        PuntajeQueResta is Puntos * -1.
    puntajeQueGenera(buenaAccion(Puntaje, _), Puntaje).
    puntajeQueGenera(responderPregunta(_, Dificultad, snape), Puntos):-
        Puntos is Dificultad / 2.
    puntajeQueGenera(responderPregunta(_, Dificultad, Profesor), Dificultad):- 
        Profesor \= snape.

    lugarProhibido(bosque, 50).
    lugarProhibido(seccionRestringida, 10).
    lugarProhibido(tercerPiso, 75).


    esBuenAlumno(Mago):-
    hizoAlgunaAccion(Mago),
    not(hizoAlgoMalo(Mago)).

/*  b. Saber si una acción es recurrente, que se cumple si más de un mago hizo esa misma acción. */

%  OPCION 1 - ACCIONES COMO PREDICADOS
    /* la solucion no funciona, porque se necesita utilizar la ccion como un individuo*/

% OPCION 2 - ACCIONES COMO INDIVIDUOS
    esRecurrente(Accion):-
        hizo(Mago, Accion),
        hizo(OtroMago, Accion),
        Mago \= OtroMago.       

/* Punto 2
    Saber cuál es el puntaje total de una casa, que es la suma de los puntos obtenidos por sus miembros. */
    esDe(hermione, gryffindor).
    esDe(ron, gryffindor).
    esDe(harry, gryffindor).
    esDe(draco, slytherin).
    esDe(luna, ravenclaw).
    esDe(cedric, hufflepuff).

    puntajeTotalDeCasa(Casa, PuntajeTotal):-
    casa(Casa),
    findall(Puntos,
        (esDe(Mago, Casa), puntosQueObtuvo(Mago, _, Puntos)),
        ListaPuntos),
    sum_list(ListaPuntos, PuntajeTotal).

    puntosQueObtuvo(Mago, Accion, Puntos):-
    hizo(Mago, Accion),
    puntajeQueGenera(Accion, Puntos).

/* Punto 3
    Saber cuál es la casa ganadora de la copa, que se verifica para aquella casa que haya obtenido una cantidad mayor de puntos que todas las otras. */

    casaGanadora(Casa):-
        puntajeTotalDeCasa(Casa, PuntajeMayor),
        forall((puntajeTotalDeCasa(OtraCasa, PuntajeMenor), Casa \= OtraCasa),
               PuntajeMayor > PuntajeMenor).
      
      casaGanadora2(Casa):-
        puntajeTotalDeCasa(Casa, PuntajeMayor),
        not((puntajeTotalDeCasa(_, OtroPuntaje), OtroPuntaje > PuntajeMayor)).

/* Punto 4
    Queremos agregar la posibilidad de ganar puntos por responder preguntas en clase. La información que nos interesa de las respuestas en clase son: cuál fue la pregunta, 
    cuál es la dificultad de la pregunta y qué profesor la hizo. */
