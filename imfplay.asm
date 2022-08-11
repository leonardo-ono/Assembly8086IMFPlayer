; getthem.imf - https://modland.ziphoid.com/pub/modules/Ad%20Lib/Apogee/Bobby%20Prince/Wolfenstein%203D/

		bits 16
		org 100h
start:
		; 2) now let's just read "getthem.imf" file content
		;    every 4 bytes. I'll use SI register as index.
		
		mov si, 0 ; current index for music_data
		
	.next_note:
	
		; 3) the first byte is the opl2 register
		;    that is selected through port 388h
		mov dx, 388h
		mov al, [si + music_data + 0]
		out dx, al
		
		; 4) the second byte is the data need to
		;    be sent through the port 389h
		mov dx, 389h
		mov al, [si + music_data + 1]
		out dx, al
		
		; 5) the last 2 bytes form a word
		;    and indicate the number of waits (delay)
		mov bx, [si + music_data + 2]
		
		; 6) then we can move to next 4 bytes
		add si, 4
		
		; 7) now let's implement the delay
		
	.repeat_delay:	
		mov cx, 12000 ; <- change this value according to the speed
		              ;    of your computer / emulator
	.delay:
	
		; if keypress then exit
		mov ah, 1
		int 16h
		jnz .exit
		
		loop .delay
		
		dec bx
		jg .repeat_delay
		
		; 8) let's send all content of music_data
		cmp si, [music_length]
		jb .next_note
		
	.exit:	
		; return to DOS
		mov ax, 4c00h
		int 21h
		
; 1) let's include the file "getthem.imf"
;    and inform the file size
music_length dw 18644
music_data incbin "getthem.imf"

; and that's all ! let's see if it works...
; yes, it works :) !

; thanks for watching :)
