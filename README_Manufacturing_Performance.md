# Project 2: Manufacturing Performance & Root Cause Analysis

## Overview
This project highlights production KPI analysis and advanced SQL skills. The dataset simulates manufacturing production over three weeks, enabling comparative analysis between lines and root cause investigation.

## Data Model

### Table: `production_runs.csv`
- `run_id`
- `line_id` (A, B, C)
- `date`
- `planned_output`
- `actual_output`
- `total_downtime_minutes`
- `downtime_reason`

### Table: `quality_checks.csv`
- `run_id` (Foreign Key)
- `defect_type` (`Stitching`, `Material`, `Assembly`)
- `defect_count`

*Line A consistently outperforms Line C to support performance benchmarking.*

## Analysis Logic (PostgreSQL)

### Query A: OEE & Average Efficiency per Line
```sql
SELECT
  line_id,
  AVG(actual_output/planned_output) AS avg_efficiency,
  AVG((planned_output-actual_output)/planned_output) AS avg_loss,
  (SUM(actual_output)::float/SUM(planned_output)) AS oee
FROM production_runs
GROUP BY line_id;
```

### Query B: Total Defect Count & Ranking
```sql
SELECT
  defect_type,
  SUM(defect_count) AS total_defects,
  RANK() OVER (ORDER BY SUM(defect_count) DESC) AS defect_rank
FROM quality_checks
GROUP BY defect_type;
```

### Query C: Weekly Efficiency Change per Line (Window Function)
```sql
SELECT
  line_id,
  date,
  (actual_output::float/planned_output) AS efficiency,
  LAG((actual_output::float/planned_output)) OVER (PARTITION BY line_id ORDER BY date) AS prev_efficiency,
  ((actual_output::float/planned_output) - LAG((actual_output::float/planned_output)) OVER (PARTITION BY line_id ORDER BY date)) AS efficiency_change
FROM production_runs
ORDER BY line_id, date;
```

## Usage Instructions
1. Import both CSVs into PostgreSQL or your analytics tool.
2. Run the provided SQL queries to analyze line efficiency, defect root causes, and time-series changes in performance.

## Portfolio Skills Validated
- Operations Management
- KPI and OEE calculation
- Advanced SQL (Window functions, aggregation, ranking)