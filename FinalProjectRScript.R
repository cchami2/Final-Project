library(tidyverse)
library(gtsummary)
library(here)
library(dplyr)
library(ggplot2)
tuition_income_data <- read_csv(here::here("data","tuition_income.csv"))
col_types = cols(campus = col_factor(levels = c("On Campus",
																								"Off Campus")), income_lvl = col_factor(levels = c("0 to 30000",
																																																	 "30001 to 48000", "48001 to 75000",																																																	 "75001 to 110000", "Over 110000")))
table1 <- tbl_summary(
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

#Multivariable Regression Analysis

linear_model <- lm(net_cost ~ income_lvl + campus + state,
									 data = tuition_income_data)
table2 <- tbl_regression(
	linear_model,
	intercept = TRUE,
	label = list(
		income_lvl ~ "Income level",
		campus ~ "On or off-campus",
		state ~ "State name"
	))
#Creating a figure
barplot <- ggplot(data.frame(tuition_income_data$income_lvl), aes(x=tuition_income_data$income_lvl)) +
	geom_bar()

#Created a function to calculate average
myaverage <- function(net_cost) {
	n <- length(net_cost)
	averageval <- sum(net_cost) / n
	return(averageval)
}
myaverage(tuition_income_data$net_cost)
myaverage(tuition_income_data$total_price)

