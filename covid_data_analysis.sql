			
																	/* Covid-19 Data Analysis
																	   Consulting and Analytics Club,
																	   IIT Guwahati              */




--Covid Death table
SELECT *
from Project..Covid_deaths$
order by 3,4

SELECT *
from Project..Covid_deaths$
--order by 3,4




--Covid Vaccination table
SELECT *
from Project..Covid_vaccination$
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from Project..Covid_deaths$
order by 1,2




--Total cases Vs Total Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Project..Covid_deaths$
where location = 'India'
order by 1,2




--Total cases Vs Population
Select Location, date, population, total_cases, (total_cases/population)*100 as CasePercentage
from Project..Covid_deaths$
where location = 'India'
order by 1,2




--Countries with Highest infection rate
Select Location, population, MAX(total_cases) as HighestInfectioncount, MAX((total_cases/population))*100 as CasePercentage
from Project..Covid_deaths$
group by Location, population
order by CasePercentage desc




--Highest Death Rates (Countries)
Select Location, MAX(CAST(total_deaths as int)) as DeathCount
from Project..Covid_deaths$
where --Location = 'India'-- and continent is NOT NULL
group by Location
order by DeathCount desc




--Highest Death Rates (Continent)
Select continent, MAX(CAST(total_deaths as int)) as DeathCount
from Project..Covid_deaths$
where continent is NOT NULL
group by continent
order by DeathCount desc




--Global Death Rate (date wise)
Select date, SUM(new_cases) as totalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from Project..Covid_deaths$
where continent is NOT NULL
group by date
order by 1,2



 
--Global Death rate (total)
Select SUM(new_cases) as totalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from Project..Covid_deaths$
where continent is NOT NULL
order by 1,2




--Joining Tables
select * 
from Project..Covid_deaths$ death join Project..Covid_vaccination$ vac
 on death.location = vac.location and death.date = vac.date




 --Total Population and vaccinations
 select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Total_vaccinations
from Project..Covid_deaths$ death join Project..Covid_vaccination$ vac
 on death.location = vac.location and death.date = vac.date
 where death.continent is NOT NULL
 order by 2,3


 

 --CTE
 with PopvsVac (continent, location, date, population, new_vaccinations, Total_vaccinations)
 as (
 select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Total_vaccinations
from Project..Covid_deaths$ death join Project..Covid_vaccination$ vac
 on death.location = vac.location and death.date = vac.date
 where death.continent is NOT NULL
 --order by 2,3
 )
 select *, (Total_vaccinations/population)*100 as Percent_vaccinated
 from PopvsVac




 /*--Temp Table
 Drop table if exists #PercentPopulationVaccinated
 create Table #PercentPopulationVaccinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 date datetime,
 Population numeric,
 Total_vaccinations numeric
 )


 Insert into #PercentPopulationVaccinated
  select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Total_vaccinations
from Project..Covid_deaths$ death join Project..Covid_vaccination$ vac
 on death.location = vac.location and death.date = vac.date
-- where death.continent is NOT NULL
 --order by 2,3

 select *, (Total_vaccinations/Population)*100 --as Percent_vaccinated
 from #PercentPopulationVaccinated */

 

 -- Data visualization
 create view PercentPopulationVaccinated as
  select death.continent, death.location, death.date, death.population, vac.new_vaccinations, 
 SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by death.location order by death.location, death.date) as Total_vaccinations
from Project..Covid_deaths$ death join Project..Covid_vaccination$ vac
 on death.location = vac.location and death.date = vac.date
-- where death.continent is NOT NULL
 --order by 2,3
