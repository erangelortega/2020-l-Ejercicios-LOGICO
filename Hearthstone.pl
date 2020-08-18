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
    nombre(jugador(Nombre,_,_,_,_,_), Nombre).
    cartasMazo(jugador(_,_,_,Carta,_,_), Carta).
  pertenece(Jugador, Carta):-
    cartasMano(jugador(_,_,_,_,Carta,_), Carta).
  pertenece(Jugador, Carta):-
    cartasCampo(jugador(_,_,_,_,_,Carta), Carta).

