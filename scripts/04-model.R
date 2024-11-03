#### Preamble ####
# Purpose: Models... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(modelsummary)
library(splines)
set.seed(304)

#### Read data ####
kh_data <- read_parquet("data/analysis_data/kh_data.parquet")
dt_data <- read_parquet("data/analysis_data/dt_data.parquet")

### Model data ####
kh_model <-
  stan_glm(
    formula = kh_win ~ pct + pollscore + transparency_score + state + population ,
    data = kh_data,
    family = binomial(link="logit")
  )


#### Save Model ####

saveRDS(kh_model, file = "models/kh_vote_model.rds")

modelsummary(kh_model)
