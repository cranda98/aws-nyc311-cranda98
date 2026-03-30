-- Issue: The original query failed with INVALID_FUNCTION_ARGUMENT: Invalid format: ""
-- because some complaints are still open, leaving closed_date as an empty string.
-- date_parse() cannot handle empty strings, so we filter them out with WHERE.
-- This means avg_days_to_close only reflects closed complaints, which is the
-- correct interpretation for a stakeholder asking about resolution time.
SELECT
  agency,
  AVG(
    date_diff(
      'day',
      date_parse(created_date, '%Y-%m-%d %H:%i:%s'),
      date_parse(closed_date,  '%Y-%m-%d %H:%i:%s')
    )
  ) AS avg_days_to_close
FROM nyc311_db.complaints
WHERE closed_date IS NOT NULL
  AND closed_date != ''
GROUP BY agency
ORDER BY avg_days_to_close DESC;
