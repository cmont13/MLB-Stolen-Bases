# Load packages####
library(tidyverse)  # Loads the `tidyverse` collection
library(readxl)     # Reads CSV and Excel files

#Read Data####
df <- read.csv("data/ESPN_ID.csv")

#Add Link####
df <- df |>
  mutate(url = paste0("https://a.espncdn.com/combiner/i?img=/i/headshots/mlb/players/full/", df$ESPNID, ".png"))

x <- df[df$PLAYERNAME == "Bartolo Colon",]

url <- x |>
  select(url)

url

#Write new data to csv####
write.csv(df, "Data/urls2.csv")

