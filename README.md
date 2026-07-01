# Explaining Stock Returns Using the Fama-French Three Factor Model

A financial econometrics project analyzing how market, size, and value factors explain the excess returns of Google, JPMorgan, and Coca-Cola.

## Overview

The Fama-French three factor model is one of the most widely used asset pricing models in finance. Rather than attributing stock returns solely to overall market movements, the model explains returns according to three systematic risk factors:

- Market excess return (MKT_RF)
- Size (SMB)
- Value (HML)

This project applies the model to three companies in distinct sectors (Google, JPMorgan, and Coca-Cola) in order to investigate how factor sensitivities differ across industries.

## Objectives

The main goals of this project are to:

1. Estimate Fama-French factor loadings for each stock
2. Compare systematic risk exposures across industries
3. Evaluate how well the three-factor model explains historical returns
4. Interpret differences in market, size, and value exposure

## Data

The analysis combines three publicly available datasets:

- Monthly adjusted stock returns from Yahoo Finance
- Fama-French factor data from the Kenneth R. French Data Library
- One-month U.S. Treasury yields from the Federal Reserve Economic Data (FRED)

This study covers monthly observations from May 2018 through February 2026, resulting in 94 observations per company.

## Data Preparation

The workflow includes:

- Cleaning and standardizing monthly dates
- Merging stock, factor, and risk-free datasets
- Converting percentages to decimal returns
- Calculating monthly excess returns
- Creating a unified modeling dataset

## Methodology

For each company, excess returns were modeled using the Fama-French Three-Factor Model:

```text
Excess Return_t = β₀ + β₁(MKT_RF)_t + β₂(SMB)_t + β₃(HML)_t + ε_t
```

Separate multiple linear regressions were estimated for each company, and model assumptions were evaluated using residual diagnostics and Q-Q plots.

## Exploratory Data Analysis

Prior to model fitting, this project includes:

- Scatterplots of excess returns vs. each factor
- Time-series plots of monthly excess returns
- Correlation matrices
- Regression diagnostics

These vizualizations provide insight into relationships prior to modeling.

## Results

Several consistent patterns emerge from analysis.

### Google

- Strong exposure to overall market movements
- Minimal size exposure
- Slight negative value loading
- `R^2` = 0.421

### JPMorgan

- Highest market beta among all three companies
- Strong positive exposure to the value factor
- Best model fit
- `R^2` = 0.731

### Coca-Cola

- Lowest market sensitivity
- Significant negative size loading
- Moderate positive value exposure
- `R^2` = 0.375

Overall, the market factor explains a substantial portion of the returns for all three companies, while the importance of size and value differs considerably across sectors.

### Visualizations

The repository also includes:

- Regression coefficient estimates with confidence intervals
- Regression diagnostic plots
- Rolling beta analysis

## Skills Demonstrated

- R programming
- Financial econometrics
- Multiple linear regression
- Data cleaning and integration
- Time-series analysis
- Statistical inference
- Data visualizations
- Asset pricing

## Packages Used

`library(dplyr)`; `library(readr)`; `library(ggplot2)`; `library(ggcorrplot)`; `library(knitr)`; `library(kableExtra)`; `library(zoo)`

## Potential Extensions

Possible future extensions include:

- Performing out-of-sample prediction
- Explanding the analysis to additional industries
- Comparing with the Fama-French five-factor model / Carhart four-factor model
- Estimating rolling factor loadings using expanding windows
