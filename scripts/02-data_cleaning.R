#### Preamble ####
# Purpose: Cleans the Marriage License data
# Author: Aamishi Avarsekar
# Date: 19th September 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)
library(dplyr)

#### Clean data ####
raw_data <- read_csv("data/raw_data/president_polls.csv")

# tibble to see the data
raw_data_tibble <- head(raw_data)

# removing variables of no interest so that important variables remain
vars_interest <- raw_data %>% select(-display_name, -sponsors, -pollster_rating_name,
                                     -endorsed_candidate_id, -endorsed_candidate_name, 
                                     -endorsed_candidate_party, -subpopulation, -url,
                                     -url_article, -url_topline, -url_crosstab,
                                     -sponsor_candidate_id, -sponsor_candidate, 
                                     -sponsor_candidate_party, -tracking, -created_at,
                                     -notes, -source, -internal, -partisan, -cycle, 
                                     -stage, -race_id,-office_type, -seat_name,
                                     -seat_number, -election_date, -nationwide_batch, 
                                     -ranked_choice_reallocated,
                                     -ranked_choice_round, -sponsor_ids)

# filtering the data and selecting variables of interest:
# clean data is for all parties and candidates
clean_data <- vars_interest |>
  clean_names() |>
  mutate(
    state = if_else(is.na(state), "National", state), # poll is conducted for the whole country
    ) |>
  na.omit()

current_date <- Sys.Date()

# blue - democrat - kamala harris; part of this code was written using ChatGPT4.0
kh_data <- clean_data |>
  filter(party=="DEM") |>
  mutate(kh_win = ifelse((party == "DEM") & (candidate_id=="16661"), 1, 0),
         state = as.factor(state),
         start_date = mdy(start_date),  # Convert to Date format
         end_date = mdy(end_date),
         start_days = as.numeric(start_date - min(start_date, na.rm = TRUE)), # Calculate days since minimum start date
         end_days = as.numeric(end_date - min(start_date, na.rm = TRUE)),      # Calculate days since minimum start date
         # Weight based on pollscore (assuming you want higher scores to have more weight)
         pollscore_weight = (pollscore - min(pollscore)) / (max(pollscore) - min(pollscore)),
         
         # Weight based on recency (1 if less than 6 months old, else 0)
         recency_weight = ifelse(end_date >= (current_date - 180), 1, 0),  # Adjusting for 6 months (180 days)
         
         # Combined weight: You might want to use multiplication or some other method
         combined_weight = pollscore_weight * recency_weight
  )

# Assuming start_date and end_date are in Date format
# Convert dates into a continuous numeric form (e.g., days since a reference date)
kh_data$start_days <- as.numeric(kh_data$start_date - min(kh_data$start_date))
kh_data$end_days <- as.numeric(kh_data$end_date - min(kh_data$start_date))

#### Save data ####
write_parquet(kh_data, "data/analysis_data/kh_data.parquet")
