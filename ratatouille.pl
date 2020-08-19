/** Base de conocimiento */
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django,pizzeriaJeSuis).

cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 10).
cocina(colette, sopa, 10).
cocina(horst, ensalaRusa, 8).

trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).

/** Saber el menú de un resto, que son los platos que se concinan en él. */
menu(Restaurante, Plato) :-
    trabaja(Cocinere, Restaurante),
    cocina(Cocinere, Plato ,_).

/** 
 * Saber si quién cocina bien un determinado plato, que es verdadero para una persona si su experiencia preparando ese plato es mayor a 7, ó si tiene un tutor que cocina bien el plato. Nos contaron que Linguini tiene como tutor a toda rata que viva en el lugar donde trabaja, además que Amelie es la tutora de Skinner.
También se sabe que remy cocina bien cualquier plato que exista.
 */
cocinaBien(Cocinere, Plato) :- cocina(Cocinere, Plato, Exp), Exp > 7.
cocinaBien(Cocinere, Plato) :- tutore(Cocinere, Tutore), cocinaBien(Tutore, Plato).
cocinaBien(remy, Plato) :- cocina(_, Plato, _).


tutore(linguini, Tutore) :-
    trabaja(linguini, Restaurante),
    rata(Tutore, Restaurante).

tutore(skinner, amelie).



/** Conocer los chefs de un resto, que son, de los que trabajan en el resto, aquellos que cocinan bien todos los platos del menú ó entre todos los platos que sabe cocinar suma una experiencia de al menos 20. */
chef(Cocinere, Restaurante) :-
    trabaja(Cocinere, Restaurante),
    esRespetado(Cocinere, Restaurante).

esRespetado(Cocinere, Restaurante) :-
    forall(menu(Restaurante, Plato), cocinaBien(Cocinere, Plato)).

esRespetado(Cocinere, _) :-
    experienciaTotal(Cocinere, Experiencia),
    Experiencia >= 20.

experienciaTotal(Cocinere, Experiencia) :-
    findall(Exp, cocina(Cocinere, _, Exp), Exps),
    sum_list(Exps, Experiencia).


/** encargadoDe/3: nos dice el encargado de cocinar un plato en un restaurante, que es quien más experiencia tiene preparándolo en ese lugar. */

encargadeDe(Encargado, Plato, Restaurante) :- 
    trabaja(Encargado,Restaurante),
    cocina(Encargado, Plato, Experiencia),
    forall((trabaja(OtroCocinere,Restaurante),OtroCocinere \= Encargado,cocina(OtroCocinere, Plato, Experiencia2)), Experiencia >= Experiencia2).

/** Platos de comida: */
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(pechugaALaPlancha, principal(ensalada, 10)).
plato(frutillasConCrema, postre(265)).
plato(ensalaDeFrutas, postre(70)).

/** saludable/1: un plato es saludable si tiene menos de 75 calorías. */
saludable(Plato):- 
    plato(Plato, TipoPlato), 
    calorias(TipoPlato, Calorias),
    Calorias < 75.

calorias(postre(Calorias), Calorias).

calorias(principal(Guarnicion,TiempoCoccion), Calorias):- 
    caloriasGuarnicion(Guarnicion, CaloriasGuarnicion),
    Calorias is TiempoCoccion * 5 + CaloriasGuarnicion.

calorias(entrada(Ingredientes), Calorias) :-
    length(Ingredientes, Cantidad),
    Calorias is Cantidad * 15.

caloriasGuarnicion(papasFritas,60).
caloriasGuarnicion(pure,20).
caloriasGuarnicion(ensalada,0).

/** 8. criticaPositiva/2: es verdadero para un restaurante si un crítico le escribe una reseña positiva. */

criticaPositiva(Critico, Restaurante):-
    inspeccionSatisfactoria(Restaurante),
    buenaResenia(Critico, Restaurante).

inspeccionSatisfactoria(Restaurante) :- 
    trabaja(_,Restaurante),
    not(rata(_,Restaurante)).


buenaResenia(antonEgo, Restaurante) :- 
    especialistas(ratatouille, Restaurante).

buenaResenia(cormillot , Restaurante) :- 
    forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)),saludable(Plato)).


especialistas(Plato, Restaurante) :- 
    menu(Restaurante, Plato),
    forall((trabaja(Cocinere, Restaurante), cocina(Cocinere, Plato, _)),cocinaBien(Cocinere, Plato)).

