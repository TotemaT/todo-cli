#!/usr/bin/perl

use strict;
use warnings;
use Scalar::Util qw(looks_like_number);

sub main;
sub readTodo;
sub showTodo;
sub writeTodo;
sub addToTodo;
sub delFromTodo;
sub delTopicFromTodo;
sub usage;

# # Main
# # # # # # # # # # # # # # # # # #
my $file = ".todo";
my $topicLength = 20;
my $taskLength = 140;

my %todo;
readTodo;

main;

# # Subroutines
# # # # # # # # # # # # # # # # # #
sub main {
	my $argCount = $#ARGV + 1;
	my $action;
	my $topic;
	my $task;

	if ($argCount == 0) { # No args -> Show todo
		showTodo;
	} elsif ($argCount == 2) {
		$action = $ARGV[0];
		$topic = $ARGV[1];

		if ($action eq "del") {
			delTopicFromTodo($topic);
			writeTodo;
		} else {
			usage;
		}
	} elsif ($argCount == 3) {
		$action = $ARGV[0];
		$topic = $ARGV[1];
		$task = $ARGV[2];

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
			usage;
		}
	} else {
		usage;
	}
	return;
}

sub readTodo {
	if (-e $file) {
		my $fh;
		open ($fh, '<', $file) or die "Couldn't open the file for reading\n";
		while (my $line = <$fh>) {
			chomp($line);
			my ($topic, $tasks) = split /:\s*/, $line, 2;
			my @fields = split '\",\"', $tasks;
			s{^\"+|\"+$}{}g foreach @fields;
			$todo{$topic} = [ @fields ];
		}
		close($fh);
	}
	return;
}

sub showTodo {
	print "TODO\n#####################\n";
	print "No task yet.\n" unless keys(%todo) > 0;
	foreach my $topic (sort keys %todo) {
		print "$topic\n";
		for my $i (0 .. $#{$todo{$topic}}) {
			printf "\t%d. $todo{$topic}[$i]\n", $i + 1;
		}
	}
	return;
}

sub writeTodo {
	my $fh;
	open ($fh, '>', $file) or die "Couldn't open the file for writing\n";

	foreach my $topic (sort keys %todo) {
		print $fh "$topic: ";
		for my $i (0 .. $#{$todo{$topic}}) {
			print $fh "\"$todo{$topic}[$i]\"";
			if ($i != $#{$todo{$topic}}) {
				print $fh ","
			} else {
				print $fh "\n";
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
	chomp($topic);
	chomp($task);

	if (exists $todo{$topic}) {
		for (my $i = 0; $i < @{$todo{$topic}}; $i++ ){
			if ($task eq $todo{$topic}[$i]) {
				print "This task already exists.\n";
				return;
			}
		}
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
		if (looks_like_number($task)) {
			$index = $task - 1;
			if ($index >= @{$todo{$topic}}) {
				print "Index out of bound.\n";
				return;
			}
		} else {
			for ($index = 0; $index < @{$todo{$topic}}; $index++) {
				last if ($todo{$topic}[$index] eq $task);
			}
		}
		print "$index\n";
		splice($todo{$topic}, $index, 1);
		delete($todo{$topic}) unless (@{$todo{$topic}} != 0);
	}
	return;
}

sub delTopicFromTodo {
	my $topic = $_[0];
	$topic = uc($topic);

	if (exists $todo{$topic}) {
		print "Do you really want to delete all tasks under $topic? (y/n)\n";
		my $answer = <STDIN>;
		chomp($answer);
		if ($answer eq "y" or $answer eq "Y") {
			delete($todo{$topic});
		}
	}
}

sub usage {
	print "Usage:\n./todo.pl\n\t#Show the full todo list\n./todo.pl add topic task\n\t#Add a task under a given topic, creating the topic if needed\n./todo.pl del topic (task | task_nb)\n\t#Delete a task, designed by its name or its number, under a topic, deleting the topic if empty\n./todo.pl del topic\n\t#Delete a topic (including its tasks) after the user confirmation\n";
}
