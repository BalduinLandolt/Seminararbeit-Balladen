# ensure(?) correct working directory [works mostly reliable]
if (!endsWith(getwd(), "coding")) {
    setwd(file.path(getwd(), "git", "Seminararbeit-Balladen", "coding"))
}

# import library for running python in R
library(reticulate)

# load python module
source_python("extract.py")

# run method in python module
main(getwd())

# run R script
source("analyze.r")
