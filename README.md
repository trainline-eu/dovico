[![build status](https://scm.capitainetrain.com/capitainetrain/dovico-client/badges/master/build.svg)](https://scm.capitainetrain.com/capitainetrain/dovico-client/commits/master)
[![coverage report](https://scm.capitainetrain.com/capitainetrain/dovico-client/badges/master/coverage.svg)](https://scm.capitainetrain.com/capitainetrain/dovico-client/commits/master)

Repository for Dovico API management.

# Installation
## Dovico authentication
Dovico provide a way to generate a 3rd party token. This token provide a full access to your account:
- Do not expose your token.
- If you believe your token has been exposed publicly, regenerate a new one. The previous token will be invalidated.

To generate a token:
* Login to https://login.dovico.com/index.aspx
* In **Options** tab, in the **Apps** part, click on the `Reset` button and copy your token

## Local configuration
* Create a new YAML file `~/.dovico/dovico.yml` with the following content:

~~~ruby
# Personal token. Can be reset through Dovico setting page
user_token: "<token you have copied from dovico.net page>"
# Your company's token
client_token: "<token given by your company's dovico admin>"
~~~

## Install required libraries
* Install Ruby 2.4.0
* `make install`

## Setup your default timesheet
* List the available tasks with `make tasks`

~~~
$ make tasks
== List of available projects ==
Project | Task | Description
   1200 |  100 | Sauron Project: Forge the One Ring
   1200 |  110 | Sauron Project: Attack Gondor
   1400 |  100 | Gandalf Project: Meet Bilbo
   1400 |  120 | Gandalf Project: Convince Frodo
   1600 |  100 | Frodo Project: Go home
~~~

* For each tasks you work on, note the Project, Task and hours spent. You should have a total of 7 hours of work each day.
* In your `~/.dovico/dovico.yml` file, *append* it with the following content

~~~ruby
# Personal token. Can be reset through Dovico setting page
user_token: "...."
# Your company's token
client_token: "...."
assignments:
  default_day:
    - project_id: 1234
      task_id:    100
      hours:      3
    - project_id: 9999
      task_id:    120
      hours:      2
    - project_id: 4321
      task_id:    424
      hours:      2
  # Quotes around day are mandatory
  # On leave: use an empty array
  '2016-01-17': []
  # Specific day: redefine each tasks
  '2017-12-19':
    - project_id: 1234
      task_id:    456
      hours:      6
    - project_id: 4321
      task_id:    424
      hours:      1
~~~

# Usage
## Display informations on your account
`make myself`

## Display the list of the tasks
`make tasks`

## Fill the timesheet
### For the current week
`make current_week`

### For today
`make today`

### For a specific [commercial week](http://www.epochconverter.com/weeks/)
`make week WEEK=49`

Year can be set too:
`make week YEAR=2015 WEEK=40`

### For a specific day
`make day DAY=2017-12-31`

# Restrictions and known issues
* The timesheet are currently created, but not submitted. You still need to login and submit your timesheet
* The client can't edit already created timesheets for now.

You are warmly welcome to contribute to the project!

# Dovico API Documentation
* http://apideveloper.dovico.com/
