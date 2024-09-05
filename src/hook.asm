_hookStart:
    db $83

    ; ---------------------
    ;
    ; Hook code goes here
    ;
    ; ---------------------

    ret

_hookSize := $ - _hookStart
