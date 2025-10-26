library(dplyr)
library(tidyverse)
library(survey)

#Data preparing

gss2017_ruth <- read.csv ("/Users/lanlanxin/Desktop/CAND3/RRWM-Sep/CAND3 Data/GSS 2017 - Family, Cycle 31/gss-12M0025-E-2017-c-31_F1.csv")
gss_subset_ruth <- gss2017_ruth %>%
  select(SLM_01, FAMINCG2, EHG3_01B, REE_03, WGHT_PER, starts_with("WTBS_"))

#Recoding
gss_subset_ruth <- gss_subset_ruth %>%
  mutate(SLM_01 = as.numeric(SLM_01))

gss_subset_ruth <- gss_subset_ruth %>%
  mutate(FAMINCG2 = factor(FAMINCG2,
                           levels = 1:6,
                           labels = c("< $25k", "$25–49,999", "$50–74,999",
                                      "$75–99,999", "$100–124,999", "$125k+")))

gss_subset_ruth <- gss_subset_ruth %>%
  mutate(EHG3_01B = factor(EHG3_01B,
                           levels = 1:7,
                           labels = c("Less than HS", "HS diploma/equiv",
                                      "Trade cert/diploma", "College/CEGEP non-univ",
                                      "Univ < Bachelor", "Bachelor's", "Univ > Bachelor")))
gss_subset_ruth <- gss_subset_ruth %>%
  mutate(REE_03 = factor(REE_03,
                         levels = 1:6,
                         labels = c("At least once a day",
                                    "At least once a week",
                                    "At least once a month",
                                    "At least 3 times a year",
                                    "Once or twice a year",
                                    "Not at all")))

gss_subset_ruth <- gss_subset_ruth %>%
  filter(
    !is.na(SLM_01) & 
      !is.na(FAMINCG2) & 
      !is.na(EHG3_01B) & 
      !is.na(REE_03)
  )

#-----Description-----
library(skimr)
gss_subset_ruth %>%
  select(SLM_01, FAMINCG2, EHG3_01B, REE_03) %>%
  skim()

#----Regression-----
library(survey)
des <- svrepdesign(
  weights     = ~WGHT_PER,           
  repweights  = "WTBS_[0-9]+",       
  type        = "bootstrap",         
  data        = gss_subset_ruth,           
  combined.weights = TRUE            
) 

##Run regression: Life satisfaction ~ income + education + religion
lm1 <- svyglm(SLM_01 ~ FAMINCG2 + EHG3_01B + REE_03, design = des)
summary(lm1)

## Wald score for model 
regTermTest(lm1, ~FAMINCG2 + EHG3_01B + REE_03)

## Tidy up coefficients with CIs
library(broom)
library(ggplot2)
coef_df <- tidy(lm1, conf.int = TRUE)

## Drop intercept
coef_df <- coef_df %>% filter(term != "(Intercept)")

# Clean labels
coef_df$term <- recode(coef_df$term,
                       "FAMINCG2$25–49,999"    = "Income: $25–49k",
                       "FAMINCG2$50–74,999"    = "Income: $50–74k",
                       "FAMINCG2$75–99,999"    = "Income: $75–99k",
                       "FAMINCG2$100–124,999"  = "Income: $100–124k",
                       "FAMINCG2$125k+"        = "Income: $125k+",
                       "EHG3_01BLess than HS"  = "Education: <HS",
                       "EHG3_01BTrade cert/diploma" = "Education: Trade/Tech",
                       "EHG3_01BCollege/CEGEP non-univ" = "Education: College/CEGEP",
                       "EHG3_01BUniv < Bachelor" = "Education: Univ < BA",
                       "EHG3_01BBachelor's"    = "Education: Bachelor's",
                       "EHG3_01BUniv > Bachelor" = "Education: Postgrad",
                       "REE_03At least once a day"   = "Religion: Daily",
                       "REE_03At least once a week"  = "Religion: Weekly",
                       "REE_03At least once a month" = "Religion: Monthly",
                       "REE_03At least 3 times a year" = "Religion: 3x/year",
                       "REE_03Once or twice a year"  = "Religion: 1–2x/year"
)

# Plot
ggplot(coef_df, aes(x = estimate, y = term)) +
  geom_point(size = 3, color = "steelblue") +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), height = 0.2) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "Predictors of Life Satisfaction (0–10 scale)",
    x = "Coefficient Estimate (β)",
    y = ""
  ) +
  theme_minimal(base_size = 14)

#Save
save.image("gss_analysis_complete.RData")
sink("descriptive_statistics.txt")
gss_subset_ruth %>%
  select(SLM_01, FAMINCG2, EHG3_01B, REE_03) %>%
  skim()
sink()

sink("regression_results.txt")
print("=== Regression Summary ===")
summary(lm1)

print("=== Wald Test ===")
regTermTest(lm1, ~FAMINCG2 + EHG3_01B + REE_03)

print("=== Coefficients with CI ===")
print(coef_df)
sink()

folder_name <- paste0("GSS_Analysis_Output_", format(Sys.time(), "%Y%m%d_%H%M"))
dir.create(folder_name)
sink(file.path(folder_name, "session_info.txt"))
cat("=== Session Information ===\n")
print(sessionInfo())
cat("\n=== Analysis Script Location ===\n")
cat("Primary analysis script: /Users/lanlanxin/Desktop/CAND3/script_Oct.25.R\n")
sink()
cat(file.path(folder_name, "session_info.txt"), "\n")


