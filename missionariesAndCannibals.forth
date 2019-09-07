create invalidset 223 , 213 , 123 , 221 , 212 , 220 , 221 , 112 , 113 , 121 , 104 , 113 , 112 , 210 , 

variable usedstack 100 cells allot 
usedstack 20 cells erase
variable usedcounter
0 usedcounter !

variable candidatestack 20 cells allot
candidatestack 20 cells erase
variable candidatecounter
0 candidatecounter !

variable breadcrumbstack 20 cells allot
breadcrumbstack 20 cells erase
variable breadcrumbcounter
0 breadcrumbcounter !

: 3dup ( xyz -- xyzxyz ) 2 pick 2 pick 2 pick ;
: 3drop ( xyz -- ) drop drop drop ;  
: pack ( near m c -- packedstate ) swap 10 * + swap 100 * + ;
: unpack ( packedstate -- near m c ) dup 100 / 1 pick 100 mod 10 / 2 pick 10 mod 3 roll drop ; 
: printstate ( side m c -- ) . . . ;

: isused ( n -- bool )
    \ loop through all set elements
    usedcounter @ 0 ?do
        \ compare n with elt i
        dup usedstack i cells + @
        \ return true if its a match
        = if drop -1 unloop exit then
    loop
    \ return false
    drop 0
;

: addused ( n -- ) 
    usedstack usedcounter @ cells + ! ( store stack value on )
    usedcounter @ ( load onto stack)
    1 + ( add one )
    usedcounter ! ( load usedcounter + 1 )
;

: pushcandidate ( n --  ) 
    candidatestack candidatecounter @ cells + ! ( store stack value on )
    candidatecounter @ ( load onto stack)
    1 + ( add one )
    candidatecounter ! 
;

: popcandidate ( -- n ) 
    candidatecounter @ 1 - cells candidatestack + @
    candidatecounter @ 1 -
    candidatecounter !
;

: pushbreadcrumb ( n --  ) 
    breadcrumbstack breadcrumbcounter @ cells + ! ( store stack value on )
    breadcrumbcounter @ ( load onto stack)
    1 + ( add one )
    breadcrumbcounter ! 
;

: popbreadcrumb ( -- n ) 
    breadcrumbcounter @ 1 - cells breadcrumbstack + @
    breadcrumbcounter @ 1 -
    breadcrumbcounter !
;

: printused ( -- )
    usedcounter @ 0 ?do
    i cells usedstack + ?
    loop
;

: printcandidate ( -- )
    cr ." candidates:"
    candidatecounter @ 0 ?do
        i cells candidatestack + @
        unpack
        cr ." [ " swap rot 2 = if ." far " else ." near " endif . . ." ]"
    loop
;

: printbreadcrumb ( -- )
    cr ." Solution Found " cr
    breadcrumbcounter @ 0 ?do
    i cells breadcrumbstack + ?
    loop
;


: isgoal ( near m c -- bool ) 
    \ compare with 2 0 0
    \ pack
    200 =
;

: 6drop ( x x x x x x -- ) drop drop drop drop drop drop ;
: 5drop ( x x x x x -- ) drop drop drop drop drop ;
: 4drop ( x x x x -- ) drop drop drop drop ;
: 3drop ( x x x -- ) drop drop drop ;

: isvalid ( near m c -- bool ) 
    3dup
    \ if c > 3 || c < 0 6
    dup 3 > if 6drop 0 exit then
    0 < if 5drop 0 exit then

    \ if m > 3 || m < 0 5
    dup 3 > if 5drop 0 exit then
    0 < if 4drop 0 exit then

    \ if near > 2 || near < 1 4
    dup 2 > if 4drop 0 exit then
    1 < if 3drop 0 exit then

    pack
    \ loop through all set elements
    13 0 ?do
        \ compare n with elt i
        dup invalidset i cells + @
        \ return true if its a match
        = if drop 0 unloop exit then
    loop
    \ return true
    drop -1
 ;

: addcandidate ( near m c -- ) 
    3dup

    isvalid  ( -1 or 0 )

    if 
        pack dup
        isused ( -1 or 0 )

        if 
            dup unpack
            cr ." repeat   [ " 
            swap rot 2 = if ." far " else ." near " endif . . ." ]"
            exit
        else
            dup unpack
            cr ." fresh   [ " 
            swap rot 2 = if ." far " else ." near " endif . . ." ]"
            pushcandidate
        endif

    else 
        cr ." invalid   [ " 
        swap rot 2 = if ." far " else ." near " endif . . ." ]"
        exit 
    endif
;

: startstate ( -- near m c ) 
    1 3 3
    pushcandidate
;

: successors ( near m c -- ) 
    \ pack
    dup 200 >= if 100 - else 100 + endif
    dup 1 - ( - 1 )
    swap dup 2 - ( - 2 )
    swap 11 - ( - 11 )
    swap dup 10 - ( - 10 )
    swap dup 20 - ( - 20 )
    5
;

: search ( -- ) 
    printcandidate 
    popcandidate
    dup pushbreadcrumb
    dup isgoal if printbreadcrumb exit
           else
               successors
               0 ?do
                   unpack
                   addcandidate
               loop
           endif
    recurse
    popbreadcrumb
;

: start ( -- ) 
    startstate
    search
;

