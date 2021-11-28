	; KR580VM80A (i8080A) assembly code

; /-----------------------------------------------\
; | ГОСТ 28147-89 "Магма" | GOST 28147-89 "Magma" |
; |                       |                       |
; | Режим простой замены  |        ECB mode       |
; |                       |                       |
; | Пример использования  |  An example of using  |
; |  набора подпрограмм   |   a set of routines   |
; |   (по адресу 7000h)   |      (at 7000h)       |
; |                       |                       |
; |  Универсальное демо   |     Universal demo    |
; \-----------------------------------------------/

magenc	equ 7000h
magdec	equ 700Ch
setdat	equ 7018h
setkey	equ 7024h

	org 0

	lxi hl, data
	call setdat ; Установка блока данных для шифрования | Setting a data block for encryption

	lxi hl, key
	call setkey ; Установка ключа для шифрования | Setting a key for encryption

	call magenc ; Шифрование блока 64-бит | 64-bit block encryption
	            ; Результат находится по адресу 71F5h | The result is located at address 71F5h

	call magdec ; Дешифрование блока 64-бит | 64-bit block decryption
	            ; Результат находится по адресу 71F5h | The result is located at address 71F5h

	hlt         ; Конец программы | End of the program

;----------------------------------------------------

key:    ; Ключ для шифрования | Encryption key
	db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 10h, 11h, 12h
	db 13h, 14h, 15h, 16h, 17h, 18h, 19h, 20h, 21h, 22h
	db 23h, 24h, 25h, 26h, 27h, 28h, 29h, 30h, 31h, 32h

data:   ; Шифруемые/дешифруемые данные | Data for encryption/decryption
	db 0AAh, 0BDh, 5Ah, 06h, 8Ah, 0FFh, 0BBh, 0E3h
