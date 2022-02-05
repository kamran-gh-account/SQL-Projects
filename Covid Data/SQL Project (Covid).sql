-- Checking our data 

select * from [SQL Project]..Covid_deaths order by 3,4

-- select * 
-- from [SQL Project]..Covid_vaccination
-- order by 3,4

-- Selecting the data that we are going to use

Select Location, date, total_cases, new_cases, total_deaths, population
from [SQL Project]..Covid_deaths
order by 1,2;

-- Looking at Total cases vs Total deaths
-- Shows likelihood of dying if you contract covid in India

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [SQL Project]..Covid_deaths
Where Location like '%India%'
order by 1,2;

-- Looking at Total cases vs Population
-- Shows what percentage of population got covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as InfectedPercentage
from [SQL Project]..Covid_deaths
where Location like '%India%'
order by 1,2;

-- Looking at countries with highest infection rate compared to population

Select Location, Population,Max(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as 
InfectedPercentage
from [SQL Project]..Covid_deaths
--where location like '%India%'
group by Location, Population
order by InfectedPercentage desc;

-- Showing the countries with highest death count per population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
from [SQL Project]..Covid_deaths
where continent is not null
group by Location
order by TotaldeathCount desc

-- -- Showing continets with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
from [SQL Project]..Covid_deaths
where continent is not null
group by continent
order by TotaldeathCount desc;

-- Global numbers

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Project]..Covid_deaths
where continent is not null
group by date
order by 1,2;

-- Total cases and total deaths in the world

Select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Project]..Covid_deaths
where continent is not null
--group by date
order by 1,2;

-- Joining two tables on location and date

Select *
from [SQL Project]..Covid_deaths dea
Join [SQL Project]..Covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date

-- Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations as numeric)) over (Partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from [SQL Project]..Covid_deaths dea
Join [SQL Project]..Covid_vaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- Creating Views 

Create view Deaths as 
Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from [SQL Project]..Covid_deaths
where continent is not null
group by date
--order by 1,2;

-- Checking query on created view
select * from Deaths;