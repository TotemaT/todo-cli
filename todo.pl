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
sub updateTodo;
sub usage;

# # Main
# # # # # # #p # # # # # # # # # # #
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

	if ($argCount == 0) {
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
	} elsif ($argCount == 4) {
		my $action = $ARGV[0];
		my $topic = $ARGV[1];
		my $task = $ARGV[2];
		my $update = $ARGV[3];

		if (lc($action) eq "upd") {
			updateTodo($topic, $task, $update);
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
		my $answer = substr(lc(<STDIN>),0,1);
		if ($answer eq "y") {
			delete($todo{$topic});
		}
	}
}

sub updateTodo {
	my ($topic, $task, $update) = @_;
	$topic = uc($topic);
	$task = lc($task);
	$update = lc($update);
	if (exists $todo{$topic} && looks_like_number($task)) {
		my $index = $task - 1;
		my $key;
		if ($index >= @{$todo{$topic}}) {
			print "Index out of bound.\n";
			return;
		} else {
			$todo{$topic}[$index] = $update;
		}
	}
}

sub usage {
	print "Usage:\n$0\n\t#Show the full todo list\n$0 add topic task\n\t#Add a task under a given topic, creating the topic if needed\n$0 del topic (task | task_nb)\n\t#Delete a task, designated by its name or its number, under a topic, deleting the topic if empty\n$0 del topic\n\t#Delete a topic (including its tasks) after the user confirmation\n$0 upd topic task_nb task_updated\n\t#Update a task, designated by its number.\n";
}
