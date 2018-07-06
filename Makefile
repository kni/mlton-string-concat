all: poly mlton perl

poly:
	poly --script bench-poly.sml

bench-mlton: mlton-string-concat.c mlton-string-concat.sml bench-mlton.sml bench-mlton.mlb
	mlton -default-ann 'allowFFI true' bench-mlton.mlb mlton-string-concat.c

mlton: bench-mlton
	./bench-mlton

perl:
	perl bench-perl.pl

clean:
	rm -rf bench-mlton
