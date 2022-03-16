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
