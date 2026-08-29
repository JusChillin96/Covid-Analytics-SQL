SELECT
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    CAST(cv.new_vaccinations AS INT) AS new_vaccinations,
    SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location
ORDER BY
    cd.location,
    cd.date) AS rolling_sum_of_new_vaccinations,
    (SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location
ORDER BY
    cd.location,
    cd.date) * 1.0 / cd.population) * 100 AS percent_vaccinated,
    cd.total_cases,
    cd.total_deaths,
    (cast(cd.total_cases as float)/cast(cd.population as float))*100 as infected_percentage,
    (cast(cd.total_deaths as float)/cast(cd.total_cases as float))*100 as death_percentage
FROM
    CovidDeaths cd
INNER JOIN CovidVaccinations cv ON
    cd.location = cv.location
    AND cd.date = cv.date;
