#!/usr/bin/env Rscript

args <- commandArgs(T)

if (length(args) == 0) {
  stop("No path provided", call. = FALSE)
}

library(readr)
library(dplyr)

path <- args[1]

if (file.exists(path) == F) {
  stop("Path does not exits", call. = FALSE)
}

# get all files in the path
files <- list.files(path, full.names = TRUE)

# generate an empty dataframe
all_data <- data.frame()

# check that the column names are all the same
mismatched_files <- list()
cols <- c("doi", "标题", "期刊", "年份", "作者")

# define function
read_aminer <- function(file, cols_check) {
  data <- read_csv(file)
  if (all(cols_check %in% names(data))) {
    return(data)
  } else {
    return(NULL)
  }
}

# use lapply
data_list <- lapply(files, function(file) read_aminer(file, cols))
data_list <- Filter(Negate(is.null), data_list)

# merge all data
all_data <- do.call(rbind, data_list)

# output
write.csv(all_data, 'Aminer_df.csv', row.names = FALSE, na = "")
