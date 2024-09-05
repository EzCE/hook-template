include 'include/ez80.inc'
include 'include/tiformat.inc'
include 'include/ti84pceg.inc'

format ti archived executable protected program 'HOOKINST'

_main:
    ld hl, -1
    ld (hl), 2
    ld hl, appvarName
    call ti.Mov9ToOP1

    ; Check if a hook is installed by reading the hook's specific flag
    ; bit <hook flag>, (iy + <hook flag group>)

    jr z, _installHookDelete ; Install our hook if no hook is installed
    call ti.ChkFindSym
    jr c, _installHook ; Install our hook if its AppVar does not exist
    call ti.ChkInRam
    jr z, _installHookDelete ; Install our hook if its AppVar is in RAM
    call _getDataPointer

    ; ld hl, (<hook pointer location>)

    or a, a
    sbc hl, de ; Check if our hook is the one installed by comparing pointers
    jr nz, _installHookDelete ; Clear our hook if it is the one installed, otherwise install it

    ; call <clear hook>

    call ti.ChkFindSym
    jp ti.DelVarArc

_installHookDelete: ; Make sure no AppVar exists before we create our's and install
    call ti.ChkFindSym
    call nc, ti.DelVarArc

_installHook:
    ld hl, _hookSize
    push hl
    ld bc, 128 ; Add 128 to size when checking if there is enough memory, just to be safe
    add hl, bc
    call ti.EnoughMem
    ld a, ti.E_Memory
    jp c, ti.JError ; Return with a memory error if the AppVar can't be created
    pop hl
    push hl ; Get original size back into hl
    call ti.CreateAppVar
    push de
    call ti.OP4ToOP1
    ld hl, _hookStart
    pop de
    pop bc
    inc de
    inc de
    ldir ; Load hook data into freshly created AppVar
    call ti.Arc_Unarc
    call ti.ChkFindSym
    call _getDataPointer ; Find the AppVar data pointer again since it's been moved to archive
    ex de, hl

    ; jp <set hook>

_getDataPointer: ; Get a data pointer in the archive
    ld hl, 10
    add hl, de
    ld a, c
    ld bc, 0
    ld c, a
    add hl, bc
    ex de, hl
    inc de
    inc de
    ret

appvarName:
    db ti.AppVarObj, 'HOOK', 0 ; Can be changed to whatever the hook AppVar should be called 

include 'src/hook.asm'
