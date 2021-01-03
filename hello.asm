		INCLUDE	"stdlib/stream.i"
		INCLUDE	"stdlib/string.i"
		INCLUDE	"stdlib/syscall.i"

		SECTION	"Code",CODE

Entry::
		ld	bc,hello
		jal	StreamDataStringOut

		sys	KExit


		SECTION	"Data",DATA
hello:	DC_STR	<"Hello, world">