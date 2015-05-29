Ruigi [![Build Status](https://img.shields.io/travis/kirillseva/ruigi.svg)](https://travis-ci.org/kirillseva/ruigi) [![Coverage Status](https://img.shields.io/coveralls/kirillseva/ruigi.svg)](https://coveralls.io/r/kirillseva/ruigi) ![Release Tag](https://img.shields.io/github/tag/kirillseva/ruigi.svg)
===========

Ruigi is a pipeline specialist, much like his python counterpart,
[Luigi](https://github.com/spotify/luigi).

How to use
----
Ruigi has two simple concepts that you need to understand in order to use it.
The first one is the concept of a **target**.

A target is an abstraction of an output of a computation that also encloses methods for reading and writing.
For example, a `.csv` file can be a valid target. [Here](https://github.com/kirillseva/ruigi/blob/master/R/csv_target.R)
is how it is defined in Ruigi. To use this target you can just define it like

```r
target <- CSVtarget$new("~/Desktop/output.csv")
target$exists() # [1] FALSE
target$write(iris)
target$exists() # [1] TRUE
identical(iris, target$read()) # [1] TRUE
```

The second abstraction is a **task**. A task is an abstraction of a confined computation module,
which can later become a part of a big computation pipeline.
When you define a pipeline, Ruigi will automatically determine the optimal order of execution for the tasks,
discover the dependencies, and perform checks to see if you have any cyclic dependencies.

A task is defined by its input targets, the output target, and the computation that needs to be performed on
those targets. Note that a task can have 0, 1 or many inputs, but it has to have exactly one output.
If the output target for a task exists, the computation will not be run again, saving you time.

By defining separate abstractions for computation modules (tasks), and inspectable outputs (targets),
you can have your own library of data processing steps that you can combine into pipelines for different use cases.


Example
----
```r
# These can be logically organized into folders and then `source`'d
# prior to defining the pipeline.
reader <- ruigi_task$new(
  requires = list(CSVtarget$new("~/Desktop/titanic.csv")),
  target = Rtarget$new("titanic_data"),
  name = "I will read a .csv file and store it on .ruigi_env",
  runner = function(requires, target) {
    out <- requires[[1]]$read()
    target$write(out)
  }
)

writer <- ruigi_task$new(
  requires = list(Rtarget$new("titanic_data")),
  target = CSVtarget$new("~/Desktop/output.csv"),
  name = "I will read a file from RAM and store it in a .csv",
  runner = function(requires, target) {
    out <- requires[[1]]$read()
    target$write(out)
  }
)

# Dependencies will be determined and the tasks will be run.
ruigi::pipeline(list(writer, reader))

# Running task:  I will read a .csv file and store it on .ruigi_env ✓
# Running task:  I will read a file from RAM and store it in a .csv ✓

# No need to run the tasks again, the results already exist
ruigi::pipeline(list(reader, writer))
# Skipping:  I will read a .csv file and store it on .ruigi_env
# Skipping:  I will read a file from RAM and store it in a .csv
```

Inspiration
----
1. [Luigi](https://github.com/spotify/luigi). A very powerful and
widely used python package.
2. [Make](http://www.gnu.org/software/make/). Classic.
3. [Remake](https://github.com/richfitz/remake). A make alternative
for R. If you prefer to write R code as opposed to oneliners in
`.yml` configs you might enjoy using Ruigi!
