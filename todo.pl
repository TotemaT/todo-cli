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
my $file = "/Users/Matt/.todo";
my $topicLength = 20;
my $taskLength = 140;
my $fh;

my %todo;
readTodo;

main;

1;

# # Subroutines
# # # # # # # # # # # # # # # # # #
sub main {
	my $argCount = $#ARGV + 1;
	if ($argCount == 0) { # No args -> Show todo
		showTodo;
	} elsif ($argCount == 3) {
		my $action = $ARGV[0];
		my $topic = $ARGV[1];
		my $task = $ARGV[2];

		if (length($topic) > $topicLength) {
			printf "Topic is limited to $topicLength characters.\n";
			return;
		}
		if (length($task) > $taskLength) {
			print "Task is limited to $taskLength characters.\n";
			return;
		}

		if (lc($action) eq "add") {
			addToTodo($topic, $task);
			showTodo;
			writeTodo;
		} elsif (lc($action) eq "del") {
			delFromTodo($topic, $task);
			showTodo;
			writeTodo;
		} else {
			print "Usage :\n\t$0\n\t$0 (add | del) topic task\n";
		}
	} else {
		print "Usage :\n\t$0\n\t$0 (add | del) topic task\n";
	}
	return;
}

sub showTodo {
	print "TODO\n#####################\n";
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
			my ($topic, $tasks) = split /:\s*/, $line, 2;
			my @fields = split ',', $tasks;
			$todo{$topic} = [ @fields ];
		}
		close($fh);
	}
	return;
}

sub writeTodo {
	open ($fh, '>', $file) or die "Couldn't open the file for writing\n";

	foreach my $topic (sort keys %todo) {
		print $fh "$topic: ";
		for my $i (0 .. $#{$todo{$topic}}) {
			print $fh "$todo{$topic}[$i]";
			if ($i != $#{$todo{$topic}}) {
				print $fh ","
			}
		}
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
	return;
}

sub delFromTodo {
	my ($topic, $task) = @_;
	$topic = uc($topic);
	$task = lc($task);

	if (exists $todo{$topic}) {
		my $index;
		for ($index = 0; $index < @{$todo{$topic}}; $index++) {
			last if ($todo{$topic}[$index] eq $task);
		}
		splice($todo{$topic}, $index, 2);
		delete($todo{$topic}) unless (@{$todo{$topic}} != 0);
	}
	return;
}
