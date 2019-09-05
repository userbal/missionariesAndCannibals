: 3dup ( xyz -- xyzxyz ) 2 pick 2 pick 2 pick ;
: 3drop ( xyz -- ) drop drop drop ;  
: pack ( near m c -- packedstate ) swap 10 * + swap 100 * + ;
: unpack ( packedstate -- near m c ) dup 100 / 1 pick 100 mod 10 / 2 pick 10 mod 3 roll drop ; 
: printstate ( side m c -- ) . . . ;


