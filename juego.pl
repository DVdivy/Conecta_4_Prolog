%%%%%%%%%%%%%%%%%
%% BUILD BOARD %%
%%%%%%%%%%%%%%%%%

% board(Rows, Cols, X) -> Inicializa un tablero de Rows x Cols y lo devuelve en X.
board(_, 0, []).
board(Rows, Cols, [C|XS]):-
    column(Rows, C),
    Cols2 is Cols-1,
    board(Rows, Cols2, XS).

% column(Rows, C) -> Inicializa una columna de Rows elementos y la devuelve en C.
column(0, []).
column(Rows, [' '|CS]):-
    Rows2 is Rows-1,
    column(Rows2, CS).

%%%%%%%%%%%%%
%% DISPLAY %%
%%%%%%%%%%%%%

% show(X) -> Imprime por pantalla el tablero X (asumimos que es un tablero Rows x Cols).
show(X, Rows, Cols):-
    writeHeader(Cols), nl,
    iShow(X, Rows, Cols, Rows).

% writeHeader(Cols) -> Imprime por pantalla los números de las columnas del tablero.
writeHeader(0).
writeHeader(Cols):-
    Cols2 is Cols-1,
    writeHeader(Cols2),
    write_custom(' '),
    write_custom(Cols).

% iShow(X, N) -> Imprime por pantalla las N filas restantes del tablero X.
iShow(_, 0, Cols, Rows):-
    dashLine(Rows, Cols, 0, Cols), nl.
iShow(X, N, Cols, Rows):-
    dashLine(Rows, Cols, N, Cols), nl,
    showLine(X, X2, Cols, Cols), nl,
    Ns is N-1,
    iShow(X2, Ns, Cols, Rows).

% showLine(X, X2) -> Imprime por pantalla los elementos de la primera fila del tablero X y devuelve en X2 un tablero sin dicha fila.
showLine([], _, _, _):-
    ansi_format([fg(blue)], '~w', '\u2551').
showLine([[X|X2]|XS], [X2|XS2], Cols, ColCurr):-
    (   
        (   
            Cols = ColCurr,
            ansi_format([fg(blue)], '~w', '\u2551')
        );
        ansi_format([fg(blue)], '~w', '\u2502')
    ),
    (   
        (   
            X = ' ',
            write_custom(' ')
        );
        write_custom(Player)
    ),
    ColCurr2 is ColCurr-1,
    showLine(XS, XS2, Cols, ColCurr2).

% dashLine(Rows, Cols, RowCurr, ColCurr) -> Imprime por pantalla una línea
dashLine(_, _, _, -1).
dashLine(Rows, Cols, RowCurr, ColCurr):-
    (   
        (   
            ColCurr = 0,
            (   
                (   
                    RowCurr = 0,
                    ansi_format([fg(blue)], '~w', '\u255D')
                );
                (   
                    RowCurr < Rows,
                    ansi_format([fg(blue)], '~w', '\u2562')
                );
                (   
                    RowCurr = Rows,
                    ansi_format([fg(blue)], '~w', '\u2557')
                )
            )
        );
        (   
            ColCurr < Cols,
            (   
                (   
                    RowCurr = 0,
                    ansi_format([fg(blue)], '~w', '\u2567\u2550')
                );
                (   
                    RowCurr < Rows,
                    ansi_format([fg(blue)], '~w', '\u253C\u2500')
                );
                (   
                    RowCurr = Rows,
                    ansi_format([fg(blue)], '~w', '\u2564\u2550')
                )
            )
        );
        (   
            ColCurr = Cols,
            (   
                (   
                    RowCurr = 0,
                    ansi_format([fg(blue)], '~w', '\u255A\u2550')
                );
                (   
                    RowCurr < Rows,
                    ansi_format([fg(blue)], '~w', '\u255F\u2500')
                );
                (   
                    RowCurr = Rows,
                    ansi_format([fg(blue)], '~w', '\u2554\u2550')
                )
            )
        )
    ),
    ColCurr2 is ColCurr-1,
    dashLine(Rows, Cols, RowCurr, ColCurr2).

%%%%%%%%%%%%%%%%
%% GAME LOGIC %%
%%%%%%%%%%%%%%%%

% jugar -> Despliega el menu para elegir el modo de juego, filas, columnas, elementos a conectar para ganar. También pregunta por que
% tableros mostrar en los modos de juego en los que participa la IA. Una vez se tienen todos los datos, inicia el juego.
jugar:-
    game_mode(Player1, Player2, M),
    table_rows(R),
    table_columns(C),
    elements_connected(R, C, E),
    (   
        (   
            M = 4,
            show_all_boards(S),
            game(R, C, E, Player1, Player2, _, S, true)
        );
        (   
            M = 5,
            simulation_number(N),
            show_final_boards(S),
            start_simulation(N, R, C, E, 0, 0, 0, S)
        );
        game(R, C, E, Player1, Player2, _, false, true)
    ).

game_color().

% players(Player1, Player2, M) -> Menu para elegir el modo de juego M
% - Modo 1: 2 jugadores
% - Modo 2: 1 jugador contra IA nivel facil
% - Modo 3: 1 jugador contra IA nivel dificil
% - Modo 4: IA nivel facil contra IA nivel dificil (1 partida)
% - Modo 5: IA nivel facil contra IA nivel dificil (N partidas)
game_mode(Player1, Player2, M):-
    repeat,
    write_custom('Elige el modo de juego:'), nl,
    write_custom('1. Jugar contra otro jugador'), nl,
    write_custom('2. Jugar contra un bot (Facil)'), nl,
    write_custom('3. Jugar contra un bot (Dificil)'), nl,
    write_custom('4. Enfrentar bots (Facil Vs. Dificil)'), nl,
    write_custom('5. Enfrentar bots (Estadisticas)'), nl,
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
            consult('IAFacil'),
            Player1 = jugando,
            Player2 = jugandoIAFacil
        );
        (   
            M = 3,
            consult('IADificil'),
            Player1 = jugando,
            Player2 = jugandoIADificil
        );
        (   
            M > 3,
            consult('IAFacil'),
            consult('IADificil'),
            Player1 = jugandoIAFacil,
            Player2 = jugandoIADificil
        )
    ).

% table_rows(R) -> devuelve el numero de filas en R
table_rows(R):-
    repeat,
    write_custom('\u00bfCuantas filas va a tener el tablero?'), nl,
    read(R),
    integer(R),
    0 < R.

% table_columns(C) -> devuelve el numero de columnas en C
table_columns(C):-
    repeat,
    write_custom('\u00bfCuantas columnas va a tener el tablero?'), nl,
    read(C),
    integer(C),
    0 < C.

% elements_connected(R,C,E) -> devuelve el numero de elementos a conectar para ganar en E
elements_connected(R,C,E):-
    repeat,
    write_custom('\u00bfCuantos elementos hay que conectar para ganar?'), nl,
    read(E),
    integer(E),
    0 < E,
    (
        E =< R;
        E =< C
    ).

% show_all_boards(S2) -> devuelve un booleano (S2) dependiendo de si se quiere mostrar o no el desarrollo de la partida
show_all_boards(S2):-
    repeat,
    write_custom('\u00bfQuieres que se muestren los tableros del desarrollo de la partida?'), nl,
    write_custom('1. Si'), nl,
    write_custom('2. No'), nl,
    read(S),
    integer(S),
    0 < S,
    S =< 2,
    (   
        (   
            S = 1,
            S2 = true
        );
        (   
            S = 2,
            S2 = false
        )
    ).

% show_final_boards(S2) -> devuelve un booleano (S2) dependiendo de si se quieren mostrar o no los tableros finales
show_final_boards(S2):-
    repeat,
    write_custom('\u00bfQuieres que se muestren los tableros finales?'), nl,
    write_custom('1. Si'), nl,
    write_custom('2. No'), nl,
    read(S),
    integer(S),
    0 < S,
    S =< 2,
    (   
        (   
            S = 1,
            S2 = true
        );
        (   
            S = 2,
            S2 = false
        )
    ).

% simulation_number(S) -> devuelve el numero de simulaciones en S
simulation_number(S):-
    repeat,
    write_custom('\u00bfCuantas simulaciones quieres realizar?'), nl,
    read(S),
    integer(S),
    0 < S.

% start_simulation(N, R, C, E, WX, WO, Tie, ShowFinalBoards) -> Inicia una simulacion de N partidas entre la IA facil y la IA dificil
% acumulando las victorias de cada una y los empates en distintos contadores para mostralos por pantalla una vez acaben.
start_simulation(0, _, _, _, WX, WO, Tie, _):-
    write_custom('Victorias IA facil: '), write_custom(WX), nl,
    write_custom('Victorias IA dificil: '), write_custom(WO), nl,
    write_custom('Empates: '), write_custom(Tie).
start_simulation(N, R, C, E, WX, WO, Tie, ShowFinalBoards):-
    game(R, C, E, jugandoIAFacil, jugandoIADificil, Winner, false, ShowFinalBoards),
    N2 is N-1,
    (   
        (   
            Winner == 'X',
            WX2 is WX + 1,
            start_simulation(N2, R, C, E, WX2, WO, Tie, ShowFinalBoards)
        );
        (   
            Winner == 'O',
            WO2 is WO + 1,
            start_simulation(N2, R, C, E, WX, WO2, Tie, ShowFinalBoards)
        );
        (   
            Winner == 'Tie',
            Tie2 is Tie + 1,
            start_simulation(N2, R, C, E, WX, WO, Tie2, ShowFinalBoards)
        )
    ).

% game(Rows, Cols, Elems, Player1, Player2, Winner, ShowBoard, ShowFinalBoard) -> Inicia una partida de conecta 4.
game(Rows, Cols, Elems, Player1, Player2, Winner, ShowBoard, ShowFinalBoard):-
    board(Rows, Cols, X),
    call(Player1, X, 'X', Rows, Cols, Elems, 'O', Player2, Winner, ShowBoard, ShowFinalBoard).

%%%%%%%%%%%%%%%%%%
%% HUMAN PLAYER %%
%%%%%%%%%%%%%%%%%%

% jugando(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard) -> Imprime el tablero X, indica que
% es el turno del Player (jugador humano), lee donde se debe introducir la siguiente ficha hasta recibir una entrada valida y
% le pasa el turno al Opponent (NextTurn).
jugando(X, Player, Rows, Cols, N, Opponent, NextTurn, _, ShowBoard, ShowFinalBoard):- % Juega
    show(X, Rows, Cols),
    write_custom('Turno del jugador '),
    write_custom(Player),
    nl,
    repeat,
    readColumn(C, Cols),
    insert(X, C, Player, X2),
    nl,
    (   
        (   
            full(X2, Cols), % Empata
            show(X2, Rows, Cols),
            write_custom('Empate!'), nl
        );
        (   
            win(Player, X2, N), % Gana
            show(X2, Rows, Cols),
            write_custom('El jugador '),
            write_custom(Player),
            write_custom(' ha ganado!')
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugando, _, ShowBoard, ShowFinalBoard) % Continua
    ).

%%%%%%%%%%%%%%%%%%%
%% COLUMN BOUNDS %%
%%%%%%%%%%%%%%%%%%%

% readColumn(C) -> Lee la consola hasta que se introduzca un entero en el rango [1, Cols] y lo devuelve en C.
readColumn(C, Cols):-
    write_custom('Column: '),
    read(C),
    integer(C),
    1 =< C,
    C =< Cols.

%%%%%%%%%%%%%%%%%%%%%%
%% INSERT IN COLUMN %%
%%%%%%%%%%%%%%%%%%%%%%

% insert(X, N, Elem, X2) -> Inserta el elemento Elem en la columna N-esima del tablero X y devuelve el tablero modificado en X2.
insert([C|XS], 1, Elem, [C2|XS]):-
    insertColumn(C, Elem, C2).
insert([C|X], N, Elem, [C|X2]):-
    Ns is N-1,
    insert(X, Ns, Elem, X2).

% insertColumn(C, Elem, C2) -> Inserta el elemento Elem en la columna C y devuelve la columna modificada en C2.
insertColumn([' '], Elem, [Elem]).
insertColumn([' ',X|CS], Elem, [Elem,X|CS]):-
    not(X = ' ').
insertColumn([' ',' '|CS], Elem, [' '|C2]):-
    insertColumn([' '|CS], Elem, C2).

%%%%%%%%%%%%%%%%%%%
%% WIN CONDITION %%
%%%%%%%%%%%%%%%%%%%

% win(E, X, N) -> Comprueba que el jugador E haya puesto N fichas en raya en el tablero X.
win(E, [C|XS], N):-
    winRow(E, [C|XS], _, N);   %-
    winCol(E, C, N, N);        %|
    winDiag1(E, [C|XS], _, N); %/
    winDiag2(E, [C|XS], _, N); %\
    win(E, XS, N).

% winCol(E, X, N, NTot) -> Comprueba que el jugador E haya puesto N fichas en columna en el tablero X.
winCol(_, _, 0, _).
winCol(E, [Elem|CS], N, NTot):-
    (   
        E = Elem,
        N2 is N-1,
        winCol(E, CS, N2, NTot),
        !
    );
    winCol(E, CS, NTot, NTot).

% winLine(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en fila en el tablero X.
winRow(_, _, _, 0).
winRow(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    winRow(E, XS, L, N2).

% winDiag1(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en diagonal (abajo-izquierda a arriba-derecha) en el tablero X.
winDiag1(_, _, _, 0).
winDiag1(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    L2 is L-1,
    0 =< L2,
    winDiag1(E, XS, L2, N2).

% winDiag2(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en diagonal (arriba-izquierda a abajo-derecha) en el tablero X.
winDiag2(_, _, _, 0).
winDiag2(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    L2 is L+1,
    0 =< L2,
    winDiag2(E, XS, L2, N2).

%%%%%%%%%%%%%%%%
%% FULL BOARD %%
%%%%%%%%%%%%%%%%

% full(X, Cols) -> Comprueba que no queden espacios libres en la matriz X
full([C|_], 1):-
    fullColumn(C).
full([C|XS], Cols):-
    fullColumn(C),
    Cols2 is Cols-1,
    full(XS, Cols2).

% fullColumn(C) -> Comprueba que no queden espacios libres en la columna C
fullColumn([E|_]):-
    not(E = ' ').
