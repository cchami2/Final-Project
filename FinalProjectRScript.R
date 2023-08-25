library(tidyverse)
library(gtsummary)
library(here)

tuition_income_data <- read_csv(here::here("data","tuition_income.csv"))
tbl_summary(
	tuition_income_data,
	by = income_lvl,
	include = c(state, campus),
label = list(
	state ~ "State Name",
	campus ~ "On or off-campus"
),
missing_text = "Missing")
