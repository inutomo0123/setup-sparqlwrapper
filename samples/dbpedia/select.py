from jinja2 import Environment, FileSystemLoader
from SPARQLWrapper import SPARQLWrapper

import pathlib


def exec():

    env = Environment(
        loader=FileSystemLoader(pathlib.Path(__file__).parent))

    template = env.get_template('select.sparql')

    data = {'s': '愛知県', 'p': 'wikiPageWikiLink'}
    query = template.render(data)

    sparql = SPARQLWrapper(endpoint='http://ja.dbpedia.org/sparql',
                           returnFormat='json')

    sparql.setQuery(query)

    return sparql.query().convert()


if __name__ == '__main__':

    print(exec())

# {'head': {'link': [], 'vars': ['o', 'label']},
#  'results': {
#      'distinct': False,
#      'ordered': True,
#      'bindings':
#      [{'o': {
#          'type': 'uri',
#          'value': 'http://ja.dbpedia.org/resource/名鉄豊川線'},
#        'label': {'type': 'literal',
#                  'xml:lang': 'ja',
#                  'value': '名鉄豊川線'}}]}}
