#TODO
Basic todo list made in Perl.

##How to use
```
perl todo.pl 
	#Show the full todo list
perl todo.pl (add | del) topic task 
	#Add or delete a precise task under a given topic
```

##Output
This program create a file nammed .todo in its directory. The file content will be in this form : 

```
TOPIC1: task1 task2 task3
TOPIC2: task1 task2 task3 task4
```

But the result shown by the program will look like this :

```
Todo list
#####################
TOPIC1 
	task1 
	task2 
	task3
TOPIC2 
	task1 
	task2 
	task3 
	task4
```

In both cases, the topics being in the alphabetical order.

##Todo
- Add the possibility to delete a whole topic at once <br>
	eg : perl todo.pl del topic
- Add the possibility to delete a task by its index in the topic <br>
	eg : perl todo.pl del topic 2 
- Add a limit for the topic and task length