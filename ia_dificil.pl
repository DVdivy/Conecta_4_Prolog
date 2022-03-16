%%%%%%%%%%%%%
%% AI HARD %%
%%%%%%%%%%%%%

% jugando_IA_dificil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard) -> Imprime el tablero X, indica
% que es el turno del Player (IA dificil), le pide a la IA donde introducir la siguiente ficha y le pasa el turno al Opponent
% (NextTurn).
jugando_IA_dificil(X, Player, Rows, Cols, N, Opponent, NextTurn, Winner, ShowBoard, ShowFinalBoard):- % Juega
    (  
        (   
            ShowBoard,
            show(X, Rows, Cols),
            write_custom('Turno del jugador '),
            write_custom(Player),
            write_custom(' (IA dificil)'), nl,
            nl
        );
        not(ShowBoard)
    ),
    play_AI_win(X, Cols, Cols, N, X2, Player, Opponent),
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
                    write_custom(' (IA dificil) ha ganado!')
                    , nl
                );
                not(ShowFinalBoard)
            ),
            Winner = Player
        );
        call(NextTurn, X2, Opponent, Rows, Cols, N, Player, jugando_IA_dificil, Winner, ShowBoard, ShowFinalBoard) % Continua
    ).

% play_AI_win(X, Cols, Column, N, X2, Player, Opponent) -> Si la IA (Player) puede ganar, lo hace. Si no, pasa a intentar evitar
% que el otro (Opponent) gane.
play_AI_win(X, Cols, 0, N, X2, Player, Opponent) :-
    play_AI_avoid(X, Cols, Cols, N, X2, Player, Opponent).
play_AI_win(X, Cols, Column, N, X2, Player, Opponent):- 
    (   
        insert(X, Column, Player, X2),
        win(Player, X2, N)
    );
    (   
        Column2 is Column - 1,
        play_AI_win(X, Cols, Column2, N, X2, Player, Opponent)
    ).

% play_AI_avoid(X, Cols, Column, N, X2, Player, Opponent) -> Si Player puede evitar que Opponent gane, lo hace. Si no, pone
% ficha aleatoriamente
play_AI_avoid(X, Cols, 0, N, X2, Player, Opponent):-
    play_AI_wont_lose(X, Cols, Cols, N, X2, Player, Opponent, L),
    play_AI_random(X, Cols, X2, Player, L).
play_AI_avoid(X, Cols, Column, N, X2, Player, Opponent):- 
    (   
        insert(X, Column, Opponent, X3),
        win(Opponent, X3, N),
        insert(X, Column, Player, X2)
    );
    (   
        Column2 is Column - 1,
        play_AI_avoid(X, Cols, Column2, N, X2, Player, Opponent)
    ).

% play_AI_wont_lose(X, Cols, Column, N, X2, Player, Opponent, L) -> Player busca en que columnas puede jugar sin perder y las va
% guardando en la lista L.
play_AI_wont_lose(_, _, 0, _, _, _, _, []).
play_AI_wont_lose(X, Cols, Column, N, X2, Player, Opponent, L):-
    Column2 is Column - 1,
    play_AI_wont_lose(X, Cols, Column2, N, X2, Player, Opponent, LS),
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
            full_column(C3),
            L = [Column|LS]
        );
        L = LS
    ).

% play_AI_random(X, Cols, X2, Player, L) -> Player inserta una ficha aleatoriamente en las posiciones en las que no va a perder
% L o, si pierde en cualquier posicion, en cualquier posicion.
play_AI_random(X, Cols, X2, Player, L):-
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
