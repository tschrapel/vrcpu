; Convert an 8-bit binary number into decimal digits
; and output digits to the display

NUMBER = 135
ADDR   = 0
TERMINATOR = 255

main:
	data SP, 255
	data Rd, NUMBER
	data Ra, ADDR
	mov Rb, Rd

	call toDec8
	
	.output:
		call printResult
		jmp .output

printResult:
	data Ra, ADDR
	data Rb, TERMINATOR
	data Rd, NUMBER
	
	.findEnd:
		lod Rc, Ra
		cmp Rb, Rc
		jz .startPrint
		inc Ra
		jmp .findEnd

	.startPrint:
		data Rc, ADDR
		mov Rb, Ra
	
	.nextDigit:
		dec Rb
		lod Rd, Rb
		cmp Rb, Rc
		jz .return
		jmp .nextDigit
	
	.return:
		ret


; function toDec - binary to decimal
;  Rb: number
;  Ra: memory address to store result. 0xff delimited
toDec8:
	push Ra
	push Rb
	
	.nextDigit:
		pop Ra  ; get remaining number
		data Rb, 10
		call div8
		pop Rb  ; address to Rb
		sto Rb, Ra ; store remainder
		inc Rb
		push Rb  ; push next memory address
		tst Rc
		jz .return
		push Rc
		jmp .nextDigit

	.return:
		pop Rb
		data Ra, TERMINATOR  ; add terminator
		sto Rb, Ra
		ret


; function div8 - divide two 8-bit integers
;  Ra: dividend
;  Rb: divisor
; returns:
;  Rc: result
;  Ra: remainder
div8:
	data Rc, 0x00
	
	.step:
		cmp Rb, Ra
		jz .add
		jc .return
		
	.add:
		inc Rc
		sub Ra
		jnz .step

	.return:
		ret