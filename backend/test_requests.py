import requests
from pprint import pprint as pp

base_url = 'http://127.0.0.1:5000/'

pp(requests.get(base_url + 'location/Russia').json())
# pp(requests.get(base_url + 'countries').json())
