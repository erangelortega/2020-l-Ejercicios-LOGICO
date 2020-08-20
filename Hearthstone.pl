/*
% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% cartas
criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
hechizo(Nombre, FunctorEfecto, CostoMana)

% efectos
daño(CantidadDaño)
cura(CantidadCura)

Base de conocimiento
*/

jugador(mecs, 1, 10, [criatura(golem, 7, 10, 8),hechizo(bolaDeFuego, danio(6), 4)], [criatura(golemChiquito, 7, 10, 8),criatura(messi, 10, 2, 6)], [criatura(golem, 7, 10, 8),criatura(mago, 5, 4, 4)]).
jugador(daniel, 30, 7, [hechizo(bolaDeFuego, danio(6), 4), criatura(messi, 10, 2, 6), hechizo(bolaDeFuego, danio(6), 4)], [criatura(golem, 7, 10, 8),hechizo(curacionMistica, cura(10), 6)], [criatura(golemChiquito, 7, 10, 8),criatura(golem, 7, 10, 8),criatura(mago, 5, 4, 4)]).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

daño(criatura(_,Daño,_), Daño).
daño(hechizo(_,daño(Daño),_), Daño).


mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

/*            	PUNTO 1
   ------------------------------------- 
  Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo. */

  pertenece(Jugador, Carta):-
    cartasMazo(Jugador(_,_,_,Cartas,_,_), Cartas),
    member(Carta, Cartas).
  pertenece(Jugador, Carta):-
    cartasMano(Jugador(_,_,_,_,Cartas,_), Cartas),
    member(Carta, Cartas).
  pertenece(Jugador, Carta):-
    cartasCampo(Jugador(_,_,_,_,_,Cartas), Cartas),
    member(Carta, Cartas).

