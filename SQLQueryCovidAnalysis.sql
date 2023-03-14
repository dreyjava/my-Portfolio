select * from ProjectPortifolio..CovidDeaths$
where continent is not null
order by 3,4

--select * from ProjectPortifolio..CovidVaccinations$
--order by 3,4

select location,date,total_cases,total_deaths, new_cases ,population
from ProjectPortifolio..CovidDeaths$
order by 1,2

--looking at Total Cases Vs Total Deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
from ProjectPortifolio..CovidDeaths$
where location like '%Zim%'
order by 1,2


--looking at Total Cases Vs Total Polulation shows what percentage of population got Covid

select location,date,population,total_cases, (total_cases/population)* 100 as DeathPercentage
from ProjectPortifolio..CovidDeaths$
where location like '%Luxem%'
order by 1,2

--looking at countries with the highest infection rate vs population

select location,population,max(total_cases) as Highestcases, max((total_cases/population))* 100 as InfectionPercentage
from ProjectPortifolio..CovidDeaths$
where continent is not null
group by location,population
--where location like '%Luxem%'
order by InfectionPercentage desc

--showing conuntries with highest death count per population

select location,population,max(cast(total_deaths as int)) as HighestDeathCountry, max(cast(total_deaths as int)/population )* 100 as DeathPercentage
from ProjectPortifolio..CovidDeaths$
where continent is not null
group by location,population
--where location like '%Zim%'
order by HighestDeathCountry desc

--Lets show by continent

--show continent with highest death count per population

select continent,max(cast(total_deaths as int)) as TotalDeathCountry
from ProjectPortifolio..CovidDeaths$
where continent is not null
group by continent
--where location like '%Zim%'
order by TotalDeathCountry desc

--Global Numbers


select date,sum(total_cases) as TotalCases
from ProjectPortifolio..CovidDeaths$
where continent is not null
--where location like '%Zim%'
group by date
order by 1,2


select date,sum(new_cases) as NewCases,sum(cast(new_deaths as int)    )as NewDeaths , sum(cast(new_deaths as int)    )/sum(new_cases) as DeathsPercentage
from ProjectPortifolio..CovidDeaths$
where continent is not null
--where location like '%Zim%'
group by date
order by 1,2

--Total people vs Vaccinations 

select  dea.continent,dea.location, dea.population ,dea.date, vac.new_vaccinations, sum (Cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from ProjectPortifolio..CovidVaccinations$ vac 
join ProjectPortifolio..CovidDeaths$ dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 
order by 2,3


--Use CTE

With PopVsVac  (continent,location,population,date,new_vaccinations,RollingPeopleVaccinated) as
(select  dea.continent,dea.location, dea.population ,dea.date, vac.new_vaccinations, sum (Cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from ProjectPortifolio..CovidVaccinations$ vac 
join ProjectPortifolio..CovidDeaths$ dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 
--order by 2,3
)

select *,(RollingPeopleVaccinated/population )*100
 from PopVsVac

 --Temp Table

 create table PercentagePopulationVacinated
 (
 continent nvarchar(255),
 location nvarchar(255),
 population numeric,
 date datetime,
 new_vaccinations numeric,
 RollingPeopleVaccinated numeric
 
 )

 Insert into PercentagePopulationVacinated
 select  dea.continent,dea.location, dea.population ,dea.date, vac.new_vaccinations, sum (Cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from ProjectPortifolio..CovidVaccinations$ vac 
join ProjectPortifolio..CovidDeaths$ dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 

select *,(RollingPeopleVaccinated/population )*100
 from PercentagePopulationVacinated

 
 
 --View

 Create View PercentagePopVacinated as
 select  dea.continent,dea.location, dea.population ,dea.date, vac.new_vaccinations, sum (Cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
from ProjectPortifolio..CovidVaccinations$ vac 
join ProjectPortifolio..CovidDeaths$ dea
on vac.location = dea.location
and vac.date = dea.date
where dea.continent is not null 