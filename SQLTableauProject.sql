select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, ROUND(sum(cast(new_deaths as int))/sum(new_cases)*100,2) as death_percentage
from [Portfolio Project 2]..CovidDeaths
where continent is not null
order by 1,2

select Location, SUM(cast(new_deaths as int)) as total_death_count
from [Portfolio Project 2]..CovidDeaths
where continent is null
and location not in('World', 'European Union','International','High income', 'Upper middle income', 'Low income', 'Lower middle income')
group by location
order by total_death_count desc

select Location, population , MAX(total_cases) as highest_infection_count, MAX(ROUND((total_cases/population)*100,2)) as percent_population_infected
from [Portfolio Project 2]..CovidDeaths
group by location, population
order by percent_population_infected desc

select Location, population, date , MAX(total_cases) as highest_infection_count, MAX(ROUND((total_cases/population)*100,2)) as percent_population_infected
from [Portfolio Project 2]..CovidDeaths
where continent is not null
group by location, population,date
order by percent_population_infected desc