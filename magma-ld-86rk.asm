	; KR580VM80A (i8080A) assembly code for Radio-86RK (32kb)

; /-----------------------------------------------\
; | ГОСТ 28147-89 "Магма" | GOST 28147-89 "Magma" |
; |                       |                       |
; | Режим простой замены  |        ECB mode       |
; |                       |                       |
; | Пример использования  |  An example of using  |
; |  набора подпрограмм   |   a set of routines   |
; |   (по адресу 7000h)   |      (at 7000h)       |
; |                       |                       |
; |    Демо для ПЭВМ      |      Demo for PC      |
; |      Радио-86РК       |       Radio-86RK      |
; \-----------------------------------------------/

exit	equ 0F86Ch
setch	equ 0F809h
sethex	equ 0F815h
print	equ 0F818h

magenc	equ 7000h
magdec	equ 700Ch
setdat	equ 7018h
setkey	equ 7024h
result	equ 71F5h

	org 0

	lxi hl, title
	call print
	
	lxi hl, data
	call setdat ; Установка блока данных для шифрования | Setting a data block for encryption

	call prih64

	lxi hl, key
	call setkey ; Установка ключа для шифрования | Setting a key for encryption

	lxi hl, enct
	call print

	call magenc ; Шифрование блока 64-бит | 64-bit block encryption
	            ; Результат находится по адресу 71F5h | The result is located at address 71F5h
	
	lxi hl, result
	call prih64

	lxi hl, dect
	call print

	call magdec ; Дешифрование блока 64-бит | 64-bit block decryption
	            ; Результат находится по адресу 71F5h | The result is located at address 71F5h
	
	lxi hl, result
	call prih64
	
	jmp exit    ; Конец программы | End of the program

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
	db 1fh,'{ifrowanie gost 28147-89 "magma"',0dh,0ah
	db 'odin 64-bit blok',0dh,0ah
	db 'radio-86rk, kr580wm80a',0dh,0ah,0ah
	db 20h,'original: ',0

enct:
	db 20h,20h,'{ifruem: ',0
dect:
	db 'de{ifruem: ',0

;----------------------------------------------------

key:    ; Ключ для шифрования | Encryption key
	db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 10h, 11h, 12h
	db 13h, 14h, 15h, 16h, 17h, 18h, 19h, 20h, 21h, 22h
	db 23h, 24h, 25h, 26h, 27h, 28h, 29h, 30h, 31h, 32h

data:   ; Шифруемые/дешифруемые данные | Data for encryption/decryption
	db 0AAh, 0BDh, 5Ah, 06h, 8Ah, 0FFh, 0BBh, 0E3h
