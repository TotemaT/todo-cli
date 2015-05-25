#TODO
Basic todo list made in Perl.

##How to use
From the command line:
```
./todo.pl
	#Show the full todo list
./todo.pl add topic task
	#Add a task under a given topic, creating the topic if needed
./todo.pl del topic (task | task_nb)
	#Delete a task, designed by its name or its number, under a topic, deleting the topic if empty
./todo.pl del topic
	#Delete a topic (including its tasks) after the user confirmation
```

Using the command without argument in a software like [GeekTool (OSX)](http://projects.tynsoe.org/fr/geektool/) allows to show the todo list directly on your desktop.

##Output
This program creates a file named .todo in its directory. The file content will be in this form :

```
TOPIC1: task1,task2,task3
TOPIC2: task1,task2,task3,task4
```

But the result shown by the program will look like this :

```
Todo list
#####################
TOPIC1
	1. task1
	2. task2
	3. task3
TOPIC2
	1. task1
	2. task2
	3. task3
	4. task4
```

In both cases, the topics are shown in alphabetical order.
