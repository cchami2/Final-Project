library(tidyverse)
library(gtsummary)
library(here)
library(dplyr)
tuition_income_data <- read_csv(here::here("data","tuition_income.csv"))
col_types = cols(campus = col_factor(levels = c("On Campus",
																								"Off Campus")), income_lvl = col_factor(levels = c("0 to 30000",
																																																	 "30001 to 48000", "48001 to 75000",
																																																	 "75001 to 110000", "Over 110000")))
tbl_summary(
	tuition_income_data,
	by = campus,
	include = c(state, income_lvl, net_cost),
label = list(
	state ~ "State name",
	income_lvl ~ "Income level",
	net_cost ~ "Average net cost"
),
missing_text = "Missing") |>
	add_p(test = list(all_continuous() ~ "t.test",
										all_categorical() ~ "chisq.test")) |>
	add_overall(col_label = "**Total**") |>
	bold_labels() |>
	modify_footnote(update = everything() ~ NA) |>
	modify_header(label = "**Variable**", p.value = "**P**")
