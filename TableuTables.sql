--Data
select dea.continent, dea.location, dea.date, dea.population, Max(vac.total_vaccinations) as RollingPeopleVaccinated
from [SQL Portfolio Project].. coviddeaths dea
join [SQL Portfolio Project]..COVIDVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3

--Tableu Table 1
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Portfolio Project]..COVIDDeaths
where continent is not null
order by 1,2



--Tableu Table 2
select location, sum(cast(new_deaths as int)) as TotalDeathCount
from [SQL Portfolio Project].. COVIDdeaths
where continent is null
and location not in ('world','european union','international')
group by location
order by TotalDeathCount desc


--Tableu Table 3 
select location, population, max(total_cases) as HighestInfectionCount, Max((Total_cases/population))*100 as PercentPopulationInfected
from [SQL Portfolio Project]..COVIDDeaths
Group by location, population
order by PercentPopulationInfected desc

--Tableu Table 4
select location, population,date,max(total_cases) as Highestinfectioncount, max((total_Cases/population))*100 as PercentPopulationInfected
from [SQL Portfolio Project]..coviddeaths
group by location, population, date 
order by PercentPopulationInfected desc