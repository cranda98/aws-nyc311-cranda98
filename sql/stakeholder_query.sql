-- Stakeholder question: What are the top problem types handled by NYPD?
-- Expected result: Illegal Parking dominates (~29K), followed by Noise - Residential (~17K).
SELECT 
  problem,
  COUNT(*) AS n
FROM nyc311_db.complaints
WHERE agency = 'NYPD'
GROUP BY problem
ORDER BY n DESC
LIMIT 10;
