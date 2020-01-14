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

data <- paste0(rdata, "/ebola_6.csv")
updatedf <- paste0(cdata, "/Updated_ebola.rda")


# ====================
# Loading dependencies
# ====================

library(tidyverse)


# ===========
# Import data
# ===========

ebola_df <- read_csv(file = data)


# ==============
# Check dataset
# =============

glimpse(ebola_df)

# ====================
# Create new variables
# ====================

ebola_df1 <- ebola_df %>%
  mutate(week = isoweek(onsetDate),
         outcome = factor(ifelse(is.na(deathDate), 
                                 "Recovered",
                                 "Died")))

# ==============
# Save dataset
# ==============

save(ebola_df, file = updatedf)

# ================
# Remove libraries 
# ================
rm(list = ls())
detach(package: tidyverse)


