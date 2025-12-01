⚠️ Data Disclaimer

This project is built on a fully synthetic, randomly generated dataset
created solely for portfolio and educational demonstration purposes.
All equipment, engineers, metrics, and incidents are fictional.
Any resemblance to real-world operations is purely coincidental.

✨ Executive Summary

This is a strategic Tableau BI dashboard designed to support decision-making for the Operations Leadership and Executive Management.

The goal is not just to measure downtime duration, but to build a risk-based analytical model that helps:

identify high-impact failures

prioritize corrective actions

optimize resource allocation

enhance production reliability and operational continuity

The project demonstrates a complete end-to-end data workflow:
synthetic generation → BigQuery → SQL processing → KPI modeling → Tableau dashboard.

⚙️ Data Pipeline & Methodology
1. Data Preparation (Google BigQuery / SQL)

Source tables:

downtime_events

reason_catalog

equipment_inventory

equipment_location

All data was processed using a custom SQL script:
📄 scripts/data_preparation.sql

Core transformation steps:

joining the four source tables

calculating downtime duration

categorizing reasons and operational criticality

creating time attributes (year-month, hour, weekday)

cleaning, normalizing, and standardizing values

producing a final BI-ready dataset

2. Final Processing & Visualization (Tableau)

Performed in Tableau Public:

calculation of Total Criticality Score

KPI modeling: OEE, MTTR, MTBF, Availability

creation of an interactive executive dashboard with full cross-filtering

segmentation of incidents by criticality level (Low / Medium / High)

🎯 Key Analytical Insights
1. Total Criticality Score — Risk-Based Classification Model

The centerpiece of the dashboard is a custom risk model that classifies downtime events
into Low/Medium/High criticality not by duration, but by combined operational risk.

Formula applied:

Total Criticality Score = [Is Unplanned Downtime Score] + [EQ Criticality Factor] + [Temp-Sensitive Product Score] + [Recurrence Score] + [Downtime Duration Score]


This enables leadership to:

prioritize failures affecting high-risk product batches

reduce recurrence of systemic issues

improve long-term asset reliability

2. Pareto Analysis (80/20 Principle)

Approximately 80% of all downtime is caused by just 3–4 root causes.
This gives management a clear roadmap for targeted improvements and investment decisions.

3. Drill-Down & Full Cross-Filtering

Any selection instantly updates all visuals and KPIs.

This enables:

rapid identification of correlated factors

deep-dive analysis into root causes

fast decision-making in real time

4. Core Operational KPIs

OEE

Availability

MTTR

MTBF

🧰 Technologies Used

Google BigQuery (SQL)

Tableau Tableau Public

Statistical Modeling & Risk Scoring

📁 Repository Structure
README.md                                        # Project documentation
dashbords/Operational_Downtime_Insights.twbx     # Tableau workbook
imagies/dashboard_screenshot                     # Dashboard screenshot   
scripts/
    data_preparation.sql                         # SQL data transformation

📌 Project Objectives

This project demonstrates the ability to:

design complete analytical data pipelines

work with large datasets in BigQuery

build risk-based classification models

create management-level dashboards with KPIs

present data as it is done in real industrial operations