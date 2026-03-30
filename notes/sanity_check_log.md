## Query: Average resolution time by agency (2026-03-29)

- **File:** sql/resolution_time.sql
- **Business question:** How long does each agency take to resolve complaints?
- **What I expected:** I expected HPD and DOB to take longer due to the nature of housing and building inspections, while NYPD would be faster since many complaints are resolved on-scene.
- **Issues encountered:** The original query failed with INVALID_FUNCTION_ARGUMENT: Invalid format: "" because date_parse() cannot handle empty closed_date values — these occur when a complaint is still open.
- **Checks performed:** Confirmed the error was caused by empty strings (not NULLs) by reading the error message. Added WHERE closed_date IS NOT NULL AND closed_date != '' to filter them out before parsing.
- **Final outcome:** Results are plausible — NYPD resolves complaints in under a day (most are parking/noise, handled on the spot), while OOS (Sheriff) takes 34 days on average. The caveat is that this only reflects closed complaints.
- **Confidence:** High. Would present to stakeholder with the caveat that open complaints are excluded.
