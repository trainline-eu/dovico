[![Build Status](https://travis-ci.org/trainline-eu/dovico.svg?branch=master)](https://travis-ci.org/trainline-eu/dovico)

Repository for Dovico API management.

# Requirements
- Ruby 2.2.2 or newer

# Installation
`gem install dovico`

# Configuration

## Dovico authentication
Dovico provide a way to generate a 3rd party token. This token provides a full access to your account:
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

## Setup your default timesheet
* List the available tasks with `dovico --tasks`

~~~
$ dovico --tasks
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
`dovico --myself`

~~~
$ dovico --myself
Informations about yourself
 - ID:         42
 - First Name: Gandalf
 - Last Name:  The White
~~~

## Display the list of the tasks
`dovico --tasks`
~~~
$ dovico --tasks
== List of available projects ==
Project | Task | Description
   1200 |  100 | Sauron Project: Forge the One Ring
   1200 |  110 | Sauron Project: Attack Gondor
   1400 |  100 | Gandalf Project: Meet Bilbo
   1400 |  120 | Gandalf Project: Convince Frodo
   1600 |  100 | Frodo Project: Go home
~~~

## Fill the timesheet
`dovico --fill [date options]`

The date options are detailed below. All the other commands use the same format for these date options.

### For the current week
`dovico --fill --current-week`

### For today
`dovico --fill --today`

### For a specific [commercial week](http://www.epochconverter.com/weeks/)
`dovicon --fill --week=49`

Year can be set too:
`dovico --fill --year=2015 --week=40`

### For a specific day
`dovico --fill --day=2017-12-31`

## Show the timesheet
`dovico --show [date options]`

~~~
$ dovico --show --start=2017-01-02 --end=2017-01-12
== List of Time Entries between 2017-01-02 and 2017-01-06 ==
2017-01-02 [××××××××××××××]    : [not_submitted]  7h Sauron Project: Forge the One Ring
2017-01-03 [××××××××××××××]    : [not_submitted]  7h Sauron Project: Attack Gondor
2017-01-12 [××××]              : [under_review]  2h Gandalf Project: Meet Bilbo
2017-01-12 [××××××××]          : [under_review]  4h Gandalf Project: Convince Frodo
2017-01-12 [××]                : [under_review]  1h Frodo Project: Go home
~~~

## Submit the timesheet
`dovico --submit [date options]`

Once submitted, the timesheet can't be edited.

## Delete timesheet
`dovico --clear [date options]`

A confirmation will be asked before the deletion.
~~~
$ dovico --clear --day=2017-01-05
• 1 Time Entries to be deleted. Are you sure? (yes/no)
yes
✓ 1 Time Entries deleted
~~~

# Contributing
You are warmly welcome to contribute to the project!

# Dovico API Documentation
* http://apideveloper.dovico.com/
