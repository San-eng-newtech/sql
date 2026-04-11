select * from PortfolioProject..Covidd
where continent is not null
order by 3,4

--select * from PortfolioProject..CovidVacc
--order by 3,4 

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..Covidd
order by 1,2 




--Total cases vs Ttoal deaths 
SELECT 
  location,
  date,
  total_cases,
  total_deaths,
  (total_deaths / NULLIF(total_cases, 0))*100 AS death_rate
FROM PortfolioProject..Covidd
where location like '%state%'
ORDER BY 1,2; 

--Total cases vs Ttoal deaths vs population
--what pct of poplation got covid
SELECT 
  location,
  date,
  total_cases,
  total_deaths,
  population,
  (total_deaths / population)*100 AS pctpopulationInfected
FROM PortfolioProject..Covidd
where location like '%state%'
ORDER BY 1,2 

--looking at countries with highest infection raate compared to population
--Total cases vs Ttoal deaths 
SELECT 
  location,
  population,
  MAX(total_cases) AS highestinfectioncount,
  MAX((total_cases /Nullif(population,0))) * 100 AS pctpopulationInfected
FROM PortfolioProject..Covidd
GROUP BY location, population
ORDER BY pctpopulationInfected 

--contriees with highest death count per population
select location, Max(Total_deaths) as totaldeathcount
from PortfolioProject..Covidd
where continent is not null
Group by location
order by totaldeathcount desc

--showing continent with higehst death count
select continent, Max(Total_deaths) as totaldeathcount
from PortfolioProject..Covidd
where continent is not null
Group by continent
order by totaldeathcount desc  



SELECT 
  --date,
  SUM(CAST(new_cases AS FLOAT)) AS total_cases,
  SUM(CAST(new_deaths AS FLOAT)) AS total_deaths,
  SUM(CAST(new_deaths AS FLOAT)) 
    / NULLIF(SUM(CAST(new_cases AS FLOAT)), 0) * 100 AS deathpercentage
FROM PortfolioProject..Covidd
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1,2; 


--looking at total population vs vaccination
with PopvsVac (continent,location,date,population,New_Vaccinations,RollingPeopleVaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations ))over(partition by dea.location order by dea.location,
dea.date) as RollinPeopleVaccinated
from PortfolioProject..Covidd dea
join PortfolioProject..CovidVacc vac 
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
) 
select * ,(RollingPeopleVaccinated/population)*100
from PopvsVac

--temp table 

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations ))over(partition by dea.location order by dea.location,
dea.date) as RollinPeopleVaccinated
from PortfolioProject..Covidd dea
join PortfolioProject..CovidVacc vac 
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

select * ,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated
