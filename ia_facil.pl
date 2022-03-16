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
            write_custom('Turno del jugador '),
            write_custom(Player),
            write_custom(' (IA facil)')
            , nl
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
                    write_custom('Empate!')
                    , nl
                );
                not(ShowFinalBoard)
            )
        );
        (   
            win(Player, X2, N), % Gana
            (   
                (   
                    ShowFinalBoard,
                    show(X2, Rows, Cols),
                    write_custom('El jugador '),
                    write_custom(Player),
                    write_custom(' (IA facil) ha ganado!')
                    , nl
                );
                not(ShowFinalBoard)
            ),
            Winner = Player
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugandoIAFacil, Winner, ShowBoard, ShowFinalBoard) % Continua
    ).
