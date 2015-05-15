use strict;
use warnings;

sub showTodo;
sub readTodo;
sub writeTodo;
sub addToTodo;
sub delFromTodo;

# # Main
# # # # # # # # # # # # # # # # # #
my $file = "todo";
my $fh;

my %todo;
readTodo;

my $argCount = $#ARGV + 1;
if ($argCount == 0) { # No args -> Show todo
	showTodo;
} elsif ($argCount == 3) { # Args -> if todo (add | del) topic task -> modify todo

} else {
		print "Usage :\n\t$0\n\t$0 (add | del) topic task\n";
}
# Args -> Too many / Too few -> quit
writeTodo;

# # Subroutines
# # # # # # # # # # # # # # # # # #
sub showTodo {
	foreach my $topic (sort keys %todo) {
		print "$topic\n";
		for my $i (0 .. $#{$todo{$topic}}) {
			print "\t$todo{$topic}[$i]\n"
		}
	}
	return;
}

sub readTodo {
	# If file exists, open it in R/W, if not, create and open in R
	if (-e $file) {
		open ($fh, '+<', $file) or die "Couldn't open the file\n";
	} else {
		open ($fh, '>', $file) or die "Couldn't open the file\n";
	}

	while (my $line = <$fh>) {
		my ($who, $rest) = split /:\s*/, $line, 2;
		my @fields = split ' ', $rest;
		$todo{$who} = [ @fields ];
	}
	close($fh);
	return;
}

sub writeTodo {
	open ($fh, '>', $file) or die "Couldn't open the file\n";

	foreach my $topic (sort keys %todo) {
		print $fh "$topic:";
		for my $i (0 .. $#{$todo{$topic}}) {
			print $fh "$todo{$topic}[$i] "
		}
		print $fh "\n";
	}
	close($fh);
	return;
}

sub addToTodo { # If topic exists add to topic, else create topic

	return;
}

sub delFromTodo { # If topic and task exists, delete task, if topic is left without task, remove it, else do nothing
	return;
}
