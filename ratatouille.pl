/** Base de conocimiento */
%rata(Nombre, Restaurante donde vive)
rata(remy, gusteaus).
rata(emile, chezMilleBar).
rata(django,pizzeriaJeSuis).

%cocina(Cociner, Restarurante, Experiencia)
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5).
cocina(colette, salmonAsado, 10).
cocina(colette, sopa, 10).
cocina(horst, ensalaRusa, 8).

%trabaja(Cocinero, Retsaurante donde trabaja)
trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(skinner, gusteaus).
trabaja(amelie, cafeDes2Moulins).

/* Punto 1
    Saber si un plato está en el menú de un restaurante, que es cuando alguno de los empleados lo sabe cocinar */
menu(Restaurante, Plato) :-
    trabaja(Cocinere, Restaurante),
    cocina(Cocinere, Plato ,_).

/* Punto 2
    Saber quién cocina bien un determinado plato, que es verdadero para una persona 
    - si su experiencia preparando ese plato es mayor a 7, ó
    - si tiene un tutor que cocina bien el plato. 
    
    Nos contaron que Linguini tiene como tutor a toda rata que viva en el lugar donde trabaja, 
    además que Amelie es la tutora de Skinner.
    También se sabe que remy cocina bien cualquier plato que exista.
 */
cocinaBien(Cocinere, Plato) :- 
    cocina(Cocinere, Plato, Exp), 
    Exp > 7.
cocinaBien(Cocinere, Plato) :- 
    tutore(Cocinere, Tutore), 
    cocinaBien(Tutore, Plato).
cocinaBien(remy, Plato) :- 
    cocina(_, Plato, _).


tutore(linguini, Tutore) :-
    trabaja(linguini, Restaurante),
    rata(Tutore, Restaurante).

tutore(skinner, amelie).



/* Saber si alguien es chef de un restó. Los chefs son, de los que trabajan en el restó, 
    - aquellos que cocinan bien todos los platos del menú ó 
    - entre todos los platos que sabe cocinar suma una experiencia de al menos 20. */
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


/* Punto 4
    Deducir cuál es la persona encargada de cocinar un plato en un restaurante, que es 
    - quien más experiencia tiene preparándolo en ese lugar.

    Nota: si sos la única persona que cocina el plato, sos el encargado, dado que tenés más experiencia cocinando el plato que las demás personas. */

encargadeDe(Encargado, Plato, Restaurante) :- 
    trabaja(Encargado,Restaurante),
    cocina(Encargado, Plato, Experiencia),
    forall((trabaja(OtroCocinere,Restaurante),OtroCocinere \= Encargado,cocina(OtroCocinere, Plato, Experiencia2)), Experiencia >= Experiencia2).


/* --------------------------------------------------------------
                PARTE 2
----------------------------------------------------------------- */
/** Platos de comida mas vendidos: */
plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(pechugaALaPlancha, principal(ensalada, 10)).
plato(frutillasConCrema, postre(265)).
plato(ensalaDeFrutas, postre(70)).

/*PUNTO 5
    Si un plato es saludable (si tiene menos de 75 calorías).
    - En las entradas, cada ingrediente suma 15 calorías.
    - Los platos principales suman 5 calorías por cada minuto de cocción. 
        Las guarniciones agregan a la cuenta total: las papas fritas 50 y el puré 20, mientras que la ensalada no aporta calorías.
    - De los postres ya conocemos su cantidad de calorías. */
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

/** PUNTO 6
    Un restaurante recibe mayor reputación si un crítico le escribe una reseña positiva. 
    Queremos saber si algún crítico le hizo una reseña positiva a algún restaurante.

    Cada crítico maneja su propio criterio, pero todos están de acuerdo en lo mismo: el lugar no debe tener ratas viviendo en él.

    - Anton Ego espera, además, que en el lugar sean especialistas preparando ratatouille. Un restaurante es especialista en aquellos platos que todos sus chefs saben cocinar bien.
    - Cormillot requiere que todos los platos que saben cocinar los empleados del restaurante sean saludables.
    - Martiniano es jerarquista, así que requiere exista sólo un chef en el restaurante.
    - Gordon Ramsey no le da una crítica positiva a ningún restaurante.

 */

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

