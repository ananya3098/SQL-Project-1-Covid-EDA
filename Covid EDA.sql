--Select data that we are going to be using

SELECT location,date,total_cases,new_cases,total_deaths,population
FROM CovidDeaths
ORDER BY 1,2

--Looking at total cases VS total deaths

SELECT date,total_cases, total_deaths, location, (total_deaths/total_cases)*100 AS DeathPercent
FROM CovidDeaths
WHERE location='INDIA'
ORDER BY total_cases DESC

--Looking at total cases VS population

SELECT location,date,total_cases,population,(total_cases/population)*100 AS CovidPercent
FROM CovidDeaths
WHERE location='INDIA'
ORDER BY CovidPercent DESC

--Looking at countries with highest infection rate compared to the population

SELECT location,MAX(total_cases) AS HighestInfectionCount,population,MAX((total_cases/population))*100 AS CovidInfectedPercent
FROM CovidDeaths
GROUP BY location,population
ORDER BY CovidInfectedPercent DESC

--Looking at countries with highest death count per population

SELECT location,MAX(CAST(Total_deaths AS INT)) AS DeathCount
FROM CovidDeaths
WHERE continent is not null    --wherever continent is null,location is the entire continent and we want specific location
GROUP BY location
ORDER BY DeathCount DESC

--BREAKING THINGS DOWN TO CONTINENTS

--Showing continents with the highest death count per population

SELECT continent,MAX(CAST(Total_deaths AS INT)) AS DeathCount
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY DeathCount DESC

--GLOBAL NUMBERS

SELECT SUM(new_cases) AS TotalCases,SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null


--Global numbers by dates

SELECT date, SUM(new_cases) AS TotalCases,SUM(CAST(new_deaths AS INT)) AS TotalDeaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY date

--Looking at Total Population VS New Vaccinations and Total vaccinations

SELECT  CD.continent,CD.location,CD.date,cd.population,cv.new_vaccinations,
SUM(CAST(CV.new_vaccinations AS INT)) OVER (PARTITION BY CD.location ORDER BY CD.date) AS TotalVaccinations
FROM CovidDeaths CD
JOIN CovidVaccinations CV
ON CD.location=CV.location
AND CD.date=CV.date
WHERE CD.continent IS NOT NULL 
ORDER BY 1

--Using CTE(Common Table Expression)

WITH TotalPopvac (continent,location,date,population,new_vaccinations,TotalVaccinations) --creating a CTE named TotalPopvac
AS 
(
SELECT  CD.continent,CD.location,CD.date,cd.population,cv.new_vaccinations,
SUM(CAST(CV.new_vaccinations AS INT)) OVER (PARTITION BY CD.location ORDER BY CD.date) AS TotalVaccinations
FROM CovidDeaths CD
JOIN CovidVaccinations CV
ON CD.location=CV.location
AND CD.date=CV.date
WHERE CD.continent IS NOT NULL 
--ORDER BY 1  (order by generally is not used in CTEs)
)

SELECT *,(TotalVaccinations/population)*100 AS VaccinationPercent FROM TotalPopvac 



