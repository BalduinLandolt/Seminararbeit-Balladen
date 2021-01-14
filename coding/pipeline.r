if (!endsWith(getwd(), "coding")) {
    setwd(file.path(getwd(), "git", "Seminararbeit-Balladen", "coding"))
}

library(reticulate)

source_python("extract.py")

main(getwd())


source("analyze.r")
