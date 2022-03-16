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
    write(' '), write(Cols).

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
            X = 'X',
            ansi_format([fg(yellow)], '~w', 'O')
        );
        (
            X = 'O',
            ansi_format([fg(red)], '~w', 'O')
        );
        write(' ')
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

