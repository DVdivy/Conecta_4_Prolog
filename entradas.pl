%%%%%%%%%%%
%% INPUT %%
%%%%%%%%%%%

% tableRows(R) -> devuelve el numero de filas en R
tableRows(R):-
    repeat,
    write_ln('\u00bfCuantas filas va a tener el tablero?'),
    read(R),
    integer(R),
    0 < R.

% tableColumns(C) -> devuelve el numero de columnas en C
tableColumns(C):-
    repeat,
    write_ln('\u00bfCuantas columnas va a tener el tablero?'),
    read(C),
    integer(C),
    0 < C.

% elementsConnected(R,C,E) -> devuelve el numero de elementos a conectar para ganar en E
elementsConnected(R, C, E):-
    repeat,
    write_ln('\u00bfCuantos elementos hay que conectar para ganar?'),
    read(E),
    integer(E),
    0 < E,
    E =< R,
    E =< C.

% showAllBoards(B) -> devuelve un booleano (B) dependiendo de si se quiere mostrar o no el desarrollo de la partida
showAllBoards(S = 1):-
    repeat,
    write_ln('\u00bfQuieres que se muestren los tableros del desarrollo de la partida?'),
    write_ln('1. Si'),
    write_ln('2. No'),
    read(S),
    integer(S),
    0 < S,
    S =< 2.

% showFinalBoards(B) -> devuelve un booleano (B) dependiendo de si se quieren mostrar o no los tableros finales
showFinalBoards(S = 1):-
    repeat,
    write_ln('\u00bfQuieres que se muestren los tableros finales?'),
    write_ln('1. Si'),
    write_ln('2. No'),
    read(S),
    integer(S),
    0 < S,
    S =< 2.

% simulationNumber(S) -> devuelve el numero de simulaciones en S
simulationNumber(S):-
    repeat,
    write_ln('\u00bfCuantas simulaciones quieres realizar?'),
    read(S),
    integer(S),
    0 < S.

% readColumn(C) -> Lee la consola hasta que se introduzca un entero en el rango [1, Cols] y lo devuelve en C.
readColumn(C, Cols):-
    write('Column: '),
    read(C),
    integer(C),
    1 =< C,
    C =< Cols.
