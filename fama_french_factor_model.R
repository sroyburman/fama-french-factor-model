---
title: "Explaining Stock Returns Using the Fama-French Three-Factor Model: A Comparison of Google, JP Morgan, and Coca-Cola"
author: "Sage Roy-Burman"
format: pdf
---

Google_Monthly <- read.csv("data/Google_Monthly_Returns.csv")
# Load Yahoo Finance data


Risk_Free <- read.csv("data/FRED.csv")
# Load FRED data


library(readr)
library(dplyr)

Fama_French <- read_csv("FamaFrench.csv", skip = 3, show_col_types = FALSE)

colnames(Fama_French) <- c("Month", "MKT_RF", "SMB", "HML", "RF")

head(Fama_French)
tail(Fama_French)
# Load Fama French data, assign variable names, skip the title of the dataset


Fama_French <- Fama_French %>%
  filter(!is.na(Month))
# Filter N/A


Fama_French <- Fama_French %>%
  filter(grepl("^[0-9]{6}$", Month))
# Only keep rows where the format for Month is YYYYMM


Fama_French <- Fama_French %>%
  filter(Month >= 201805 & Month <= 202602)
# Limit dataset to May 2018 to February 2026


Risk_Free <- Risk_Free %>%
  filter(observation_date != as.Date("2026-03-01"))
# Remove the March observation date from the risk-free column


Risk_Free <- Risk_Free %>%
  mutate(
    Month = format(as.Date(observation_date), "%Y%m")
  )
# Convert date to same YYYYMM format


Google_Monthly <- Google_Monthly[order(Google_Monthly$Month, decreasing = TRUE), ]
# Reorder dataset so most recent months come first


Google_Monthly$Month <- as.character(Google_Monthly$Month)
# Convert to a string to prepare for merge


Google_Monthly <- Google_Monthly %>%
  mutate(
    Year = substr(Month, 1, 4),
    Month_num = substr(Month, 5, nchar(Month)),
    Month_num = sprintf("%02d", as.numeric(Month_num)),
    Month = paste0(Year, Month_num)
  )
# Fixes Month variable formatting. Was initially either one or two digits for the month (ex. 20231, 202310), this code block converts and standardizes into YYYYMM (instead of the weird formatting of YYYYM and YYYYMM)


Google_Monthly <- Google_Monthly %>%
  arrange(desc(Month))
# Sort rows from largest to smallest (puts dates in chronological order)


Google_Monthly <- Google_Monthly %>%
  filter(Month != ("202603"))
# Once again, remove the March observation


Risk_Free <- Risk_Free %>%
  mutate(
    Month = format(as.Date(observation_date), "%Y%m")
  )
# Ensures same Month variable format in the Risk_Free dataset


Risk_Free <- Risk_Free %>%
  mutate(RF = DGS1MO / 100)
# Convert the percentage to a decimal
Risk_Free <- Risk_Free %>%
  mutate(RF = RF / 12)
# Revert the annualization of monthly risk-free rate


Risk_Free <- Risk_Free %>%
  select(-observation_date)
# Remove the observation_date column


Fama_French <- Fama_French %>%
  mutate(Month = as.character(Month))

Google_Monthly <- Google_Monthly %>%
  mutate(Month = as.character(Month))

Risk_Free <- Risk_Free %>%
  mutate(Month = as.character(Month))

# Ensure all Month variables in the three datasets are strings for proper merging


merged_data <- Google_Monthly %>%
  inner_join(Fama_French, by = "Month") %>%
  inner_join(Risk_Free, by = "Month")
# Merging the three datasets by the common variable, Month


head(merged_data)
str(merged_data)
names(merged_data)
# Check new dataset


merged_data <- merged_data %>%
  mutate(
    Return = as.numeric(gsub("%", "", Return)) / 100,
    MKT_RF = MKT_RF / 100,
    SMB = SMB / 100,
    HML = HML / 100,
  )
# Change the percentages to decimals (Fama French data is in percentages)


merged_data <- merged_data %>%
  select(-RF.y, -DGS1MO, -RF.x)
# Drop unnecessary/redundant columns


Google_merged <- merged_data %>%
  mutate(
    Excess_Return = Return - RF
  )
# Create a new Excess Return variable (model variable of interest)


JPM_Monthly <- read.csv("data/JPM Monthly.csv")


JPM_Monthly$Month <- as.character(JPM_Monthly$Month)
# Convert Month variable to a string


JPM_merged <- merged_data %>%
  inner_join(JPM_Monthly, by = "Month")
# Create a new dataset with the merged data, adding JPM as the stock instead of GOOG


KO_Monthly <- read.csv("data/Coca-Cola Monthly.csv")


KO_Monthly$Month <- as.character(KO_Monthly$Month)
# Convert Month variable to a string


KO_merged <- merged_data %>%
  inner_join(KO_Monthly, by = "Month")
# Create a new dataset with KO as the stock of interest


KO_merged <- KO_merged %>%
  select(-Return.x)
# Remove clutter


JPM_merged <- JPM_merged %>%
  select(-Return.x)
# Remove clutter


str(Google_merged)
summary(Google_merged)


str(JPM_merged)
summary(JPM_merged)


str(KO_merged)
summary(KO_merged)


Google_merged <- Google_merged %>%
  select(-Year, -Month_num)
# Remove clutter


JPM_merged <- JPM_merged %>%
  select(-Year, -Month_num)
# Remove clutter


KO_merged <- KO_merged %>%
  select(-Year, -Month_num)
# Remove clutter


Google_merged <- Google_merged %>%
  mutate(Date = as.Date(paste0(substr(Month,1,4), "-", substr(Month,5,6), "-01")))
# Decided it would look cleaner if I changed the YYYYMM format to YYYY-MM-DD format for the first of the month


JPM_merged <- JPM_merged %>%
  mutate(Date = as.Date(paste0(substr(Month,1,4), "-", substr(Month,5,6), "-01")))
# Same change as above


KO_merged <- KO_merged %>%
  mutate(Date = as.Date(paste0(substr(Month,1,4), "-", substr(Month,5,6), "-01")))
# Same change as above


Google_merged <- Google_merged %>%
  select(-Month)
# Remove Month now that Date is its replacement


JPM_merged <- JPM_merged %>%
  select(-Month)
# Same as above


KO_merged <- KO_merged %>%
  select(-Month)
# Same as above


summary(Google_merged$Excess_Return)
summary(Google_merged[, c("MKT_RF", "SMB", "HML")])


JPM_merged <- JPM_merged %>%
  mutate(Excess_Return = Return.y - RF)
# Calculate JPM excess returns


KO_merged <- KO_merged %>%
  mutate(Excess_Return = Return.y - RF)
# Calculate KO excess returns


summary(JPM_merged$Excess_Return)


summary(KO_merged$Excess_Return)


library(ggplot2)
ggplot(Google_merged, aes(x = MKT_RF, y = Excess_Return)) +
  geom_point() +
  geom_smooth(method = "lm")
# Plot Google excess returns vs. MKT_RF


ggplot(Google_merged, aes(x = SMB, y = Excess_Return)) +
  geom_point() +
  geom_smooth(method = "lm")
# Plot Google excess returns vs. SMB values


ggplot(Google_merged, aes(x = HML, y = Excess_Return)) +
  geom_point() +
  geom_smooth(method = "lm")
# Plot Google excess returns vs. HML values


library(ggplot2)
ggplot(Google_merged, aes(x = Date, y = Excess_Return)) +
  geom_line() +
  ggtitle("Google Excess Returns Over Time")


ggplot(JPM_merged, aes(x = Date, y = Excess_Return)) +
  geom_line() +
  ggtitle("JP Morgan Excess Returns Over Time")


ggplot(KO_merged, aes(x = Date, y = Excess_Return)) +
  geom_line() +
  ggtitle("Coca-Cola Excess Returns Over Time")


reg_Google <- lm(Excess_Return ~ MKT_RF + SMB + HML, data = Google_merged)
summary(reg_Google)


confint(reg_Google)


reg_JPM <- lm(Excess_Return ~ MKT_RF + SMB + HML, data = JPM_merged)
summary(reg_JPM)


confint(reg_JPM)


reg_KO <- lm(Excess_Return ~ MKT_RF + SMB + HML, data = KO_merged)
summary(reg_KO)


confint(reg_KO)


plot(reg_Google)
# Q-Q and residuals vs. fitted plots


plot(reg_JPM)
# Q-Q and residuals vs. fitted plots


plot(reg_KO)
# Q-Q and residuals vs. fitted plots


library(ggcorrplot)

corr_data <- Google_merged[, c("Excess_Return", "MKT_RF", "SMB", "HML")]

corr_matrix <- cor(corr_data)

ggcorrplot(corr_matrix, lab = TRUE)

# Create a correlation matrix of the factors + Google excess returns


google_coef <- coef(reg_Google)
jpm_coef <- coef(reg_JPM)
ko_coef <- coef(reg_KO)

coef_df <- data.frame(
  Factor = rep(names(google_coef)[-1], 3),
  Value = c(google_coef[-1], jpm_coef[-1], ko_coef[-1]),
  Stock = rep(c("Google", "JPM", "KO"), each = 3)
)

library(ggplot2)

ggplot(coef_df, aes(x = Factor, y = Value, fill = Stock)) +
  geom_bar(stat = "identity", position = "dodge")
# Visualization of coefficients, opted to use a better looking visual with confidence intervals later


#| tbl-cap: "Results"

library(knitr)

# Function to extract regression results
extract_results <- function(model) {
  coefs <- coef(model)
  cis <- confint(model)
  pvals <- summary(model)$coefficients[,4]
  
  # Assign significance stars
  stars <- ifelse(pvals < 0.01, "***",
           ifelse(pvals < 0.05, "**",
           ifelse(pvals < 0.1, "*", "")))
  
  # Create clean data frame
  data.frame(
    Variable = names(coefs),
    Estimate = round(coefs, 3),
    Stars = stars,
    CI = paste0("(", round(cis[,1], 3), ", ", round(cis[,2], 3), ")")
  )
}

# Extract results
google_results <- extract_results(reg_Google)
jpm_results <- extract_results(reg_JPM)
ko_results <- extract_results(reg_KO)

# Remove intercept
google_results <- google_results[google_results$Variable != "(Intercept)", ]
jpm_results <- jpm_results[jpm_results$Variable != "(Intercept)", ]
ko_results <- ko_results[ko_results$Variable != "(Intercept)", ]

# Combine into one table
table_df <- data.frame(
  Variable = google_results$Variable,
  Google = paste0(google_results$Estimate, google_results$Stars, " ", google_results$CI),
  JPM = paste0(jpm_results$Estimate, jpm_results$Stars, " ", jpm_results$CI),
  KO = paste0(ko_results$Estimate, ko_results$Stars, " ", ko_results$CI)
)

# Add R² row
r2_row <- data.frame(
  Variable = "R^2",
  Google = round(summary(reg_Google)$r.squared, 3),
  JPM = round(summary(reg_JPM)$r.squared, 3),
  KO = round(summary(reg_KO)$r.squared, 3)
)

table_df <- rbind(table_df, r2_row)

# Create table
kable(table_df, align = "c")


#| fig-cap: "Coefficient Estimates"
# Google coefficients + confidence intervals
google_coef <- coef(reg_Google)
google_ci <- confint(reg_Google)

# JPM coefficients + confidence intervals
jpm_coef <- coef(reg_JPM)
jpm_ci <- confint(reg_JPM)

# KO coefficients + confidence intervals
ko_coef <- coef(reg_KO)
ko_ci <- confint(reg_KO)

google_df <- data.frame(
  term = names(google_coef),
  estimate = google_coef,
  conf.low = google_ci[,1],
  conf.high = google_ci[,2],
  Stock = "Google"
)

jpm_df <- data.frame(
  term = names(jpm_coef),
  estimate = jpm_coef,
  conf.low = jpm_ci[,1],
  conf.high = jpm_ci[,2],
  Stock = "JPM"
)

ko_df <- data.frame(
  term = names(ko_coef),
  estimate = ko_coef,
  conf.low = ko_ci[,1],
  conf.high = ko_ci[,2],
  Stock = "KO"
)

CIs <- rbind(google_df, jpm_df, ko_df)

CIs <- CIs[CIs$term != "(Intercept)", ] # AI help

# Build and combine data frames
ggplot(CIs, aes(x = term, y = estimate, color = Stock)) +
  geom_point(position = position_dodge(width = 0.5)) +
  geom_errorbar(
    aes(ymin = conf.low, ymax = conf.high),
    position = position_dodge(width = 0.5),
    width = 0.2
  ) + xlab("Factor") + ylab("Estimate")
  ggtitle("Coefficient Estimates with 95% Confidence Intervals")

# Plot coefficient estimates with 95% confidence intervals using the combined data


#| fig-cap: "Stock Returns Over Time"
Google_mini <- Google_merged %>%
  select(Date, Excess_Return) %>%
  mutate(Stock = "Google")
# Create mini datasets for Google, JPM, and KO with only date and excess return variables
JPM_mini <- JPM_merged %>%
  select(Date, Excess_Return) %>%
  mutate(Stock = "JPM")

KO_mini <- KO_merged %>%
  select(Date, Excess_Return) %>%
  mutate(Stock = "KO")

combined_stocks <- rbind(Google_mini, JPM_mini, KO_mini)
# Combine mini datasets into one dataset to plot
ggplot(combined_stocks, aes(x = Date, y = Excess_Return)) +
  geom_line() +
  facet_wrap(~ Stock, ncol = 1) +
  labs(
    title = "Monthly Excess Returns Over Time",
    x = "Date",
    y = "Excess Return"
  ) +
  theme_minimal()
# Plot all three stock monthly excess returns over time in a stacked graph


library(zoo)

rolling_beta <- rollapply(
  Google_merged[, c("Excess_Return", "MKT_RF")],
  width = 24,
  FUN = function(x) coef(lm(x[,1] ~ x[,2]))[2],
  by.column = FALSE,
  align = "right"
)

plot(rolling_beta, type = "l", main = "Rolling Market Beta (Google)")
# Plot Google rolling beta



rolling_beta <- rollapply(
  JPM_merged[, c("Excess_Return", "MKT_RF")],
  width = 24,
  FUN = function(x) coef(lm(x[,1] ~ x[,2]))[2],
  by.column = FALSE,
  align = "right"
)

plot(rolling_beta, type = "l", main = "Rolling Market Beta (JP Morgan)")
# Plot JPMorgan rolling beta



rolling_beta <- rollapply(
  KO_merged[, c("Excess_Return", "MKT_RF")],
  width = 24,
  FUN = function(x) coef(lm(x[,1] ~ x[,2]))[2],
  by.column = FALSE,
  align = "right"
)

plot(rolling_beta, type = "l", main = "Rolling Market Beta (Coca-Cola)")
# Plot Coca-Cola rolling beta

