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

raw_data_tibble <- head(raw_data)
vars_interest <- raw_data %>% select(-display_name, -sponsors, -pollster_rating_name,
                                     -endorsed_candidate_id, -endorsed_candidate_name, 
                                     -endorsed_candidate_party, -subpopulation, -url,
                                     -url_article, -url_topline, -url_crosstab,
                                     -sponsor_candidate_id, -sponsor_candidate, -sponsor_candidate_party, 
                                     -tracking, -created_at, -notes, -source,
                                     -internal, -partisan, -cycle, -stage, -race_id, -office_type, -seat_name,
                                     -seat_number, -election_date, -nationwide_batch, -ranked_choice_reallocated,
                                     -ranked_choice_round, -sponsor_ids)

# filtering the data and selecting variables of interest:
# clean data is for all parties and candidates
clean_data <- vars_interest |>
  clean_names() |>
  mutate(
    state = if_else(is.na(state), "National", state), # poll is conducted for the whole country
    end_date = mdy(end_date)
    ) |>
  na.omit()

# blue - democrat - kamala harris
kh_data <- clean_data |>
  filter(party=="DEM") |>
  mutate(kh_win = ifelse(party == "DEM", 
                1, 
                0))

# red - republican - donald trump
dt_data <- clean_data |>
  filter(party=="REP" , candidate_id=="16651")

president_data <- table(raw_data$pollster)
president_data <- as.data.frame(president_data)
print(president_data)

# top 10 pollsters
president_data <- president_data[order(-president_data$Freq), ]

# Get the top 10 most frequent pollsters
top_10_pollsters <- head(president_data, 10)

# Display the result
top_10_pollsters

#### Save data ####
write_parquet(raw_data, "data/analysis_data/president_polls.parquet")
write_parquet(kh_data, "data/analysis_data/kh_data.parquet")
write_parquet(dt_data, "data/analysis_data/dt_data.parquet")
