if VERBOSE > 0
  align 16
  VerboseOutput         rq 1024
  VerboseTime           rq 2
end if


if DEBUG > 0
  align 16
  DebugBalance          rq 1
  DebugOutput           rq 1024
end if




align 16
constd:
.0p03	 dq 0.03
.0p505	 dq 0.505
.1p0	 dq 1.0
.628p0	 dq 628.0


match =0, CPU_HAS_POPCNT {
 Mask55    dq 0x5555555555555555
 Mask33    dq 0x3333333333333333
 Mask0F    dq 0x0F0F0F0F0F0F0F0F
 Mask01    dq 0x0101010101010101
 Mask11    dq 0x1111111111111111
}


szUciResponse:
	db 'id name '
szGreeting:
	db VERSION_PRE
	db VERSION_OS
	db '_'
	create_build_time DAY, MONTH, YEAR
	db '_'
	db VERSION_POST
	NewLineData
szGreetingEnd:
	db 'id author TypingALot'
	NewLineData
	db 'option name Hash type spin default 16 min 1 max '
	IntegerStringData (1 shl MAX_HASH_LOG2MB)
	NewLineData
	db 'option name LargePages type check default false'
	NewLineData
	db 'option name Threads type spin default 1 min 1 max '
	IntegerStringData MAX_THREADS
	NewLineData
	db 'option name NodeAffinity type string default all'
	NewLineData
	db 'option name Priority type combo default none var none var normal var low var idle'
	NewLineData

	db 'option name TTFile type string default <empty>'
	NewLineData
	db 'option name TTSave type button'
	NewLineData
	db 'option name TTLoad type button'
	NewLineData

	db 'option name Clear Hash type button'
	NewLineData

	db 'option name Ponder type check default false'
	NewLineData
	db 'option name UCI_Chess960 type check default false'
	NewLineData

	db 'option name MultiPV type spin default 1 min 1 max 224'
	NewLineData
	db 'option name Contempt type spin default 0 min -100 max 100'
	NewLineData
	db 'option name MoveOverhead type spin default 30 min 0 max 5000'
	NewLineData
	db 'option name MinThinkTime type spin default 20 min 0 max 5000'
	NewLineData
	db 'option name SlowMover type spin default 89 min 10 max 1000'
	NewLineData

if USE_SYZYGY
	db 'option name SyzygyProbeDepth type spin default 1 min 1 max 100'
	NewLineData
	db 'option name SyzygyProbeLimit type spin default 6 min 0 max 6'
	NewLineData
	db 'option name Syzygy50MoveRule type check default true'
	NewLineData
	db 'option name SyzygyPath type string default <empty>'
	NewLineData
end if

if USE_WEAKNESS
	db 'option name UCI_LimitStrength type check default false'
	NewLineData
	db 'option name UCI_Elo type spin default 1000 min 0 max 3300'
	NewLineData
end if

if USE_VARIETY
	db 'option name Variety type spin default 0 min 0 max 40'
	NewLineData
end if

if USE_BOOK
	db 'option name OwnBook type check default false'
	NewLineData
	db 'option name BookFile type string default <empty>'
	NewLineData
	db 'option name BestBookMove type check default false'
	NewLineData
        db 'option name BookDepth type spin default 100 min -10 max 100'
        NewLineData
end if

	db 'uciok'
sz_NewLine:
	NewLineData
sz_NewLineEnd:
szUciResponseEnd:

szCPUError         db 'Error: processor does not support',0
   .POPCNT         db ' POPCNT',0
   .AVX1           db ' AVX1',0
   .AVX2           db ' AVX2',0
   .BMI1           db ' BMI1',0
   .BMI2           db ' BMI2',0
szStartFEN         db 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',0
PieceToChar        db '.?PNBRQK??pnbrqk'


sz_format_currmove:
        db 'info depth %u0 currmove %m1 currmovenumber %u2%n', 0
sz_format_thread:
        db 'info string node %i0 has threads', 0
sz_format_perft1:
        db '%m0 : %U1%n', 0
sz_format_bench1:
        db '*** bench hash %u0 threads %u1 depth %u2 realtime %u3 ***%n', 0
sz_format_bench2:
        db '%U0: %a8nodes: %U1 %a32%U2 knps%n', 0
sz_format_perft2:
sz_format_bench3:
        db '===========================%n'
        db 'Total time (ms) : %U0%n'
        db 'Nodes searched  : %U1%n'
        db 'Nodes/second    : %U2%n', 0

sz_info_node_threads db 'info string node %i0 has threads',0
sz_tt_update         db 'info string finished %U0 MB of %U1 MB%n',0
sz_path_set          db 'info string path set to ', 0
sz_hash_cleared      db 'info string hash cleared', 0
sz_error_badttfile   db 'error: could not read ttfile ',0
sz_error_badttsize   db 'error: ttfile has funny size 0x%X0%n',0
sz_error_middlett    db 'error: could not process whole file',0

sz_error_priority  db 'error: unknown priority ',0
sz_error_depth     db 'error: bad depth ',0
sz_error_fen       db 'error: illegal fen',0
sz_error_moves     db 'error: illegal move ',0
sz_error_token     db 'error: unexpected token ',0
sz_error_unknown   db 'error: unknown command ',0
sz_error_think	   db 'error: setoption called while thinking',0
sz_error_value	   db 'error: setoption has no value',0
sz_error_name	   db 'error: setoption has no name',0
sz_error_option    db 'error: unknown option ',0
sz_error_hashsave  db 'error: could not save hash file ',0
sz_error_affinity1 db 'error: parsing affinity failed after "',0
sz_error_affinity2 db '"; proceeding as "all"',0
sz_empty           db '<empty>',0

sz_go			db 'go',0
sz_all			db 'all',0
sz_low			db 'low',0
sz_uci			db 'uci',0
sz_fen			db 'fen',0
sz_wait 		db 'wait',0
sz_quit 		db 'quit',0
sz_none 		db 'none',0
sz_winc 		db 'winc',0
sz_binc 		db 'binc',0
sz_mate 		db 'mate',0
sz_name 		db 'name',0
sz_idle 		db 'idle',0
sz_hash 		db 'hash',0
sz_stop 		db 'stop',0
sz_value		db 'value',0
sz_depth		db 'depth',0
sz_nodes		db 'nodes',0
sz_wtime		db 'wtime',0
sz_btime		db 'btime',0
sz_moves                db 'moves',0
sz_perft		db 'perft',0
sz_bench		db 'bench',0
sz_ttfile		db 'ttfile',0
sz_ttsave		db 'ttsave',0
sz_ttload		db 'ttload',0
sz_ponder		db 'ponder',0
sz_normal		db 'normal',0
sz_threads		db 'threads',0
sz_isready		db 'isready',0
sz_multipv		db 'multipv',0
sz_realtime		db 'realtime',0
sz_startpos		db 'startpos',0
sz_infinite		db 'infinite',0
sz_movetime		db 'movetime',0
sz_contempt		db 'contempt',0
sz_weakness		db 'weakness',0
sz_priority		db 'priority',0
sz_position		db 'position',0
sz_movestogo		db 'movestogo',0
sz_setoption		db 'setoption',0
sz_slowmover		db 'slowmover',0
sz_ponderhit		db 'ponderhit',0
sz_ucinewgame		db 'ucinewgame',0
sz_clear_hash		db 'clear hash',0
sz_largepages		db 'largepages',0
sz_searchmoves		db 'searchmoves',0
sz_nodeaffinity 	db 'nodeaffinity',0
sz_moveoverhead 	db 'moveoverhead',0
sz_minthinktime 	db 'minthinktime',0
sz_uci_chess960 	db 'uci_chess960',0

if USE_SYZYGY
sz_syzygypath		db 'syzygypath',0
sz_syzygyprobedepth	db 'syzygyprobedepth',0
sz_syzygy50moverule	db 'syzygy50moverule',0
sz_syzygyprobelimit	db 'syzygyprobelimit',0
end if

if USE_WEAKNESS
sz_uci_limitstrength	db 'uci_limitstrength',0
sz_uci_elo		db 'uci_elo',0
end if

if USE_VARIETY
sz_variety              db 'variety',0
end if

if USE_BOOK
sz_ownbook		db 'ownbook',0
sz_bookfile		db 'bookfile',0
sz_bookdepth            db 'bookdepth',0
sz_bestbookmove 	db 'bestbookmove',0
end if

BenchFens: ;fens must be separated by one or more space char
.bench_fen00 db "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1 "
.bench_fen01 db "r3k2r/p1ppqpb1/bn2pnp1/3PN3/1p2P3/2N2Q1p/PPPBBPPP/R3K2R w KQkq - 0 10 "
.bench_fen02 db "8/2p5/3p4/KP5r/1R3p1k/8/4P1P1/8 w - - 0 11 "
.bench_fen03 db "4rrk1/pp1n3p/3q2pQ/2p1pb2/2PP4/2P3N1/P2B2PP/4RRK1 b - - 7 19 "
.bench_fen04 db "rq3rk1/ppp2ppp/1bnpb3/3N2B1/3NP3/7P/PPPQ1PP1/2KR3R w - - 7 14 "
.bench_fen05 db "r1bq1r1k/1pp1n1pp/1p1p4/4p2Q/4Pp2/1BNP4/PPP2PPP/3R1RK1 w - - 2 14 "
.bench_fen06 db "r3r1k1/2p2ppp/p1p1bn2/8/1q2P3/2NPQN2/PPP3PP/R4RK1 b - - 2 15 "
.bench_fen07 db "r1bbk1nr/pp3p1p/2n5/1N4p1/2Np1B2/8/PPP2PPP/2KR1B1R w kq - 0 13 "
.bench_fen08 db "r1bq1rk1/ppp1nppp/4n3/3p3Q/3P4/1BP1B3/PP1N2PP/R4RK1 w - - 1 16 "
.bench_fen09 db "4r1k1/r1q2ppp/ppp2n2/4P3/5Rb1/1N1BQ3/PPP3PP/R5K1 w - - 1 17 "
.bench_fen10 db "2rqkb1r/ppp2p2/2npb1p1/1N1Nn2p/2P1PP2/8/PP2B1PP/R1BQK2R b KQ - 0 11 "
.bench_fen11 db "r1bq1r1k/b1p1npp1/p2p3p/1p6/3PP3/1B2NN2/PP3PPP/R2Q1RK1 w - - 1 16 "
.bench_fen12 db "3r1rk1/p5pp/bpp1pp2/8/q1PP1P2/b3P3/P2NQRPP/1R2B1K1 b - - 6 22 "
.bench_fen13 db "r1q2rk1/2p1bppp/2Pp4/p6b/Q1PNp3/4B3/PP1R1PPP/2K4R w - - 2 18 "
.bench_fen14 db "4k2r/1pb2ppp/1p2p3/1R1p4/3P4/2r1PN2/P4PPP/1R4K1 b - - 3 22 "
.bench_fen15 db "3q2k1/pb3p1p/4pbp1/2r5/PpN2N2/1P2P2P/5PP1/Q2R2K1 b - - 4 26 "
.bench_fen16 db "6k1/6p1/6Pp/ppp5/3pn2P/1P3K2/1PP2P2/3N4 b - - 0 1 "
.bench_fen17 db "3b4/5kp1/1p1p1p1p/pP1PpP1P/P1P1P3/3KN3/8/8 w - - 0 1 "
.bench_fen18 db "2K5/p7/7P/5pR1/8/5k2/r7/8 w - - 0 1 "
.bench_fen19 db "8/6pk/1p6/8/PP3p1p/5P2/4KP1q/3Q4 w - - 0 1 "
.bench_fen20 db "7k/3p2pp/4q3/8/4Q3/5Kp1/P6b/8 w - - 0 1 "
.bench_fen21 db "8/2p5/8/2kPKp1p/2p4P/2P5/3P4/8 w - - 0 1 "
.bench_fen22 db "8/1p3pp1/7p/5P1P/2k3P1/8/2K2P2/8 w - - 0 1 "
.bench_fen23 db "8/pp2r1k1/2p1p3/3pP2p/1P1P1P1P/P5KR/8/8 w - - 0 1 "
.bench_fen24 db "8/3p4/p1bk3p/Pp6/1Kp1PpPp/2P2P1P/2P5/5B2 b - - 0 1 "
.bench_fen25 db "5k2/7R/4P2p/5K2/p1r2P1p/8/8/8 b - - 0 1 "
.bench_fen26 db "6k1/6p1/P6p/r1N5/5p2/7P/1b3PP1/4R1K1 w - - 0 1 "
.bench_fen27 db "1r3k2/4q3/2Pp3b/3Bp3/2Q2p2/1p1P2P1/1P2KP2/3N4 w - - 0 1 "
.bench_fen28 db "6k1/4pp1p/3p2p1/P1pPb3/R7/1r2P1PP/3B1P2/6K1 w - - 0 1 "
.bench_fen29 db "8/3p3B/5p2/5P2/p7/PP5b/k7/6K1 w - - 0 1 "
  ; 5-man positions
.bench_fen30 db "8/8/8/8/5kp1/P7/8/1K1N4 w - - 0 1 "
.bench_fen31 db "8/8/8/5N2/8/p7/8/2NK3k w - - 0 1 "
.bench_fen32 db "8/3k4/8/8/8/4B3/4KB2/2B5 w - - 0 1 "
  ; 6-man positions
.bench_fen33 db "8/8/1P6/5pr1/8/4R3/7k/2K5 w - - 0 1 "
.bench_fen34 db "8/2p4P/8/kr6/6R1/8/8/1K6 w - - 0 1 "
.bench_fen35 db "8/8/3P3k/8/1p6/8/1P6/1K3n2 b - - 0 1 "
  ; 7-man positions
.bench_fen36 db "8/R7/2q5/8/6k1/8/1P5p/K6R w - - 0 124"
BenchFensEnd: db 0

match ='W', VERSION_OS {
 sz_kernel32			      db 'kernel32',0
 sz_Advapi32dll 		      db 'Advapi32.dll',0
 sz_VirtualAllocExNuma		      db 'VirtualAllocExNuma',0
 sz_SetThreadGroupAffinity	      db 'SetThreadGroupAffinity',0
 sz_GetLogicalProcessorInformationEx  db 'GetLogicalProcessorInformationEx',0
align 8
 Frequency   dq ?
 Period      dq ?
 hProcess    dq ?
 hStdOut     dq ?
 hStdIn      dq ?
 hStdError   dq ?
 hAdvapi32   dq ?
 __imp_MessageBoxA                    dq ?
 __imp_VirtualAllocExNuma             dq ?
 __imp_SetThreadGroupAffinity         dq ?
 __imp_GetLogicalProcessorInformationEx dq ?
}

match ='L', VERSION_OS {
align 8
 rspEntry dq ?
 __imp_clock_gettime dq ?
}

match ='X', VERSION_OS {
align 8
 argc dq ?
 argv dq ?
}
match ='C', VERSION_OS {
align 8
 argc dq ?
 argv dq ?
}

align 8
 LargePageMinSize dq ?
