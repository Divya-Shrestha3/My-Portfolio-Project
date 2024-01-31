/*
The top 4 query is used to create visualization in Tableau
Query to show total population and total cases in all locations...\
Table1

*/
use portfolioproject;
select * from covidvaccinations;
select * from CovidDeaths;

select location,SUM(population) as TotalPopulation,  sum(total_cases) as TotalCasesPerCountry
from coviddeaths 
where continent is not null
group by location
order by location
;

--Query to show percentage of maximum infected population in United States
--Table2
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))* 100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc
;

--Query to show total tests and new tests done in certain time period
--Table4
select cast(date as date) as Date,sum(cast(total_tests as int)) as TotalTests,sum(cast(new_tests as int)) as NewTests
from CovidVaccinations
where date between '2020-01-24' and '2020-12-31'
group by date
order by date;

--Total population, total cases per location
--Table5
select * from CovidDeaths;

select location,sum(population) as TotalPopulation,sum(total_cases) as TotalCases,(sum(total_cases)/sum(population))*100 as Percentageaffected
from coviddeaths
group by location
;

--Query to show total cases, total deaths and percentage of death per cases

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
--Group By date
order by 1,2
;



