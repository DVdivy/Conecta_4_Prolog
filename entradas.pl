leer_entero(N, Li, Ls, Msg):-
    repeat,
    write_custom(Msg), nl,
    read(N),
    integer(N),
    Li =< N,
    N < Ls.

leer_entero(N, Li, Msg):-
    repeat,
    write_custom(Msg), nl,
    read(N),
    integer(N),
    Li =< N.

% '\u00bfQuieres que se muestren los tableros del desarrollo de la partida?'
leer_booleano(B, Msg):-
    repeat,
    write_custom(Msg), nl,
    write_custom('1. Si'), nl,
    write_custom('2. No'), nl,
    read(S),
    integer(S),
    0 < S,
    S =< 2,
    (   
        (   
            S = 1,
            B = true
        );
        (   
            S = 2,
            B = false
        )
    ).
