# README

[![Code Climate](https://codeclimate.com/github/fitchMitch/head-hunter-crm.png)](https://codeclimate.com/github/fitchMitch/head-hunter-crm)


HH_CRM stands for  Head Hunters Customer RelationShip; This tool helps a Head Hunter team to organize its interview plannings, get resumes and fullfill customers missions.

**users** manage **people** having **jobs**. Other people are **company** representatives for which users set **missions** to fullfill (euros) according to a list of **commercial actions** available in business plannings with status describing a classical Head Hunter's business events workflow.

## Using
* Rails 5.0.1
* Ruby version 2.2.0
* Database : posgresql 1.9.4
* Database initialization : seeds are provided for each environment

## Test suite
* Minitest with 75% coverage

## Services (job queues, cache servers, search engines, etc.)
* *pg_search* as search engines to dig into the *uploaded docx cv files*
* No queues, no cache servers
* *I18n* use

## Deployment
`bundle install`

`rails db:migrate`

According to the role's permissions you'll have to set the following extensions manually or not:
* fuzzystrmatch
* pg_trgm
* plpgsql
* unaccent

`rails db:seed `


## License

The [MIT License](http://opensource.org/licenses/MIT) (MIT)

Copyright (c) 2018 [Etienne WEIL](https://www.linkedin.com/in/etienneweil/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
