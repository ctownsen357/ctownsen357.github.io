+++
date = "2017-01-08T17:08:34-05:00"
title = "Compiled R"
menu = "main"
Categories = ["Development","R"]
Tags = ["Development","R"]
Description = "Increasing the performance of R by compiling to bytecode."

+++


While investigating ways to make some R code more performant I came across the compiler package.  This package allows one to compile functions and/or entire files into compiled bytecode.  Alternatively one may also enable just-in-time compilation.  In my use case with Rserve the JIT compilation options actually made performance worse because each session was recompiling everything rather than sharing compiled source.  In my case the way forward was to compile the files into bytecode so they were precompiled manually and available as bytecode files.

## Just-in-time Compile

```
library(compiler)
enableJIT(3)
```

The options for JIT are 0 through 3, inicating no JIT through the max level where everything possible is compiled before first use.

## Compiling functions
```{r}
library(compiler)
myfoo <- function(){
    seq(1:5)
}

compiledfoo <- cmpfun(myfoo)
```
That example is not going to yield any performance benefit because seq is already compiled but it demonstrates HOW to compile a function.  My experience was that it is about 2-3 times faster and is most helpful for a function that gets called multiple times.

## Compiling an entire R file
```{r}
library(compiler)
cmpfile(infile='<path_to_file>.R')
```
This will compile the entire R file down to bytecode in the same location with an extension of .Rc  This compiled file may then be sourced in other R files and the performance benefits I saw were highly dependent on the types of routines being called.  

## Sourcing your newly compiled R file
```{r}
library(compiler)

loadcmp('<path/to/compiled/file>.Rc')
# call all of your functions as you normally would
```





