-- Query A: OEE & Average Efficiency per line
SELECT
  line_id,
  AVG(actual_output/planned_output) AS avg_efficiency,
  AVG((planned_output-actual_output)/planned_output) AS avg_loss,
  (SUM(actual_output)::float/SUM(planned_output)) AS oee
FROM production_runs
GROUP BY line_id;

-- Query B: Total Defect Count & Ranking
SELECT
  defect_type,
  SUM(defect_count) AS total_defects,
  RANK() OVER (ORDER BY SUM(defect_count) DESC) AS defect_rank
FROM quality_checks
GROUP BY defect_type;

-- Query C: Weekly Efficiency Change per line (using LAG for time-series)
SELECT
  line_id,
  date,
  (actual_output::float/planned_output) AS efficiency,
  LAG((actual_output::float/planned_output)) OVER (PARTITION BY line_id ORDER BY date) AS prev_efficiency,
  ((actual_output::float/planned_output) - LAG((actual_output::float/planned_output)) OVER (PARTITION BY line_id ORDER BY date)) AS efficiency_change
FROM production_runs
ORDER BY line_id, date;