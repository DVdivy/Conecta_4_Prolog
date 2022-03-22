%%%%%%%%%%%
%% INPUT %%
%%%%%%%%%%%

% gameMode(Player1, Player2, M) -> Menu para elegir el modo de juego M.
gameMode(Player1, Player2, M):-
    repeat,
    write_ln('Elige el modo de juego:'),
    write_ln('1. Jugar contra otro jugador'),
    write_ln('2. Jugar contra un bot (Facil)'),
    write_ln('3. Jugar contra un bot (Dificil)'),
    write_ln('4. Enfrentar bots (Facil Vs. Dificil)'),
    write_ln('5. Enfrentar bots (Estadisticas)'),
    read(M),
    integer(M),
    0 < M,
    M < 6,
    (
        (
            M = 1,
            Player1 = jugando,
            Player2 = jugando
        );
        (
            M = 2,
            Player1 = jugando,
            Player2 = jugandoIAFacil,
            consult('ia_facil.pl')
        );
        (
            M = 3,
            Player1 = jugando,
            Player2 = jugandoIADificil,
            consult('ia_dificil.pl')
        );
        (
            M > 3,
            Player1 = jugandoIAFacil,
            Player2 = jugandoIADificil,
            consult('ia_facil.pl'),
            consult('ia_dificil.pl')
        )
    ).

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
