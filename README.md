# README #

### R/Rd2Dash ###

[Dash](https://kapeli.com/dash) is a wonderful tool to manage API documentation sets in MAC (OS X). For us R users, Only the documentation of R/base is available as Dash docset, and it is usually not good enough for some "real" analysis. It would be more convenient if we can generate a Dash docset includes the documentation of those (and only those) packages used in projects.

Even though [some scripts](https://kapeli.com/docsets#scriptExamples) are available for generating docsets, here I propose another one that can directly build a docset based on a folder of .Rd files, which is commonly used in packages in [CRAN](http://cran.r-project.org/). It is a R function that depends on R/base, R/tools and R/RSQLite. A .docset file would be generated, which can then be loaded into Dash.