Select DISTINCT id from heartrate_seconds_merged; 14

Select DISTINCT id from weightLogInfo_merged; 8

Select DISTINCT id from sleepDay_merged; 24

--CREATE TABLE ActivitySleep AS
SELECT
	i.id,
	Trim(substr(
		ActivityDate, 0, 10)) AS Date,
	i.TotalSteps,
	i.TrackerDistance,
	i.FairlyActiveMinutes,
	VeryActiveMinutes,
	LightlyActiveMinutes,
	SedentaryMinutes,
	Calories,
	TotalMinutesAsleep,
	TotalTimeInBed,
	TotalTimeInBed - TotalMinutesAsleep AS TotalMinutesNotAsleep
FROM
	sleepDay_merged s
	JOIN dailyActivity_merged I ON s.id = i.id
		AND Trim(substr(
			SleepDay, 0, 10)) = Trim(substr(
		ActivityDate, 0, 10))
		;

--Create table ActivityVsCalories AS
SELECT 
id, sum(Calories) as TotalCalories, sum(VeryActiveMinutes) as TotalVeryActive, sum(SedentaryMinutes) As TotalSedentary, sum(LightlyActiveMinutes) as TotalLightlyActive,
sum(FairlyActiveMinutes) as TotalFairlyActive
From dailyActivity_merged
Group by Id
Order by Id;

--CREATE TABLE TotalActive AS 
SELECT DISTINCT
	id,
	sum(
		VeryActiveMinutes),
	sum(
		FairlyActiveMinutes),
	sum(
		LightlyActiveMinutes),
	sum(
		SedentaryMinutes),
	sum(
		VeryActiveMinutes + FairlyActiveMinutes + LightlyActiveMinutes + SedentaryMinutes) AS TotalDuration
FROM
	dailyActivity_merged
GROUP BY
	id
ORDER BY
	id;

--Create Table Active_NonActiveDays AS
SELECT
	i1.id,
	count(i1.ActivityDate) AS TotalDays,
	(
		SELECT
			count(i2.ActivityDate)
		FROM
			dailyActivity_merged i2
		WHERE
			i1.Id = i2.id
			AND i2.TotalSteps = 0) As NonActiveDays,
			(
		SELECT
			count(i3.ActivityDate)
		FROM
			dailyActivity_merged i3
		WHERE
			i1.Id = i3.id
			AND i3.TotalSteps != 0) As ActiveDays
	FROM
		dailyActivity_merged i1
	GROUP BY
		i1.Id
	ORDER BY
		i1.Id
Not null;


Create Table DateStep As
SELECT
	id, substr(ActivityDate, 6, 4) || '-' || SUBSTRING(ActivityDate, 1, 1) || '-' || substr(ActivityDate, 3, 2) as Date, 
	TotalSteps
FROM
	dailyActivity_merged
WHERE
	LENGTH(ActivityDate) = 9
UNION
	SELECT
	id, substr(ActivityDate, 5, 4) || '-' || SUBSTRING(ActivityDate, 1, 1) || '-' || substr(ActivityDate, 3, 1) as Date, 
	TotalSteps
FROM
	dailyActivity_merged
WHERE
	LENGTH(ActivityDate) = 8

;
