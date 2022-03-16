%%%%%%%%%%%%%%%
%% GAME MENU %%
%%%%%%%%%%%%%%%

% jugar -> Despliega el menu para elegir el modo de juego, filas, columnas, elementos a conectar para ganar. También pregunta por que
% tableros mostrar en los modos de juego en los que participa la IA. Una vez se tienen todos los datos, inicia el juego.
jugar:-
    game_mode(Player1, Player2, M),
    leer_entero(Rows, 1, '\u00bfCuantas filas va a tener el tablero?'),
    leer_entero(Cols, 1, '\u00bfCuantas filas va a tener el tablero?'),
    elements_connected(Rows, Cols, E),
    (   
        (   
            M = 4,
            show_all_boards(S),
            game(Rows, Cols, E, Player1, Player2, _, S, true)
        );
        (   
            M = 5,
            simulation_number(N),
            show_final_boards(S),
            start_simulation(N, Rows, Cols, E, 0, 0, 0, S)
        );
        game(Rows, Cols, E, Player1, Player2, _, false, true)
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
            Player2 = jugando_IA_facil
        );
        (   
            M = 3,
            consult('IADificil'),
            Player1 = jugando,
            Player2 = jugando_IA_dificil
        );
        (   
            M > 3,
            consult('IAFacil'),
            consult('IADificil'),
            Player1 = jugando_IA_facil,
            Player2 = jugando_IA_dificil
        )
    ).

% tableColumns(C) -> devuelve el numero de columnas en C
tableColumns(C):-
    leer_entero(C, 1, '\u00bfCuantas columnas va a tener el tablero?').

% elements_connected(R,C,E) -> devuelve el numero de elementos a conectar para ganar en E
elements_connected(R,C,E):-
    (
        R =< C,
        leer_entero(N, 1, R, '\u00bfCuantos elementos hay que conectar para ganar?')
    );
    (
        C < R,
        leer_entero(N, 1, C, '\u00bfCuantos elementos hay que conectar para ganar?')
    ).

% show_all_boards(B) -> devuelve un booleano (B) dependiendo de si se quiere mostrar o no el desarrollo de la partida
show_all_boards(B):-
    leer_booleano(B, '\u00bfQuieres que se muestren los tableros del desarrollo de la partida?').

% show_final_boards(B) -> devuelve un booleano (B) dependiendo de si se quieren mostrar o no los tableros finales
show_final_boards(B):-
    leer_booleano(B, '\u00bfQuieres que se muestren los tableros finales?').

% simulation_number(S) -> devuelve el numero de simulaciones en S
simulation_number(S):-
    repeat,
    write_custom('\u00bfCuantas simulaciones quieres realizar?'), nl,
    read(S),
    integer(S),
    0 < S.

% start_simulation(N, R, C, E, WX, WO, Tie, show_final_boards) -> Inicia una simulacion de N partidas entre la IA facil y la IA dificil
% acumulando las victorias de cada una y los empates en distintos contadores para mostralos por pantalla una vez acaben.
start_simulation(0, _, _, _, WX, WO, Tie, _):-
    write_custom('Victorias IA facil: '), write_custom(WX), nl,
    write_custom('Victorias IA dificil: '), write_custom(WO), nl,
    write_custom('Empates: '), write_custom(Tie).
start_simulation(N, R, C, E, WX, WO, Tie, show_final_boards):-
    game(R, C, E, jugando_IA_facil, jugando_IA_dificil, Winner, false, show_final_boards),
    N2 is N-1,
    (   
        (   
            Winner == 'X',
            WX2 is WX + 1,
            start_simulation(N2, R, C, E, WX2, WO, Tie, show_final_boards)
        );
        (   
            Winner == 'O',
            WO2 is WO + 1,
            start_simulation(N2, R, C, E, WX, WO2, Tie, show_final_boards)
        );
        (   
            Winner == 'Tie',
            Tie2 is Tie + 1,
            start_simulation(N2, R, C, E, WX, WO, Tie2, show_final_boards)
        )
    ).

%%%%%%%%%%%%%%%%%%%
%% COLUMN BOUNDS %%
%%%%%%%%%%%%%%%%%%%

% readColumn(C) -> Lee la consola hasta que se introduzca un entero en el rango [1, Cols] y lo devuelve en C.
readColumn(C, Cols):-
    repeat,
    write_custom('Column: '),
    read(C),
    integer(C),
    1 =< C,
    C =< Cols.

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

%%%%%%%%%%%%%%%%%%%
%% GAME LAUNCHER %%
%%%%%%%%%%%%%%%%%%%

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
