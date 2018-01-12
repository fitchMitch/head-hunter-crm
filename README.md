# README

HH_CRM stands for  Head Hunters Customer RelationShip; This tool helps a Head Hunter team to organize its interview plannings, get resumes and fullfill customers missions.

*users* manage *people* having *jobs*. Other people are *company* representatives for which users set *missions* to fullfill (euros) according to a list of *commercial actions* available in business plannings with status describing a classical Head Hunter's business events workflow.

* Ruby version 2.2.0
* Database : posgresql 1.9.4
* Database initialization : seeds are provided for each environment

## Test suite
* Minitest with 75% coverage

## Services (job queues, cache servers, search engines, etc.)
* pg_search as search engines to dig into the docx files that are uploaded
* No queues, no cache servers

## Deployment instructions
* bundle install
* rails db:migrate
* rails db:seed
