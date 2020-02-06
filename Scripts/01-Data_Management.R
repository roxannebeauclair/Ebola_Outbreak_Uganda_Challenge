# Authors: Roxanne Beauclair and Ivy Kombe

# Description: This script imports the Uganda Ebola Outbreak line list
# and saves it as an R dataset. It also cleans and formats the data for
# subsequent analyses.

# ===================
# Relative file paths
# ===================

wd <- getwd()
rdata <- paste0(wd, "/Data/Raw") 
cdata <- paste0(wd, "/Data/Cleaned")

data <- paste0(rdata, "/ebola_6_update.csv")
data2 <- paste0(rdata, "/ebola_6_hhSize.csv")
updatedf <- paste0(cdata, "/Updated_ebola.rda")


# ====================
# Loading dependencies
# ====================

library(tidyverse)
library(lubridate)


# ===========
# Import data
# ===========

ebola_df <- read_csv(file = data)
ebola_hh_df <- read_csv(file = data2)

# ========================================
# Join household size data to main dataset
# ========================================

ebola_df1 <- ebola_df %>%
  left_join(ebola_hh_df, by = c("householdID" = "hhID")) %>%
  select(-X1)

# ==============
# Check dataset
# =============

glimpse(ebola_df1)

# ====================
# Create new variables
# ====================

ebola_df2 <- ebola_df1 %>%
  mutate(week = isoweek(onsetDate),
         outcome = factor(ifelse(is.na(deathDate), 
                                 "Recovered",
                                 "Died")),
         status = str_to_title(status),
         sex = str_to_title(sex)) %>% # Capitalize first letter
  group_by(householdID) %>%
  mutate(n_cases_hh = n()) %>%
  ungroup() %>%
  mutate(prop_hh_infected = n_cases_hh / size)

# ==============
# Save dataset
# ==============
ebola_df <- ebola_df2

save(ebola_df, file = updatedf)

# ================
# Remove libraries 
# ================
rm(list = ls())
detach(package: lubridate)
detach(package: tidyverse)



