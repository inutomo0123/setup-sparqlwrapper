from jinja2 import Environment, FileSystemLoader
from SPARQLWrapper import SPARQLWrapper

from pathlib import Path


def exec():

    env = Environment(
        loader=FileSystemLoader(
            Path(__file__).parent))

    template = env.get_template('ask.sparql')

    data = {'s': '愛知県', 'p': 'wikiPageWikiLink'}
    query = template.render(data)

    sparql = SPARQLWrapper(
        endpoint='http://localhost:3030/ddd/sparql',
        returnFormat='json')

    sparql.setQuery(query)

    return sparql.query().convert()


if __name__ == '__main__':

    print(exec())
