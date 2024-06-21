# Load necessary libraries
library(plumber)
library(fitzRoy)
library(dplyr)

pr("util_fns.R") %>% pr_run(host = "0.0.0.0", port = 8000)
