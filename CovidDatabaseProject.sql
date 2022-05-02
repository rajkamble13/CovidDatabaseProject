select * from covid_deaths
select * from covid_vaccinations



-- Looking at Total Cases vs Total Deaths
-- Shows liklihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS real)/CAST(total_cases AS real))*100 AS death_percentage
FROM covid_deaths
WHERE location ILIKE 'india'
ORDER BY 2



-- Looking at Total Cases vs Population
-- Shows what percentage of population got covid

SELECT location, date, population, total_cases, (CAST(total_cases AS numeric)/CAST(population AS numeric))*100 AS percentage_population_infected
FROM covid_deaths
WHERE location ILIKE 'india'
ORDER BY 2



-- Looking at Countries with Highest Infection Rate compared to Population

WITH T1 AS (
		SELECT location, population, MAX(total_cases) AS highest, MAX((CAST(total_cases AS numeric)/CAST(population AS numeric)))*100 AS percentage_population_infected
		FROM covid_deaths
		GROUP BY location, population
		ORDER BY percentage_population_infected desc)
SELECT *
FROM T1
WHERE percentage_population_infected IS NOT NULL



-- Showing Countires with Highest Death Count

WITH T1 AS (
		SELECT continent, location, population, MAX(total_deaths) AS deathcount
		FROM covid_deaths
		WHERE continent IS NOT NULL
		GROUP BY location, population, continent
		ORDER BY deathcount desc)
SELECT location, deathcount
FROM T1
WHERE deathcount IS NOT NULL



-- Looking at Total Population vs Vaccinations

WITH T1 AS(
		SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.date) AS rolling_vaccination_count, 
		cv.people_fully_vaccinated
		FROM covid_deaths cd
		JOIN covid_vaccinations cv
		ON cd.date = cv.date
		AND cd.location = cv.location
		WHERE cd.continent IS NOT NULL)
SELECT *, (CAST(people_fully_vaccinated AS numeric)/CAST(population AS numeric))*100 AS rolling_vaccination_percentage
FROM T1
WHERE location ILIKE 'India'



-- Creating View 

Create View PercentPopulationVaccinated AS
		SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
		SUM(cv.new_vaccinations) OVER(PARTITION BY cd.location ORDER BY cd.date) AS rolling_vaccination_count, 
		cv.people_fully_vaccinated
		FROM covid_deaths cd
		JOIN covid_vaccinations cv
		ON cd.date = cv.date
		AND cd.location = cv.location
		WHERE cd.continent IS NOT NULL
		




