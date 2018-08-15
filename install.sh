#!/usr/bin/env /bin/bash
set -e # halt script on error

cd _scss/
bourbon install
cd ../

bundle exec jekyll build
