%%%%%%%%%%%%%%%%%%%
%% WIN CONDITION %%
%%%%%%%%%%%%%%%%%%%

% win(E, X, N) -> Comprueba que el jugador E haya puesto N fichas en raya en el tablero X.
win(E, [C|XS], N):-
    win_row(E, [C|XS], _, N);   %-
    win_col(E, C, N, N);        %|
    win_diag1(E, [C|XS], _, N); %/
    win_diag2(E, [C|XS], _, N); %\
    win(E, XS, N).

% win_col(E, X, N, NTot) -> Comprueba que el jugador E haya puesto N fichas en columna en el tablero X.
win_col(_, _, 0, _).
win_col(E, [Elem|CS], N, NTot):-
    (   
        E = Elem,
        N2 is N-1,
        win_col(E, CS, N2, NTot),
        !
    );
    win_col(E, CS, NTot, NTot).

% winLine(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en fila en el tablero X.
win_row(_, _, _, 0).
win_row(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    win_row(E, XS, L, N2).

% win_diag1(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en diagonal (abajo-izquierda a arriba-derecha) en el tablero X.
win_diag1(_, _, _, 0).
win_diag1(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    L2 is L-1,
    0 =< L2,
    win_diag1(E, XS, L2, N2).

% win_diag2(E, X, L, N) -> Comprueba que el jugador E haya puesto N fichas en diagonal (arriba-izquierda a abajo-derecha) en el tablero X.
win_diag2(_, _, _, 0).
win_diag2(E, [C|XS], L, N):-
    append(E1, [E|_], C),
    length(E1, L),
    N2 is N-1,
    L2 is L+1,
    0 =< L2,
    win_diag2(E, XS, L2, N2).

%%%%%%%%%%%%%%%%
%% FULL BOARD %%
%%%%%%%%%%%%%%%%

% full(X, Cols) -> Comprueba que no queden espacios libres en la matriz X
full([C|_], 1):-
    full_column(C).
full([C|XS], Cols):-
    full_column(C),
    Cols2 is Cols-1,
    full(XS, Cols2).

% full_column(C) -> Comprueba que no queden espacios libres en la columna C
full_column([E|_]):-
    not(E = ' ').
