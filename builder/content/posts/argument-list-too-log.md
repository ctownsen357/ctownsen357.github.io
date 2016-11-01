+++
date = "2016-11-01T15:47:38-04:00"
title = "Argument List Too Long"
Categories = [
  "Development",
  "bash",
  "Terminal",
  "xargs",
]
menu = "main"
Description = ""
Tags = [
  "Development",
  "bash",
  "Terminal",
  "xargs",
]

+++

You know it before you even try.  You try anyway.  Something like trying to bzip2 316,387 CSV files representing ~ 10TB of data.  You know it will be at least 1/10 the size and R can handle the bzip2 files directly so you call bzip2 and get the argument list too long error.  Find and xargs to the rescue!  Also, lbzip2 because you really don't want to wait on bzip2 any more than you have to.

```{bash}

find path_to_files/ -name "*.csv" | xargs -P 5 lbzip2

```

**Note:** you'll want to balance the number of parallel lbzip2 instances (or whatever you are running) as indicated by -P 5 above, balance that with the fact that lbzip2 runs in parallel too.  

It still took a long time to compress 316,387 files but it went a whole lot faster with parallel instances of parallel bzip2 using the xargs -P flag.

