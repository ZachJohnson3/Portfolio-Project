--"Where continent is not null" was added after looking through the data and removed.
select *
from [SQL Portfolio Project]..COVIDDeaths
where continent is not null
order by 3,4 

--select *
--from [SQL Portfolio Project]..COVIDVaccinations
--order by 3,4 


--Select Data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
from [SQL Portfolio Project]..coviddeaths
order by 1,2

--Looking at the Total Deaths vs. Total Cases
--Shows the chance of dying from COVID 19 in your country 
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [SQL Portfolio Project]..coviddeaths
where location like '%states%'
order by 1,2

--Looking at the total cases vs. the population
--Shows what population got COVID in the USA
select location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulation
from [SQL Portfolio Project]..coviddeaths
where location like '%states%'
order by 1,2

--Which countries have the highest infection rate?
select location, population, max(total_cases), (Max(total_cases)/population)*100 as InfectedPopulation
from [SQL Portfolio Project]..coviddeaths
group by Location, Population
order by InfectedPopulation desc

--LET'S BREAK THINGS DOWN BY CONTINENT. 
select location, max(cast(total_deaths as int))as TotalDeathCount
from [SQL Portfolio Project]..coviddeaths
where continent is null
group by location
order by TotalDeathCount desc 


--Showing the countries with the highest death count per population  
select location, max(cast(total_deaths as int))as TotalDeathCount
from [SQL Portfolio Project]..coviddeaths
where continent is not null
group by Location
order by TotalDeathCount desc 

--Showing the continents with the highest death counts 
select continent, Max(cast(total_deaths as int)) as TotalDeathCount
from [SQL Portfolio Project] .. coviddeaths 
where continent is not null
Group by Continent
order by TotalDeathCount desc 


-- Global Numbers 
select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Portfolio Project]..coviddeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

--Look at total population v. vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinations 
, 
from [SQL Portfolio Project] .. coviddeaths dea
Join [SQL Portfolio Project] .. covidvaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null
order by 2,3

--USE CTE

with PopvsVac (continent, location, date, population, New_vaccinations, RollingVaccinations) 
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinations  
from [SQL Portfolio Project] .. coviddeaths dea
Join [SQL Portfolio Project] .. covidvaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null
)
select * , (RollingVaccinations/Population)*100
from PopvsVac

--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric, 
New_vaccinations numeric, 
RollingVaccinations numeric,
)
insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(convert(int,vac.new_vaccinations)) Over (Partition by dea.location order by dea.location, dea.date) as RollingVaccinations 
from [SQL Portfolio Project]..coviddeaths dea
join [SQL Portfolio Project]..covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent is not null

Select *, (RollingVaccinations/Population)*100
from PopvsVac


--Create View to store Data

Create View #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccinations 
, 
from [SQL Portfolio Project] .. coviddeaths dea
Join [SQL Portfolio Project] .. covidvaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
