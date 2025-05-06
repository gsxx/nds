.arm
.align 4

.global _start
_start:
    b startup

startup:
    ldr sp, =0x027FFF00  @ Pila ARM9
    bl  main             @ Llamar a main()
    b   .                @ Bucle infinito al terminar