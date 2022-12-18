select *
From [Portfolio Project 2]..CovidDeaths
where continent is not null
order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from [Portfolio Project 2]..CovidDeaths
where continent is not null
order by 1,2

-- Shows likelihood of dying if you contract covid in Brazil
select Location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,2) as death_percentage
from [Portfolio Project 2]..CovidDeaths
Where location like '%Brazil%'
and continent is not null
order by 1,2

--Shows what percentage of population got Covid
select Location, date, total_cases, population, ROUND((total_cases/population)*100,2) as percent_population_infected
from [Portfolio Project 2]..CovidDeaths
Where location like '%Brazil%'
and continent is not null
order by 1,2

--Showing countries with highest infection rate compared to population
select Location, population , MAX(total_cases) as highest_infection_count, MAX(ROUND((total_cases/population)*100,2)) as percent_population_infected
from [Portfolio Project 2]..CovidDeaths
where continent is not null
group by location, population
order by percent_population_infected desc

--Showing countries with highest death count per population
select Location, MAX(cast(total_deaths as int)) as total_death_count
from [Portfolio Project 2]..CovidDeaths
where continent is not null
group by location
order by total_death_count desc

-- Showing continents with the highest death count per population
select continent, MAX(cast(total_deaths as int)) as total_death_count
from [Portfolio Project 2]..CovidDeaths
where continent is not null
group by continent
order by total_death_count desc

-- Global numbers 
select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, ROUND(sum(cast(new_deaths as int))/sum(new_cases)*100,2) as death_percentage
from [Portfolio Project 2]..CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, ROUND(sum(cast(new_deaths as int))/sum(new_cases)*100,2) as death_percentage
from [Portfolio Project 2]..CovidDeaths
where continent is not null
order by 1,2

--Vaccination table
select *
From [Portfolio Project 2]..CovidVaccinations
where continent is not null

--CTE
With PopvsVac(continent, location, date, population, new_vaccinations, rolling_people_vaccinated) as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) as rolling_people_vaccinated
From [Portfolio Project 2]..CovidDeaths dea
Join [Portfolio Project 2]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, ROUND((rolling_people_vaccinated/population)*100,2) as pop_percentage_vaccinated
From PopvsVac

--Temp table
DROP table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric)

Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) as rolling_people_vaccinated
From [Portfolio Project 2]..CovidDeaths dea
Join [Portfolio Project 2]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
Select *,(rolling_people_vaccinated/population)*100 pop_percentual_vaccinated
from #PercentPopulationVaccinated
