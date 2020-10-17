import pandas as pd

df = pd.read_csv('data/covid-data.csv')

columns = ['date', 'location', 'total_cases', 'new_cases', 'new_cases_smoothed',
           'total_deaths', 'new_deaths', 'new_deaths_smoothed']
df_country = df[df['location'] == 'Russia'][columns].fillna(0).set_index(['date'], drop=True)
print(df_country)
