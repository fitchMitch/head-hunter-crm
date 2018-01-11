# README

HH_CRM stands for Customer RelationShip tool for Head Hunters. It allows team to organize its interview plannings, get resumes and fullfill customers missions following classical status workflows.

* Ruby version 2.2.0
* Database : posgresql 1.9.4
* Database initialization : seeds are provided for each environment

## Test suite
* Minitest with 75% coverage

## Services (job queues, cache servers, search engines, etc.)
* No queues, no cache servers
* pg_search as search engines to dig into the docx files that are uploaded

## Deployment instructions
* bundle install
* rails db:migrate
* rails db:seed

