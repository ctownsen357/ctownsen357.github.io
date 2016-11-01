+++
Tags = [
  "Development",
  "Docker",
  "Monitor",
  "Awk",
]
date = "2016-11-01T09:38:04-04:00"
title = "Monitor Docker Events with Awk"
Categories = [
  "Development",
  "Docker",
  "Monitor",
  "Awk",

]
menu = "main"
Description = "Monitoring Docker events with Awk."

+++
I recently wrote a Docker event monitor in Go as an excercise to demonstrate some proficiency in Go and Docker.  Before getting started I was thinking about how it could be done with piping, bash, and awk.  It was actually really easy to do.  Some of the excercise requirements were:

- The service should monitor the Docker API for restart events 
- The service should run an arbitrary command in response to that event. 
- The arbitrary command should be supplied via a config file.

The pipe, bash, awk solution:

```{bash}
echo ' pwd' > cmd.txt && docker events | awk '/container restart/{system("echo docker exec " $4 " $(cat cmd.txt) | bash -")}'
```

This pipes the pwd command into a file and then pipes the stream from docker events into awk which is searching for the restart event.  When the restart event is encountered it executes the arbitrary command from the text file against the restarted container.  The command in the text file could be replaced with any desired command. 

There were other requirements that made it interesting to think through in Go.  I'll be posting the entire excercise and my code soon.

