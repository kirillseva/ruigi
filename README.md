Ruigi [![Build Status](https://img.shields.io/travis/kirillseva/ruigi.svg)](https://travis-ci.org/kirillseva/ruigi) [![Coverage Status](https://img.shields.io/coveralls/kirillseva/ruigi.svg)](https://coveralls.io/r/kirillseva/ruigi) ![Release Tag](https://img.shields.io/github/tag/kirillseva/ruigi.svg)
===========

Ruigi is a pipeline specialist, much like his python counterpart,
[Luigi](https://github.com/spotify/luigi).

Example
----
```r
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

# Dependencies will be determined and the tasks will be run
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
