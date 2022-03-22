%%%%%%%%%%%%%
%% AI HARD %%
%%%%%%%%%%%%%

% jugandoIADificil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard) -> Imprime el tablero X, indica
% que es el turno del Player (IA dificil), le pide a la IA donde introducir la siguiente ficha y le pasa el turno al Opponent
% (NextTurn).
jugandoIADificil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard):- % Juega
    (
        (
            ShowBoard,
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
            write_ln(' (IA dificil)'),
            nl
        );
        not(ShowBoard)
    ),
    playAIWin(X, Cols, Cols, N, X2, Player, Opponent),
    (
        (
            win(Player, X2, N), % Gana
            (
                (
                    ShowFinalBoard,
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
                    write_ln(' (IA dificil) ha ganado!')
                );
                not(ShowFinalBoard)
            ),
            Winner = Player
        );
        (
            full(X2, Cols), % Empata
            (
                (
                    ShowFinalBoard,
                    show(X2, Rows, Cols),
                    write_ln('Empate!')
                );
                not(ShowFinalBoard)
            ),
            Winner = 'Tie'
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugandoIADificil, Winner, ShowBoard, ShowFinalBoard) % Continua
    ).

% playAIWin(X, Cols, Column, N, X2, Player, Opponent) -> Si la IA (Player) puede ganar, lo hace. Si no, pasa a intentar evitar
% que el otro (Opponent) gane.
playAIWin(X, Cols, 0, N, X2, Player, Opponent) :-
    playAIAvoid(X, Cols, Cols, N, X2, Player, Opponent).
playAIWin(X, Cols, Column, N, X2, Player, Opponent):- 
    (
        insert(X, Column, Player, X2),
        win(Player, X2, N)
    );
    (
        Column2 is Column - 1,
        playAIWin(X, Cols, Column2, N, X2, Player, Opponent)
    ).

% playAIAvoid(X, Cols, Column, N, X2, Player, Opponent) -> Si Player puede evitar que Opponent gane, lo hace. Si no, pone
% ficha aleatoriamente
playAIAvoid(X, Cols, 0, N, X2, Player, Opponent):-
    playAIWontLose(X, Cols, Cols, N, X2, Player, Opponent, L),
    playAIRandom(X, Cols, X2, Player, L).
playAIAvoid(X, Cols, Column, N, X2, Player, Opponent):- 
    (
        insert(X, Column, Opponent, X3),
        win(Opponent, X3, N),
        insert(X, Column, Player, X2)
    );
    (
        Column2 is Column - 1,
        playAIAvoid(X, Cols, Column2, N, X2, Player, Opponent)
    ).

% playAIWontLose(X, Cols, Column, N, X2, Player, Opponent, L) -> Player busca en que columnas puede jugar sin perder y las va
% guardando en la lista L.
playAIWontLose(_, _, 0, _, _, _, _, []).
playAIWontLose(X, Cols, Column, N, X2, Player, Opponent, L):-
    Column2 is Column - 1,
    playAIWontLose(X, Cols, Column2, N, X2, Player, Opponent, LS),
    (
        (
            insert(X, Column, Player, X3),
            insert(X3, Column, Opponent, X4),
            not(win(Opponent, X4, N)),
            L = [Column|LS]
        );
        (
            insert(X, Column, Player, X3),
            nth1(Column, X3, C3),
            fullColumn(C3),
            L = [Column|LS]
        );
        L = LS
    ).

% playAIRandom(X, Cols, X2, Player, L) -> Player inserta una ficha aleatoriamente en las posiciones en las que no va a perder
% L o, si pierde en cualquier posicion, en cualquier posicion.
playAIRandom(X, Cols, X2, Player, L):-
    length(L, Len),
    (
        (
            Len = 0,
            repeat,
            random_between(1, Cols, R),
            insert(X, R, Player, X2)
        );
        (
            repeat,
            random_member(R, L),      
            insert(X, R, Player, X2)
        )
    ).
