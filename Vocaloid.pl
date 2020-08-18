/* ------------------------------------- 
                    PARTE 1
            CANTANTES VOCALOID
   ------------------------------------- 

Base de conocimiento */
%canta(nombreCancion, cancion)%
sabeCantar(megurineLuka, cancion(nightFever, 4)).
sabeCantar(megurineLuka, cancion(foreverYoung, 5)).
sabeCantar(hatsuneMiku, cancion(tellYourWorld, 4)).
sabeCantar(gumi, cancion(foreverYoung, 4)).
sabeCantar(gumi, cancion(tellYourWorld, 5)).
sabeCantar(seeU, cancion(novemberRain, 6)).
sabeCantar(seeU, cancion(nightFever, 5)).


esVocaloid(Cantante):-
    sabeCantar(Cantante, _).


/* Punto 1
    Para comenzar el concierto, es preferible introducir primero a los cantantes más novedosos, por lo que necesitamos un predicado para saber 
    si un vocaloid es novedoso cuando saben al menos 2 canciones y el tiempo total que duran todas las canciones debería ser menor a 15. */

    cantanteNovedoso(Cantante):-
        sabeAlMenosDosCanciones(Cantante),
        tiempoTotalDeCanciones(Cantante, Tiempo),
        Tiempo < 15.

    
    sabeAlMenosDosCanciones(Cantante) :-
        sabeCantar(Cantante, Cancion1),
        sabeCantar(Cantante, Cancion2),
        Cancion1 \= Cancion2.

    tiempoTotalDeCanciones(Cantante, Tiempo):-
        %esVocaloid(Cantante),
        findall(Tiempo, sabeCantar(Cantante, cancion(_, Tiempo)), ListaDeTiempos),
        sum_list(ListaDeTiempos, Tiempo).


/* Punto 2
    Hay algunos vocaloids que simplemente no quieren cantar canciones largas porque no les gusta, es por eso que se pide saber 
    si un cantante es acelerado, condición que se da cuando todas sus canciones duran 4 minutos o menos. Resolver sin usar forall/2. */

    cantanteAcelerado(Cantante):-
        esVocaloid(Cantante),
        not((sabeCantar(Cantante, cancion(_, Tiempo)), Tiempo > 4)).


/* ------------------------------------- 
                PARTE 2
            LOS CONCIERTOS
   ------------------------------------- */
/*
    TIPOS DE CONCIERTOS
    - gigante = (la cantidad MIN de canciones que el cantante tiene que saber, la duración total de todas las canciones tiene que ser MAYOR a una cantidad dada).
    - mediano = (la duración total de las canciones del cantante sea MENOR a una cantidad determinada)
    - pequenio = (alguna de las canciones dure MAS de una cantidad dada)

  Punto 1
    Modelar los conciertos y agregar en la base de conocimiento todo lo necesario.

    concierto(Nombre, Pais, Fama, Tipo de concierto ) */
    concierto(mikuExpo, estadosUnidos, 2000, gigante(2, 6)).
    concierto(magical, japon, 3000, gigante(3, 10)).
    concierto(vocalektVisions, estadosUnidos, 1000, mediano(9)).
    concierto(mikuFest, argentina, 100, pequenio(4)).


/* Punto 2.
    Se requiere saber si un vocaloid puede participar en un concierto, esto se da cuando 
    - cumple los requisitos del tipo de concierto. 
    - También sabemos que Hatsune Miku puede participar en cualquier concierto.*/

    puedeParticipar(hatsuneMiku, Concierto):-
        concierto(Concierto, _, _, _).    
    puedeParticipar(Cantante, Concierto):-
        esVocaloid(Cantante),
        Cantante \= hatsuneMiku,
        concierto(Concierto, _, _, Condiciones),
        cumpleCondiciones(Cantante, Condiciones).
    

    cumpleCondiciones(Cantante, gigante(CantMinCanciones, TiempoMinimo)):-
        cantidadDeCanciones(Cantante, CantCanciones),
        CantCanciones >= CantMinCanciones,
        tiempoTotalDeCanciones(Cantante, TiempoTotal),
        TiempoTotal > TiempoMinimo.
    cumpleCondiciones(Cantante, mediano(TiempoMaximo)):-
        tiempoTotalDeCanciones(Cantante, TiempoTotal),
        TiempoTotal < TiempoMaximo.
    cumpleCondiciones(Cantante, pequenio(TiempoMinimo)):-
        sabeCantar(Cantante, cancion(_, Duracion)),
        Duracion > TiempoMinimo.
    
    
    cantidadDeCanciones(Cantante, CantCanciones):-
        findall(Cancion, sabeCantar(Cantante, cancion(Cancion, _)), ListaDeCanciones),
        length(ListaDeCanciones, CantCanciones).


/* Punto 3
    Conocer el vocaloid más famoso, es decir con mayor nivel de fama. El nivel de fama de un vocaloid se calcula como 
    - la fama total que le dan los conciertos en los cuales puede participar multiplicado por la cantidad de canciones que sabe cantar.*/

    masFamoso(Cantante, Puntaje):-
        nivelDeFama(Cantante, Puntaje),
        forall(nivelDeFama(_, OtroPuntaje), OtroPuntaje =< Puntaje).

        %not((nivelDeFama(_, OtroPuntaje), OtroPuntaje > Puntaje)).

    nivelDeFama(Cantante, Puntaje):-
        esVocaloid(Cantante),
        cantidadDeCanciones(Cantante, CantCanciones),
        cantidadDeConciertos(Cantante, PuntajeConciertos),
        Puntaje is PuntajeConciertos * CantCanciones.

    cantidadDeConciertos(Cantante, PuntajeConciertos):-
        findall(Puntaje, (puedeParticipar(Cantante, Concierto), concierto(Concierto, _, Puntaje, _)), ListaDePuntajes),
        list_to_set(ListaDePuntajes, X),        
        sum_list(X, PuntajeConciertos).

/* Punto 4
    Sabemos que:
    - megurineLuka conoce a hatsuneMiku  y a gumi 
    - gumi conoce a seeU
    - seeU conoce a kaito

    Queremos verificar si un vocaloid es el único que participa de un concierto, esto se cumple si ninguno de sus conocidos ya sea directo o indirectos (en cualquiera de los niveles)
    participa en el mismo concierto. */

    conoce(megurineLuka, hatsuneMiku).
    conoce(megurineLuka, gumi).
    conoce(gumi, seeU).
    conoce(seeU, kaito).

    unicoParticipanteEntreConocidos(Cantante,Concierto):- 
        puedeParticipar(Cantante, Concierto),
        not((conocido(Cantante, OtroCantante), puedeParticipar(OtroCantante, Concierto))).

    %Conocido directo
    conocido(Cantante, OtroCantante) :- 
        conoce(Cantante, OtroCantante).

    %Conocido indirecto
    conocido(Cantante, OtroCantante) :- 
        conoce(Cantante, Intermediario), 
        conocido(Intermediario, OtroCantante).



/* Punto 5
    Supongamos que aparece un nuevo tipo de concierto y necesitamos tenerlo en cuenta en nuestra solución, explique los cambios que habría que realizar para que siga todo funcionando. 
        En la solución planteada habría que agregar 
        - un hecho mas en el predicado concierto/4 
        - una claúsula en el predicado cumpleRCondiciones/2  que tenga en cuenta el nuevo functor con sus respectivas condiciones, en caso de que sea una nueva informacion que no cumpla con el patron
            de lo que se tiene. 
    
    ¿Qué conceptos facilitaron dicha implementación?
        El concepto que facilita los cambios para el nuevo requerimiento es el POLIMORFISMO, que nos permite dar un tratamiento en particular a cada uno de los conciertos en la cabeza de la cláusula.*/