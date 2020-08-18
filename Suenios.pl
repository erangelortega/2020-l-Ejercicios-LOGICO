/*            	PUNTO 1
   ------------------------------------- 

a- Generar la base de conocimientos inicial */
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascuas).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).

% Diego por UNIVERSO CERRADO no se agrega a la base de conocimiento, Diego no es un SOÑADOR :(

              % ganarLoteria([serie de nuemros])
suenio(gabriel, ganarLoteria([5, 9])).
              % serFutbolista(equipo de futbol)
suenio(gabriel, serFutbolista(arsenal)).
              % serCantante(Cantidad de discos, estilo)
suenio(juan, serCantante(100000, _)).
suenio(macarena, serCantante(10000, erucaSativa)).

esSoniador(Persona):-
  cree(Persona, _).
esSoniador(Persona):-
  suenio(Persona, _).


/* Punto b
  Indicar qué conceptos entraron en juego para cada punto.
    cree/2
        universo cerrado para Diego
    
    suenio/2
        uso de FUNTORES  */


/*            	PUNTO 2 
   ------------------------------------- 
    Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los sueños es mayor a 20. 
    La dificultad de cada sueño se calcula como 
    - 6 para ser un CANTANTE que vende más de 500.000 ó 4 en caso contrario
    - ganar la LOTERIA implica una dificultad de 10 * la cantidad de los números apostados
    - lograr ser un FUTBOLISTA tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y Aldosivi son equipos chicos.
    
    Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
    
    Gabriel es ambicioso, porque quiere ganar a la lotería con 2 números (20 puntos de dificultad) y quiere ser futbolista de Arsenal (3 puntos) = 23 que es mayor a 20. 
    En cambio Juan y Macarena tienen 4 puntos de dificultad (cantantes con menos de 500.000 discos) */

    ambicioso(Persona):-
      esSoniador(Persona),
      findall(Dificultad, calculoDeDificultad(Persona, Dificultad),ListaDeDificultad),
      sumlist(ListaDeDificultad, Total),
      Total > 20.


    calculoDeDificultad(Persona, Dificultad):-
      suenio(Persona, Suenio),  
      dificultadDeLosSuenios(Suenio, Dificultad).

    dificultadDeLosSuenios(serCantante(DiscosVendidos, _), Dificultad):-
      DiscosVendidos > 500000, 
      Dificultad is 6.
    dificultadDeLosSuenios(serCantante(_, _), 4).
    dificultadDeLosSuenios(ganarLoteria(Numeros), Dificultad):-
      length(Numeros, Cantidad),
      Dificultad is Cantidad * 10.
    dificultadDeLosSuenios(serFutbolista(Equipo), Dificultad):-
      equipoChico(Equipo),
      Dificultad is 3.
    dificultadDeLosSuenios(serFutbolista(_), 16).


    equipoChico(arsenal).
    equipoChico(aldosivi).
      

/*             	PUNTO 3 
   -------------------------------------
    Queremos saber si un personaje tiene química con una persona. Esto se da 
    - si la persona cree en el personaje y...
    - para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
    - para el resto, todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos) y la persona no debe ser ambiciosa

    No puede utilizar findall en este punto.
    El predicado debe ser inversible para todos sus argumentos.
    
    Campanita tiene química con Gabriel (porque tiene como sueño ser futbolista de Arsenal, que es un sueño de dificultad 3 - menor a 5), 
    y los Reyes Magos, el Mago Capria y Campanita tienen química con Macarena porque no es ambiciosa. */

    tieneQuimica(Personaje, Persona):-
        cree(Persona, Personaje),
        criterioPersonaje(Personaje, Persona).

    criterioPersonaje(campanita, Persona):-
        calculoDeDificultad(Persona, Dificultad),
        Dificultad < 5.
    criterioPersonaje(Personaje, Persona):-
        suenio(Persona, Suenio),
        esSuenioPuro(Suenio),
        not(ambicioso(Persona)),
        Personaje \= campanita.


    esSuenioPuro(serFutbolista(_)).
    esSuenioPuro(serCantante(DiscosVendidos, _)):-
        DiscosVendidos < 200000.

/*             	PUNTO 4 
    -------------------------------------
    Sabemos que
    - Campanita es amiga de los Reyes Magos y del Conejo de Pascua
    - el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

    Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
    - si una persona tiene algún sueño
    - el personaje tiene química con la persona y...
    - el personaje no está enfermo
    o algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del personaje principal

    Debe evitar repetición de lógica.
    El predicado debe ser totalmente inversible.
    Debe considerar cualquier nivel de amistad posible (la solución debe ser general).
    
    Suponiendo que Campanita, los Reyes Magos y el Conejo de Pascua están enfermos, 
    el Mago Capria alegra a Macarena, ya que tiene química con ella y no está enfermo
    Campanita alegra a Macarena; aunque está enferma es amiga del Conejo de Pascua, que aunque está enfermo es amigo de Cavenaghi que no está enfermo. */
    
    amigos(campanita, reyesMagos).
    amigos(campanita, conejoDePascuas).
    amigos(conejoDePascuas, cavenaghi).

    enfermo(campanita).
    enfermo(reyesMagos).
    enfermo(conejoDePascuas).


    puedeAlegrar(Personaje, Persona):-
        suenio(Persona, _),
        tieneQuimica(Personaje, Persona),
        personajeNoEnfermo(Personaje).


    personajeNoEnfermo(Personaje):-
        not(enfermo(Personaje)).
    personajeNoEnfermo(Personaje):-
        backup(Personaje, OtroPersonaje),
        not(enfermo(OtroPersonaje)).


    % Amigo Directo
    backup(UnPersonaje, OtroPersonaje):-
        amigos(UnPersonaje, OtroPersonaje).

    % amigo Indirecto
    backup(UnPersonaje, OtroPersonaje):-
        amigos(UnPersonaje, Intermediario),
        backup(Intermediario, OtroPersonaje).
