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

%%%%%%%%%%%%%%%
%% MAIN MENU %%
%%%%%%%%%%%%%%%

% jugar -> Despliega el menu para elegir el modo de juego, filas, columnas, elementos a conectar para ganar. También pregunta por que
% tableros mostrar en los modos de juego en los que participa la IA. Una vez se tienen todos los datos, inicia el juego.
jugar:-
    consult('entradas.pl'),
    consult('fin_juego.pl'),
    consult('introducir_ficha.pl'),
    consult('mostrar_tablero.pl'),
    gameMode(Player1, Player2, M),
    tableRows(R),
    tableColumns(C),
    elementsConnected(R, C, E),
    (
        (
            M = 4,
            showAllBoards(S),
            game(R, C, E, Player1, Player2, _, S, true)
        );
        (
            M = 5,
            simulationNumber(N),
            showFinalBoards(S),
            startSimulation(N, R, C, E, 0, 0, 0, S)
        );
        game(R, C, E, Player1, Player2, _, false, true)
    ).

% startSimulation(N, R, C, E, WX, WO, Tie, ShowFinalBoards) -> Inicia una simulacion de N partidas entre la IA facil y la IA dificil
% acumulando las victorias de cada una y los empates en distintos contadores para mostralos por pantalla una vez acaben.
startSimulation(0, _, _, _, WX, WO, Tie, _):-
    write('Victorias IA facil: '), write_ln(WX),
    write('Victorias IA dificil: '), write_ln(WO),
    write('Empates: '), write_ln(Tie).
startSimulation(N, R, C, E, WX, WO, Tie, ShowFinalBoards):-
    game(R, C, E, jugandoIAFacil, jugandoIADificil, Winner, false, ShowFinalBoards),
    N2 is N-1,
    (
        (
            Winner == 'X',
            WX2 is WX + 1,
            startSimulation(N2, R, C, E, WX2, WO, Tie, ShowFinalBoards)
        );
        (
            Winner == 'O',
            WO2 is WO + 1,
            startSimulation(N2, R, C, E, WX, WO2, Tie, ShowFinalBoards)
        );
        (
            Winner == 'Tie',
            Tie2 is Tie + 1,
            startSimulation(N2, R, C, E, WX, WO, Tie2, ShowFinalBoards)
        )
    ).

%%%%%%%%%%%%%%%%
%% GAME LOGIC %%
%%%%%%%%%%%%%%%%

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
    write('Turno del jugador '),
    (
        (
            Player = 'X',
            ansi_format([fg(yellow)], '~w', 'X')
        );
        (
            Player = 'O',
            ansi_format([fg(red)], '~w', 'O')
        )
    ),
    nl,
    repeat,
    readColumn(C, Cols),
    insert(X, C, Player, X2),
    nl,
    (
        (
            win(Player, X2, N), % Gana
            show(X2, Rows, Cols),
            write('El jugador '),
            (
                (
                    Player = 'X',
                    ansi_format([fg(yellow)], '~w', 'X')
                );
                (
                    Player = 'O',
                    ansi_format([fg(red)], '~w', 'O')
                )
            ),
            write_ln(' ha ganado!')
        );
        (
            full(X2, Cols), % Empata
            show(X2, Rows, Cols),
            write_ln('Empate!')
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugando, _, ShowBoard, ShowFinalBoard) % Continua
    ).
