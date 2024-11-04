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
library(loo)
set.seed(304)

#### Read data ####
kh_data <- read_parquet("data/analysis_data/kh_data.parquet")

### Model data ####
kh_model <-
  stan_glm(pct ~ pollster + pollscore + transparency_score + ns(end_days, df = 3) + state,
            data = kh_data,
            family = gaussian(),
            prior = normal(0, 1),
            prior_intercept = normal(0, 10),
            chains = 4,
            iter = 2000,
            weights = kh_data$combined_weight)


#### Save Model ####

saveRDS(kh_model, file = "models/kh_vote_model.rds")
