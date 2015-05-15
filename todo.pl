#! /usr/bin/perl

package TODO 1;

use strict;
use warnings;

sub main;
sub showTodo;
sub readTodo;
sub writeTodo;
sub addToTodo;
sub delFromTodo;

# # Main
# # # # # # # # # # # # # # # # # #
my $file = ".todo";
my $fh;

my %todo;
readTodo;

main;

writeTodo;
1;

# # Subroutines
# # # # # # # # # # # # # # # # # #
sub main {
	my $argCount = $#ARGV + 1;
	if ($argCount == 0) { # No args -> Show todo
		showTodo;
	} elsif ($argCount == 3) {
		if (lc($ARGV[0]) eq "add") {
			addToTodo($ARGV[1], $ARGV[2]);
		} elsif (lc($ARGV[0]) eq "del") {
			delFromTodo($ARGV[1], $ARGV[2]);
		} else {
			print "Usage :\n\t$0\n\t$0 (add | del) topic task\n";
		}
	} else {
		print "Usage :\n\t$0\n\t$0 (add | del) topic task\n";
	}
	return;
}

sub showTodo {
	print "Todo list\n#####################\n";
	print "No task yet.\n" unless keys(%todo) > 0;
	foreach my $topic (sort keys %todo) {
		print "$topic\n";
		for my $i (0 .. $#{$todo{$topic}}) {
			print "\t$todo{$topic}[$i]\n"
		}
	}
	return;
}

sub readTodo {
	if (-e $file) {
		open ($fh, '<', $file) or die "Couldn't open the file for reading\n";
		while (my $line = <$fh>) {
			my ($who, $rest) = split /:\s*/, $line, 2;
			my @fields = split ' ', $rest;
			$todo{$who} = [ @fields ];
		}
		close($fh);
	}
	return;
}

sub writeTodo {
	open ($fh, '>', $file) or die "Couldn't open the file for writing\n";

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

sub addToTodo {
	my ($topic, $task) = @_;
	$topic = uc($topic);
	$task = lc($task);

	if (exists $todo{$topic}) {
		push($todo{$topic}, $task);
	} else {
		$todo{$topic} = [$task];
	}
	showTodo;
	return;
}

sub delFromTodo {
	my ($topic, $task) = @_;
	$topic = uc($topic);
	$task = lc($task);

	if (exists $todo{$topic}) {
		my $index ;
		for ($index = 0; $index < @{$todo{$topic}}; $index++) {
			last if ($todo{$topic}[$index] eq $task);
		}
		splice($todo{$topic}, $index, 1);
		delete($todo{$topic}) unless (@{$todo{$topic}} != 0);
	}
	showTodo;
	return;
}