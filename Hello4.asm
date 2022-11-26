; Snake do Hexa
; Rafael Scalon Peres Conti - nUSP: 11871181
; Henrique Gualberto Marques - 
; João Otávio Cano - 

; ------- TABELA DE CORES -------
; adicione ao caracter para Selecionar a cor correspondente

; 0 branco							0000 0000
; 256 marrom						0001 0000
; 512 verde							0010 0000
; 768 oliva							0011 0000
; 1024 azul marinho					0100 0000
; 1280 roxo							0101 0000
; 1536 teal							0110 0000
; 1792 prata						0111 0000
; 2048 cinza						1000 0000
; 2304 vermelho						1001 0000
; 2560 lima							1010 0000
; 2816 amarelo						1011 0000
; 3072 azul							1100 0000
; 3328 rosa							1101 0000
; 3584 aqua							1110 0000
; 3840 branco						1111 0000


SnakePos:  	var #500
SnakeSize:	var #1
Dir:		var #1 ; 0-direita, 1-baixo, 2-esquerda, 3-cima
FoodPos:	var #1
FoodStatus:	var #1

GameOverMessage: 	string " SEM ALEGRIA PRO POVO "
EraseGameOver:		string "                      "
RestartMessage:		string " Aperte 'Space' para recomecar "
EraseRestart:		string "                               "

; Main
main:
	call Initialize
	;call Draw_Stage
	
	loop:
		ingame_loop:
			call Draw_Snake
			call Dead_Snake
			
			call Move_Snake
			call Replace_Food
					
			call Delay
				
			jmp ingame_loop
		GameOver_loop:
			call Restart_Game
		
			jmp GameOver_loop
	
; Funções

Initialize:
		call ApagaTela
		loadn r1, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
		loadn r2, #512	        ; Utiliza cor verde
		call ImprimeTela2   	; Rotina de Impresao de Cenario na Tela Inteira
		
		push r0
		push r1
		
		loadn r0, #4
		store SnakeSize, r0
		
		; SnakePos[0] = 460
		loadn 	r0, #SnakePos
		loadn 	r1, #460
		storei 	r0, r1
		
		; SnakePos[1] = 459
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[2] = 458
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[3] = 457
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[3] = 456
		inc 	r0
		dec 	r1
		storei 	r0, r1
		
		; SnakePos[5] = -1
		inc 	r0
		loadn 	r1, #0
		storei 	r0, r1
				
		call FirstPrintSnake
		
		loadn r0, #0
		store Dir, r0
		
		pop r1
		pop r0
		
		rts

FirstPrintSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #SnakePos		; r0 = & SnakePos
	loadn r1, #'}'			; r1 = '}'
	loadi r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	
	loadn 	r0, #820
	loadn 	r1, #'*'
	outchar r1, r0
	store 	FoodPos, r0
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts
	
EraseSnake:
	push r0
	push r1
	push r2
	push r3
	
	loadn 	r0, #SnakePos		; r0 = & SnakePos
	inc 	r0
	loadn 	r1, #' '			; r1 = ' '
	loadi 	r2, r0			; r2 = SnakePos[0]
		
	loadn 	r3, #0			; r3 = 0
	
	Print_Loop:
		outchar r1, r2
		
		inc 	r0
		loadi 	r2, r0
		
		cmp r2, r3
		jne Print_Loop
	
	pop	r3
	pop r2
	pop r1
	pop r0
	
	rts

;Draw_Stage:
;	push r0
;	push r1
;	push r2
;	push r3
;	push r4
;	
;	loadn r0, #0
;	loadn r1, #39
;	
;	loadn r2, #557 ; - verde
;	
;	loadn r3, #40
;	loadn r4, #1200
;	
;	Stage_Loop1:
;		outchar r2, r0
;		add r0, r0, r3
;		nop
;		nop
;		outchar r2, r1	
;		
;		add r1, r1, r3
;		
;		cmp r0, r4
;		jle Stage_Loop1
;		
;	loadn r0, #1
;	loadn r1, #1161
;	
;	Stage_Loop2:
;		outchar r2, r0
;		inc r0
;		nop
;		nop
;		outchar r2, r1
;		
;		inc r1
;		
;		cmp r0, r3
;		jle Stage_Loop2
;	
;	pop r4
;	pop r3
;	pop r2
;	pop r1
;	pop r0
;	
;	rts

Move_Snake:
	push r0	; Dir / SnakePos
	push r1	; inchar
	push r2 ; local helper
	push r3
	push r4
	
	; Sincronização
	loadn 	r0, #5000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Move_End
	; =============
	
	Check_Food:
		load 	r0, FoodPos
		loadn 	r1, #SnakePos
		loadi 	r2, r1
		
		cmp r0, r2
		jne Spread_Move
		
		load 	r0, SnakeSize
		inc 	r0
		store 	SnakeSize, r0
		
		loadn 	r0, #0
		dec 	r0
		store 	FoodStatus, r0
		
	Spread_Move:
		loadn 	r0, #SnakePos
		loadn 	r1, #SnakePos
		load 	r2, SnakeSize
		
		add 	r0, r0, r2		; r0 = SnakePos[Size]
		
		dec 	r2				; r1 = SnakePos[Size-1]
		add 	r1, r1, r2
		
		loadn 	r4, #0
		
		Spread_Loop:
			loadi 	r3, r1
			storei 	r0, r3
			
			dec r0
			dec r1
			
			cmp r2, r4
			dec r2
			
			jne Spread_Loop	
	
	Change_Dir:
		inchar 	r1
		
		loadn r2, #100	; char r4 = 'd'
		cmp r1, r2
		jeq Move_D
		
		loadn r2, #115	; char r4 = 's'
		cmp r1, r2
		jeq Move_S
		
		loadn r2, #97	; char r4 = 'a'
		cmp r1, r2
		jeq Move_A
		
		loadn r2, #119	; char r4 = 'w'
		cmp r1, r2
		jeq Move_W		
		
		jmp Update_Move
	
		Move_D:
			loadn 	r0, #0
			; Impede de "ir pra trás"
			loadn 	r1, #2
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Left
			
			store 	Dir, r0
			jmp 	Move_Right
		Move_S:
			loadn 	r0, #1
			; Impede de "ir pra trás"
			loadn 	r1, #3
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Up
			
			store 	Dir, r0
			jmp 	Move_Down
		Move_A:
			loadn 	r0, #2
			; Impede de "ir pra trás"
			loadn 	r1, #0
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Right
			
			store 	Dir, r0
			jmp 	Move_Left
		Move_W:
			loadn 	r0, #3
			; Impede de "ir pra trás"
			loadn 	r1, #1
			load  	r2, Dir
			cmp 	r1, r2
			jeq 	Move_Down
			
			store 	Dir, r0
			jmp 	Move_Up
	
	Update_Move:
		load 	r0, Dir
				
		loadn 	r2, #0
		cmp 	r0, r2
		jeq 	Move_Right
		
		loadn 	r2, #1
		cmp 	r0, r2
		jeq 	Move_Down
		
		loadn 	r2, #2
		cmp 	r0, r2
		jeq 	Move_Left
		
		loadn 	r2, #3
		cmp 	r0, r2
		jeq 	Move_Up
		
		jmp Move_End
		
		Move_Right:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			inc 	r1				; r1++
			storei 	r0, r1
			
			jmp Move_End
				
		Move_Down:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			add 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
		
		Move_Left:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			dec 	r1				; r1--
			storei 	r0, r1
			
			jmp Move_End
		Move_Up:
			loadn 	r0, #SnakePos	; r0 = & SnakePos
			loadi 	r1, r0			; r1 = SnakePos[0]
			loadn 	r2, #40
			sub 	r1, r1, r2
			storei 	r0, r1
			
			jmp Move_End
	
	Move_End:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0

	rts

Replace_Food:
	push r0
	push r1

	loadn 	r0, #0
	dec 	r0
	load 	r1, FoodStatus
	cmp 	r0, r1
	
	jne Replace_End
	
	loadn r1, #0
	store FoodStatus, r1
	load  r1, FoodPos
	
	load r0, Dir
	
	loadn r2, #0
	cmp r0, r2
	jeq Replace_Right
	
	loadn r2, #1
	cmp r0, r2
	jeq Replace_Down
	
	loadn r2, #2
	cmp r0, r2
	jeq Replace_Left
	
	loadn r2, #3
	cmp r0, r2
	jeq Replace_Up
	
	Replace_Right:
		loadn r3, #355
		add r1, r1, r3
		jmp Replace_Boundaries
	Replace_Down:
		loadn r3, #445
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Left:
		loadn r3, #395
		sub r1, r1, r3
		jmp Replace_Boundaries
	Replace_Up:
		loadn r3, #485
		add r1, r1, r3
		jmp Replace_Boundaries
	
	
	Replace_Boundaries:
		loadn r2, #40
		cmp r1, r2
		jle Replace_Lower
		
		loadn r2, #1160
		cmp r1, r2
		jgr Replace_Upper
		
		loadn r0, #40
		loadn r3, #1
		mod r2, r1, r0
		cmp r2, r3
		jel Replace_West
		
		loadn r0, #40
		loadn r3, #39
		mod r2, r1, r0
		cmp r2, r3
		jeg Replace_East
		
		jmp Replace_Update
		
		Replace_Upper:
			loadn r1, #215
			jmp Replace_Update
		Replace_Lower:
			loadn r1, #1035
			jmp Replace_Update
		Replace_East:
			loadn r1, #835
			jmp Replace_Update
		Replace_West:
			loadn r1, #205
			jmp Replace_Update
			
		Replace_Update:
			store FoodPos, r1
			loadn r0, #'*'
			outchar r0, r1
	
	Replace_End:
		pop r1
		pop r0
	
	rts

Dead_Snake:
	loadn r0, #SnakePos
	loadi r1, r0
	
	; Trombou na parede direita
	loadn r2, #40
	loadn r3, #39
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; Trombou na parede esquerda
	loadn r2, #40
	loadn r3, #0
	mod r2, r1, r2		; r2 = r1 % r2 (Teste condições de contorno)
	cmp r2, r3
	jeq GameOver_Activate
	
	; Trombou na parede esquerda
	loadn r2, #40
	cmp r1, r2
	jle GameOver_Activate
	
	; Trombou na parede esquerda
	loadn r2, #1160
	cmp r1, r2
	jgr GameOver_Activate
	
	; Trombou na própria cobra
	Collision_Check:
		load 	r2, SnakeSize
		loadn 	r3, #1
		loadi 	r4, r0			; Posição da cabeça
		
		Collision_Loop:
			inc 	r0
			loadi 	r1, r0
			cmp r1, r4
			jeq GameOver_Activate
			
			dec r2
			cmp r2, r3
			jne Collision_Loop
		
	
	jmp Dead_Snake_End
	
	GameOver_Activate:
		load 	r0, FoodPos
		loadn 	r1, #' '
		outchar r1, r0
	
		loadn r0, #609
		loadn r1, #GameOverMessage
		loadn r2, #2816
		call Imprime
		
		loadn r0, #685
		loadn r1, #RestartMessage
		loadn r2, #512
		call Imprime
		
		jmp GameOver_loop
	
	Dead_Snake_End:
	
	rts

Draw_Snake:
	push r0
	push r1
	push r2
	push r3 
	
	; Sincronização
	loadn 	r0, #1000
	loadn 	r1, #0
	mod 	r0, r6, r0		; r1 = r0 % r1 (Teste condições de contorno)
	cmp 	r0, r1
	jne Draw_End
	; =============
	
	load 	r0, FoodPos
	loadn 	r1, #1647       ; r1 = `o` em cor teal
	outchar r1, r0
	
	loadn 	r0, #SnakePos	; r0 = end SnakePos
	loadn 	r1, #2870	    ; r1 = '6 amarelo'
	loadi 	r2, r0			; r2 = SnakePos[0]
	outchar r1, r2			
	
	loadn 	r0, #SnakePos	; r0 = & SnakePos
	loadn 	r1, #' '		; r1 = ' '
	load 	r3, SnakeSize	; r3 = SnakeSize
	add 	r0, r0, r3		; r0 += SnakeSize
	loadi 	r2, r0			; r2 = SnakePos[SnakeSize]
	outchar r1, r2
	
	Draw_End:
		pop	r3
		pop r2
		pop r1
		pop r0
	
	rts
;----------------------------------
Delay:
	push r0
	
	inc r6
	loadn r0, #1000000
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts
	
Delay2: ; Delay para desenho do cenario
	push r0
	
	inc r6
	loadn r0, #1
	cmp r6, r0
	jgr Reset_Timer
	
	jmp Timer_End
	
	Reset_Timer:
		loadn r6, #0
	Timer_End:		
		pop r0
	
	rts

Restart_Game:
	inchar 	r0
	loadn 	r1, #' '
	
	cmp r0, r1
	jeq Restart_Activate
	
	jmp Restart_End
	
	Restart_Activate:
		loadn r0, #609
		loadn r1, #EraseGameOver
		loadn r2, #0
		call Imprime
		
		loadn r0, #685
		loadn r1, #EraseRestart
		loadn r2, #0
		call Imprime
	
		call EraseSnake
		call Initialize
		
		jmp ingame_loop
		
	Restart_End:
	
	rts

Imprime:
	push r0		; Posição na tela para imprimir a string
	push r1		; Endereço da string a ser impressa
	push r2		; Cor da mensagem
	push r3
	push r4

	
	loadn r3, #'\0'

	LoopImprime:	
		loadi r4, r1
		cmp r4, r3
		jeq SaiImprime
		add r4, r2, r4
		outchar r4, r0
		inc r0
		inc r1
		jmp LoopImprime
		
	SaiImprime:	
		pop r4	
		pop r3
		pop r2
		pop r1
		pop r0
		
	rts

;********************************************************
;                       IMPRIME TELA2
;********************************************************	

ImprimeTela2: 	;  Rotina de Impresao de Cenario na Tela Inteira
		;  r1 = endereco onde comeca a primeira linha do Cenario
		;  r2 = cor do Cenario para ser impresso

	push r0	; protege o r3 na pilha para ser usado na subrotina
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina

	loadn R0, #0  	; posicao inicial tem que ser o comeco da tela!
	loadn R3, #40  	; Incremento da posicao da tela!
	loadn R4, #41  	; incremento do ponteiro das linhas da tela
	loadn R5, #1200 ; Limite da tela!
	loadn R6, #tela0Linha0	; Endereco onde comeca a primeira linha do cenario!!
	
   ImprimeTela2_Loop:
		call ImprimeStr2
		add r0, r0, r3  	; incrementaposicao para a segunda linha na tela -->  r0 = R0 + 40
		add r1, r1, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		add r6, r6, r4  	; incrementa o ponteiro para o comeco da proxima linha na memoria (40 + 1 porcausa do /0 !!) --> r1 = r1 + 41
		cmp r0, r5			; Compara r0 com 1200
		jne ImprimeTela2_Loop	; Enquanto r0 < 1200

	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
				
;---------------------

;********************************************************
;                   IMPRIME STRING2
;********************************************************
	
ImprimeStr2:	;  Rotina de Impresao de Mensagens:    r0 = Posicao da tela que o primeiro caractere da mensagem sera' impresso;  r1 = endereco onde comeca a mensagem; r2 = cor da mensagem.   Obs: a mensagem sera' impressa ate' encontrar "/0"
	push r0	; protege o r0 na pilha para preservar seu valor
	push r1	; protege o r1 na pilha para preservar seu valor
	push r2	; protege o r1 na pilha para preservar seu valor
	push r3	; protege o r3 na pilha para ser usado na subrotina
	push r4	; protege o r4 na pilha para ser usado na subrotina
	push r5	; protege o r5 na pilha para ser usado na subrotina
	push r6	; protege o r6 na pilha para ser usado na subrotina
	
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r5, #' '	; Espaco em Branco

   ImprimeStr2_Loop:	
		loadi r4, r1
		cmp r4, r3		; If (Char == \0)  vai Embora
		jeq ImprimeStr2_Sai
		cmp r4, r5		; If (Char == ' ')  vai Pula outchar do espaco para na apagar outros caracteres
		jeq ImprimeStr2_Skip
		add r4, r2, r4	; Soma a Cor
		outchar r4, r0	; Imprime o caractere na tela
   		storei r6, r4
   ImprimeStr2_Skip:
		inc r0			; Incrementa a posicao na tela
		inc r1			; Incrementa o ponteiro da String
		inc r6
		jmp ImprimeStr2_Loop
	
   ImprimeStr2_Sai:	
	pop r6	; Resgata os valores dos registradores utilizados na Subrotina da Pilha
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts

;********************************************************
;                       APAGA TELA
;********************************************************
ApagaTela:
	push r0
	push r1
	
	loadn r0, #1200		; apaga as 1200 posicoes da Tela
	loadn r1, #' '		; com "espaco"
	
	   ApagaTela_Loop:	;;label for(r0=1200;r3>0;r3--)
		dec r0
		outchar r1, r0
		jnz ApagaTela_Loop
 
	pop r1
	pop r0
	rts	

;Desenho do campo de futebol

tela0Linha0  : string "|--------------------------------------|"
tela0Linha1  : string "|_|                                  |_|"
tela0Linha2  : string "|                                      |"
tela0Linha3  : string "|                                      |"
tela0Linha4  : string "|                                      |"
tela0Linha5  : string "|                                      |"
tela0Linha6  : string "|                                      |"
tela0Linha7  : string "|                                      |"
tela0Linha8  : string "|                                      |"
tela0Linha9  : string "|                                      |"
tela0Linha10 : string "|---------                    ---------|"
tela0Linha11 : string "|        |                    |        |"
tela0Linha12 : string "|        |                    |        |"
tela0Linha13 : string "|---     |       ______       |     ---|"
tela0Linha14 : string "|  |     |      |      |      |     |  |"
tela0Linha15 : string "|  |     |      |BRASIL|      |     |  |"
tela0Linha16 : string "|  |     |      | 2022 |      |     |  |"
tela0Linha17 : string "|  |     |      |______|      |     |  |"
tela0Linha18 : string "|---     |                    |     ---|"
tela0Linha19 : string "|        |                    |        |"
tela0Linha20 : string "|        |                    |        |"
tela0Linha21 : string "|---------                    ---------|"
tela0Linha22 : string "|                                      |"
tela0Linha23 : string "|                                      |"
tela0Linha24 : string "|                                      |"
tela0Linha25 : string "|                                      |"
tela0Linha26 : string "|                                      |"
tela0Linha27 : string "|_                                    _|"
tela0Linha28 : string "| |                                  | |"
tela0Linha29 : string "|--------------------------------------|"