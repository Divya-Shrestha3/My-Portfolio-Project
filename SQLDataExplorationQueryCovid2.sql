use portfolioproject;
select *
from coviddeaths;

--Query to show location, date, total cases, new cases, total deaths and population in the countries
select location,date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2;

--Query to show total cases vs total deaths
select location,date,total_cases,total_deaths,population,(total_deaths)/(total_cases) *100 as DeathPercentage
from coviddeaths
order by 1,2;

--Query to show total cases vs total deaths in a specific location
select location,date,total_cases,total_deaths,population,(total_deaths)/(total_cases) *100 as DeathPercentage
from coviddeaths
where location like '_ep%'
order by 1,2;

--Query to show total cases vs population
select location,date,total_cases,population,(total_cases)/(population) *100 as InfectedPercentage
from coviddeaths
where location like '_ep%'
order by 1,2;

--Query to show countris with highest infection rate cmpared to population
select location,population,MAX(total_cases)/population *100 as HighestInfectedPercentage
from coviddeaths
group by location,population
order by HighestInfectedPercentage desc;

--Query to show countries with highest death rate by location
select location,MAX(cast(total_deaths as int)) as HighestDeath
from coviddeaths
where continent is not null
group by location
order by HighestDeath desc
;

--Query to show countries with highest death rate by continent
select continent,MAX(cast(total_deaths as int)) as HighestDeath
from coviddeaths
where continent is not null
group by continent
order by HighestDeath desc
;

--Query to show global numbers in a specific date
select date, SUM(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
group by date
;

--Query to show global numbers 
select SUM(new_cases) as TotalCases,sum(cast(new_deaths as int)) as TotalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
;

select *
from covidvaccinations
;

--Query to join tables

select *
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date
;

--Query to show total population vs vaccinations

select a.continent,a.location,a.date,a.population,b.new_vaccinations
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date
where a.continent is not null
order by 1,2,3
;

--Query to show rolling new vaccination count 

select a.continent,a.location,a.date,a.population,b.new_vaccinations
,sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date) as RollingVaccinationCount
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date
where a.continent is not null
order by 1,2,3
;


--Query to show rolling new vaccination count vs population
with PopvsVac(continent,location,date,population,new_vaccinations,RollingVaccinationCount)
as
(
select a.continent,a.location,a.date,a.population,b.new_vaccinations
,sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date) as RollingVaccinationCount
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date
where a.continent is not null
)
select *,(RollingVaccinationCount/Population)*100
from PopvsVac;

--Same Query with temptable
create table #PercentPopulationVaccination
(continent varchar(255),
location varchar (255),
date datetime,
population numeric,
New_Vaccinations numeric,
RollingVaccinationCount numeric
)
insert into #PercentPopulationVaccination
select a.continent,a.location,a.date,a.population,b.new_vaccinations
,sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date) as RollingVaccinationCount
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date

select *,(RollingVaccinationCount/Population)*100
from #PercentPopulationVaccination;

--Alering the same table
drop table if exists #PercentPopulationVaccination;
create table #PercentPopulationVaccination
(continent varchar(255),
location varchar (255),
date datetime,
population numeric,
New_Vaccinations numeric,
RollingVaccinationCount numeric
)
insert into #PercentPopulationVaccination
select a.continent,a.location,a.date,a.population,b.new_vaccinations
,sum(cast(b.new_vaccinations as int)) over (partition by a.location order by a.location, a.date) as RollingVaccinationCount
from coviddeaths a
join covidvaccinations b
on a.location=b.location
and a.date=b.date

select *,(RollingVaccinationCount/Population)*100
from #PercentPopulationVaccination;