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

$$
\mathrm{Excess Return}_t = \beta_0 + \beta_1 \text{MKT\_RF}_t + \beta_2 \text{SMB}_t + \beta_3 \text{HML}_t + \epsilon_t
$$

Separate multiple linear regressions were estimated for each company, and model assumptions were evaluated using residual diagnostics and Q-Q plots.

## Exploratory Data Analysis

