/* ------------------------------------- 
            PUNTO 1 - sombrero seleccionador
   ------------------------------------- 
 Parte a
     */




/* Parte c - CASOS DE PRUEBA */

:- begin_tests(mafia_punto1).

    test(en_una_ronda_puede_perder_mas_de_una_persona, set(Persona == [bart, lisa])):-
        perdioLaRonda(5, Persona).

:- end_tests(mafia_punto1).


/* ------------------------------------- 
            PUNTO 2 -
   ------------------------------------- 
 Punto a
     */



/* Parte c - CASOS DE PRUEBA */   

:- begin_tests(mafia_punto2).

    test(contrincantes_de_la_antiMafia, set(Persona == [bart, tony, maggie])):-
        contrincante(homero, Persona).

    test(ganador_o_ganadores, nondet):-
        ganador(maggie).

% alternativa para set
	test(todas_las_personas_en_juego_juegan_la_primera_ronda_2, nondet):-
        forall(rol(Persona,_), sigueEnJuego(Persona, 1)).
:- end_tests(mafia_punto2).


/* ------------------------------------- 
            PUNTO 3 - IMBATIBLE (Maxi)
   ------------------------------------- 
 Punto a
    
 */




/* ------------------------------------- 
            PUNTO 4 - MAS INFO
   ------------------------------------- 
 Punto a
    */



/* ------------------------------------- 
            PUNTO 5 - Estrategia
   ------------------------------------- */
/*  Punto a.

     */

