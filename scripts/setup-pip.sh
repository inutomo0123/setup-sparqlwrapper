#!/bin/bash

set -Cue

function install-packages() {
    pip3 install wheel sparqlwrapper jinja2 pip-review
}

install-packages


