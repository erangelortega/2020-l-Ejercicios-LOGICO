/* ------------------------------------- 
    PUNTO 1 - Sombrero Seleccionador
   ------------------------------------- 
 Parte a
    Saber si una casa permite entrar a un mago, lo cual se cumple para cualquier mago y cualquier casa excepto en el caso de Slytherin, que no permite entrar a magos de sangre impura.
     */

    permiteEntrar(Casa, _):-
        Casa \= slytherin.

    
    %permiteEntrar(Casa, Mago):-


