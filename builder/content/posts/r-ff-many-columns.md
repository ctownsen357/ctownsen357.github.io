+++
title = "R and ff, and many columns! Oh my!"
Description = ""
Tags = [
  "Development",
  "R",
  "ff",
  "ffbase",
]
Categories = [
  "Development",
  "R",
  "ff",
  "ffbase",
]
menu = "main"
date = "2016-12-02T10:28:40-05:00"

+++


Recently, I was experimenting with a data set in R that ended up being more challenging than I first expected.  It really wasn't that large as far as size on disk or memory(single instance) was concerned but it had over 3,000 columns.  

At first I didn't think it was that big of a deal and it wouldn't be if one only needed a single instance of the ~ 750MB file in memory.  What if you have a web application that instantiates that data set on a server for each user and you have many concurrent users? All of a sudden that 750MB and any operations on that data can quickly exhaust available RAM.

I looked at the bigmemory package because it looked promising and contained some tech under the hood that I've used: memory mapped files and shared memory via the C++ boost libraries.  That combination allows a single instance of a matrix to be accessed by multiple processes.  The problem with that ended up being that the dat set was not a matrix of uniform type but mixed types.  Enter the ff and ffbase packages! 

The ff package provides data structures that are stored on disk but behave (almost) as if they were in RAM by transparently mapping only a section (pagesize) in main memory - the effective virtual memory consumption per ff object.

I loaded the original data frame and tried to cast it to an ffdf (ff data frame):
```{r}
require(ffbase)
load('./35509-0001-Data.rda')
testffdf <- as.ffdf(da35509.0001, vmode = NULL)
save.ffdf(testffdf, dir="./testdf", relative=TRUE)
```

It failed silently.  I looked in the `./testdf` and nothing.  Ugh, what appeared so promising now looked bleak!

After some additional tinkering, I received an actual error. 

```
Error en  ff(initdata = initdata, length = length, levels = levels, ordered = ordered,  : 
   write error

```

Not very descriptive but it was something to go on.  After some searching [I came across this thread on stackoverflow.](http://stackoverflow.com/questions/14025202/ff-package-write-error)

The answers were not entirely helpful but they did discuss that each column in an ff data frame are stored in distinct files.  Bingo! I've encountered bumping into exceeding the max number of files open on a system before and it is a very simple fix.  Keep in mind the file limits are in place to prevent resource exhaustion on the system.  Those limits are set VERY conservatively though.  Increasing the limits is as simple as the following:

### Linux:
Add the following to your `/etc/security/limits.conf` file.
```
youruserid  hard  nofile 100000 # you may enter whatever number you wish here
youruserid  soft  nofile  10000 # whatever you want the default to be for each shell or process you have running
```

### OS X:
Add or edit the following in your `/etc/sysctl.con` file.
```
kern.maxfilesperproc=166384
kern.maxfiles=8192
```

You'll need to log out and log back in for the change to take effect.  After that change, one may use the ff data frame with up to the number of columns you specified in your `limits.conf` or `sysctl.con` file.  

Now I'm able to load  what was 750MB per data frame instance as a ffdf and only consume ~ 11MB of RAM per instance.  Many parallel instances of the R routines using this data may be run without exhausting available RAM.  Keep in mind that you'll want to tweak your max open file settings to account for expected concurrent use.

You can test this by opening up a new R session, changing directories to where you were working previously and loading the ffdf from disk:
```{R}
required(ffbase)
load.ffdf('./testdf')
```
Your should now have an instance of the original testffdf object.

A helpful presentation on the ff and ffbase packages is [available here](http://ff.r-forge.r-project.org/ff&bit_UseR!2009.pdf).

