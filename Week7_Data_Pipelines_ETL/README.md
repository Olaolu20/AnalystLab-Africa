# Week 7: Data Pipelines & Automation — Weather ETL Pipeline

## Project Overview
This project builds a simple ETL (Extract, Transform, Load) pipeline that retrieves real-time weather data for three Nigerian cities — Lagos, Ibadan, and Abuja — using the OpenWeather API. The data is cleaned, structured, stored, and briefly analysed to compare weather patterns across the cities.

## Data Source
- **API:** OpenWeather API (https://openweathermap.org/api)
- **Endpoint used:** Current Weather Data API
- **Cities covered:** Lagos, Ibadan, Abuja

## ETL Process

**Extract**
Weather data was retrieved for each city using Python's `requests` library, connecting to the OpenWeather API with an authenticated API key. Raw JSON responses were collected for all three cities.

**Transform**
The raw JSON data was parsed and structured into a clean Pandas DataFrame. Key fields extracted and renamed include:
- City
- Temperature_C
- Humidity_%
- Weather_Condition
- Wind_Speed_mps
- Date_Time (converted from Unix timestamp to readable datetime format)

**Load**
The cleaned dataset was saved as a CSV file (`weather_data.csv`) for future analysis and reference.

## Tools Used
- Python
- Pandas
- Requests
- Jupyter Notebook
- OpenWeather API

## Steps Taken
1. Created a free OpenWeather account and generated an API key.
2. Wrote a Python script to extract live weather data for Lagos, Ibadan, and Abuja.
3. Transformed the raw JSON responses into a structured Pandas DataFrame with clean column names and correct data types.
4. Exported the cleaned dataset to a CSV file.
5. Performed basic analysis comparing temperature, humidity, and weather conditions across the three cities.

## Key Findings
- **Hottest city:** Abuja (31.37°C)
- **Most humid city:** Lagos (66%)
- **Weather conditions:** Lagos and Ibadan both experienced overcast clouds, while Abuja had light rain.

## What I Learned
This project reinforced how ETL pipelines work end-to-end — from connecting to a live API, to cleaning and structuring raw data, to storing it for analysis. It highlighted the importance of data transformation (e.g., unit conversion, timestamp formatting) in making raw API data usable for real analysis.
