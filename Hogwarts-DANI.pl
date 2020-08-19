%ingresante(Mago, StatusDeSangre, Caracteristicas, CasaQueOdia).
escuela(gryffindor).
escuela(slytherin).
escuela(ravenclaw).
escuela(hufflepuff).

sangre(harry, mestizo).
sangre(draco, puro).
sangre(hermione, impuro).

caracteristica(harry, coraje).
caracteristica(harry, amistoso).
caracteristica(harry, orgulloso).
caracteristica(harry, inteligente).
caracteristica(draco, orgulloso).
caracteristica(draco, inteligente).

caracteristica(hermione, amistoso).

caracteristica(hermione, orgulloso).
caracteristica(hermione, inteligente).
caracteristica(hermione, responsable).

odiariaIr(harry, slytherin).
odiariaIr(draco, hufflepuff).


permiteEntrarMago(Escuela, Mago):-
    sangre(Mago, _),
    escuela(Escuela),
    Escuela \= slytherin.

permiteEntrarMago(slytherin, Mago):-
    sangre(Mago, Tipo),
    Tipo \= impuro.

%
%

/*
Para Gryffindor, lo más importante es tener coraje.
Para Slytherin, lo más importante es el orgullo y la inteligencia.
Para Ravenclaw, lo más importante es la inteligencia y la responsabilidad.
Para Hufflepuff, lo más importante es ser amistoso.*/ 

masImportante(gryffindor, coraje).
masImportante(slytherin, orgulloso).
masImportante(slytherin, inteligente).
masImportante(ravenclaw, inteligente).
masImportante(ravenclaw, responsable).
masImportante(hufflepuff, amistoso).

caracterApropiado(Mago, Escuela):-
    sangre(Mago, _),
    escuela(Escuela),
    forall(masImportante(Escuela, Caract), caracteristica(Mago, Caract)).

%
%

puedeQuedarSeleccionado(hermione, gryffindor).

puedeQuedarSeleccionado(Mago, Escuela):-
    caracterApropiado(Mago, Escuela),
    permiteEntrarMago(Escuela, Mago),
    not(odiariaIr(Mago, Escuela)).

%
%

cadenaDeAmistades([UltimoAmigo]):-
    caracteristica(UltimoAmigo, amistoso).

cadenaDeAmistades([PrimerAmigo,SegundoAmigo|OtrosAmigos]):-
    caracteristica(PrimerAmigo, amistoso),
    puedeQuedarSeleccionado(PrimerAmigo, Escuela),
    puedeQuedarSeleccionado(SegundoAmigo, Escuela),
    PrimerAmigo \= SegundoAmigo,
    cadenaDeAmistades([SegundoAmigo|OtrosAmigos]).

%
%
%

esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

/*accion(harry, fueraDeCama, -50).
accion(hermione, tercerPiso, -75).
accion(hermione, biblioteca, -10).
accion(harry, bosque, -50).
accion(harry, tercerPiso, -75).
accion(ron, ajedrez, 50).
accion(hermione, salvar, 50).
accion(harry, voldemort, 60).*/

accion(harry, fueraDeCama).
accion(hermione, irA(tercerPiso)).
accion(hermione, irA(biblioteca)).
accion(harry, irA(bosque)).
accion(harry, irA(tercerPiso)).
accion(ron, buenaAccion(ajedrez, 50)).
accion(hermione, buenaAccion(salvar, 50)).
accion(harry, buenaAccion(voldemort, 60)).
accion(hermione, responderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).
accion(hermione, responderPregunta(comoHacerLevitarUnaPluma, 25, flitwick)).


puntos(responderPregunta(_, Puntos, Profesor), Puntos):-
    Profesor \= snape.
puntos(responderPregunta(_, Dificultad, snape), Puntos):-
    Puntos is Dificultad / 2.
puntos(fueraDeCama, -50).
puntos(irA(Lugar), Puntos):-
    lugarProhibido(Lugar, Puntos).
puntos(buenaAccion(_, Puntos), Puntos).

lugarProhibido(tercerPiso, -75).
lugarProhibido(biblioteca, -10).
lugarProhibido(bosque, -50).


/*
accion(_, pregunta(_, Dificultad, Profesor), Puntos):-
    Profesor \= snape,
    Puntos is Dificultad.

accion(_, pregunta(_, Dificultad, snape), Puntos):-
    Puntos is Dificultad/2.*/

hizoAccion(Mago):-
    accion(Mago,_).

hizoAlgoMalo(Mago):-
    accion(Mago, Accion),
    puntos(Accion, Puntos),
    Puntos < 0.

buenAlumno(Mago):-
    hizoAccion(Mago),
    not(hizoAlgoMalo(Mago)).

accionRecurrente(Accion):-
    accion(Mago, Accion),
    accion(OtroMago, Accion),
    Mago \= OtroMago.

%
%

puntosDelMago(Mago, Accion, Puntos):-
    accion(Mago, Accion),
    puntos(Accion, Puntos).

puntajeTotal(Escuela, PuntajeFinal):-
    escuela(Escuela),
    findall(Puntaje, (esDe(Mago, Escuela), puntosDelMago(Mago, _, Puntaje)), ListaDePuntajes),
    sum_list(ListaDePuntajes, PuntajeFinal).

mejorEscuela(Escuela):-
    puntajeTotal(Escuela, MayorPuntaje),
    forall((puntajeTotal(Escuelas, Puntajes), Escuelas \= Escuela), Puntajes < MayorPuntaje).