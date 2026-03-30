-- Query 1: Count total complaints. Expected result: 200,000.
SELECT COUNT(*) AS n_complaints
FROM nyc311_db.complaints;

-- Query 2: Date range of complaints. Expected result: Jan 29 2026 to Mar 21 2026.
SELECT 
  MIN(created_date) AS earliest,
  MAX(created_date) AS latest
FROM nyc311_db.complaints;

-- Query 3: Complaints by agency, top 10. Expected result: NYPD leads with ~71K.
SELECT agency, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY agency
ORDER BY n DESC
LIMIT 10;

-- Query 4: Complaint types by borough, top 20. Expected result: Illegal Parking in Brooklyn leads.
SELECT borough, problem, COUNT(*) AS n
FROM nyc311_db.complaints
GROUP BY borough, problem
ORDER BY n DESC
LIMIT 20;

-- Query 5: Join complaints with agencies to get full names.
SELECT 
  c.agency,
  a.agency_name,
  COUNT(*) AS n
FROM nyc311_db.complaints AS c
JOIN nyc311_db.agencies AS a
  ON c.agency = a.agency
GROUP BY c.agency, a.agency_name
ORDER BY n DESC;
