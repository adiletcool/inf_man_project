import os
from flask import Flask
from flask_restful import Api, Resource, abort
import pandas as pd
from datetime import datetime

app = Flask(__name__)
api = Api(app)

columns = ['date', 'location', 'total_cases', 'new_cases', 'total_deaths', 'new_deaths']
_last_data_url = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv'
_path = 'data/'
_filename = f'covid-data-{datetime.today().strftime("%d_%m_%Y")}.csv'
_csv_files = os.listdir(_path)

if len(_csv_files) > 0 and _csv_files[0] == _filename:
    print('Data is up to date')
    df = pd.read_csv(f'{_path}/{_filename}')[columns].fillna(0).set_index(['date'], drop=True)
else:
    print('Downloading last data')
    if len(_csv_files) > 0 and os.path.exists(f'data/{_csv_files[0]}'):
        os.remove(f'{_path}/{_csv_files[0]}')

    df = pd.read_csv(_last_data_url)[columns].fillna(0).set_index(['date'], drop=True)
    df.to_csv(_path + _filename)
    print('Downloaded last data')

countries = df.groupby(by='location').count().index.tolist()
counties_available = ', '.join([i.replace(' ', '_') for i in countries])


class Covid(Resource):
    @staticmethod
    def validate_location(location: str):
        if location not in countries:
            abort(404, message=f'No such location. Available locations: {counties_available}')

    @staticmethod
    def get_country_data(location):
        result = df[df['location'] == location].to_dict()
        result.update({'location': location})
        return result

    def get(self, location: str):
        location = location.replace('_', ' ')
        self.validate_location(location)
        return self.get_country_data(location)


class Countries(Resource):
    @staticmethod
    def get():
        return {"countries": counties_available}


api.add_resource(Covid, '/location/<string:location>')
api.add_resource(Countries, '/countries')

if __name__ == '__main__':
    app.run(debug=True)
