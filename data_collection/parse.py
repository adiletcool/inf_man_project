import requests

url = "https://covid-19-data.p.rapidapi.com/report/country/all"

headers = {
    'x-rapidapi-host': "covid-19-data.p.rapidapi.com",
    'x-rapidapi-key': "96c9bf6347mshaa70842b22ac472p17ea96jsncd83f482d9aa"
}


def get_daily_all_countries(day_str: str):
    querystring = {"date-format": "YYYY-MM-DD", "format": "json", "date": day_str}
    response = requests.request("GET", url, headers=headers, params=querystring)
    return response

# https://rapidapi.com/api-sports/api/covid-193/endpoints