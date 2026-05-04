CREATE DATABASE HealthcareDB;
USE HealthcareDB;
select * from doctors;
commit;
select * from visit;
select * from labtests;
select * from treatment;
show tables;
CREATE TABLE Patients (
    `Patient ID` INT PRIMARY KEY,
    `Gender` VARCHAR(10),
    `Age` INT,
    `Phone Number` VARCHAR(20),
    `Blood Type` VARCHAR(5),
    `Country` VARCHAR(50),
    `Medical History` TEXT,
    `Race` VARCHAR(50),
    `Marital Status` VARCHAR(20),
    `First Name` VARCHAR(50),
    `LastName` VARCHAR(50),
    `Chronic Conditions` VARCHAR(255)
);
alter table patients
modify gender varchar(15),
modify `phone number` varchar(50),
modify `blood type` varchar(15),
modify `marital status` varchar(30);


-- Q1. Total number of patients

SELECT COUNT(Patient_ID) AS Total_Patients from patients;
select * from patients;

-- Q2. Total number of doctors

SELECT COUNT(*) AS Total_Doctors
FROM Doctors;

-- Q3. Total visits recorded
SELECT COUNT(*) AS Total_Visits
FROM Visit;

---- 4. Average age of patients------ 

SELECT 
ROUND(AVG(Age), 1) AS Average_Age
FROM Patients;

-- Q5. Male vs Female patient count
SELECT Gender,
       COUNT(*) AS Patient_Count
FROM Patients
GROUP BY Gender;
-- Q6. Top 5 most common diagnoses

SELECT Diagnosis,
       COUNT(*) AS Diagnosis_Count
FROM Visit
GROUP BY Diagnosis
ORDER BY Diagnosis_Count DESC
LIMIT 5;

-- Q7. Follow-up required percentage
SELECT 
ROUND(
    SUM(CASE WHEN `Follow Up Required` = 'Yes' THEN 1 ELSE 0 END) * 100.0
    / COUNT(*), 2
) AS `Follow Up Percentage`
FROM Visit;
-- Q8. Total revenue from treatments
SELECT 
ROUND(SUM(Treatment_cost), 2) AS Total_Revenue
FROM Treatment;

-- Q9. Average treatment cost

SELECT 
ROUND(AVG(Treatment_cost), 2) AS Avg_treatment_cost
FROM Treatment;
---- monthly trend analysis----
UPDATE Visit
SET Visit_Date = STR_TO_DATE(Visit_Date,'%m/%d/%Y');
SELECT 
YEAR(Visit_Date) AS Visit_Year,
MONTH(Visit_Date) AS Visit_Month,
COUNT(*) AS Total_Visits
FROM Visit
GROUP BY YEAR(Visit_Date), MONTH(Visit_Date)
ORDER BY Visit_Year, Visit_Month;

-- Q10. Doctor-wise total visits
SELECT d.Doctor_Name,
       COUNT(v.Visit_ID) AS Total_Visits
FROM Visit v
JOIN Doctors d 
ON v.Doctor_ID = d.Doctor_ID
GROUP BY d.Doctor_Name
ORDER BY Total_Visits DESC;
select * from visit;
-- Q12. Total lab tests conducted

SELECT COUNT(*) AS Total_LabTests
FROM Labtests;
--- percentage of labtests ---
SELECT 
Test_Result,
ROUND(COUNT(*) * 100.0 / 
      (SELECT COUNT(*) FROM Labtests), 2) AS Percentage
FROM Labtests
GROUP BY Test_Result;



-- Q13. Abnormal test percentage

SELECT 
ROUND(
    SUM(CASE WHEN Test_Result='Abnormal' THEN 1 ELSE 0 END)*100.0
    / COUNT(*),2
) AS Abnormal_Test_Percentage
FROM Labtests;

-- Q14. Average patients handled per doctor
SELECT 
ROUND(AVG(patient_count),2) AS Avg_Patients_Per_Doctor
FROM (
    SELECT Doctor_ID,
           COUNT(DISTINCT Patient_ID) AS patient_count
    FROM Visit
    GROUP BY Doctor_ID
) AS doctor_stats;

-- Q15. Most expensive treatments
SELECT Treatment_Name,
       Treatment_Cost
FROM Treatment
ORDER BY Treatment_Cost DESC
LIMIT 5;

select * from treatment;
-- =====================================================
-- Q16. Complete healthcare report (Final JOIN Query)
SELECT 
p.Patient_ID,
p.First_Name,
p.Last_Name,
d.Doctor_Name,
v.Visit_Date,
v.Reason_for_Visit,
t.Treatment_Name,
t.Treatment_Cost,
l.Test_Name,
l.Test_Result
FROM Patients p
JOIN Visit v ON p.Patient_ID = v.Patient_ID
JOIN Doctors d ON v.Doctor_ID = d.Doctor_ID
LEFT JOIN Treatment t ON v.Visit_ID = t.Visit_ID
LEFT JOIN Labtests l ON v.Visit_ID = l.Visit_ID;
SELECT 
DATE_FORMAT(Visit_Date,'%Y/%m') AS Visit_Month,
COUNT(*) AS Total_Visits
FROM Visit
WHERE Visit_Date IS NOT NULL
GROUP BY DATE_FORMAT(Visit_Date,'%Y/%m')
ORDER BY Visit_Month;
SELECT 
YEAR(Visit_Date) AS Visit_Year,
MONTH(Visit_Date) AS Visit_Month,
COUNT(*) AS Total_Visits
FROM Visit
GROUP BY YEAR(Visit_Date), MONTH(Visit_Date)
ORDER BY Visit_Year, Visit_Month;
ALTER TABLE Visit
ADD COLUMN Visit_Year INT,
ADD COLUMN Visit_Month INT;
UPDATE Visit
SET 
Visit_Year = YEAR(Visit_Date),
Visit_Month = MONTH(Visit_Date);
UPDATE Visit
SET Visit_Date = STR_TO_DATE(Visit_Date,'%m/%d/%Y');
select * from visit;
ALTER TABLE Patients RENAME COLUMN `Patient ID` TO Patient_ID;
ALTER TABLE Visit RENAME COLUMN `Visit ID` TO Visit_ID;
ALTER TABLE Visit RENAME COLUMN `Doctor ID` TO Doctor_ID;
ALTER TABLE Doctors RENAME COLUMN `Doctor ID` TO Doctor_ID;
ALTER TABLE Treatment RENAME COLUMN `Treatment Cost` TO Treatment_Cost;
ALTER TABLE Patients
RENAME COLUMN `First Name` TO First_Name;
ALTER TABLE Patients
RENAME COLUMN `LastName` TO Last_Name;
ALTER TABLE Visit
RENAME COLUMN `Visit Date` TO Visit_Date;
ALTER TABLE Visit
RENAME COLUMN `Reason for Visit` TO Reason_for_Visit;
ALTER TABLE Treatment
RENAME COLUMN `Treatment Name` TO Treatment_Name;
ALTER TABLE Labtests
RENAME COLUMN `Test Result` TO Test_Result;
ALTER TABLE Treatment
RENAME COLUMN `Treatment cost` TO Treatment_Cost;
ALTER TABLE Labtests
RENAME COLUMN `Test Name` TO Test_Name;
ALTER TABLE Labtests
CHANGE COLUMN `Visit ID` Visit_ID VARCHAR(50);

ALTER TABLE Treatment
CHANGE COLUMN `Visit ID` Visit_ID INT;
ALTER TABLE Doctors
CHANGE COLUMN `Doctor ID` Doctor_ID INT;
ALTER TABLE Visit
CHANGE COLUMN `Patient ID` Patient_ID INT;
DESCRIBE visit;
