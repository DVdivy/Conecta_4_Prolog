%%%%%%%%%%%%%
%% AI EASY %%
%%%%%%%%%%%%%

% jugandoIAFacil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard) -> Imprime el tablero X, indica
% que es el turno del Player (IA facil), le pide a la IA donde introducir la siguiente ficha y le pasa el turno al Opponent
% (NextTurn).
jugandoIAFacil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard):- % Juega
    (
        (
            ShowBoard,
            show(X, Rows, Cols),
            write('Turno del jugador '),
            (
                (
                    Player = 'X',
                    ansi_format([fg(yellow)], '~w', 'O')
                );
                (
                    Player = 'O',
                    ansi_format([fg(red)], '~w', 'O')
                )
            ),
            write_ln(' (IA facil)'),
            nl
        );
        not(ShowBoard)
    ),
    repeat,
    random_between(1, Cols, R),
    insert(X, R, Player, X2),
    (
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
                            ansi_format([fg(yellow)], '~w', 'O')
                        );
                        (
                            Player = 'O',
                            ansi_format([fg(red)], '~w', 'O')
                        )
                    ),
                    write_ln(' (IA facil) ha ganado!')
                );
                not(ShowFinalBoard)
            ),
            Winner = Player
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugandoIAFacil, Winner, ShowBoard, ShowFinalBoard) % Continua
    ).
