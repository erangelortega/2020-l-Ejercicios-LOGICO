/* ------------------------------------- 
                    PARTE 1
            SOMBRERO SELECCIONADOR
   ------------------------------------- 

Base de conocimiento */

%jugador(Nombre, items que posee, nivel de hambre)
jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

%lugar(Seccion, jugadores, nivel de oscuridad)
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


/* ------------------------------------- 
    PUNTO 1 - Jugando con los items
   ------------------------------------- 
  a. Relacionar un jugador con un ítem que posee. tieneItem/2 */

  tieneItem(Jugador, Item):-
    jugador(Jugador, ListaItems, _),
    member(Item, ListaItems).


/* b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible. (Tratar de resolver sin findall) sePreocupaPorSuSalud/1*/

  sePreocupaPorSuSalud(Jugador):-
    itemComestible(Jugador, UnItem),
    itemComestible(Jugador, OtroItem),
    UnItem \= OtroItem.

  itemComestible(Jugador, Item):-
    tieneItem(Jugador, Item),
    comestible(Item).

/* c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), y la cantidad que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeItem/3 */
  
  /* OPCION 1
  cantidadDeItem(Jugador, Item, Cantidad):-
    tieneItem(Jugador, Item),
    cantidadPoseeDeItem(Jugador, Item, Cantidad).
  cantidadDeItem(Jugador, Item, 0):-
    existe(Item),
    jugador(Jugador, _, _),
    not(tieneItem(Jugador, Item)).
  */

  % OPCION 2
  cantidadDeItem(Jugador, Item, Cantidad):-
    existe(Item),
    jugador(Jugador, ListaItems, _),
    cantidadQuePoseeDeItem(ListaItems, Item, Cantidad).


  existe(Item):-
    tieneItem(_, Item).

  cantidadQuePoseeDeItem(ListaItems, Item, Cantidad):-
    findall(Item, member(Item, ListaItems), NuevaLista),
    length(NuevaLista, Cantidad).
    
/* d. Relacionar un jugador con un ítem, si de entre todos los jugadores, es el que más cantidad tiene de ese ítem. tieneMasDe/2

?- tieneMasDe(steve, panceta).
true.
*/
  tieneMasDe(Jugador, Item):-
    cantidadDeItem(Jugador, Item, Cantidad),
    not((cantidadDeItem(_, Item, OtraCantidad), OtraCantidad > Cantidad)).


/* ------------------------------------- 
    PUNTO 2 - Alejarse de la oscuridad 
   ------------------------------------- 
  a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1 */
  
  hayMonstruos(Lugar):-
    lugar(Lugar, _, NivelOscuridad),
    NivelOscuridad > 6.

/* b. Saber si un jugador corre peligro. 
  Un jugador corre peligro si se encuentra en un lugar donde hay monstruos; o si está hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1 */

  correPeligro(Jugador):-
    lugar(Lugar, ListaJugadores, _),
    member(Jugador, ListaJugadores),
    hayMonstruos(Lugar).
  correPeligro(Jugador):-
    estaHambriento(Jugador),
    not(tieneItemsComestibles(Jugador)).
    

  estaHambriento(Jugador):-
    jugador(Jugador, _, NivelDeHambre),
    NivelDeHambre < 4.
  tieneItemsComestibles(Jugador):-
    jugador(Jugador, ListaItems, _),
    member(Item, ListaItems),
    comestible(Item).

/* c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
  - Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
  - Si hay monstruos, es 100.
  - Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

  ?- nivelPeligrosidad(playa,Peligrosidad).
  Peligrosidad = 50.
*/


  nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).
  nivelPeligrosidad(Lugar, Nivel):-
    porcentajeHambrientos(Lugar, Nivel),
    not(hayMonstruos(Lugar)).
  nivelPeligrosidad(Lugar, Nivel):-
    noPoblado(Lugar, NivelOscuridad),
    Nivel is NivelOscuridad * 10.
    
    

  porcentajeHambrientos(Lugar, Nivel):-
    lugar(Lugar, ListaJugadores, _),
    totalHambrientos(ListaJugadores, TotalHambrientos),
    length(ListaJugadores, Poblacion),
    Poblacion > 0,
    Nivel is TotalHambrientos * 100 / Poblacion.
    
  totalHambrientos(ListaJugadores, TotalHambrientos):-
    findall(Jugador, (member(Jugador, ListaJugadores), estaHambriento(Jugador)), ListaHambrientos),
    length(ListaHambrientos, TotalHambrientos).

  noPoblado(Lugar, NivelOscuridad):-
    lugar(Lugar, ListaJugadores, NivelOscuridad),
    length(ListaJugadores, 0).
  

/* ------------------------------------- 
    PUNTO 3 - A Construir
   ------------------------------------- 
    El aspecto más popular del juego es la construcción. Se pueden construir nuevos ítems a partir de otros, cada uno tiene ciertos requisitos para poder construirse:
    - Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. Por ejemplo, 8 unidades de piedra.
    - Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
    Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2 
    
    Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes, es decir no puede haber más de un ítem que requiera el mismo elemento.*/

  item(horno, [itemSimple(piedra, 8)]).
  item(placaDeMadera, [itemSimple(madera, 1)]).
  item(palo, [itemCompuesto(placaDeMadera)]).
  item(antorcha, [itemCompuesto(palo), itemSimple(carbon, 1)]).


  puedeConstruir(Jugador, NuevoItem):-
    jugador(Jugador, ListaItems, _),
    item(NuevoItem, RequisitosConstruccion),
    construirUnItem(ListaItems, RequisitosConstruccion).

  construirUnItem(ListaItems, [itemSimple(Item, Cantidad) | OtrosRequisitosConstruccion]):-
    cantidadQuePoseeDeItem(ListaItems, Item, CantidadQuePosee),
    CantidadQuePosee >= Cantidad,
    construirUnItem(ListaItems, OtrosRequisitosConstruccion).
  
  construirUnItem(ListaItems, [itemCompuesto(Item) | OtrosRequisitosConstruccion]):-
    item(Item, RequisitosConstruccion),                 % Averigua que se necesita para construir el item compuesto
    construirUnItem(ListaItems, RequisitosConstruccion), % se contruye el itemcompuesto
    construirUnItem(ListaItems, OtrosRequisitosConstruccion).
  
  construirUnItem(ListaItems, []):-
    length(ListaItems, Int),
    Int > 0.
  
/* ------------------------------------- 
    PUNTO 4 - Para pensar sin bloques
   ------------------------------------- 

  a. ¿Qué sucede si se consulta el nivel de peligrosidad del desierto? ¿A qué se debe?
      por universo cerrado daria false
      
  b. ¿Cuál es la ventaja que nos ofrece el paradigma lógico frente a funcional a la hora de realizar una consulta?
      por la inversibilidad se pueden consultar todos los casos posibles, sin necesidad de recurrir a listas*/