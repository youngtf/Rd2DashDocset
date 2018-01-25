# README #

### R/Rd2Dash ###

[Dash](https://kapeli.com/dash) is a wonderful tool to manage API documentation sets in MAC (OS X). Currently, the documentation is available only for R/base as Dash docset, and it is usually not good enough for analysis in practice. It would be more convenient if we can generate customized Dash docsets including the documentation of those (and only those) packages used in projects.

Even though [some scripts](https://kapeli.com/docsets#scriptExamples) are available for generating docsets, Rd2DashDocset provides another option to build a docset based on a folder of .Rd files, which are commonly used in packages in [CRAN](http://cran.r-project.org/). It is a R function that depends on R/base, R/tools and R/RSQLite. A .docset file would be generated, which can then be loaded into Dash.
