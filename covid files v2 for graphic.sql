
----select lower(Notes) , trim((CONCAT(Upper(firstname,1) lower(LastName)))  as fullname, 2024-convert(float,year(birthdate)) as agenow , (notes) from Employees
----where FirstName like '%'
----order by EmployeeID

----select * , AVG(year(BirthDate)) from Employees
----group by FirstName

----With popvsvac (continent,location, date,population ,new_vaccinations, Rollingpeoplevaccinated )
----as
----(
----select dea.continent ,dea.location, dea.date , dea.population ,vac.new_vaccinations,
----SUM(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.date) as Rollingpeoplevaccinated
----from coviddeaths dea
----join vacaccines as vac
----on dea.date= vac.date and
----dea.location= vac.location
----where dea.continent is not null
----and vac.new_vaccinations is not null 
------order by 2,3)
----select * from popvsvac



--WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS

--( SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--         SUM(convert(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location order by dea.date) AS RollingPeopleVaccinated
--  FROM coviddeaths dea
--  JOIN vacaccines AS vac  -- Corrected table name (assuming vaccinations)
--  ON dea.date = vac.date
--  AND dea.location = vac.location
--  WHERE dea.continent IS NOT NULL
--  AND vac.new_vaccinations IS NOT NULL
--)
--SELECT MIN(convert(float,RollingPeopleVaccinated/population)*100
--FROM popvsvac




--WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
--  SELECT dea.continent, dea.location, dea.date, dea.population,
--         vac.new_vaccinations,
--         SUM(convert(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location) AS RollingPeopleVaccinated
--  FROM coviddeaths dea
--  JOIN vacaccines AS vac  -- Corrected table name (assuming vaccinations)
--  ON dea.date = vac.date
--  AND dea.location = vac.location
--  WHERE dea.continent IS NOT NULL
--  AND vac.new_vaccinations IS NOT NULL
--)
--SELECT sum(convert(float, RollingPeopleVaccinated / population) * 100) AS MinimumVaccinatedPercentage
--FROM PopvsVac;




--select * from coviddeaths
--select * from vacaccines

----new cases, population, new_death , new_test,totl_vaccinated


--select dea.continent, dea.date, dea.location ,COALESCE(dea.new_cases, 0) AS new_cases , dea.population , dea.date, vac.new_tests , vac.total_vaccinations,
--from coviddeaths dea
--join vacaccines vac on 
--dea.continent= vac.continent
--and dea.location= vac.location
--and dea.date= vac.date
--where dea.continent is not null
--order by 1,2,3

--with newcol( continent, date, location, population, new_cases , new_tests, total_vaccinations, countrysize) 
--as
--(
--SELECT dea.continent, dea.date, dea.location,dea.population,
--       COALESCE(dea.new_cases, 0) AS new_cases,  -- Handle null with 0
--       COALESCE(vac.new_tests, 0 ) AS new_tests,
--	   COALESCE(convert(float,vac.total_vaccinations), 0) as total_vaccinations,
--	   case
--	   when dea.population <= 1000000 then 'small country'
--	   when dea.population <= 5000000 then 'ok country'
--	   else 'big country'
--	   end as countrysize
--FROM coviddeaths dea
--JOIN vacaccines vac ON dea.continent = vac.continent  -- Corrected table name
--                    AND dea.location = vac.location
--                    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL)

--select Distinct(continent), convert(float,total_vaccinations)/population*100 from newcol
--where total_vaccinations>0
----group by continent
--order by 1


----temp table
--Drop Table if exists #percent_population_vac
--create table #percent_population_vac
--(continent nvarchar(255),
--location nvarchar (255),
--date datetime,
--population float,
--new_cases float,
--new_tests float,
--total_vaccinations float ,
--countrysize nvarchar(255)
--)
--insert into #percent_population_vac
--SELECT dea.continent, dea.date, dea.location,dea.population,
--       COALESCE(dea.new_cases, 0) AS new_cases,  -- Handle null with 0
--       COALESCE(vac.new_tests, 0 ) AS new_tests,
--	   COALESCE(convert(float,vac.total_vaccinations), 0) as total_vaccinations,
--	   case
--	   when dea.population <= 1000000 then 'small country'
--	   when dea.population <= 5000000 then 'ok country'
--	   else 'big country'
--	   end as countrysize
--FROM coviddeaths dea
--JOIN vacaccines vac ON dea.continent = vac.continent  -- Corrected table name
--                    AND dea.location = vac.location
--                    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL

--select Distinct(continent), convert(float,total_vaccinations)/population*100 from #percent_population_vac
--where total_vaccinations>0
----group by continent
--order by 1


--DROP TABLE IF EXISTS #percent_population_vac;
--CREATE TABLE #percent_population_vac (
--  continent nvarchar(255),
--  location nvarchar(255),
--  population float,
--  new_cases float,
--  new_tests float,
--  total_vaccinations float,
--  countrysize nvarchar(255)
--);

--INSERT INTO #percent_population_vac
--SELECT dea.continent, 
--       dea.location, dea.population,
--       COALESCE(dea.new_cases, 0) AS new_cases,  -- Handle null with 0
--       COALESCE(vac.new_tests, 0 ) AS new_tests,
--       COALESCE(convert(float,vac.total_vaccinations), 0) as total_vaccinations,
--       CASE WHEN dea.population <= 1000000 THEN 'small country'
--            WHEN dea.population <= 5000000 THEN 'ok country'
--            ELSE 'big country'
--       END AS countrysize
--FROM coviddeaths dea
--JOIN vacaccines vac ON dea.continent = vac.continent -- Corrected table name
--                    AND dea.location = vac.location
--                    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL;

--SELECT DISTINCT continent, convert(float,total_vaccinations)/population*100 AS vaccination_rate
--FROM #percent_population_vac
--WHERE total_vaccinations > 0
----group by continent (not needed if continents are already distinct)
--ORDER BY 1;


create view percentagepopulation as
SELECT dea.continent, 
       dea.location, dea.population,
       COALESCE(dea.new_cases, 0) AS new_cases,  -- Handle null with 0
       COALESCE(vac.new_tests, 0 ) AS new_tests,
       COALESCE(convert(float,vac.total_vaccinations), 0) as total_vaccinations,
       CASE WHEN dea.population <= 1000000 THEN 'small country'
            WHEN dea.population <= 5000000 THEN 'ok country'
            ELSE 'big country'
       END AS countrysize
FROM coviddeaths dea
JOIN vacaccines vac ON dea.continent = vac.continent -- Corrected table name
                    AND dea.location = vac.location
                    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


select * from percentagepopulation