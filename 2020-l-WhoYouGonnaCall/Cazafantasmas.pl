/* ------------------------------------- 
                PARTE 1
            CAZAFANTASMAS
   ------------------------------------- 

Base de conocimiento */

% herramientasRequeridas(Tarea de limpieza, Herramientas)
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).
herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).

cazafantasmas(peter).
cazafantasmas(egon).
cazafantasmas(ray).
cazafantasmas(winston).


/* Punto 1
    Agregar a la base de conocimientos la siguiente información:
    - Egon tiene una aspiradora de 200 de potencia.
    - Egon y Peter tienen un trapeador, Ray y Winston no.
    - Sólo Winston tiene una varita de neutrones.
    - Nadie tiene una bordeadora. */

    poseeHerramienta(egon, aspiradora(200)).
    poseeHerramienta(egon, trapeador).
    poseeHerramienta(peter, trapeador).
    poseeHerramienta(winston, varitaDeNeutrones).

    poseeHerramienta(egon, plumero).
    poseeHerramienta(egon, escoba).
    poseeHerramienta(egon, pala).
    poseeHerramienta(peter, sopapa).
    poseeHerramienta(peter, escoba).
    poseeHerramienta(peter, plumero).


/* Punto 2 
    Definir un predicado que determine si un integrante satisface la necesidad de una herramienta requerida. 
    Esto será cierto si tiene dicha herramienta, teniendo en cuenta que si la herramienta requerida es una aspiradora, 
    el integrante debe tener una con potencia igual o superior a la requerida.

    Nota: No se pretende que sea inversible respecto a la herramienta requerida.*/

    tieneHerramientaRequerida(Integrante, Herramienta):-
        poseeHerramienta(Integrante, Herramienta),
        Herramienta \= aspiradora(_).
    tieneHerramientaRequerida(Integrante, aspiradora(PotenciaRequerida)):-
        poseeHerramienta(Integrante, aspiradora(Potencia)),
        Potencia >= PotenciaRequerida.


/* Punto 3
    Queremos saber si una persona puede realizar una tarea, que dependerá de las herramientas que tenga. Sabemos que:
    - Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
    - Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de todas las herramientas requeridas para dicha tarea. */
      
    puedeRealizarTarea(Persona, Tarea, ListaDeHerramientas):-
        cazafantasmas(Persona),
        herramientasRequeridas(Tarea, ListaDeHerramientas),
        forall((member(Herramienta, ListaDeHerramientas), Herramienta \= varitaDeNeutrones), tieneHerramientaRequerida(Persona, Herramienta)).
    puedeRealizarTarea(Persona, Tarea, _):-
        herramientasRequeridas(Tarea, _),
        poseeHerramienta(Persona, varitaDeNeutrones).


/* Punto 4
    Nos interesa saber de antemano cuanto se le debería cobrar a un cliente por un pedido (que son las tareas que pide). Para ellos disponemos de 
    la siguiente información en la base de conocimientos:
    - tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros cuadrados sobre los cuales hay que realizar esa tarea.
    - precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al cliente.
    
    Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea, multiplicando el precio por los metros cuadrados de la tarea. */
    
    costoDePedido(Cliente, Pedido, CostoTotal):-
        pedido(Cliente, Pedido),
        findall(Costo, (member(Tarea, Pedido), costoPorTarea(Cliente, Tarea, Costo)), ListaDeCostos),
        sum_list(ListaDeCostos, CostoTotal).


    % tareaPedida(Cliente, TareaPedida, MetrosCuadrados)
    tareaPedida(elo, limpiarTecho, 20).
    tareaPedida(elo, cortarPasto, 10).
    tareaPedida(marco, limpiarBanio, 2).
    tareaPedida(maria, ordenarCuarto, 10).
    tareaPedida(maria, encerarPisos, 10).
    tareaPedida(cielo, limpiarTecho, 20).

    % precio(Tarea, Precio)
    precioPorTarea(ordenarCuarto, 500).
    precioPorTarea(limpiarTecho, 200).
    precioPorTarea(cortarPasto, 100).
    precioPorTarea(limpiarBanio, 200).
    precioPorTarea(encerarPisos, 500).

    cliente(Cliente):-
        tareaPedida(Cliente, _, _).
    
    pedido(Cliente, ListaDeTareas):-
        cliente(Cliente),
        findall(Tarea, tareaPedida(Cliente, Tarea, _), ListaDeTareas).
        
    costoPorTarea(Cliente, Tarea, Costo):-
        tareaPedida(Cliente, Tarea, Metros),
        precioPorTarea(Tarea, Precio),
        Costo is Metros * Precio.

/* Punto 5
    Finalmente necesitamos saber quiénes aceptarían el pedido de un cliente. Un integrante acepta el pedido cuando 
    - puede realizar todas las tareas del pedido y además está dispuesto a aceptarlo.
    - Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos, Winston sólo acepta pedidos que paguen más de $500, 
      Egon está dispuesto a aceptar pedidos que no tengan tareas complejas y Peter está dispuesto a aceptar cualquier pedido.
    
    Decimos que una tarea es compleja si requiere más de dos herramientas. Además la limpieza de techos siempre es compleja. */

    
    aceptaElPedido(Integrante, Cliente, Pedido):-
        cazafantasmas(Integrante),
        pedido(Cliente, Pedido),
        forall(member(Tarea, Pedido), puedeRealizarTarea(Integrante, Tarea, _)),
        dispuestoAceptar(Integrante, Cliente, Pedido).


    dispuestoAceptar(ray, Cliente, Pedido):-
        pedido(Cliente, Pedido),
        not(member(limpiarTecho, Pedido)).
    dispuestoAceptar(winston, Cliente, Pedido):-
        costoDePedido(Cliente, Pedido, CostoDePedido),
        CostoDePedido > 500.
    dispuestoAceptar(egon, Cliente, Pedido):-
        pedido(Cliente, Pedido),
        forall(member(Tarea, Pedido), not(tareaCompleja(Tarea))).
    dispuestoAceptar(peter, Cliente, Pedido):-
        pedido(Cliente, Pedido).

    tareaCompleja(Tarea):-
        herramientasRequeridas(Tarea, ListaDeHerramientas),
        length(ListaDeHerramientas, Cantidad),
        Cantidad > 2.


/* Punto 6
    Necesitamos agregar la posibilidad de tener herramientas reemplazables, que incluyan 2 herramientas de las que pueden tener los integrantes como alternativas, 
    para que puedan usarse como un requerimiento para poder llevar a cabo una tarea.
    a. Mostrar cómo modelarías este nuevo tipo de información modificando el hecho de herramientasRequeridas/2 para que ordenar un cuarto pueda realizarse tanto 
        con una aspiradora de 100 de potencia como con una escoba, además del trapeador y el plumero que ya eran necesarios.

        agregar un nuevo hecho con la nueva informacion en el predicado de herramientasRequeridas
        herramientasRequeridas(ordenarCuarto, [escoba, trapeador, plumero]).
                                               ^^^^^^

    b. Realizar los cambios/agregados necesarios a los predicados definidos en los puntos anteriores para que se soporten estos nuevos requerimientos de herramientas para poder 
        llevar a cabo una tarea, teniendo en cuenta que para las herramientas reemplazables alcanza con que el integrante satisfaga la necesidad de alguna de las herramientas indicadas 
        para cumplir dicho requerimiento.

        - ligar las herramientasRequeridas antes del forall en el predicado de puedeRealizarTarea, y así asegurarnos que el predicado matcheara con una única lista de herramientas por tarea a la vez
         y agregar un parametro en aceptarPedido que usa a al predicado puedeRealizarTarea.
    
    c. Explicar a qué se debe que esto sea difícil o fácil de incorporar. 
        
        El concepto que facilita los cambios para el nuevo requerimiento es el POLIMORFISMO, que nos permite dar un tratamiento en particular a cada una de las listas de herramientas en la cabeza 
        de la cláusula */