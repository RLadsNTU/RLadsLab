library(readr)
library(dplyr)

# loading and parsing text
cpbl <- read_file("cpbl_20170929_235.play_by_play.txt")
innings <- strsplit(cpbl, "\\d[上下]")[[1]]
innings <- innings[-1]
labels = regmatches(cpbl, gregexpr("\\d[上下]", cpbl))[[1]]
bat.idx.vec <- gregexpr("\n\\d\\.", innings)
bat.n.vec <- sapply(bat.idx.vec, length)

# bulding and cleaning data.frame
df.nbat <- tibble(label=labels, nbat=bat.n.vec)
df.nbat <- df.nbat %>%
    mutate(
        inning = as.numeric(substr(labels, 1, 1)),
        half = substr(labels, 2, 2)
    )
df.nbat <- select(df.nbat, -label)

barchart(nbat~inning, data=df.nbat, 
        horizontal=F, stacked=T, groups=half, stack=T)

