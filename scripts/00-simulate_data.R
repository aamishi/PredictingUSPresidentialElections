#### Preamble ####
# Purpose: Simulates Poll-of-Polls data for the US President Elections 2024
# Author: Aamishi Avarsekar, Divya Gupta, Gaurav Thind
# Date: 4th November 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

# the following code was created by ChatGPT 4.0

# Load necessary library
library(dplyr)

# Set random seed for reproducibility
set.seed(304)

# Define the number of polls to simulate
n <- 500

# Simulate poll data
poll_data <- tibble(
  pollster_id = sample(1:50, n, replace = TRUE),
  pollster_name = paste("Pollster", pollster_id),
  level = sample(c("national", "state"), n, replace = TRUE, prob = c(0.3, 0.7)),
  state = ifelse(level == "state", 
                 sample(state.name, n, replace = TRUE), 
                 NA_character_), # national level has no state
  leaning = sample(c("Democratic", "Republican", "Swing"), n, replace = TRUE),
  duration = sample(3:15, n, replace = TRUE), # duration of polls in days
  poll_quality = round(runif(n, 1, 5), 1), # poll quality rating from 1 to 5
  predicted_part = sample(c("Democratic", "Republican"), n, replace = TRUE),
  predicted_candidate = ifelse(predicted_part == "Democratic",
                               sample(c("Harris", "Biden"), n, replace = TRUE),
                               sample(c("Trump", "Hailey"), n, replace = TRUE))
)

# Print the first few rows of the simulated data
print(head(poll_data))




