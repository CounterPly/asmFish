
Position_Init:

		push   rbx rsi rdi r12 r13 r14 r15
virtual at rsp
  .prng        rq 1
  .lend rb 0
end virtual
.localsize = ((.lend-rsp+15) and (-16))

	 _chkstk_ms   rsp, .localsize
		sub   rsp, .localsize

		mov   qword[.prng], 1070372

		xor   ebx, ebx


; TODO:

; 4) Now that we have our cuckoo loops perfected, reenable the L25 code and make it
; init the cuckoo tables.

; PS:
; This is for C++ Land:
	 ; #include <iostream>
	 ; std::cerr << std::endl << "pc " << std::endl;


; This is the double-for loop
	.HashKeyInitLoopA:
		imul  esi, ebx, 64*8
		lea   rdi, [Zobrist_Pieces+8*rsi]
		mov   esi, 64*Pawn
		xor   r8, r8

	.HashKeyInitLoopB:
		xor   r9, r9
	; ==================================================
		Display 1, 'pcCount%n'
	; ==================================================

	.HashKeyInitLoopC:
		lea   rcx, [.prng]
		call   Math_Rand_i
		mov   qword[rdi+8*rsi], rax

; ==================================================
	Display 1, '.'
; ==================================================
		add   esi, 1
		add   r9, 1
		cmp   r9, 64

		 jb   .HashKeyInitLoopC
 ; ==================================================
 	Display 1, '%n'
 ; ==================================================
		 add   r8, 1
		 cmp   r8, 6
		 jb   .HashKeyInitLoopB

		add   ebx, 1
		cmp   ebx, 2
		 jb   .HashKeyInitLoopA
; end of double-for loop


		lea   rdi, [Zobrist_Ep]
		xor   esi, esi

	.l3: ; for-loop for files and Zobrist_Ep
		lea   rcx, [.prng]
		call   Math_Rand_i
		mov   qword[rdi+8*rsi], rax ; rax is result of Math_Rand_i
		add   esi, 1
		cmp   esi, 8 ; there are only 8 files
		 jb   .l3

		lea   rdi, [Zobrist_Castling]
		xor   esi, esi

	.l2: ; This is the castling for-loop
		lea   rcx, [.prng]
		call   Math_Rand_i ; rax has random key
		xor   ebx, ebx ; Zobrist::castling[cr] = 0;

	.l1: ; while (b)
		bt    ebx, esi
		sbb   rcx, rcx ; store flag result from bit test (bt) into rcx
		and   rcx, rax
		xor   qword[rdi+8*rbx], rcx ;  Zobrist::castling[cr] ^= k (but k never happens)
		add   ebx, 1
		cmp   ebx, 16
		 jb   .l1

		add   esi, 1
		cmp   esi, 4 ; there are only 4 castling states
		 jb   .l2

		lea   rcx, [.prng]
		call   Math_Rand_i
		mov   qword[Zobrist_side], rax

		lea   rcx, [.prng]
		call   Math_Rand_i
		mov   qword[Zobrist_noPawns], rax

;======================================================
; ; This is the double-for loop we are currently working on
;
		xor  ebx, ebx

; Notes: 9/23/18
; 1) We need to create (or find an already existing) array of pieces in asm
;   that matches the array of "Pieces" found in C++ land. This array would
;   contain the various types of pieces defined in asm as used for "Pt".
; 2) CuckooLoopA needs to set the current Pt for each of its iterations.
; 3) Now we have the Pt we need to pass into PseudoAttacks.
; 4) We need to figure out where sq comes from relative to CuckooLoopB.

	.CuckooLoopColor:
		imul  esi, ebx, 64*8
		lea   rdi, [Zobrist_Pieces+8*rsi]
		mov  r8, Pawn

	.CuckooLoopPieceType:
		xor   esi, esi
; To do:
	; Put display statements within all the labels to make sure we are looping through as many times
	; as we think we are and ensure we aren't affecting the bench.
	; Put print statements over in the C++ side to make sure we know how many times they
	; go through the loops and make sure the numbers match (just like we did with the dots).
	; This will be a good way to ensure we have our looping structures down right.
	;======================================================
			Display 1, 'cuckoo%n'
	;======================================================
	; Once we know we have the control structure set up for the looping, then we can go back
	; and map all registers and addresses to Moha's world.

	; We can also use the display technique to confirm what we execute on the assembly side
	; to confirm if it matches up to what we are executing on the C++ side.
	; You just have to put "print statements" on both sides of the fence and make sure
	; that they match up for the L9-L10 range of code.

	.CuckooLoopS1Squares:
				; .L25:
				; 	lea r10d, [rsi+1] # s2,
				; 	cmp r10d, 63 # s2,
				; 	jg .L10
				;
				; 	mov r11d, esi # s1, _27
				; 	mov esi, r10d # _27, s2
				; 	jmp .L9
				;
				; .L11:
				; 	add r10d, 1 # s2,
				; 	cmp r10d, 63 # s2,
				; 	jg .L25
				;
				; .L9: ; The "Guts" of the loop (i.e. everything inside that if-test)
				;   movsx rdx, r11d # s1, s1
				;   add rdx, rbx # tmp215, tmp214
				;   movsx rax, r10d # s2, s2
				;   mov rdx, QWORD PTR PseudoAttacks[0+rdx*8] # tmp219, PseudoAttacks
				;   test QWORD PTR SquareBB[0+rax*8], rdx # SquareBB, tmp219
				;   je .L11 #,
				;   mov r9d, r11d # tmp220, s1
				;   sal r9d, 6 # tmp220,
				;   add r9d, r10d # _104, s2
				;   movsx rdx, r11d # s1, s1
				;   add rdx, rbp # tmp225, tmp245
				;   add rax, rbp # tmp230, tmp245
				;   mov r8, QWORD PTR Zobrist::psq[0+rdx*8] # tmp232, psq
				;   xor r8, QWORD PTR Zobrist::psq[0+rax*8] # tmp231, psq
				;   xor r8, r15 # key, _95
				;   mov ecx, r8d # i, key
				;   and ecx, 8191 # i,
				;
				; .L12:
				;   movsx rdx, ecx # i, i
				;   mov rax, QWORD PTR cuckoo[0+rdx*8] # _106, cuckoo
				;   mov QWORD PTR cuckoo[0+rdx*8], r8 # cuckoo, key
				;   mov esi, DWORD PTR cuckooMove[0+rdx*4] # move, cuckooMove
				;   mov DWORD PTR cuckooMove[0+rdx*4], r9d # cuckooMove, _104
				;   test esi, esi # move
				;   je .L11 #,
				;   mov edi, eax # i, _106
				;   and edi, 8191 # i,
				;   mov rdx, rax # tmp241, _106
				;   shr rdx, 16 # tmp241,
				;   and edx, 8191 # tmp243,
				;   cmp ecx, edi # i, i
				;   mov r8, rax # key, _106
				;   mov r9d, esi # _104, move
				;   mov ecx, edi # i, i
				;   cmove ecx, edx # tmp243,, i
				;   jmp .L12 #
;.L10:
;======================================================
		Display 1, '.'
;======================================================
; This call to PseudoAttacks populates r9 with the BitBoard of Attackable Squares for the current PieceType (r8)
; from Square rsi.

		; r9 = BitBoard Output
		; r8 = PieceType
		; rsi = square
		PseudoAttacks r9, r8, rsi, r10

; At this point, to match the inner for-loop on the C++ side, we need to...
;     1. Create a for-loop equivalent structure for s1+1 through SQ_H8 squares. That gives us s2 in our loop.
;     2. Perform a bitwise-AND between r9 and the BitBoard that results from SquareBB[s2].
;     3. As part of doing (2) we need to figure out how to get SquareBB equivalent in Moha's asmLand.
;     4. Once steps (1)-(3) are complete, we will be able to print out pseudoAttackHash like we do in C++ Land.
;        This will allow us to confirm our looping control structure in asm is an exact match to C++.

; We should be able to match the Hash Values after this.

		add   esi, 1
		cmp   esi, 64

		 jb   .CuckooLoopS1Squares
 ; ==================================================
 		Display 1, '%n'
 ; ==================================================
		 add   r8, 1
		 cmp   r8, (King+1)
		 jb   .CuckooLoopPieceType

		add   ebx, 1
		cmp   ebx, 2
		 jb   .CuckooLoopColor

; end of double-for loop



; Compiler Output
 ; // Prepare the cuckoo tables (Optimization = 0)
;  mov qword[rbp-88], OFFSET FLAT:(anonymous namespace)::Pieces ; __for_range,
;  mov qword[rbp-40], OFFSET FLAT:(anonymous namespace)::Pieces ; __for_begin,
;  mov qword[rbp-96], OFFSET FLAT:(anonymous namespace)::Pieces+48 ; __for_end,
;
; .L266:
;  mov rax, qword[rbp-40] ; tmp161, __for_begin
;  cmp rax, qword[rbp-96] ; tmp161, __for_end
;  je
;
; .L267:
;  mov rax, qword[rbp-40] ; tmp162, __for_begin
;  mov eax, dword[rax] ; tmp163, *__for_begin_48
;  mov dword[rbp-100], eax ; pc, tmp163
;  mov dword[rbp-132], 0 ; s1,
;
; .L265:
;  mov eax, dword[rbp-132] ; s1.27_16, s1
;  cmp eax, 63 ; s1.27_16,
;  jg
;
; .L256:
;  mov eax, dword[rbp-132] ; s1.28_17, s1
;  add eax, 1 ; _18,
;  mov dword[rbp-136], eax ; s2, _18
;
; .L264:
;  mov eax, dword[rbp-136] ; s2.29_19, s2
;  cmp eax, 63 ; s2.29_19,
;  jg
;
; .L257
;  mov ebx, dword[rbp-136] ; s2.31_20, s2
;  mov eax, dword[rbp-100] ; tmp164, pc
;  mov edi, eax  tmp164
;  call type_of(Piece)
;  mov edx, eax ; _22, _21
;  mov eax, dword[rbp-132] ; s1.32_23, s1
;  cdqe
;  movsx rdx, edx ; tmp166, _22
;  sal rdx, 6 ; tmp167,
;  add rax, rdx ; tmp168, tmp167
;  mov rax, QWORD PTR PseudoAttacks[0+rax*8] ; _24, PseudoAttacks
;  mov esi, ebx  s2.31_20
;  mov rdi, rax  _24
;  call operator&(unsigned long, Square)
;  test rax, rax ; _25
;  setne al  retval.30_105
;  test al, al ; retval.30_105
;  je
;
; .L258
;  mov edx, dword[rbp-136] ; s2.33_26, s2
;  mov eax, dword[rbp-132] ; s1.34_27, s1
;  mov esi, edx  s2.33_26
;  mov edi, eax  s1.34_27
;  call make_move(Square, Square) ;
;  mov dword[rbp-140], eax ; move, _28
;  mov edx, dword[rbp-100] ; pc.35_29, pc
;  mov eax, dword[rbp-132] ; s1.36_30, s1
;  cdqe
;  movsx rdx, edx ; tmp170, pc.35_29
;  sal rdx, 6 ; tmp171,
;  add rax, rdx ; tmp172, tmp171
;  mov rdx, QWORD PTR Zobrist::psq[0+rax*8] ; _31, psq
;  mov ecx, dword[rbp-100] ; pc.37_32, pc
;  mov eax, dword[rbp-136] ; s2.38_33, s2
;  cdqe
;  movsx rcx, ecx ; tmp174, pc.37_32
;  sal rcx, 6 ; tmp175,
;  add rax, rcx ; tmp176, tmp175
;  mov rax, QWORD PTR Zobrist::psq[0+rax*8] ; _34, psq
;  xor rdx, rax ; _35, _34
;  mov rax, QWORD PTR Zobrist::side[rip] ; side.39_36, side
;  xor rax, rdx ; _37, _35
;  mov qword[rbp-152], rax ; key, _37
;  mov rax, qword[rbp-152] ; key.40_38, key
;  mov rdi, rax  key.40_38
;  call H1(unsigned long) ;
;  mov dword[rbp-44], eax ; i, tmp177
;
; .L263:
;  mov eax, dword[rbp-44] ; tmp179, i
;  cdqe
;  sal rax, 3 ; tmp180,
;  lea rdx, cuckoo[rax] ; _39,
;  lea rax, [rbp-152] ; tmp181,
;  mov rsi, rax  tmp181
;  mov rdi, rdx  _39
;  call std::enable_if<std::__and_<std::__not_<std::__is_tuple_like<unsigned long> >, std::is_move_constructible<unsigned long>, std::is_move_assignable<unsigned long> >::value, void>::type std::swap<unsigned long>(unsigned long&, unsigned long&) ;
;  mov eax, dword[rbp-44] ; tmp183, i
;  cdqe
;  sal rax, 2 ; tmp184,
;  lea rdx, cuckooMove[rax] ; _40,
;  lea rax, [rbp-140] ; tmp185,
;  mov rsi, rax  tmp185
;  mov rdi, rdx  _40
;  call std::enable_if<std::__and_<std::__not_<std::__is_tuple_like<Move> >, std::is_move_constructible<Move>, std::is_move_assignable<Move> >::value, void>::type std::swap<Move>(Move&, Move&) ;
;  mov eax, dword[rbp-140] ; move.41_41, move
;  test eax, eax ; move.41_41
;  je
;
; .L268
;  mov rax, qword[rbp-152] ; key.43_42, key
;  mov rdi, rax  key.43_42
;  call H1(unsigned long)
;  cmp dword[rbp-44], eax ; i, _43
;  jne
;
; .L261
;  mov rax, qword[rbp-152] ; key.44_44, key
;  mov rdi, rax  key.44_44
;  call H2(unsigned long)
;  jmp
;
; .L262
;
; .L261:
;  mov rax, qword[rbp-152] ; key.45_45, key
;  mov rdi, rax  key.45_45
;  call H1(unsigned long) ;
;
; .L262:
;  mov dword[rbp-44], eax ; i, iftmp.42_51
;  jmp
;
; .L263
;
; .L268:
;  nop
;
; .L258:
;  lea rax, [rbp-136] ; tmp186,
;  mov rdi, rax  tmp186
;  call operator++(Square&) ;
;  jmp
;
; .L264
;
; .L257:
;  lea rax, [rbp-132] ; tmp187,
;  mov rdi, rax  tmp187
;  call operator++(Square&)
;  jmp
;
; .L265
;
; .L256:
;  add qword[rbp-40], 4 ; __for_begin,
;  jmp
;
; .L266
;======================================================
                lea   rdi, [IsPawnMasks]
		mov   eax, 00FF0000H
              stosq
              stosq
                lea   rdi, [IsNotPawnMasks]
		not   rax
              stosq
              stosq
                lea   rdi, [IsNotPieceMasks]
		mov   eax, 00FFH
              stosq
              stosq

		lea   rdi, [PieceValue_MG]
		lea   rsi, [.PieceValue_MG]
		mov   ecx, 8
	  rep movsd
		lea   rsi, [.PieceValue_MG]
		mov   ecx, 8
	  rep movsd
		lea   rdi, [PieceValue_EG]
		lea   rsi, [.PieceValue_EG]
		mov   ecx, 8
	  rep movsd
		lea   rsi, [.PieceValue_EG]
		mov   ecx, 8
	  rep movsd

		lea   rsi, [.PSQR]
		mov   r15d, Pawn
.TypeLoop:
	       imul   r12d, r15d, 8*64
		lea   r12, [r12+Scores_Pieces]
		lea   r11, [r12+8*8*64]

		xor   r14d, r14d
  .RankLoop:
		xor   r13d, r13d
    .FileLoop:
		mov   eax, dword[PieceValue_EG+4*r15]
		mov   edx, dword[PieceValue_MG+4*r15]
		shl   edx, 16
		add   eax, edx
		shr   edx, 16
		add   eax, dword[rsi]
		add   rsi, 4
		cmp   r15d, Pawn
		 ja   @f
		xor   edx, edx
	      @@:
	; eax = piece square value
	; edx = non pawn material

	; set white abcd
		lea   edi, [8*r14+r13]
		mov   dword[r12+8*rdi+0], eax
		mov   dword[r12+8*rdi+4], edx

	; set white efgh
		xor   edi, 0000111b
		mov   dword[r12+8*rdi+0], eax
		mov   dword[r12+8*rdi+4], edx

		neg   eax
		shl   edx, 16

	; set black efgh
		xor   edi, 0111000b
		mov   dword[r11+8*rdi+0], eax
		mov   dword[r11+8*rdi+4], edx

	; set black abcd
		xor   edi, 0000111b
		mov   dword[r11+8*rdi+0], eax
		mov   dword[r11+8*rdi+4], edx

		add   r13d, 1
		cmp   r13d, 4
		 jb   .FileLoop
		add   r14d, 1
		cmp   r14d, 8
		 jb   .RankLoop
		add   r15d, 1
		cmp   r15d, King
		jbe   .TypeLoop

	      .Return:
		add   rsp, .localsize
		pop   r15 r14 r13 r12 rdi rsi rbx
		ret


             calign   4
.PieceValue_MG:
 dd 0, 0, PawnValueMg, KnightValueMg, BishopValueMg, RookValueMg, QueenValueMg, 0
.PieceValue_EG:
 dd 0, 0, PawnValueEg, KnightValueEg, BishopValueEg, RookValueEg, QueenValueEg, 0


.PSQR:
 dd 0,0,0,0
 dd (-11 shl 16) + ( 7), (  6 shl 16) + (-4), ( 7 shl 16) + ( 8), ( 3 shl 16) + (-2)
 dd (-18 shl 16) + (-4), ( -2 shl 16) + (-5), (19 shl 16) + ( 5), (24 shl 16) + ( 4)
 dd (-17 shl 16) + ( 3), ( -9 shl 16) + ( 3), (20 shl 16) + (-8), (35 shl 16) + (-3)
 dd ( -6 shl 16) + ( 8), (  5 shl 16) + ( 9), ( 3 shl 16) + ( 7), (21 shl 16) + (-6)
 dd ( -6 shl 16) + ( 8), ( -8 shl 16) + (-5), (-6 shl 16) + ( 2), (-2 shl 16) + ( 4)
 dd ( -4 shl 16) + ( 3), ( 20 shl 16) + (-9), (-8 shl 16) + ( 1), (-4 shl 16) + (18)
 dd 0,0,0,0

 dd (-161 shl 16) + (-105), (-96 shl 16) + (-82), (-80 shl 16) + (-46), (-73 shl 16) + (-14)
 dd (-83 shl 16) + (-69), (-43 shl 16) + (-54), (-21 shl 16) + (-17), (-10 shl 16) + (9)
 dd (-71 shl 16) + (-50), (-22 shl 16) + (-39), (0 shl 16) + (-7), (9 shl 16) + (28)
 dd (-25 shl 16) + (-41), (18 shl 16) + (-25), (43 shl 16) + (6), (47 shl 16) + (38)
 dd (-26 shl 16) + (-46), (16 shl 16) + (-25), (38 shl 16) + (3), (50 shl 16) + (40)
 dd (-11 shl 16) + (-54), (37 shl 16) + (-38), (56 shl 16) + (-7), (65 shl 16) + (27)
 dd (-63 shl 16) + (-65), (-19 shl 16) + (-50), (5 shl 16) + (-24), (14 shl 16) + (13)
 dd (-195 shl 16) + (-109), (-67 shl 16) + (-89), (-42 shl 16) + (-50), (-29 shl 16) + (-13)

 dd (-44 shl 16) + (-58), (-13 shl 16) + (-31), (-25 shl 16) + (-37), (-34 shl 16) + (-19)
 dd (-20 shl 16) + (-34), (20 shl 16) + (-9),	(12 shl 16) + (-14),   (1 shl 16) + (4)
 dd (-9 shl 16) + (-23), (27 shl 16) + (0),	(21 shl 16) + (-3),  (11 shl 16) + (16)
 dd (-11 shl 16) + (-26), (28 shl 16) + (-3),	(21 shl 16) + (-5),  (10 shl 16) + (16)
 dd (-11 shl 16) + (-26), (27 shl 16) + (-4),	(16 shl 16) + (-7),   (9 shl 16) + (14)
 dd (-17 shl 16) + (-24), (16 shl 16) + (-2),	(12 shl 16) + (0),   (2 shl 16) + (13)
 dd (-23 shl 16) + (-34), (17 shl 16) + (-10),	(6 shl 16) + (-12),  (-2 shl 16) + (6)
 dd (-35 shl 16) + (-55), (-11 shl 16) + (-32), (-19 shl 16) + (-36), (-29 shl 16) + (-17)

 dd (-25 shl 16) + (0), (-16 shl 16) + (0), (-16 shl 16) + (0), (-9 shl 16) + (0)
 dd (-21 shl 16) + (0), (-8 shl 16) + (0), (-3 shl 16) + (0), (0 shl 16) + (0)
 dd (-21 shl 16) + (0), (-9 shl 16) + (0), (-4 shl 16) + (0), (2 shl 16) + (0)
 dd (-22 shl 16) + (0), (-6 shl 16) + (0), (-1 shl 16) + (0), (2 shl 16) + (0)
 dd (-22 shl 16) + (0), (-7 shl 16) + (0), (0 shl 16) + (0), (1 shl 16) + (0)
 dd (-21 shl 16) + (0), (-7 shl 16) + (0), (0 shl 16) + (0), (2 shl 16) + (0)
 dd (-12 shl 16) + (0), (4 shl 16) + (0), (8 shl 16) + (0), (12 shl 16) + (0)
 dd (-23 shl 16) + (0), (-15 shl 16) + (0), (-11 shl 16) + (0), (-5 shl 16) + (0)

 dd (0 shl 16) + (-71),  (-4 shl 16) + (-56), (-3 shl 16) + (-42), (-1 shl 16) + (-29)
 dd (-4 shl 16) + (-56), (6 shl 16) + (-30),  (9 shl 16) + (-21),  (8 shl 16) + (-5)
 dd (-2 shl 16) + (-39), (6 shl 16) + (-17),  (9 shl 16) + (-8),   (9 shl 16) + (5)
 dd (-1 shl 16) + (-29), (8 shl 16) + (-5),   (10 shl 16) + (9),   (7 shl 16) + (19)
 dd (-3 shl 16) + (-27), (9 shl 16) + (-5),   (8 shl 16) + (10),   (7 shl 16) + (21)
 dd (-2 shl 16) + (-40), (6 shl 16) + (-16),  (8 shl 16) + (-10),  (10 shl 16) + (3)
 dd (-2 shl 16) + (-55), (7 shl 16) + (-30),  (7 shl 16) + (-21),  (6 shl 16) + (-6)
 dd (-1 shl 16) + (-74), (-4 shl 16) + (-55), (-1 shl 16) + (-43), (0 shl 16) + (-30)

 dd (267 shl 16) + (  0), (320 shl 16) + ( 48), (270 shl 16) + ( 75), (195 shl 16) + ( 84)
 dd (264 shl 16) + ( 43), (304 shl 16) + ( 92), (238 shl 16) + (143), (180 shl 16) + (132)
 dd (200 shl 16) + ( 83), (245 shl 16) + (138), (176 shl 16) + (167), (110 shl 16) + (165)
 dd (177 shl 16) + (106), (185 shl 16) + (169), (148 shl 16) + (169), (110 shl 16) + (179)
 dd (149 shl 16) + (108), (177 shl 16) + (163), (115 shl 16) + (200), ( 66 shl 16) + (203)
 dd (118 shl 16) + ( 95), (159 shl 16) + (155), ( 84 shl 16) + (176), ( 41 shl 16) + (174)
 dd ( 87 shl 16) + ( 50), (128 shl 16) + ( 99), ( 63 shl 16) + (122), ( 20 shl 16) + (139)
 dd ( 63 shl 16) + (  9), ( 88 shl 16) + ( 55), ( 47 shl 16) + ( 80), (  0 shl 16) + ( 90)
