        ; KR580VM80A (i8080A) assembly code for Radio-86RK (32kb)

; /-----------------------------------------------\
; | ГОСТ 28147-89 "Магма" | GOST 28147-89 "Magma" |
; |                       |                       |
; |Режим выр. имитовставки|        MAC mode       |
; |                       |                       |
; | Реализация алгоритма  |  Algorithm implement. |
; |    для процессора     |     for processor     |
; |      КР580ВМ80А       |      Intel 8080A      |
; |                       |                       |
; |      Магма-Имито      |       Magma-Imito     |
; |      Радио-86РК       |       Radio-86RK      |
; \-----------------------------------------------/

exit	equ 0F86Ch
setch	equ 0F809h
sethex	equ 0F815h
print	equ 0F818h

        org 0

;----------------------------------------------------
;       Изменяемые параметры | Changeable parameters 
;----------------------------------------------------

        lxi de, text ; Адрес начала текста | Text start address

        lxi hl, 128  ; Количество блоков для обработки (8 б) | Number of blocks to process (8 b)

;----------------------------------------------------
;       ********************************************
;----------------------------------------------------
	
        push hl

        lxi hl, title
        call print

        lxi hl, imito
        mvi b, 8

imrst:  ; Очистка зоны имитовставки | Clearing the Message Authentication Code area
        xra a
        mov m, a
        inx hl
        dcr b
        jnz imrst

;----------------------------------------------------

start:  ; Запуск алгоритма | Running the algorithm

        lxi hl, imito
        mvi c, 8
        call 2addf

        lxi bc, 0111h
        mvi a, 1
        push de
        push bc

;--------------------------

drtobf: ; Перенос правого блока в буфер | Move the right block to the buffer
        lxi hl, buf
        lxi de, imito+4
        mvi c, 4
        mov b, a
drloop:
        ldax de
        inx de
        mov m, a
        inx hl
        dcr c
        jnz drloop
        mov a, b

;---------------------------

mainlp:
        push psw

;----------------------------------------------------

gikey:  ; Получение адреса итерационного ключа | Getting the address of the iteration key
        lxi hl, key+3
grnum:
        cpi 9
        jc gnadr
        sui 8
        jmp grnum

gnadr:
        dcr a
        jz 32add
        lxi bc, 4
galoop:
        dad bc
        dcr a
        jnz galoop

;--------------------------

32add:  ; Cложение по модулю 32 | Addition by mod 32
        xchg
        lxi hl, buf+3
        mvi c, 4
        ora a
        push psw
32loop:
        pop psw
        ldax de
        dcx de
        adc m
        mov m, a
        dcx hl
        push psw
        dcr c
        jnz 32loop

        pop psw

;--------------------------

tchg:   ; T-преобразование | T-transform
        lxi de, buf
        mvi c, 4
tcloop:
        ldax de
        ani 00001111b
        lxi hl, pitab+10h
        call findvt
        mov b, a
        ldax de
        rrc
        rrc
        rrc
        rrc
        ani 00001111b
        lxi hl, pitab
        call findvt
        rlc
        rlc
        rlc
        rlc
        ora b
        stax de
        inx de
        dcr c
        jnz tcloop

;--------------------------

11left: ; Цикличный сдвиг битов на 11 позиций влево | Cyclic bit shift 11 positions to the left
        lxi hl, buf+3
        lda buf
        mvi c, 3
        mov b, m
8yloop:
        dcx hl
        mov d, m
        mov m, b
        mov b, d
        dcr c
        jnz 8yloop

        lxi hl, buf+3
        mov m, a
        lxi de, 4
        lxi bc, 0403h
3bloop:
        ora a
        push psw
3bilop:
        pop psw
        mov a, m
        ral
        mov m, a
        push psw
        dcx hl
        dcr b
        jnz 3bilop

        dad de
        pop psw
        jnc skipcr
        mov a, m
        ori 1
        mov m, a
skipcr:
        mvi b, 4
        dcr c
        jnz 3bloop

;--------------------------

2add:   ; Сложение по модулю 2 (XOR) | Addition by mod 2 (XOR)
        lxi hl, buf
        lxi de, imito
        mvi c, 4
        call 2addf

;----------------------------------------------------

        call swap
        pop psw
        pop bc
        add b
        cmp c
        push bc
        jnz mainlp

        pop bc
        
        pop de
        pop hl
        dcx hl
        push hl
        xra a
        cmp h
        jnz start
        cmp l
        jnz start

        lxi hl, done
        call print
        lxi hl, imito
        call prih64

        jmp exit ; Конец программы | End of the program

;----------------------------------------------------

2addf:  ; Функция сложения по модулю 2 (XOR) | Addition by mod 2 (XOR) function
        ldax de
        inx de
        xra m
        mov m, a
        inx hl
        dcr c
        jnz 2addf
        ret

;--------------------------

swap:   ; Перенос блоков | Swapping blocks
        lxi hl, imito
        lxi de, imito+4
        mvi c, 4
        call doswap
        lxi hl, imito+4
        lxi de, buf
        mvi c, 4

doswap:
        mov b, a
swaplp:
        ldax de
        inx de
        mov m, a
        inx hl
        dcr c
        jnz swaplp
        mov a, b
        ret

;--------------------------

findvt: ; Преобразование 2D координаты таблицы в 1D адрес | Convert 2D table coordinate to 1D address
        push bc
        push de
        cpi 0
        cnz fdloph
        lxi de, 10h
        mvi a, 4
        sub c
        jz fdend
        add a
fdlopw:
        dad de
        dcr a 
        jnz fdlopw
fdend:
        mov a, m
        pop de
        pop bc
        ret

fdloph:
        mvi d, 0
        mov e, a
        dad de
        ret

;----------------------------------------------------

prih64: ; HEX вывод 64-бит данных на дисплей | HEX print 64-bit data to the display
        mvi b, 8
prhlop:
        mov a, m
        call sethex
        mvi c, 20h
        call setch
        inx hl
        dcr b
        jnz prhlop

        lxi bc, 0A0Dh
        call setch
        mov c, b
        call setch
        ret

;----------------------------------------------------

title:
        db 1fh,'magma-imito',0dh,0ah
        db 'rabota...',0

done:
        db 0dh,0ah,'imitowstawka: ',0

;----------------------------------------------------

buf:    ; Буфер | Buffer
        db 0, 0, 0, 0

pitab:  ; Таблица перестановок (S-блоки) | Permutation table (S-blocks)
        db 1, 7, 14, 13, 0, 5, 8, 3, 4, 15, 10, 6, 9, 12, 11, 2
        db 8, 14, 2, 5, 6, 9, 1, 12, 15, 4, 11, 0, 13, 10, 3, 7
        db 5, 13, 15, 6, 9, 2, 12, 10, 11, 7, 8, 1, 4, 3, 14, 0
        db 7, 15, 5, 10, 8, 1, 6, 13, 0, 9, 3, 14, 11, 4, 2, 12
        db 12, 8, 2, 1, 13, 4, 15, 6, 7, 0, 10, 5, 3, 14, 9, 11
        db 11, 3, 5, 8, 2, 15, 10, 13, 14, 1, 7, 4, 12, 9, 6, 0
        db 6, 8, 2, 3, 9, 10, 5, 12, 1, 14, 4, 7, 11, 13, 0, 15
        db 12, 4, 6, 2, 10, 5, 11, 9, 14, 8, 13, 7, 0, 3, 15, 1

key:    ; Ключ для шифрования | Encryption key
        db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 10h, 11h, 12h
        db 13h, 14h, 15h, 16h, 17h, 18h, 19h, 20h, 21h, 22h
        db 23h, 24h, 25h, 26h, 27h, 28h, 29h, 30h, 31h, 32h

imito:  ; Имитовставка | Message Authentication Code
        db 0, 0, 0, 0, 0, 0, 0, 0

;----------------------------------------------------

text:	; Шифруемый/дешифруемый текст | Text for encryption/decryption
        db 'lobortis id euismod in, elementum vitae elit. Duis id ipsum ac turpis porta consequat. Vestibulum eget odio non nisl posuere placerat eget ut leo. Donec convallis aliquet varius. Proin eu faucibus magna, vel sodales magna. Maecenas euismod, felis vel hendrerit vehicula, dolor urna posuere quam, eu auctor metus ante sit amet dolor. Sed eget lectus felis. Cras congue dignissim vestibulum. Nullam sed odio nibh. Phasellus in est enim. Praesent dui ex, placerat vitae nibh non, rutrum efficitur orci. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque tellus diam, gravida quis mi sed, luctus aliquam neque. Praesent lacinia suscipit sapien, eu malesuada nunc ullamcorper eu. Aenean ac risus ornare purus feugiat pulvinar. Suspendisse ac ipsum nulla. Morbi lacinia elit quis leo mattis, a vestibulum turpis efficitur. Maecenas sed felis congue, varius metus id tortor. Praesent lacinia suscipit sapien, eu malesuada nunc ullamcorper eu. Aenean ac risus ornare purus feugiat pulvinar. Morbi lacinia elit qu.'