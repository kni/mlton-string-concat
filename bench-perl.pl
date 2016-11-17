$| = 1;
use v5.10;
use strict;
use warnings;
use Time::HiRes qw(time);

sub runBench {
	my ($n, $name, $f) = @_;
	my $t0 = time;
	while ($n--) {
		$f->();
	}
	my $t1 = time;
	print $name, " ", $t1 - $t0, "\n";
}


sub bench_concat {
	my ($n) = @_;
	my $a = "a";
	my $b = "a" x $n;
	runBench 100000, "string . (size is $n)", sub { $a . $b };
}

bench_concat 1000; # n - size of string


sub bench_concat_list {
	my ($n) = @_;
	my @l = map { $_ x $n } ("a", "b", "c", "d", "e");
	runBench 100000, "concat string list (size is $n)", sub { join "", @l };
}

bench_concat_list 1000;
bench_concat_list 10000;
