```markdown
# COVID-19 Analytics SQL & Visualization

[![SQL](https://img.shields.io/badge/Language-SQL-blue.svg)](https://en.wikipedia.org/wiki/SQL)
[![Database](https://img.shields.io/badge/Database-SQLite%20%7C%20MS%20SQL%20Server-00758F.svg)](https://www.sqlite.org/)
[![Tableau](https://img.shields.io/badge/Visualization-Tableau-E97627.svg)](https://www.tableau.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

An end-to-end data exploration and analytics pipeline leveraging SQL to transform raw global COVID-19 infection, mortality, and vaccination datasets into structured aggregations optimized for Tableau dashboards.

---

## Key Features

* **Global Mortality & Case Metrics:** Aggregates global totals for cases, deaths, and calculates exact fatality percentages.
* **Continental Breakdown:** Groups and filters mortality data across continents while handling aggregate location anomalies (e.g., removing 'World', 'European Union', and 'International').
* **Population Infection Dynamics:** Measures peak infection counts and maximum population percentage infected per country.
* **Time-Series Tracking:** Converts epoch dates and tracks infection spread over time for detailed trend analysis.
* **Vaccination Rollout Analytics:** Integrates `CovidDeaths` and `CovidVaccinations` datasets using Common Table Expressions (CTEs) and window functions (`OVER / PARTITION BY`) to compute rolling total vaccinations per population.

---

## Project Structure

```text
.
├── Covid-Analytics.sql       # SQL queries for exploratory data analysis and Tableau extraction
├── CovidDeaths.xlsx          # Raw dataset containing global case, death, and population metrics
├── CovidVaccinations.xlsx    # Raw dataset tracking daily vaccination numbers by location
└── README.md                 # Project documentation

```

---

## Tech Stack

* **Database / Query Engine:** T-SQL (MS SQL Server) & SQLite
* **Data Visualisation:** Tableau
* **Data Sources:** Global COVID-19 tracking datasets (`CovidDeaths`, `CovidVaccinations`)

---

## Getting Started

### Prerequisites

* An SQL database engine (e.g., MS SQL Server Management Studio, SQLite, or PostgreSQL)
* Microsoft Excel or a CSV viewer to inspect raw datasets
* Tableau Desktop or Public for dashboard generation

### Installation & Environment Setup

1. **Clone the repository:**
```bash
git clone [https://github.com/JusChillin96/Covid-Analytics-SQL.git](https://github.com/JusChillin96/Covid-Analytics-SQL.git)
cd Covid-Analytics-SQL

```


2. **Import Datasets:**
* Load `CovidDeaths.xlsx` into your database as table `CovidDeaths`.
* Load `CovidVaccinations.xlsx` into your database as table `CovidVaccinations`.


3. **Execute Queries:**
* Open `Covid-Analytics.sql` in your SQL client and execute the scripts to extract the aggregated datasets.



---

## Usage

The SQL scripts are divided into primary production queries (used for Tableau dashboard views) and extended exploratory queries.

### Example Query: Vaccination Tracking via CTE

```sql
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(CONVERT(int, vac.new_vaccinations)) OVER (
            PARTITION BY dea.Location 
            ORDER BY dea.location, dea.Date
        ) AS RollingPeopleVaccinated
    FROM CovidDeaths dea
    JOIN CovidVaccinations vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentPeopleVaccinated
FROM PopvsVac;

```

Export the query outputs to CSV format and connect them directly to Tableau to build interactive map and chart visualisations.

```

```
