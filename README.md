Replication of Life Satisfaction Determinants Analysis

**Overview**
This replication reproduces survey-weighted regression modeling to examine whether household income, education, religious attendance predicts self-rated life satisfaction (0–10 scale) using the 2017 General Social Survey (Cycle 31-Family).
The replication include two steps, the first step was based on the Project Program provided by the author, and the second step was based on the master script provided by the author. The analysis was reproduced by following the project program and master script’s annotations seperately, replicating each data cleaning, modeling, and output step.

All data were accessible via the CAnD3 course site, and the code executed without any error. The process of replication reproduced the same outputs with the authors. Results indicate all three predictor variables significantly influence life satisfaction scores.

**Data Files** 
Replication package included:
- RRWM_Ruth_Replication.R: Statistical analysis conducted strictly following the author's approach
- regression_coefficients.csv: Coefficient estimates with confidence intervals
- model_summary.csv: Overall model fit statistics
- wald_test_results.txt: Wald test for overall model significance
- life_satisfaction_coefficient_plot.png: Visual representation of coefficients
- complete_analysis_report.txt: Comprehensive analysis output
- life_satisfaction_complete_results.xlsx: All results in Excel format
- RRWM_Ruth_result.jpg
- Reproducibility Report.R:Statistical analysis conducted following the general approach of the author
- descriptive_statistics.txt：Analysis results reproduced following the author's methodological framework
- regression_results.txt：Analysis results reproduced following the author's methodological framework

No dataset provided but can be retrieved and downloaded from CAnD3 course portal.

**Data Source**
Statistics Canada, *General Social Survey (GSS) 2017 – Family, Cycle 31.

**Requirement**
RStudio: Version 2025.09.0 Build 387 (“Cucumberleaf Sunflower”)
R: Version 4.5.1 (2025-06-13 ucrt)
Quarto:1.7.32
Packages Used: tidyverse, survey, dplyr, haven, skimr, gtsummary, emmeans, broom, ggplot2, forcats

**Analysis details**
- Model: Life satisfaction ~ Income + Education + Religious participation
- Method: Survey-weighted regression with bootstrap replicates

**Data Accessibility Statement**
Data used in this exercise were obtained through ODESI, a service provided by the Ontario Council of University Libraries (https://search1.odesi.ca/#/
Access is restricted to those users who have a DLI License and can be used for statistical and research purposes. The terms and more information about the license can be viewed here (https://www.statcan.gc.ca/en/microdata/dli
As part of McGill University, the CAnD3 initiative has a license to use the data for the purposes of training. Those outside of McGill university should not use the data provided through CAnD3's training activities for purposes not related to their CAnD3 training.
Fellows who belong to another DLI institution should re-download the data using the ODESI site using the login provided by their institution if they wish to make use of the data for other purposes.

**Data Citation**
Statistics Canada. 2020. General Social Survey, Cycle 31, 2017 [Canada]: Family (version 2020-09). Statistics Canada [producer and distributor], accessed September 10, 2021. ID: gss-12M0025-E-2017-c-31
