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
