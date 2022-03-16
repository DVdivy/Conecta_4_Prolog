%%%%%%%%%%%%%%%%%%%%
%% CUSTOM PRINTER %%
%%%%%%%%%%%%%%%%%%%%

write_custom(X):-
    (
        X = 'X',
        ansi_format([fg(yellow)], '~w', 'X')
    );
    (   
        X = 'O',
        ansi_format([fg(red)], '~w', 'O')
    );
    (   
        (   
            X = '\u2551';
            X = '\u2502';
            X = '\u255D';
            X = '\u2562';
            X = '\u2557';
            X = '\u2567\u2550';
            X = '\u253C\u2500';
            X = '\u2564\u2550';
            X = '\u255A\u2550';
            X = '\u255F\u2500';
            X = '\u2554\u2550'
        ),
        ansi_format([fg(blue)], '~w', X)
    );
    write(X).
