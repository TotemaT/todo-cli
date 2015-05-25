#TODO
Basic todo list made in Perl.

##How to use
From the command line :
```
./todo.pl
	#Show the full todo list
./todo.pl (add | del) topic task
	#Add or delete a precise task under a given topic
./todo.pl del topic
	#Delete a whole topic after the user confirmation
```

Using the command without argument in a software like [GeekTool (OSX)](http://projects.tynsoe.org/fr/geektool/) allows to show the todo list directly on your desktop.

##Output
This program create a file nammed .todo in its directory. The file content will be in this form :

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